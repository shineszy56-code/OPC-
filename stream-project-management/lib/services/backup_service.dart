import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../core/crypto/encryption_service.dart';
import '../core/crypto/key_manager.dart';
import '../data/models/project.dart';
import '../data/repositories/project_repository.dart';
import 'project_service.dart';
import 'task_service.dart';

/// 备份与恢复服务
/// 设计文档 5.4：BackupService - 本地JSON导出、加密云备份、恢复
class BackupService {
  BackupService._();

  static final BackupService _instance = BackupService._();

  factory BackupService() => _instance;

  final _encryption = EncryptionService();
  final _keyManager = KeyManager();
  final _projectService = ProjectService();
  final _taskService = TaskService();

  /// 导出为 JSON 文件（本地备份）
  /// 设计文档 11.1：用户可以随时导出所有数据
  Future<String?> exportToJson() async {
    try {
      final projects = await _projectService.getAllProjects(
        includeArchived: true,
      );
      final data = {
        'version': '1.0.0',
        'exported_at': DateTime.now().toIso8601String(),
        'projects': projects.map((p) => p.toJson()).toList(),
        // TODO: 导出任务和成员
      };

      final jsonStr = json.encode(data);
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/ai_opc_backup_${DateTime.now().millisecondsSinceEpoch}.json',
      );
      await file.writeAsString(jsonStr);

      return file.path;
    } catch (e) {
      return null;
    }
  }

  /// 导出到用户选择的路径
  Future<String?> exportToPath() async {
    try {
      final projects = await _projectService.getAllProjects(
        includeArchived: true,
      );
      final data = {
        'version': '1.0.0',
        'exported_at': DateTime.now().toIso8601String(),
        'projects': projects.map((p) => p.toJson()).toList(),
      };

      final jsonStr = json.encode(data);
      final result = await FilePicker.platform.saveFile(
        dialogTitle: '导出备份',
        fileName: 'ai_opc_backup_${DateTime.now().millisecondsSinceEpoch}.json',
      );

      if (result != null) {
        final file = File(result);
        await file.writeAsString(jsonStr);
        return result;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 从 JSON 文件恢复
  Future<bool> restoreFromPath() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: '选择备份文件',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) return false;

      final file = File(result.files.first.path!);
      final jsonStr = await file.readAsString();
      final data = json.decode(jsonStr) as Map<String, dynamic>;

      // 验证版本
      final version = data['version'] as String?;
      if (version == null) return false;

      // 恢复项目
      final projects = data['projects'] as List<dynamic>? ?? [];
      for (final projectJson in projects) {
        final project = Project.fromJson(projectJson as Map<String, dynamic>);
        await _projectService.createProject(
          name: project.name,
          icon: project.icon,
          description: project.description,
          startDate: DateTime.fromMillisecondsSinceEpoch(project.startDate),
          endDate: DateTime.fromMillisecondsSinceEpoch(project.endDate),
          aiPrompt: project.aiPrompt,
        );
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// 加密备份到云端（Cloudflare R2）
  /// 设计文档 5.2.1：端到端加密云备份
  Future<bool> encryptedCloudBackup() async {
    try {
      // 1. 收集所有数据
      final projects = await _projectService.getAllProjects(
        includeArchived: true,
      );
      final data = {
        'version': '1.0.0',
        'projects': projects.map((p) => p.toJson()).toList(),
      };

      final jsonStr = json.encode(data);

      // 2. 使用用户密码派生的密钥加密
      // TODO: 获取用户密码（通过生物识别验证后）
      final password = 'user_password_placeholder'; // 需要从用户获取
      final salt = _encryption.generateSalt();
      final key = _encryption.deriveKeyFromPassword(password, salt);

      final encrypted = _encryption.encryptAES256CBC(jsonStr, key);

      // 3. 上传到 Cloudflare R2
      // TODO: 实现 R2 上传
      await Future.delayed(const Duration(seconds: 1));

      return true;
    } catch (e) {
      return false;
    }
  }

  /// 从云端恢复（需要密码）
  Future<bool> restoreFromCloud(String password) async {
    try {
      // 1. 从 Cloudflare R2 下载加密备份
      // TODO: 实现 R2 下载
      final encryptedData = 'encrypted_data_placeholder';

      // 2. 解密
      final salt = _encryption.generateSalt(); // 需要从备份中获取
      final key = _encryption.deriveKeyFromPassword(password, salt);
      final jsonStr = _encryption.decryptAES256CBC(encryptedData, key);

      // 3. 恢复数据
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      final projects = data['projects'] as List<dynamic>? ?? [];
      for (final projectJson in projects) {
        final project = Project.fromJson(projectJson as Map<String, dynamic>);
        await _projectService.createProject(
          name: project.name,
          icon: project.icon,
          description: project.description,
          startDate: DateTime.fromMillisecondsSinceEpoch(project.startDate),
          endDate: DateTime.fromMillisecondsSinceEpoch(project.endDate),
        );
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// 自动备份（定期调用）
  Future<void> autoBackup() async {
    // 每天自动备份到本地临时目录
    final tempDir = await getTemporaryDirectory();
    final backupDir = Directory('${tempDir.path}/ai_opc_backups');
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    final projects = await _projectService.getAllProjects(
      includeArchived: true,
    );
    final data = {
      'version': '1.0.0',
      'projects': projects.map((p) => p.toJson()).toList(),
    };

    final jsonStr = json.encode(data);
    final file = File(
      '${backupDir.path}/backup_${DateTime.now().millisecondsSinceEpoch}.json',
    );
    await file.writeAsString(jsonStr);
  }

  /// 获取本地备份列表
  Future<List<FileSystemEntity>> getLocalBackups() async {
    final tempDir = await getTemporaryDirectory();
    final backupDir = Directory('${tempDir.path}/ai_opc_backups');
    if (!await backupDir.exists()) return [];

    final files = backupDir.listSync()
      ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    return files;
  }

  /// 删除本地备份
  Future<void> deleteLocalBackup(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
