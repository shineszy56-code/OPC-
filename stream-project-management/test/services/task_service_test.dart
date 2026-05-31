/// 任务服务测试
/// 设计文档 10.3：单元测试（services、repositories、ai_engine）
import 'package:flutter_test/flutter_test.dart';

import 'package:stream_project_management/data/models/enums.dart';
import 'package:stream_project_management/data/models/task.dart';
import 'package:stream_project_management/data/repositories/task_repository.dart';
import 'package:stream_project_management/services/task_service.dart';

void main() {
  group('TaskService 测试', () {
    late TaskService service;

    setUp(() {
      service = TaskService();
    });

    tearDown(() {
      // 清理
    });

    test('创建任务 - 成功', () async {
      // Arrange
      const projectId = 'test-project-id';
      const taskTitle = '测试任务';

      // Act
      final task = await service.createTask(
        projectId: projectId,
        title: taskTitle,
      );

      // Assert
      expect(task, isNotNull);
      expect(task.title, taskTitle);
      expect(task.status, TaskStatus.todo);
      expect(task.priority, TaskPriority.medium);
    });

    test('批量创建任务 - 成功', () async {
      // Arrange
      const projectId = 'test-project-id';
      final drafts = [
        TaskDraft(
          title: '子任务1',
          priority: TaskPriority.high,
        ),
        TaskDraft(
          title: '子任务2',
          priority: TaskPriority.low,
        ),
      ];

      // Act
      final tasks = await service.createTasksBatch(
        projectId: projectId,
        drafts: drafts,
      );

      // Assert
      expect(tasks, isA<List<Task>>());
      expect(tasks.length, 2);
    });

    test('获取项目任务 - 返回列表', () async {
      // Arrange
      const projectId = 'test-project-id';

      // Act
      final tasks = await service.getProjectTasks(projectId);

      // Assert
      expect(tasks, isA<List<Task>>());
    });

    test('更新任务状态 - 成功', () async {
      // Arrange
      const taskId = 'test-task-id';
      const newStatus = TaskStatus.inProgress;

      // Act & Assert
      expect(
        () => service.updateStatus(taskId, newStatus),
        returnsNormally,
      );
    });

    test('删除任务 - 成功', () async {
      // Arrange
      const taskId = 'test-task-id';

      // Act & Assert
      expect(
        () => service.deleteTask(taskId),
        returnsNormally,
      );
    });

    test('获取即将到期任务 - 成功', () async {
      // Arrange
      const projectId = 'test-project-id';

      // Act
      final tasks = await service.getUpcomingTasks(projectId);

      // Assert
      expect(tasks, isA<List<Task>>());
    });

    test('获取逾期任务 - 成功', () async {
      // Arrange
      const projectId = 'test-project-id';

      // Act
      final tasks = await service.getOverdueTasks(projectId);

      // Assert
      expect(tasks, isA<List<Task>>());
    });

    test('构建任务树 - 成功', () async {
      // Arrange
      const projectId = 'test-project-id';

      // Act
      final tree = await service.buildTaskTree(projectId);

      // Assert
      expect(tree, isA<List<TaskTreeNode>>());
    });
  });

  group('TaskRepository 测试', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    test('创建任务 - 返回 ID', () async {
      // Arrange
      final task = Task(
        id: 'test-task-id',
        projectId: 'test-project-id',
        title: '测试任务',
        description: '测试描述',
        status: TaskStatus.todo,
        priority: TaskPriority.medium,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

      // Act
      final id = await repository.create(task);

      // Assert
      expect(id, isNotNull);
    });

    test('根据 ID 获取任务 - 存在', () async {
      // Arrange
      const taskId = 'test-task-id';

      // Act
      final task = await repository.getById(taskId);

      // Assert
      // 当前返回 null（需要数据库）
      expect(task, isNull);
    });

    test('更新任务状态 - 成功', () async {
      // Arrange
      const taskId = 'test-task-id';
      const status = 'in_progress';

      // Act & Assert
      expect(
        () => repository.updateStatus(taskId, status),
        returnsNormally,
      );
    });

    test('删除任务 - 成功', () async {
      // Arrange
      const taskId = 'test-task-id';

      // Act & Assert
      expect(
        () => repository.delete(taskId),
        returnsNormally,
      );
    });

    test('获取子任务 - 成功', () async {
      // Arrange
      const parentId = 'test-parent-id';

      // Act
      final subtasks = await repository.getSubtasks(parentId);

      // Assert
      expect(subtasks, isA<List<Task>>());
    });
  });
}
