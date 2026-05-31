import 'package:flutter/foundation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../core/database/database_service.dart';
import '../models/enums.dart';
import '../models/share_record.dart';

/// 分享记录数据仓库
class ShareRecordRepository {
  ShareRecordRepository._();

  static final ShareRecordRepository _instance = ShareRecordRepository._();

  factory ShareRecordRepository() => _instance;

  final _dbService = DatabaseService();

  /// 创建分享记录
  Future<String> create(ShareRecord record) async {
    final db = await _dbService.database;
    final data = _recordToMap(record);
    await db.insert('share_records', data);
    return record.id;
  }

  /// 获取项目下的所有分享记录
  Future<List<ShareRecord>> getByProjectId(String projectId) async {
    final db = await _dbService.database;
    final results = await db.query(
      'share_records',
      where: 'project_id = ? AND expires_at > ?',
      whereArgs: [projectId, DateTime.now().millisecondsSinceEpoch],
      orderBy: 'created_at DESC',
    );

    return results.map((map) => _recordFromMap(map)).toList();
  }

  /// 根据 ID 获取分享记录
  Future<ShareRecord?> getById(String id) async {
    final db = await _dbService.database;
    final results = await db.query(
      'share_records',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return _recordFromMap(results.first);
  }

  /// 根据 Cloudflare Key 获取分享记录
  Future<ShareRecord?> getByCloudflareKey(String cloudflareKey) async {
    final db = await _dbService.database;
    final results = await db.query(
      'share_records',
      where: 'cloudflare_key = ?',
      whereArgs: [cloudflareKey],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return _recordFromMap(results.first);
  }

  /// 撤销分享（删除记录）
  Future<void> delete(String id) async {
    final db = await _dbService.database;
    await db.delete(
      'share_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 清理过期分享记录
  Future<void> cleanupExpired() async {
    final db = await _dbService.database;
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.delete(
      'share_records',
      where: 'expires_at < ?',
      whereArgs: [now],
    );
  }

  /// 更新分享权限
  Future<void> updatePermission(String id, MemberPermission permission) async {
    final db = await _dbService.database;
    await db.update(
      'share_records',
      {'permission': _permissionToString(permission), 'updated_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 延长分享有效期
  Future<void> extendExpiry(String id, int newExpiry) async {
    final db = await _dbService.database;
    await db.update(
      'share_records',
      {'expires_at': newExpiry, 'updated_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== 数据转换 ====================

  Map<String, dynamic> _recordToMap(ShareRecord record) {
    return {
      'id': record.id,
      'project_id': record.projectId,
      'task_id': record.taskId,
      'type': _typeToString(record.type),
      'permission': _permissionToString(record.permission),
      'expires_at': record.expiresAt,
      'cloudflare_key': record.cloudflareKey,
      'peer_id': record.peerId,
      'created_at': record.createdAt,
    };
  }

  ShareRecord _recordFromMap(Map<String, dynamic> map) {
    return ShareRecord(
      id: map['id'] as String,
      projectId: map['project_id'] as String?,
      taskId: map['task_id'] as String?,
      type: _typeFromString(map['type'] as String? ?? 'cloudflare'),
      permission: _permissionFromString(map['permission'] as String? ?? 'read'),
      expiresAt: map['expires_at'] as int,
      cloudflareKey: map['cloudflare_key'] as String?,
      peerId: map['peer_id'] as String?,
      createdAt: map['created_at'] as int,
    );
  }

  String _typeToString(ShareType type) {
    switch (type) {
      case ShareType.cloudflare:
        return 'cloudflare';
      case ShareType.p2p:
        return 'p2p';
    }
  }

  ShareType _typeFromString(String type) {
    switch (type) {
      case 'p2p':
        return ShareType.p2p;
      case 'cloudflare':
      default:
        return ShareType.cloudflare;
    }
  }

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

  MemberPermission _permissionFromString(String permission) {
    switch (permission) {
      case 'comment':
        return MemberPermission.comment;
      case 'edit':
        return MemberPermission.edit;
      case 'admin':
        return MemberPermission.admin;
      case 'read':
      default:
        return MemberPermission.read;
    }
  }
}
