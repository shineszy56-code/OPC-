import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/sync_service.dart';
import 'project_state.dart';


/// 同步状态
final syncStatusProvider = FutureProvider<SyncStatus>((ref) async {
  final service = SyncService();
  final projectId = ref.watch(selectedProjectIdProvider);
  if (projectId == null) return SyncStatus.offline;
  return service.getSyncStatus(projectId);
});

/// 待同步项数量
final pendingSyncCountProvider = FutureProvider<int>((ref) async {
  final service = SyncService();
  return service.getPendingChangeCount(ref.watch(selectedProjectIdProvider) ?? '');
});

/// 同步操作 Notifier
final syncNotifierProvider =
    NotifierProvider<SyncNotifier, SyncResult>(SyncNotifier.new);

class SyncNotifier extends Notifier<SyncResult> {
  @override
  SyncResult build() {
    return SyncResult(
      status: SyncStatus.synced,
      synced: 0,
      failed: 0,
    );
  }

  /// 执行同步
  Future<void> syncAll(String projectId) async {
    state = SyncResult(
      status: SyncStatus.inProgress,
      synced: 0,
      failed: 0,
    );

    try {
      final service = SyncService();
      final result = await service.syncAll(projectId);
      state = result;
    } catch (e) {
      state = SyncResult(
        status: SyncStatus.failed,
        synced: 0,
        failed: 1,
        errorMessage: e.toString(),
      );
    }
  }

  /// 处理离线队列
  Future<void> processOfflineQueue(String projectId) async {
    state = SyncResult(
      status: SyncStatus.inProgress,
      synced: 0,
      failed: 0,
    );

    try {
      final service = SyncService();
      final result = await service.processOfflineQueue(projectId);
      state = result;
    } catch (e) {
      state = SyncResult(
        status: SyncStatus.failed,
        synced: 0,
        failed: 1,
        errorMessage: e.toString(),
      );
    }
  }

  /// 清理已同步项
  Future<void> cleanup() async {
    final service = SyncService();
    await service.cleanupSynced();
    await service.cleanupOldFailed();
  }
}
