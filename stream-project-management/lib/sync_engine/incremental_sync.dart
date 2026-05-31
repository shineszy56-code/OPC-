import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../core/crypto/encryption_service.dart';
import '../core/crypto/key_manager.dart';
import '../data/models/offline_queue.dart';
import '../data/repositories/offline_queue_repository.dart';
import '../services/sync_service.dart';
import 'crdt_sync.dart';

/// 增量同步引擎
/// 设计文档 5.1 + 10.3：增量同步（仅传输变更内容）
class IncrementalSync {
  IncrementalSync._();

  static final IncrementalSync _instance = IncrementalSync._();

  factory IncrementalSync() => _instance;

  final _queueRepo = OfflineQueueRepository();
  final _encryption = EncryptionService();
  final _keyManager = KeyManager();
  final _crdt = CRDTSync();

  StreamController<SyncProgress>? _progressController;

  /// 增量同步进度流
  Stream<SyncProgress> get syncProgress async* {
    _progressController = StreamController();
    yield* _progressController!.stream;
  }

  /// 执行增量同步
  /// 仅传输变更内容（设计文档 10.2）
  Future<SyncResult> syncIncremental(String projectId) async {
    try {
      // 1. 获取本地状态向量
      final stateVector = await _crdt.getStateVector(projectId);

      // 2. 计算差异
      final diff = await _crdt.computeDiff(
        projectId: projectId,
        remoteStateVector: stateVector,
      );

      if (diff.isEmpty) {
        return SyncResult(
          status: SyncStatus.synced,
          synced: 0,
          failed: 0,
        );
      }

      // 3. 加密差异数据
      final projectKey = await _keyManager.getProjectKey(projectId);
      final encryptedDiff = _encryption.encryptAES256GCM(
        diff.toString(),
        projectKey,
      );

      // 4. 上传到 Cloudflare KV
      await _uploadDiff(projectId, encryptedDiff);

      // 5. 下载远程差异
      final remoteEncryptedDiff = await _downloadDiff(projectId);

      // 6. 解密并应用远程差异
      if (remoteEncryptedDiff != null) {
        final remoteDiff = _encryption.decryptAES256GCM(
          remoteEncryptedDiff,
          projectKey,
        );
        await _crdt.applyUpdate(
          projectId: projectId,
          update: Uint8List.fromList(remoteDiff.codeUnits),
        );
      }

      // 7. 清理已同步的队列项
      await _queueRepo.deleteSynced();

      return SyncResult(
        status: SyncStatus.synced,
        synced: diff.length,
        failed: 0,
      );
    } catch (e) {
      return SyncResult(
        status: SyncStatus.failed,
        synced: 0,
        failed: 1,
        errorMessage: e.toString(),
      );
    }
  }

  /// 上传差异到 Cloudflare KV
  Future<void> _uploadDiff(String projectId, String encryptedDiff) async {
    // TODO: 实现 Cloudflare Workers API 调用
    // 设计文档 6.2.2: POST /share/{id}/sync
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// 从 Cloudflare KV 下载差异
  Future<String?> _downloadDiff(String projectId) async {
    // TODO: 实现 Cloudflare Workers API 调用
    // 设计文档 6.2.2: GET /share/{id}/sync
    await Future.delayed(const Duration(milliseconds: 100));
    return null;
  }

  /// 获取待同步的变更数量
  Future<int> getPendingChangeCount(String projectId) async {
    final pending = await _queueRepo.getPending(limit: 1000);
    return pending.length;
  }

  /// 清理过期的同步数据
  Future<void> cleanupOldSyncData(String projectId) async {
    await _queueRepo.cleanupOldFailed();
  }

  /// 销毁资源
  void dispose() {
    _progressController?.close();
  }
}

/// 同步进度
class SyncProgress {
  final int total;
  final int current;
  final String? currentTask;
  final SyncStatus status;

  SyncProgress({
    required this.total,
    required this.current,
    this.currentTask,
    required this.status,
  });

  double get progress => total > 0 ? current / total : 0.0;
}
