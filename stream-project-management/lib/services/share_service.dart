import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import '../core/crypto/encryption_service.dart';
import '../core/crypto/key_manager.dart';
import '../data/models/enums.dart';
import '../data/models/operation_log.dart';
import '../data/models/share_record.dart';
import '../data/repositories/offline_queue_repository.dart';
import '../data/repositories/operation_log_repository.dart';
import '../data/repositories/project_repository.dart';
import '../data/repositories/share_record_repository.dart';
import 'notification_service.dart';

/// 分享管理服务
/// 设计文档 5.4：ShareService - 分享链接生成/撤销、加密/解密
class ShareService {
  ShareService._();

  static final ShareService _instance = ShareService._();

  factory ShareService() => _instance;

  final _shareRepo = ShareRecordRepository();
  final _logRepo = OperationLogRepository();
  final _queueRepo = OfflineQueueRepository();
  final _keyManager = KeyManager();
  final _encryption = EncryptionService();
  final _storage = const FlutterSecureStorage();

  /// 创建分享链接
  /// 返回分享 URL（密钥在哈希中）
  Future<String> createShareLink({
    required String projectId,
    String? taskId,
    required MemberPermission permission,
    required Duration ttl,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final shareKey = _encryption.generateShareKey();
    final shareId = const Uuid().v4();

    final record = ShareRecord(
      id: shareId,
      projectId: projectId,
      taskId: taskId,
      type: ShareType.cloudflare,
      permission: permission,
      expiresAt: now + ttl.inMilliseconds,
      cloudflareKey: shareId,
      createdAt: now,
    );

    await _shareRepo.create(record);

    // 记录日志
    await _logRepo.create(
      OperationLog(
        id: const Uuid().v4(),
        projectId: projectId,
        memberId: await _keyManager.getDeviceId(),
        memberName: '我',
        action: LogAction.create,
        field: 'share',
        newValue: permission.name,
        timestamp: now,
        synced: false,
      ),
    );

    await _queueRepo.enqueue(
      operationType: 'create',
      tableName: 'share_records',
      recordId: shareId,
      payload: record.toJson(),
    );

    // 生成分享 URL（密钥在哈希中，不传输到服务器）
    return KeyManager.generateShareUrl(shareId, shareKey);
  }

  /// 获取项目所有分享记录
  Future<List<ShareRecord>> getProjectShares(String projectId) async {
    return _shareRepo.getByProjectId(projectId);
  }

  /// 撤销分享链接
  Future<void> revokeShare(String shareId) async {
    final record = await _shareRepo.getById(shareId);
    if (record == null) return;

    await _shareRepo.delete(shareId);

    await _logRepo.create(
      OperationLog(
        id: const Uuid().v4(),
        projectId: record.projectId ?? '',
        memberId: await _keyManager.getDeviceId(),
        memberName: '我',
        action: LogAction.delete,
        field: 'share',
        oldValue: shareId,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        synced: false,
      ),
    );
  }

  /// 更新分享权限
  Future<void> updateSharePermission(
    String shareId,
    MemberPermission newPermission,
  ) async {
    await _shareRepo.updatePermission(shareId, newPermission);
  }

  /// 延长分享有效期
  Future<void> extendShareExpiry(String shareId, Duration additional) async {
    final record = await _shareRepo.getById(shareId);
    if (record == null) return;

    final newExpiry = record.expiresAt + additional.inMilliseconds;
    await _shareRepo.extendExpiry(shareId, newExpiry);
  }

  /// 清理过期分享
  Future<void> cleanupExpired() async {
    await _shareRepo.cleanupExpired();
  }

  /// 从分享 URL 中解析并解密数据
  /// 这是网页协作端使用的核心方法
  Future<Map<String, dynamic>> decryptShareData(
    String shareId,
    List<int> shareKey,
  ) async {
    // 从 Cloudflare KV 获取加密数据
    final encryptedData = await _fetchFromCloudflare(shareId);
    if (encryptedData == null) {
      throw Exception('分享已过期或不存在');
    }

    // 使用分享密钥解密
    final jsonStr = _encryption.decryptFromShare(encryptedData, shareKey);
    return json.decode(jsonStr) as Map<String, dynamic>;
  }

  /// 加密数据并上传到 Cloudflare KV
  Future<void> encryptAndUploadShareData(
    String shareId,
    List<int> shareKey,
    Map<String, dynamic> data,
  ) async {
    final jsonStr = json.encode(data);
    final encrypted = _encryption.encryptForShare(jsonStr, shareKey);

    await _uploadToCloudflare(shareId, encrypted);
  }

  /// 从 Cloudflare KV 获取数据（模拟）
  Future<String?> _fetchFromCloudflare(String shareId) async {
    // TODO: 实现 Cloudflare Workers API 调用
    return null;
  }

  /// 上传数据到 Cloudflare KV（模拟）
  Future<void> _uploadToCloudflare(String shareId, String encrypted) async {
    // TODO: 实现 Cloudflare Workers API 调用
  }

  /// 生成分享二维码数据
  Future<String> generateQRData(String shareUrl) async {
    return shareUrl;
  }
}
