import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../core/crypto/key_manager.dart';
import '../data/models/enums.dart';
import '../data/models/operation_log.dart';
import '../data/models/task.dart';
import '../data/repositories/offline_queue_repository.dart';
import '../data/repositories/operation_log_repository.dart';
import '../data/repositories/project_repository.dart';
import '../data/repositories/task_repository.dart';
import 'notification_service.dart';
import 'project_service.dart';

/// 任务业务逻辑服务
/// 设计文档 5.4：TaskService - 任务CRUD、状态管理、负责人分配
class TaskService {
  TaskService._();

  static final TaskService _instance = TaskService._();

  factory TaskService() => _instance;

  final _taskRepo = TaskRepository();
  final _projectRepo = ProjectRepository();
  final _logRepo = OperationLogRepository();
  final _queueRepo = OfflineQueueRepository();
  final _keyManager = KeyManager();
  final _projectService = ProjectService();

  /// 创建任务
  Future<Task> createTask({
    required String projectId,
    String? parentId,
    required String title,
    String description = '',
    TaskPriority priority = TaskPriority.medium,
    DateTime? dueDate,
    String? assigneeId,
    bool aiExecutable = false,
  }) async {
    final deviceId = await _keyManager.getDeviceId();
    final now = DateTime.now().millisecondsSinceEpoch;

    final task = Task(
      id: const Uuid().v4(),
      projectId: projectId,
      parentId: parentId,
      title: title,
      description: description,
      status: TaskStatus.todo,
      priority: priority,
      dueDate: dueDate?.millisecondsSinceEpoch,
      assigneeId: assigneeId,
      aiExecutable: aiExecutable,
      aiStatus: AIStatus.idle,
      attachments: const [],
      createdAt: now,
      updatedAt: now,
      lastModifiedBy: deviceId,
    );

    await _taskRepo.create(task);
    await _logCreation(task);
    await _enqueue('create', task);

    // 递归创建子任务（如果有 parentId，更新父任务进度）
    if (parentId != null) {
      await _recalculateParentProgress(parentId);
    }

    // 重新计算项目进度
    await _projectService.recalculateProgress(projectId);

    return task;
  }

  /// 批量创建任务（AI 拆解任务时使用）
  Future<List<Task>> createTasksBatch({
    required String projectId,
    required List<TaskDraft> drafts,
  }) async {
    final deviceId = await _keyManager.getDeviceId();
    final now = DateTime.now().millisecondsSinceEpoch;
    final tasks = <Task>[];

    for (final draft in drafts) {
      final task = Task(
        id: const Uuid().v4(),
        projectId: projectId,
        parentId: draft.parentId,
        title: draft.title,
        description: draft.description ?? '',
        status: TaskStatus.todo,
        priority: draft.priority,
        dueDate: draft.dueDate?.millisecondsSinceEpoch,
        assigneeId: draft.assigneeId,
        aiExecutable: draft.aiExecutable,
        aiStatus: AIStatus.idle,
        attachments: const [],
        createdAt: now,
        updatedAt: now,
        lastModifiedBy: deviceId,
      );
      tasks.add(task);
    }

    await _taskRepo.createBatch(tasks);
    for (final task in tasks) {
      await _logCreation(task);
    }

    // 重新计算项目进度
    await _projectService.recalculateProgress(projectId);

    return tasks;
  }

  /// 获取项目下所有根任务
  Future<List<Task>> getProjectTasks(String projectId) async {
    return _taskRepo.getByProjectId(projectId);
  }

  /// 获取任务详情
  Future<Task?> getTaskById(String id) async {
    return _taskRepo.getById(id);
  }

