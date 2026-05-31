import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../core/database/database_service.dart';
import '../models/enums.dart';
import '../models/offline_queue.dart';

/// 离线变更队列数据仓库
/// 设计文档 5.1 同步引擎层要求
class OfflineQueueRepository {
  OfflineQueueRepository._();

  static final OfflineQueueRepository _instance = OfflineQueueRepository._();

  factory OfflineQueueRepository() => _instance;

  final _dbService = DatabaseService();

  /// 添加变更到队列
  Future<String> enqueue({
    required String operationType,
    required String tableName,
    required String recordId,
    required Map<String, dynamic> payload,
  }) async {
    final db = await _dbService.database;
    final id = DateTime.now().millisecondsSinceEpoch.toString() + '_' + recordId;
    await db.insert('offline_queue', {
      'id': id,
      'operation_type': operationType,
      'table_name': tableName,
      'record_id': recordId,
      'payload': json.encode(payload),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'retry_count': 0,
      'status': 'pending',
    });
    return id;
  }

  /// 获取待同步的队列项
  Future<List<OfflineQueueItem>> getPending({int limit = 50}) async {
    final db = await _dbService.database;
    final results = await db.query(
      'offline_queue',
      where: 'status = ?',
      whereArgs: ['pending'],
      orderBy: 'timestamp ASC',
      limit: limit,
    );

    return results.map((map) => _itemFromMap(map)).toList();
  }

  /// 标记队列项为已同步
  Future<void> markAsSynced(String id) async {
    final db = await _dbService.database;
    await db.update(
      'offline_queue',
      {'status': 'synced'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 标记队列项为失败，并增加重试计数
  Future<void> markAsFailed(String id, String errorMessage) async {
    final db = await _dbService.database;
    final item = await getById(id);
    if (item == null) return;

    final newCount = item.retryCount + 1;
    final status = newCount >= 10 ? 'failed' : 'pending';

    await db.update(
      'offline_queue',
      {
        'retry_count': newCount,
        'status': status,
        'error_message': errorMessage,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 根据 ID 获取队列项
  Future<OfflineQueueItem?> getById(String id) async {
    final db = await _dbService.database;
    final results = await db.query(
      'offline_queue',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return _itemFromMap(results.first);
  }

  /// 删除已同步的队列项（清理）
  Future<void> deleteSynced() async {
    final db = await _dbService.database;
    await db.delete(
      'offline_queue',
      where: 'status = ?',
      whereArgs: ['synced'],
    );
  }

  /// 删除失败超过 7 天的队列项
  Future<void> cleanupOldFailed() async {
    final db = await _dbService.database;
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch;
    await db.delete(
      'offline_queue',
      where: 'status = ? AND timestamp < ?',
      whereArgs: ['failed', sevenDaysAgo],
    );
  }

  /// 获取队列统计
  Future<Map<String, int>> getStats() async {
    final db = await _dbService.database;
    final result = await db.rawQuery('''
      SELECT status, COUNT(*) as count 
      FROM offline_queue 
      GROUP BY status
    ''');

    final stats = <String, int>{};
    for (final row in result) {
      stats[row['status'] as String] = row['count'] as int;
    }
    return stats;
  }

  /// 重试失败的队列项（重置状态）
  Future<void> retryFailed(String id) async {
    final db = await _dbService.database;
    await db.update(
      'offline_queue',
      {'status': 'pending', 'retry_count': 0, 'error_message': null},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== 数据转换 ====================

  OfflineQueueItem _itemFromMap(Map<String, dynamic> map) {
    return OfflineQueueItem(
      id: map['id'] as String,
      operationType: map['operation_type'] as String,
      tableName: map['table_name'] as String,
      recordId: map['record_id'] as String,
      payload: map['payload'] as String,
      timestamp: map['timestamp'] as int,
      retryCount: map['retry_count'] as int? ?? 0,
      status: _statusFromString(map['status'] as String? ?? 'pending'),
      errorMessage: map['error_message'] as String?,
    );
  }

  String _statusToString(OfflineQueueStatus status) {
    switch (status) {
      case OfflineQueueStatus.pending:
        return 'pending';
      case OfflineQueueStatus.synced:
        return 'synced';
      case OfflineQueueStatus.failed:
        return 'failed';
    }
  }

  OfflineQueueStatus _statusFromString(String status) {
    switch (status) {
      case 'synced':
        return OfflineQueueStatus.synced;
      case 'failed':
        return OfflineQueueStatus.failed;
      case 'pending':
      default:
        return OfflineQueueStatus.pending;
    }
  }
}
