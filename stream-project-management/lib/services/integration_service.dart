import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import '../core/crypto/key_manager.dart';
import '../data/models/enums.dart';
import '../data/models/operation_log.dart';
import '../data/repositories/operation_log_repository.dart';
import 'ai_service.dart';
import 'project_service.dart';

/// 第三方工具集成服务
/// 设计文档 5.4：IntegrationService - GitHub等第三方工具集成
class IntegrationService {
  IntegrationService._();

  static final IntegrationService _instance = IntegrationService._();

  factory IntegrationService() => _instance;

  final _logRepo = OperationLogRepository();
  final _keyManager = KeyManager();
  final _projectService = ProjectService();
  final _aiService = AIService();

  /// GitHub 集成配置
  String? _githubToken;
  String? _githubUsername;

  /// Cursor 集成配置
  String? _cursorApiKey;

  /// Claude 集成配置
  String? _claudeApiKey;

  /// 配置 GitHub 集成
  Future<bool> configureGithub({
    required String token,
    required String username,
  }) async {
    _githubToken = token;
    _githubUsername = username;

    // 保存到安全存储
    final storage = FlutterSecureStorage();
    await storage.write(key: 'github_token', value: token);
    await storage.write(key: 'github_username', value: username);

    return true;
  }

  /// 配置 Cursor 集成
  Future<bool> configureCursor(String apiKey) async {
    _cursorApiKey = apiKey;
    final storage = FlutterSecureStorage();
    await storage.write(key: 'cursor_api_key', value: apiKey);
    return true;
  }

  /// 配置 Claude 集成
  Future<bool> configureClaude(String apiKey) async {
    _claudeApiKey = apiKey;
    final storage = FlutterSecureStorage();
    await storage.write(key: 'claude_api_key', value: apiKey);
    return true;
  }

  /// 从安全存储加载配置
  Future<void> loadSavedConfigs() async {
    final storage = FlutterSecureStorage();
    _githubToken = await storage.read(key: 'github_token');
    _githubUsername = await storage.read(key: 'github_username');
    _cursorApiKey = await storage.read(key: 'cursor_api_key');
    _claudeApiKey = await storage.read(key: 'claude_api_key');
  }

  /// 同步 GitHub 提交记录
  /// 返回新增提交数
  Future<int> syncGithubCommits(String projectId) async {
    if (_githubToken == null || _githubUsername == null) {
      return 0;
    }

    try {
      // TODO: 实现 GitHub API 调用
      // GET /user/repos + /repos/{owner}/{repo}/commits
      await Future.delayed(const Duration(seconds: 1));

      // 模拟：记录到操作日志
      final deviceId = await _keyManager.getDeviceId();
      await _logRepo.create(OperationLog(
        id: const Uuid().v4(),
        projectId: projectId,
        memberId: deviceId,
        memberName: 'GitHub Sync',
        action: LogAction.create,
        field: 'integration',
        newValue: '同步了 GitHub 提交记录',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        synced: false,
      ));

      return 3; // 模拟返回 3 条新提交
    } catch (e) {
      return 0;
    }
  }

  /// 同步 Cursor 使用记录
  Future<int> syncCursorUsage(String projectId) async {
    if (_cursorApiKey == null) return 0;

    try {
      // TODO: 实现 Cursor API 调用
      await Future.delayed(const Duration(seconds: 1));

      final deviceId = await _keyManager.getDeviceId();
      await _logRepo.create(OperationLog(
        id: const Uuid().v4(),
        projectId: projectId,
        memberId: deviceId,
        memberName: 'Cursor Sync',
        action: LogAction.update,
        field: 'integration',
        newValue: '同步了 Cursor 使用记录',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        synced: false,
      ));

      return 5; // 模拟返回 5 条记录
    } catch (e) {
      return 0;
    }
  }

  /// 同步 Claude 使用记录
  Future<int> syncClaudeUsage(String projectId) async {
    if (_claudeApiKey == null) return 0;

    try {
      // TODO: 实现 Claude API 调用
      await Future.delayed(const Duration(seconds: 1));

      final deviceId = await _keyManager.getDeviceId();
      await _logRepo.create(OperationLog(
        id: const Uuid().v4(),
        projectId: projectId,
        memberId: deviceId,
        memberName: 'Claude Sync',
        action: LogAction.update,
        field: 'integration',
        newValue: '同步了 Claude 使用记录',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        synced: false,
      ));

      return 2; // 模拟返回 2 条记录
    } catch (e) {
      return 0;
    }
  }

  /// 同步所有已配置的集成
  Future<IntegrationSyncResult> syncAll(String projectId) async {
    final githubCount = await syncGithubCommits(projectId);
    final cursorCount = await syncCursorUsage(projectId);
    final claudeCount = await syncClaudeUsage(projectId);

    return IntegrationSyncResult(
      githubCommits: githubCount,
      cursorUsage: cursorCount,
      claudeUsage: claudeCount,
    );
  }

  /// 获取 GitHub 仓库列表
  Future<List<GithubRepo>> getGithubRepos() async {
    if (_githubToken == null) return [];

    try {
      // TODO: 实现 GitHub API 调用
      // GET /user/repos
      await Future.delayed(const Duration(seconds: 1));

      return [
        GithubRepo(
          name: 'sample-repo',
          fullName: '$_githubUsername/sample-repo',
          description: '示例仓库',
          url: 'https://github.com/$_githubUsername/sample-repo',
          lastCommitAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];
    } catch (e) {
      return [];
    }
  }

  /// 获取集成状态
  IntegrationStatus getStatus() {
    return IntegrationStatus(
      githubConfigured: _githubToken != null,
      cursorConfigured: _cursorApiKey != null,
      claudeConfigured: _claudeApiKey != null,
    );
  }

  /// 移除 GitHub 配置
  Future<void> removeGithubConfig() async {
    _githubToken = null;
    _githubUsername = null;
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'github_token');
    await storage.delete(key: 'github_username');
  }

  /// 移除 Cursor 配置
  Future<void> removeCursorConfig() async {
    _cursorApiKey = null;
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'cursor_api_key');
  }

  /// 移除 Claude 配置
  Future<void> removeClaudeConfig() async {
    _claudeApiKey = null;
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'claude_api_key');
  }
}

/// GitHub 仓库信息
class GithubRepo {
  final String name;
  final String fullName;
  final String description;
  final String url;
  final int lastCommitAt;

  GithubRepo({
    required this.name,
    required this.fullName,
    required this.description,
    required this.url,
    required this.lastCommitAt,
  });
}

/// 集成同步结果
class IntegrationSyncResult {
  final int githubCommits;
  final int cursorUsage;
  final int claudeUsage;

  IntegrationSyncResult({
    required this.githubCommits,
    required this.cursorUsage,
    required this.claudeUsage,
  });
}

/// 集成状态
class IntegrationStatus {
  final bool githubConfigured;
  final bool cursorConfigured;
  final bool claudeConfigured;

  IntegrationStatus({
    required this.githubConfigured,
    required this.cursorConfigured,
    required this.claudeConfigured,
  });
}
