import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../core/crypto/key_manager.dart';
import '../data/models/enums.dart';
import '../data/models/operation_log.dart';
import '../data/repositories/operation_log_repository.dart';

/// 操作日志服务
/// 设计文档 5.4：OperationLogService - 操作日志记录、变更追溯、时间线生成
class OperationLogService {
  OperationLogService._();

  static final OperationLogService _instance = OperationLogService._();

  factory OperationLogService() => _instance;

  final _logRepo = OperationLogRepository();
  final _keyManager = KeyManager();

  /// 记录操作日志
  Future<String> log({
    required String projectId,
    String? taskId,
    required LogAction action,
    String? field,
    String? oldValue,
    String? newValue,
    required String memberName,
  }) async {
    final deviceId = await _keyManager.getDeviceId();
    final log = OperationLog(
      id: const Uuid().v4(),
      projectId: projectId,
      taskId: taskId,
      memberId: deviceId,
      memberName: memberName,
      action: action,
      field: field,
      oldValue: oldValue,
      newValue: newValue,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      synced: false,
    );

    return _logRepo.create(log);
  }

  /// 获取项目操作日志（时间线）
  Future<List<OperationLog>> getTimeline(
    String projectId, {
    int limit = 50,
    int offset = 0,
  }) async {
    return _logRepo.getByProjectId(projectId, limit: limit, offset: offset);
  }

  /// 获取任务操作日志
  Future<List<OperationLog>> getTaskLogs(String taskId) async {
    return _logRepo.getByTaskId(taskId);
  }

  /// 标记日志已同步
  Future<void> markAsSynced(String logId) async {
    await _logRepo.markAsSynced(logId);
  }

  /// 获取未同步的日志
  Future<List<OperationLog>> getUnsyncedLogs(String projectId) async {
    return _logRepo.getUnsynced(projectId);
  }

  /// 删除过期日志（保留最近 7 天）
  Future<void> cleanupOldLogs(String projectId) async {
    await _logRepo.deleteOldLogs(projectId);
  }

  /// 获取日志统计
  Future<Map<String, int>> getStats(String projectId) async {
    return _logRepo.getStats(projectId);
  }

  /// 格式化时间线显示
  String formatTimelineTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} 分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} 小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} 天前';
    } else {
      return DateFormat('MM-dd HH:mm').format(date);
    }
  }

  /// 生成时间线描述
  String generateTimelineDescription(OperationLog log) {
    final buffer = StringBuffer();
    buffer.write(log.memberName);
    buffer.write(' ');
    buffer.write(_getActionText(log.action));

    if (log.field != null) {
      buffer.write(' ');
      buffer.write(log.field);
    }

    if (log.oldValue != null && log.newValue != null) {
      buffer.write(': ${log.oldValue} → ${log.newValue}');
    } else if (log.newValue != null) {
      buffer.write(' 为 ${log.newValue}');
    }

    return buffer.toString();
  }

  String _getActionText(LogAction action) {
    switch (action) {
      case LogAction.create:
        return '创建了';
      case LogAction.update:
        return '更新了';
      case LogAction.delete:
        return '删除了';
      case LogAction.statusChange:
        return '修改了状态';
      case LogAction.progressChange:
        return '更新了进度';
    }
  }
}
