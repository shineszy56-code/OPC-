import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import '../core/crypto/encryption_service.dart';
import '../core/crypto/key_manager.dart';
import '../data/models/enums.dart';
import 'incremental_sync.dart';

/// Cloudflare KV 中继同步
/// 设计文档 5.1 + 6.2：Cloudflare Workers API 同步
class CloudflareSync {
  CloudflareSync._();

  static final CloudflareSync _instance = CloudflareSync._();

  factory CloudflareSync() => _instance;

  final _encryption = EncryptionService();
  final _keyManager = KeyManager();
  final _dio = Dio();
  final _incrementalSync = IncrementalSync();

  /// Cloudflare Workers API 基础 URL
  static const String _baseUrl = 'https://api.aiopc.app/v1';

  /// 上传分享数据到 Cloudflare KV
  /// [shareId] 分享 ID
  /// [encryptedData] AES-256-GCM 加密后的数据（base64）
  Future<bool> uploadShareData({
    required String shareId,
    required String encryptedData,
  }) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/share/$shareId',
        data: {'data': encryptedData},
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  /// 从 Cloudflare KV 下载分享数据
  /// 返回 AES-256-GCM 加密后的数据（base64）
  Future<String?> downloadShareData(String shareId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/share/$shareId',
        options: Options(
          validateStatus: (status) => status != null,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data['data'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 同步增量变更到 Cloudflare KV
  /// [projectId] 项目 ID
  /// [diff] 增量变更数据（已加密）
  Future<bool> syncIncremental({
    required String projectId,
    required String encryptedDiff,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/share/$projectId/sync',
        data: {'diff': encryptedDiff},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// 从 Cloudflare KV 拉取增量变更
  /// 返回加密的增量数据（需使用项目密钥解密）
  Future<String?> pullIncremental(String projectId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/share/$projectId/sync',
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data['diff'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 上传文件到 Cloudflare R2
  Future<String?> uploadFile({
    required String fileId,
    required List<int> fileBytes,
    required String fileName,
  }) async {
    try {
      // 使用 FormData 上传
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      });

      final response = await _dio.post(
        '$_baseUrl/file',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['url'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 从 Cloudflare R2 下载文件
  Future<List<int>?> downloadFile(String fileId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/file/$fileId',
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data as List<int>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 获取操作日志
  Future<List<Map<String, dynamic>>> getOperationLogs(String projectId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/share/$projectId/log',
      );

      if (response.statusCode == 200 && response.data != null) {
        final logs = response.data['logs'] as List<dynamic>;
        return logs.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// 健康检查
  Future<bool> healthCheck() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/health',
        options: Options(
          validateStatus: (status) => status != null,
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// 生成分享链接
  /// 返回完整的分享 URL（密钥在哈希中）
  Future<String?> generateShareLink({
    required String projectId,
    required MemberPermission permission,
    required Duration ttl,
  }) async {
    try {
      final shareKey = _encryption.generateShareKey();
      final shareId = _generateShareId();

      final response = await _dio.post(
        '$_baseUrl/share',
        data: {
          'project_id': projectId,
          'permission': _permissionToString(permission),
          'expires_in': ttl.inSeconds,
        },
      );

      if (response.statusCode == 201 && response.data != null) {
        final shareUrl = KeyManager.generateShareUrl(
          response.data['share_id'] as String,
          shareKey,
        );
        return shareUrl;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 撤销分享链接
  Future<bool> revokeShareLink(String shareId) async {
    try {
      final response = await _dio.delete(
        '$_baseUrl/share/$shareId',
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// 生成分享 ID
  String _generateShareId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        _encryption.generateSalt().map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// 权限枚举转字符串
  String _permissionToString(MemberPermission permission) {
    switch (permission) {
      case MemberPermission.read:
        return 'read';
      case MemberPermission.comment:
        return 'comment';
      case MemberPermission.edit:
        return 'edit';
      case MemberPermission.admin:
        return 'admin';
    }
  }

  /// 销毁资源
  void dispose() {
    _dio.close();
  }
}
