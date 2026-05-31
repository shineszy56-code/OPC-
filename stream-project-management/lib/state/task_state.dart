import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/enums.dart';
import '../data/models/project.dart';
import '../data/models/task.dart';
import '../services/task_service.dart';


/// 项目任务列表
final projectTasksProvider = FutureProvider.family<List<Task>, String>((ref, projectId) async {
  final service = TaskService();
  return service.getProjectTasks(projectId);
});

/// 任务详情
final taskDetailProvider = FutureProvider.family<Task?, String>((ref, taskId) async {
  final service = TaskService();
  return service.getTaskById(taskId);
});

/// 即将到期任务
final upcomingTasksProvider = FutureProvider.family<List<Task>, String>((ref, projectId) async {
  final service = TaskService();
  return service.getUpcomingTasks(projectId);
});

/// 逾期任务
final overdueTasksProvider = FutureProvider.family<List<Task>, String>((ref, projectId) async {
  final service = TaskService();
  return service.getOverdueTasks(projectId);
});

/// 任务操作 Notifier
final taskNotifierProvider = NotifierProvider<TaskNotifier, void>(TaskNotifier.new);

class TaskNotifier extends Notifier<void> {
  @override
  void build() {}

  /// 创建任务
  Future<Task> createTask({
    required String projectId,
    String? parentId,
    required String title,
    String description = '',
    TaskPriority priority = TaskPriority.medium,
    DateTime? dueDate,
    String? assigneeId,
  }) async {
    final service = TaskService();
    final task = await service.createTask(
      projectId: projectId,
      parentId: parentId,
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      assigneeId: assigneeId,
    );

    // 刷新任务列表
    ref.invalidate(projectTasksProvider(projectId));
    return task;
  }

  /// 更新任务状态
  Future<void> updateStatus(String taskId, TaskStatus newStatus) async {
    final service = TaskService();
    await service.updateStatus(taskId, newStatus);

    ref.invalidateSelf();
  }

  /// 更新优先级
  Future<void> updatePriority(String taskId, TaskPriority priority) async {
    final service = TaskService();
    await service.updatePriority(taskId, priority);

    ref.invalidateSelf();
  }

  /// 删除任务
  Future<void> deleteTask(String taskId, String projectId) async {
    final service = TaskService();
    await service.deleteTask(taskId);

    ref.invalidate(projectTasksProvider(projectId));
  }
}
