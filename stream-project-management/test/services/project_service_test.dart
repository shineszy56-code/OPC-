library;

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stream_project_management/data/models/enums.dart';
import 'package:stream_project_management/data/models/project.dart';
import 'package:stream_project_management/data/repositories/project_repository.dart';
import 'package:stream_project_management/services/project_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  final testDocumentsPath = Directory.systemTemp
      .createTempSync('ai_opc_test_')
      .path;

  setUpAll(() {
    FlutterSecureStorage.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (call) async {
          if (call.method == 'getApplicationDocumentsDirectory') {
            return testDocumentsPath;
          }
          return testDocumentsPath;
        });
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
    Directory(testDocumentsPath).deleteSync(recursive: true);
  });

  group(
    'ProjectService 测试',
    skip: 'Requires native sqflite_sqlcipher plugin',
    () {
      late ProjectService service;

      setUp(() {
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
    },
  );

  group(
    'ProjectRepository 测试',
    skip: 'Requires native sqflite_sqlcipher plugin',
    () {
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
          endDate: DateTime.now()
              .add(const Duration(days: 30))
              .millisecondsSinceEpoch,
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
          endDate: DateTime.now()
              .add(const Duration(days: 30))
              .millisecondsSinceEpoch,
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
    },
  );
}
