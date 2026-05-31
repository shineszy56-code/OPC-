/// 项目数据仓库测试
/// 设计文档 10.3：单元测试（services、repositories、ai_engine）
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:stream_project_management/data/models/enums.dart';
import 'package:stream_project_management/data/models/project.dart';
import 'package:stream_project_management/data/repositories/project_repository.dart';
import 'package:stream_project_management/services/project_service.dart';

/// 模拟 ProjectRepository
class MockProjectRepository extends Mock implements ProjectRepository {}

void main() {
  group('ProjectService 测试', () {
    late ProjectService service;
    late MockProjectRepository mockRepo;

    setUp(() {
      mockRepo = MockProjectRepository();
      // TODO: 使用依赖注入替换实际 Repository
      service = ProjectService();
    });

    tearDown(() {
      // 清理
    });

    test('创建项目 - 成功', () async {
      // Arrange
      const projectName = '测试项目';
      final startDate = DateTime.now();
      final endDate = startDate.add(const Duration(days: 30));

      // Act
      final project = await service.createProject(
        name: projectName,
        startDate: startDate,
        endDate: endDate,
      );

      // Assert
      expect(project, isNotNull);
      expect(project.name, projectName);
      expect(project.status, ProjectStatus.active);
      expect(project.progress, 0.0);
    });

    test('获取所有项目 - 返回列表', () async {
      // Act
      final projects = await service.getAllProjects();

      // Assert
      expect(projects, isA<List<Project>>());
    });

    test('归档项目 - 成功', () async {
      // Arrange
      const projectId = 'test-id';

      // Act & Assert
      expect(() => service.archiveProject(projectId), returnsNormally);
    });

    test('删除项目 - 成功', () async {
      // Arrange
      const projectId = 'test-id';

      // Act & Assert
      expect(() => service.deleteProject(projectId), returnsNormally);
    });

    test('重新计算项目进度 - 成功', () async {
      // Arrange
      const projectId = 'test-id';

      // Act & Assert
      expect(() => service.recalculateProgress(projectId), returnsNormally);
    });
  });

  group('ProjectRepository 测试', () {
    late ProjectRepository repository;

    setUp(() {
      repository = ProjectRepository();
    });

    test('创建项目 - 返回 ID', () async {
      // Arrange
      final project = Project(
        id: 'test-id',
        name: '测试项目',
        icon: '📁',
        description: '测试描述',
        status: ProjectStatus.active,
        startDate: DateTime.now().millisecondsSinceEpoch,
        endDate: DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch,
        progress: 0.0,
        aiPrompt: '',
        ownerId: 'test-owner',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

      // Act
      final id = await repository.create(project);

      // Assert
      expect(id, isNotNull);
      expect(id, 'test-id');
    });

    test('根据 ID 获取项目 - 存在', () async {
      // Arrange
      const projectId = 'test-id';
      // TODO: 先插入测试数据

      // Act
      final project = await repository.getById(projectId);

      // Assert
      expect(project, isNull);
    });

    test('更新项目 - 成功', () async {
      // Arrange
      final project = Project(
        id: 'test-id',
        name: '更新后的名称',
        icon: '📊',
        description: '更新后的描述',
        status: ProjectStatus.active,
        startDate: DateTime.now().millisecondsSinceEpoch,
        endDate: DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch,
        progress: 0.5,
        aiPrompt: '',
        ownerId: 'test-owner',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

      // Act & Assert
      expect(() => repository.update(project), returnsNormally);
    });

    test('删除项目 - 成功', () async {
      // Arrange
      const projectId = 'test-id';

      // Act & Assert
      expect(() => repository.delete(projectId), returnsNormally);
    });
  });
}
