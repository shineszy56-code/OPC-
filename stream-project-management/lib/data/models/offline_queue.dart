import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'offline_queue.freezed.dart';
part 'offline_queue.g.dart';

/// 离线变更队列模型
/// 设计文档 5.1 同步引擎层要求
@freezed
class OfflineQueueItem with _$OfflineQueueItem {
  const factory OfflineQueueItem({
    /// UUID v4
    required String id,

    /// 操作类型：create / update / delete
    required String operationType,

    /// 表名
    required String tableName,

    /// 记录 ID
    required String recordId,

    /// 操作负载（JSON 字符串）
    required String payload,

    /// 时间戳（Unix timestamp）
    required int timestamp,

    /// 重试次数
    @Default(0) int retryCount,

    /// 状态
    @Default(OfflineQueueStatus.pending) OfflineQueueStatus status,

    /// 错误信息
    String? errorMessage,
  }) = _OfflineQueueItem;

  factory OfflineQueueItem.fromJson(Map<String, dynamic> json) =>
      _$OfflineQueueItemFromJson(json);
}

/// OfflineQueueItem 扩展方法
extension OfflineQueueItemX on OfflineQueueItem {
  /// 是否待同步
  bool get isPending => status == OfflineQueueStatus.pending;

  /// 是否已同步
  bool get isSynced => status == OfflineQueueStatus.synced;

  /// 是否失败
  bool get isFailed => status == OfflineQueueStatus.failed;

  /// 是否还可以重试
  bool get canRetry => retryCount < 10 && !isSynced;

  /// 状态显示文本
  String get statusText {
    switch (status) {
      case OfflineQueueStatus.pending:
        return '待同步';
      case OfflineQueueStatus.synced:
        return '已同步';
      case OfflineQueueStatus.failed:
        return '失败';
    }
  }
}
