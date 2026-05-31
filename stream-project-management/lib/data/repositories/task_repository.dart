import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../core/database/database_schema.dart';
import '../../core/database/database_service.dart';
import '../models/enums.dart';
import '../models/task.dart';

/// 任务数据仓库
/// 封装 tasks 表的 CRUD 操作
class TaskRepository {
  TaskRepository._();

  static final TaskRepository _instance = TaskRepository._();

  factory TaskRepository() => _instance;

  final _dbService = DatabaseService();

  /// 创建任务
  Future<String> create(Task task) async {
    final db = await _dbService.database;
    final data = _taskToMap(task);
    await db.insert('tasks', data);
    return task.id;
  }

  /// 批量创建任务
  Future<List<String>> createBatch(List<Task> tasks) async {
    final db = await _dbService.database;
    final ids = <String>[];

    await db.transaction((txn) async {
      for (final task in tasks) {
        final data = _taskToMap(task);
        await txn.insert('tasks', data);
        ids.add(task.id);
      }
    });

    return ids;
  }

  /// 获取项目下的所有任务（不含子任务）
  Future<List<Task>> getByProjectId(String projectId, {bool includeSubtasks = false}) async {
    final db = await _dbService.database;
    String? where;
    List<dynamic> whereArgs = [projectId];

    if (!includeSubtasks) {
      where = 'project_id = ? AND parent_id IS NULL';
    } else {
      where = 'project_id = ?';
    }

    final results = await db.query(
      'tasks',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'created_at ASC',
    );

    return results.map((map) => _taskFromMap(map)).toList();
  }

  /// 获取子任务
  Future<List<Task>> getSubtasks(String parentId) async {
    final db = await _dbService.database;
    final results = await db.query(
      'tasks',
      where: 'parent_id = ?',
      whereArgs: [parentId],
      orderBy: 'created_at ASC',
    );

    return results.map((map) => _taskFromMap(map)).toList();
  }

  /// 根据 ID 获取任务
  Future<Task?> getById(String id) async {
    final db = await _dbService.database;
    final results = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return _taskFromMap(results.first);
  }

