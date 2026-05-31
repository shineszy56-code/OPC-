import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../core/crypto/key_manager.dart';
import '../data/models/enums.dart';
import '../data/models/operation_log.dart';
import '../data/models/project.dart';
import '../data/repositories/offline_queue_repository.dart';
import '../data/repositories/operation_log_repository.dart';
import '../data/repositories/project_repository.dart';
import 'notification_service.dart';

/// 项目业务逻辑服务
/// 设计文档 5.4：ProjectService - 项目CRUD、进度计算
class ProjectService {
  ProjectService._();

  static final ProjectService _instance = ProjectService._();

  factory ProjectService() => _instance;

  final _repository = ProjectRepository();
  final _logRepository = OperationLogRepository();
  final _queueRepository = OfflineQueueRepository();
  final _keyManager = KeyManager();

  /// 创建项目
  Future<Project> createProject({
    required String name,
    String icon = '📁',
    String description = '',
    required DateTime startDate,
    required DateTime endDate,
    String aiPrompt = '',
  }) async {
    final deviceId = await _keyManager.getDeviceId();
    final now = DateTime.now().millisecondsSinceEpoch;

    final project = Project(
      id: const Uuid().v4(),
      name: name,
      icon: icon,
      description: description,
      status: ProjectStatus.active,
      startDate: startDate.millisecondsSinceEpoch,
      endDate: endDate.millisecondsSinceEpoch,
      progress: 0.0,
      aiPrompt: aiPrompt,
      ownerId: deviceId,
      createdAt: now,
      updatedAt: now,
    );

    await _repository.create(project);

    // 记录操作日志
    await _logRepository.create(OperationLog(
      id: const Uuid().v4(),
      projectId: project.id,
      memberId: deviceId,
      memberName: '我', // TODO: 从设置获取用户昵称
      action: LogAction.create,
      field: 'project',
      newValue: name,
      timestamp: now,
      synced: false,
    ));

    // 加入离线队列
    await _queueRepository.enqueue(
      operationType: 'create',
      tableName: 'projects',
      recordId: project.id,
      payload: project.toJson(),
    );

    return project;
  }

  /// 获取所有项目
  Future<List<Project>> getAllProjects({bool includeArchived = false}) async {
    return _repository.getAll(includeArchived: includeArchived);
  }

  /// 根据 ID 获取项目
  Future<Project?> getProjectById(String id) async {
    return _repository.getById(id);
  }

  /// 更新项目
  Future<void> updateProject(Project project, {String? changedField}) async {
    final updated = project.copyWith(
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _repository.update(updated);

    // 记录操作日志
    final deviceId = await _keyManager.getDeviceId();
    await _logRepository.create(OperationLog(
      id: const Uuid().v4(),
      projectId: project.id,
      memberId: deviceId,
      memberName: '我',
      action: LogAction.update,
      field: changedField,
      newValue: changedField == 'name' ? project.name : null,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      synced: false,
    ));
  }

  /// 归档项目
  Future<void> archiveProject(String id) async {
    await _repository.archive(id);

    final deviceId = await _keyManager.getDeviceId();
    await _logRepository.create(OperationLog(
      id: const Uuid().v4(),
      projectId: id,
      memberId: deviceId,
      memberName: '我',
      action: LogAction.statusChange,
      field: 'status',
      oldValue: 'active',
      newValue: 'archived',
      timestamp: DateTime.now().millisecondsSinceEpoch,
      synced: false,
    ));
  }

  /// 删除项目（硬删除）
  Future<void> deleteProject(String id) async {
    await _repository.delete(id);
  }

  /// 自动计算项目进度
  /// 设计文档 5.2.2：progress 自动计算
  Future<void> recalculateProgress(String projectId) async {
    final progress = await _repository.calculateProgress(projectId);
    await _repository.updateProgress(projectId, progress);

    // 通知监听者
    NotificationService().notifyProjectProgressChanged(projectId, progress);
  }

  /// 搜索项目
  Future<List<Project>> searchProjects(String query) async {
    return _repository.search(query);
  }

  /// 获取活跃项目数量
  Future<int> getActiveProjectCount() async {
    final projects = await _repository.getAll();
    return projects.where((p) => p.isActive).length;
  }

  /// 获取项目统计
  Future<Map<String, dynamic>> getProjectStats(String projectId) async {
    final tasks = await _repository.getAll(); // TODO: 需要 TaskRepository
    final project = await _repository.getById(projectId);
    
    return {
      'totalTasks': 0, // TODO: 从 TaskRepository 获取
      'completedTasks': 0,
      'progress': project?.progress ?? 0,
      'daysRemaining': project != null
          ? ((project.endDate - DateTime.now().millisecondsSinceEpoch) / (24 * 60 * 60 * 1000)).ceil()
          : 0,
    };
  }
}