  /// 更新任务状态
  Future<void> updateStatus(String taskId, TaskStatus newStatus) async {
    final task = await _taskRepo.getById(taskId);
    if (task == null) return;

    final oldStatus = task.statusText;
    await _taskRepo.updateStatus(taskId, _statusToString(newStatus));

    // 记录日志
    final deviceId = await _keyManager.getDeviceId();
    await _logRepo.create(OperationLog(
      id: const Uuid().v4(),
      projectId: task.projectId,
      taskId: taskId,
      memberId: deviceId,
      memberName: '我',
      action: LogAction.statusChange,
      field: 'status',
      oldValue: oldStatus,
      newValue: newStatus.name,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      synced: false,
    ));

    await _enqueue('update', task.copyWith(status: newStatus));

    // 如果任务完成，重新计算进度
    if (newStatus == TaskStatus.done) {
      await _projectService.recalculateProgress(task.projectId);
    }
  }

  /// 更新任务优先级
  Future<void> updatePriority(String taskId, TaskPriority priority) async {
    final task = await _taskRepo.getById(taskId);
    if (task == null) return;

    final updated = task.copyWith(
      priority: priority,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _taskRepo.update(updated);
    await _enqueue('update', updated);
  }

  /// 分配任务负责人
  Future<void> assignTask(String taskId, String assigneeId) async {
    await _taskRepo.assignTask(taskId, assigneeId);
    await _enqueue('update', {'id': taskId, 'assignee_id': assigneeId});
  }

  /// 更新任务描述
  Future<void> updateDescription(String taskId, String description) async {
    final task = await _taskRepo.getById(taskId);
    if (task == null) return;

    final updated = task.copyWith(
      description: description,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _taskRepo.update(updated);
    await _enqueue('update', updated);
  }

  /// 删除任务
  Future<void> deleteTask(String taskId) async {
    final task = await _taskRepo.getById(taskId);
    if (task == null) return;

    await _taskRepo.delete(taskId);
    await _logDeletion(task);
    await _enqueue('delete', {'id': taskId, 'table': 'tasks'});

    // 重新计算项目进度
    await _projectService.recalculateProgress(task.projectId);
  }

  /// 获取即将到期任务
  Future<List<Task>> getUpcomingTasks(String projectId, {int daysAhead = 7}) async {
    return _taskRepo.getUpcomingTasks(projectId, daysAhead: daysAhead);
  }

  /// 获取逾期任务
  Future<List<Task>> getOverdueTasks(String projectId) async {
    return _taskRepo.getOverdueTasks(projectId);
  }

  /// 构建任务树
  Future<List<TaskTreeNode>> buildTaskTree(String projectId) async {
    return _taskRepo.buildTaskTree(projectId);
  }

  // ==================== 私有方法 ====================

  Future<void> _logCreation(Task task) async {
    final deviceId = await _keyManager.getDeviceId();
    await _logRepo.create(OperationLog(
      id: const Uuid().v4(),
      projectId: task.projectId,
      taskId: task.id,
      memberId: deviceId,
      memberName: '我',
      action: LogAction.create,
      field: 'task',
      newValue: task.title,
      timestamp: task.createdAt,
      synced: false,
    ));
  }

  Future<void> _logDeletion(Task task) async {
    final deviceId = await _keyManager.getDeviceId();
    await _logRepo.create(OperationLog(
      id: const Uuid().v4(),
      projectId: task.projectId,
      taskId: task.id,
      memberId: deviceId,
      memberName: '我',
      action: LogAction.delete,
      field: 'task',
      oldValue: task.title,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      synced: false,
    ));
  }

  Future<void> _enqueue(String operationType, dynamic payload) async {
    await _queueRepo.enqueue(
      operationType: operationType,
      tableName: 'tasks',
      recordId: payload is Task ? payload.id : payload['id'],
      payload: payload is Map ? payload : payload.toJson(),
    );
  }

  Future<void> _recalculateParentProgress(String parentId) async {
    // 简化的父任务进度计算：基于子任务完成比例
    final subtasks = await _taskRepo.getSubtasks(parentId);
    if (subtasks.isEmpty) return;

    final doneCount = subtasks.where((t) => t.isDone).length;
    final progress = doneCount / subtasks.length;
    await _taskRepo.updateProgress(parentId, progress);
  }

  String _statusToString(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return 'todo';
      case TaskStatus.inProgress:
        return 'in_progress';
      case TaskStatus.done:
        return 'done';
      case TaskStatus.blocked:
        return 'blocked';
    }
  }
}
