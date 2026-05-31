import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../core/crypto/encryption_service.dart';
import '../core/crypto/key_manager.dart';
import '../data/models/offline_queue.dart';
import '../data/repositories/offline_queue_repository.dart';
import '../services/sync_service.dart';
import 'crdt_sync.dart';

/// 离线变更队列引擎
/// 设计文档 5.1 + 12 风险评估：离线变更队列持久化存储
class OfflineQueue {
  OfflineQueue._();

  static final OfflineQueue _instance = OfflineQueue._();

  factory OfflineQueue() => _instance;

  final _queueRepo = OfflineQueueRepository();
  final _encryption = EncryptionService();
  final _keyManager = KeyManager();
  final _crdt = CRDTSync();

  StreamController<OfflineQueueStatus>? _statusController;

  /// 状态监听
  Stream<OfflineQueueStatus> get statusStream {
    _statusController = StreamController.broadcast();
    return _statusController!.stream;
  }

  /// 将操作加入离线队列
  Future<String> enqueue({
    required String operationType,
    required String tableName,
    required String recordId,
    required Map<String, dynamic> payload,
  }) async {
    final id = '${DateTime.now().millisecondsSinceEpoch}_$recordId';
    final now = DateTime.now().millisecondsSinceEpoch;

    await _queueRepo.enqueue(
      operationType: operationType,
      tableName: tableName,
      recordId: recordId,
      payload: payload,
    );

    _notifyStatus();
    return id;
  }

  /// 处理离线队列（网络恢复时调用）
  /// 按时间戳顺序重放队列中的操作
  Future<QueueProcessResult> processQueue(String projectId) async {
    final pending = await _queueRepo.getPending(limit: 50);
    if (pending.isEmpty) {
      return QueueProcessResult(synced: 0, failed: 0);
    }

    var synced = 0;
    var failed = 0;

    for (final item in pending) {
      try {
        await _processItem(item, projectId);
        await _queueRepo.markAsSynced(item.id);
        synced++;
      } catch (e) {
        await _queueRepo.markAsFailed(item.id, e.toString());
        failed++;
      }
      _notifyStatus();
    }

    return QueueProcessResult(synced: synced, failed: failed);
  }

  /// 处理单个队列项
  Future<void> _processItem(OfflineQueueItem item, String projectId) async {
    final projectKey = await _keyManager.getProjectKey(projectId);
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
  Future<List<Map<String, dynamic>>> _downloadFromCloudflare(String projectId) async {
    // TODO: 实现 Cloudflare Workers API 调用
    // 设计文档 6.2.2: GET /share/{id}
    return [];
  }

  /// 应用远程变更到本地
  Future<void> _applyRemoteChanges(
    String projectId,
    List<Map<String, dynamic>> changes,
  ) async {
    for (final change in changes) {
      // 使用 CRDT 算法合并变更
      // 设计文档 5.1: CRDT 冲突解决
      // TODO: 实现 Yjs CRDT 合并
    }
  }

  /// 获取待同步项数量
  Future<int> getPendingCount() async {
    final stats = await _queueRepo.getStats();
    return stats['pending'] ?? 0;
  }

  /// 获取失败项数量
  Future<int> getFailedCount() async {
    final stats = await _queueRepo.getStats();
    return stats['failed'] ?? 0;
  }

  /// 重试失败项
  Future<QueueProcessResult> retryFailed(String projectId) async {
    final failed = await _queueRepo.getPending(limit: 50);
    final failedItems = failed.where((item) => item.canRetry).toList();

    var synced = 0;
    var stillFailed = 0;

    for (final item in failedItems) {
      try {
        await _processItem(item, projectId);
        await _queueRepo.markAsSynced(item.id);
        synced++;
      } catch (e) {
        await _queueRepo.markAsFailed(item.id, e.toString());
        stillFailed++;
      }
    }

    return QueueProcessResult(synced: synced, failed: stillFailed);
  }

  /// 清理已同步的项
  Future<void> cleanupSynced() async {
    await _queueRepo.deleteSynced();
  }

  /// 清理失败的队列项（超过 7 天）
  Future<void> cleanupOldFailed() async {
    await _queueRepo.cleanupOldFailed();
  }

  /// 通知状态变化
  void _notifyStatus() async {
    if (_statusController == null || !_statusController!.isClosed) return;

    final pending = await getPendingCount();
    final failed = await getFailedCount();
    final state = pending > 0
        ? OfflineQueueState.pending
        : failed > 0
            ? OfflineQueueState.failed
            : OfflineQueueState.synced;

    _statusController!.add(OfflineQueueStatus(
      state: state,
      pendingCount: pending,
      failedCount: failed,
    ));
  }

  /// 销毁资源
  void dispose() {
    _statusController?.close();
  }
}

/// 离线队列状态
class OfflineQueueStatus {
  final OfflineQueueState state;
  final int pendingCount;
  final int failedCount;

  OfflineQueueStatus({
    required this.state,
    required this.pendingCount,
    required this.failedCount,
  });
}

/// 离线队列状态枚举
enum OfflineQueueState {
  synced,
  pending,
  inProgress,
  failed,
  offline,
}

/// 队列处理结果
class QueueProcessResult {
  final int synced;
  final int failed;

  QueueProcessResult({
    required this.synced,
    required this.failed,
  });
}
