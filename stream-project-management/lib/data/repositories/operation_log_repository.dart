import 'package:flutter/foundation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../core/database/database_service.dart';
import '../models/enums.dart';
import '../models/operation_log.dart';

/// 操作日志数据仓库
class OperationLogRepository {
  OperationLogRepository._();

  static final OperationLogRepository _instance = OperationLogRepository._();

  factory OperationLogRepository() => _instance;

  final _dbService = DatabaseService();

  /// 记录操作日志
  Future<String> create(OperationLog log) async {
    final db = await _dbService.database;
    final data = _logToMap(log);
    await db.insert('operation_logs', data);
    return log.id;
  }

  /// 获取项目操作日志（时间线）
  Future<List<OperationLog>> getByProjectId(
    String projectId, {
    int limit = 50,
    int offset = 0,
  }) async {
    final db = await _dbService.database;
    final results = await db.query(
      'operation_logs',
      where: 'project_id = ?',
      whereArgs: [projectId],
      orderBy: 'timestamp DESC',
      limit: limit,
      offset: offset,
    );

    return results.map((map) => _logFromMap(map)).toList();
  }

  /// 获取任务操作日志
  Future<List<OperationLog>> getByTaskId(String taskId) async {
    final db = await _dbService.database;
    final results = await db.query(
      'operation_logs',
      where: 'task_id = ?',
      whereArgs: [taskId],
      orderBy: 'timestamp DESC',
    );

    return results.map((map) => _logFromMap(map)).toList();
  }

  /// 标记日志已同步
  Future<void> markAsSynced(String id) async {
    final db = await _dbService.database;
    await db.update(
      'operation_logs',
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 获取未同步的日志
  Future<List<OperationLog>> getUnsynced(String projectId) async {
    final db = await _dbService.database;
    final results = await db.query(
      'operation_logs',
      where: 'project_id = ? AND synced = 0',
      whereArgs: [projectId],
      orderBy: 'timestamp ASC',
    );

    return results.map((map) => _logFromMap(map)).toList();
  }

  /// 删除过期日志（保留最近 7 天）
  Future<void> deleteOldLogs(String projectId) async {
    final db = await _dbService.database;
    final sevenDaysAgo = DateTime.now()
        .subtract(const Duration(days: 7))
        .millisecondsSinceEpoch;

    await db.delete(
      'operation_logs',
      where: 'project_id = ? AND timestamp < ?',
      whereArgs: [projectId, sevenDaysAgo],
    );
  }

  /// 获取日志统计
  Future<Map<String, int>> getStats(String projectId) async {
    final db = await _dbService.database;
    final result = await db.rawQuery(
      'SELECT action, COUNT(*) as count FROM operation_logs WHERE project_id = ? GROUP BY action',
      [projectId],
    );

    final stats = <String, int>{};
    for (final row in result) {
      stats[row['action'] as String] = row['count'] as int;
    }
    return stats;
  }

  // ==================== 数据转换 ====================

  Map<String, dynamic> _logToMap(OperationLog log) {
    return {
      'id': log.id,
      'project_id': log.projectId,
      'task_id': log.taskId,
      'member_id': log.memberId,
      'member_name': log.memberName,
      'action': _actionToString(log.action),
      'field': log.field,
      'old_value': log.oldValue,
      'new_value': log.newValue,
      'timestamp': log.timestamp,
      'synced': log.synced ? 1 : 0,
    };
  }

  OperationLog _logFromMap(Map<String, dynamic> map) {
    return OperationLog(
      id: map['id'] as String,
      projectId: map['project_id'] as String,
      taskId: map['task_id'] as String?,
      memberId: map['member_id'] as String,
      memberName: map['member_name'] as String,
      action: _actionFromString(map['action'] as String),
      field: map['field'] as String?,
      oldValue: map['old_value'] as String?,
      newValue: map['new_value'] as String?,
      timestamp: map['timestamp'] as int,
      synced: (map['synced'] as int) == 1,
    );
  }

  String _actionToString(LogAction action) {
    switch (action) {
      case LogAction.create:
        return 'create';
      case LogAction.update:
        return 'update';
      case LogAction.delete:
        return 'delete';
      case LogAction.statusChange:
        return 'status_change';
      case LogAction.progressChange:
        return 'progress_change';
    }
  }

  LogAction _actionFromString(String action) {
    switch (action) {
      case 'update':
        return LogAction.update;
      case 'delete':
        return LogAction.delete;
      case 'status_change':
        return LogAction.statusChange;
      case 'progress_change':
        return LogAction.progressChange;
      case 'create':
      default:
        return LogAction.create;
    }
  }
}