  /// 更新任务
  Future<void> update(Task task) async {
    final db = await _dbService.database;
    final data = _taskToMap(task);
    data['updated_at'] = DateTime.now().millisecondsSinceEpoch;
    await db.update(
      'tasks',
      data,
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  /// 删除任务（递归删除子任务）
  Future<void> delete(String id) async {
    final db = await _dbService.database;
    await db.delete(
      'tasks',
      where: 'id = ? OR parent_id = ?',
      whereArgs: [id, id],
    );
  }

  /// 更新任务状态
  Future<void> updateStatus(String id, String status) async {
    final db = await _dbService.database;
    await db.update(
      'tasks',
      {'status': status, 'updated_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 更新任务进度（递归计算父任务进度）
  Future<void> updateProgress(String id, double progress) async {
    final db = await _dbService.database;
    await db.update(
      'tasks',
      {'progress': progress, 'updated_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 分配任务负责人
  Future<void> assignTask(String taskId, String assigneeId) async {
    final db = await _dbService.database;
    await db.update(
      'tasks',
      {'assignee_id': assigneeId, 'updated_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  /// 获取即将到期的任务
  Future<List<Task>> getUpcomingTasks(String projectId, {int daysAhead = 7}) async {
    final db = await _dbService.database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final future = DateTime.now().add(Duration(days: daysAhead)).millisecondsSinceEpoch;

    final results = await db.query(
      'tasks',
      where: 'project_id = ? AND due_date BETWEEN ? AND ? AND status != ?',
      whereArgs: [projectId, now, future, 'done'],
      orderBy: 'due_date ASC',
    );

    return results.map((map) => _taskFromMap(map)).toList();
  }

  /// 获取逾期任务
  Future<List<Task>> getOverdueTasks(String projectId) async {
    final db = await _dbService.database;
    final now = DateTime.now().millisecondsSinceEpoch;

    final results = await db.query(
      'tasks',
      where: 'project_id = ? AND due_date < ? AND status != ?',
      whereArgs: [projectId, now, 'done'],
      orderBy: 'due_date ASC',
    );

    return results.map((map) => _taskFromMap(map)).toList();
  }

  /// 构建任务树（父任务 + 子任务）
  Future<List<TaskTreeNode>> buildTaskTree(String projectId) async {
    final allTasks = await getByProjectId(projectId, includeSubtasks: true);
    final parentTasks = allTasks.where((t) => t.parentId == null).toList();
    final result = <TaskTreeNode>[];

    for (final parent in parentTasks) {
      final children = allTasks.where((t) => t.parentId == parent.id).toList();
      result.add(TaskTreeNode(task: parent, children: children));
    }

    return result;
  }

  // ==================== 数据转换 ====================

  Map<String, dynamic> _taskToMap(Task task) {
    return {
      'id': task.id,
      'project_id': task.projectId,
      'parent_id': task.parentId,
      'title': task.title,
      'description': task.description,
      'status': _statusToString(task.status),
      'priority': _priorityToString(task.priority),
      'due_date': task.dueDate,
      'assignee_id': task.assigneeId,
      'ai_executable': task.aiExecutable ? 1 : 0,
      'ai_status': _aiStatusToString(task.aiStatus),
      'ai_result': task.aiResult,
      'attachments': json.encode(task.attachments.map((a) => a.toJson()).toList()),
      'created_at': task.createdAt,
      'updated_at': task.updatedAt,
      'last_modified_by': task.lastModifiedBy,
    };
  }

  Task _taskFromMap(Map<String, dynamic> map) {
    List<Attachment> attachments = [];
    if (map['attachments'] != null && map['attachments'].toString().isNotEmpty) {
      try {
        final List<dynamic> jsonList = json.decode(map['attachments'] as String);
        attachments = jsonList.map((json) => Attachment.fromJson(json as Map<String, dynamic>)).toList();
      } catch (_) {
        // 忽略解析错误
      }
    }

    return Task(
      id: map['id'] as String,
      projectId: map['project_id'] as String,
      parentId: map['parent_id'] as String?,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      status: _statusFromString(map['status'] as String),
      priority: _priorityFromString(map['priority'] as String? ?? 'medium'),
      dueDate: map['due_date'] as int?,
      assigneeId: map['assignee_id'] as String?,
      aiExecutable: (map['ai_executable'] as int? ?? 0) == 1,
      aiStatus: _aiStatusFromString(map['ai_status'] as String? ?? 'idle'),
      aiResult: map['ai_result'] as String?,
      attachments: attachments,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
      lastModifiedBy: map['last_modified_by'] as String? ?? '',
    );
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

  TaskStatus _statusFromString(String status) {
    switch (status) {
      case 'in_progress':
        return TaskStatus.inProgress;
      case 'done':
        return TaskStatus.done;
      case 'blocked':
        return TaskStatus.blocked;
      case 'todo':
      default:
        return TaskStatus.todo;
    }
  }

  String _priorityToString(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'low';
      case TaskPriority.medium:
        return 'medium';
      case TaskPriority.high:
        return 'high';
    }
  }

  TaskPriority _priorityFromString(String priority) {
    switch (priority) {
      case 'low':
        return TaskPriority.low;
      case 'high':
        return TaskPriority.high;
      case 'medium':
      default:
        return TaskPriority.medium;
    }
  }

  String _aiStatusToString(AIStatus status) {
    switch (status) {
      case AIStatus.idle:
        return 'idle';
      case AIStatus.running:
        return 'running';
      case AIStatus.completed:
        return 'completed';
      case AIStatus.failed:
        return 'failed';
    }
  }

  AIStatus _aiStatusFromString(String status) {
    switch (status) {
      case 'running':
        return AIStatus.running;
      case 'completed':
        return AIStatus.completed;
      case 'failed':
        return AIStatus.failed;
      case 'idle':
      default:
        return AIStatus.idle;
    }
  }
}

/// 任务树节点（用于展示父子任务关系）
class TaskTreeNode {
  final Task task;
  final List<Task> children;

  TaskTreeNode({required this.task, required this.children});
}
