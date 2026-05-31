import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../core/crypto/encryption_service.dart';
import '../core/crypto/key_manager.dart';
import '../data/models/offline_queue.dart';
import '../data/repositories/offline_queue_repository.dart';
import '../data/repositories/operation_log_repository.dart';

/// 同步引擎服务
/// 设计文档 5.1 + 5.4：SyncService - 云端同步、冲突解决、离线队列
class SyncService {
  SyncService._();

  static final SyncService _instance = SyncService._();

  factory SyncService() => _instance;

  final _queueRepo = OfflineQueueRepository();
  final _logRepo = OperationLogRepository();
  final _encryption = EncryptionService();
  final _keyManager = KeyManager();
  final _connectivity = Connectivity();

  bool _isSyncing = false;

  /// 网络状态监听
  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;

  /// 是否在线
  Future<bool> get isOnline async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  /// 同步所有待同步数据
  Future<SyncResult> syncAll(String projectId) async {
    if (_isSyncing) {
      return SyncResult(status: SyncStatus.inProgress, synced: 0, failed: 0);
    }

    _isSyncing = true;
    var synced = 0;
    var failed = 0;

    try {
      final pendingItems = await _queueRepo.getPending(limit: 50);

      for (final item in pendingItems) {
        try {
          await _syncItem(item, projectId);
          await _queueRepo.markAsSynced(item.id);
          synced++;
        } catch (e) {
          await _queueRepo.markAsFailed(item.id, e.toString());
          failed++;
        }
      }

      return SyncResult(
        status: SyncStatus.synced,
        synced: synced,
        failed: failed,
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// 同步单个队列项
  Future<void> _syncItem(OfflineQueueItem item, String projectId) async {
    // 获取项目密钥
    final projectKey = await _keyManager.getProjectKey(projectId);

    // 加密 payload
    final payloadJson = json.encode(item.payload);
    final encrypted = _encryption.encryptAES256GCM(payloadJson, projectKey);

    // 上传到 Cloudflare KV
    await _uploadToCloudflare(item.id, encrypted);
  }

  /// 上传到 Cloudflare KV
  Future<void> _uploadToCloudflare(String key, String encryptedData) async {
    // TODO: 实现 Cloudflare Workers API 调用
    // 设计文档 6.2.2: POST /share/{id}/sync
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// 从 Cloudflare KV 下载变更
  Future<List<Map<String, dynamic>>> pullChanges(String projectId) async {
    await _keyManager.getProjectKey(projectId);

    // TODO: 实现 Cloudflare Workers API 调用
    // 设计文档 6.2.2: GET /share/{id}

    return [];
  }

  /// 应用远程变更到本地
  Future<void> applyRemoteChanges(
    String projectId,
    List<Map<String, dynamic>> changes,
  ) async {
    for (final _ in changes) {
      // 使用 CRDT 算法合并变更
      // 设计文档 5.1: CRDT 冲突解决
      // TODO: 实现 Yjs CRDT 合并
    }
  }

  /// 处理离线队列（网络恢复时调用）
  Future<SyncResult> processOfflineQueue(String projectId) async {
    final online = await isOnline;
    if (!online) {
      return SyncResult(status: SyncStatus.offline, synced: 0, failed: 0);
    }

    return syncAll(projectId);
  }

  /// 清理已同步的队列项
  Future<void> cleanupSynced() async {
    await _queueRepo.deleteSynced();
  }

  /// 清理失败的队列项（超过 7 天）
  Future<void> cleanupOldFailed() async {
    await _queueRepo.cleanupOldFailed();
  }

  /// 获取同步状态
  Future<SyncStatus> getSyncStatus(String projectId) async {
    // projectId will scope sync status once Cloudflare sync is wired.
    projectId;
    final stats = await _queueRepo.getStats();
    final pending = stats['pending'] ?? 0;
    final failed = stats['failed'] ?? 0;

    if (_isSyncing) return SyncStatus.inProgress;
    if (pending > 0) return SyncStatus.pending;
    if (failed > 0) return SyncStatus.failed;
    return SyncStatus.synced;
  }

  /// 获取待同步项数量
  Future<int> getPendingChangeCount(String projectId) async {
    // projectId will scope pending counts once Cloudflare sync is wired.
    projectId;
    final stats = await _queueRepo.getStats();
    return stats['pending'] ?? 0;
  }
}

/// 同步结果
class SyncResult {
  final SyncStatus status;
  final int synced;
  final int failed;
  final String? errorMessage;

  SyncResult({
    required this.status,
    required this.synced,
    required this.failed,
    this.errorMessage,
  });
}

/// 同步状态枚举
enum SyncStatus { synced, pending, inProgress, failed, offline }
