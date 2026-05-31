import 'package:flutter/foundation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../core/database/database_service.dart';
import '../models/enums.dart';
import '../models/project_member.dart';

/// 项目成员数据仓库
class ProjectMemberRepository {
  ProjectMemberRepository._();

  static final ProjectMemberRepository _instance = ProjectMemberRepository._();

  factory ProjectMemberRepository() => _instance;

  final _dbService = DatabaseService();

  /// 添加成员
  Future<String> create(ProjectMember member) async {
    final db = await _dbService.database;
    final data = _memberToMap(member);
    await db.insert('project_members', data);
    return member.id;
  }

  /// 获取项目下所有成员
  Future<List<ProjectMember>> getByProjectId(String projectId) async {
    final db = await _dbService.database;
    final results = await db.query(
      'project_members',
      where: 'project_id = ?',
      whereArgs: [projectId],
      orderBy: 'created_at ASC',
    );

    return results.map((map) => _memberFromMap(map)).toList();
  }

  /// 根据 ID 获取成员
  Future<ProjectMember?> getById(String id) async {
    final db = await _dbService.database;
    final results = await db.query(
      'project_members',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return _memberFromMap(results.first);
  }

  /// 更新成员权限
  Future<void> updatePermission(String id, MemberPermission permission) async {
    final db = await _dbService.database;
    await db.update(
      'project_members',
      {
        'permission': _permissionToString(permission),
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 更新在线状态
  Future<void> updateOnlineStatus(String id, bool isOnline) async {
    final db = await _dbService.database;
    await db.update(
      'project_members',
      {
        'is_online': isOnline ? 1 : 0,
        'last_active_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 移除成员
  Future<void> delete(String id) async {
    final db = await _dbService.database;
    await db.delete('project_members', where: 'id = ?', whereArgs: [id]);
  }

  /// 获取在线成员数量
  Future<int> getOnlineCount(String projectId) async {
    final db = await _dbService.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM project_members WHERE project_id = ? AND is_online = 1',
      [projectId],
    );
    return (result.first['count'] as int);
  }

  // ==================== 数据转换 ====================

  Map<String, dynamic> _memberToMap(ProjectMember member) {
    return {
      'id': member.id,
      'project_id': member.projectId,
      'name': member.name,
      'permission': _permissionToString(member.permission),
      'share_id': member.shareId,
      'last_active_at': member.lastActiveAt,
      'is_online': member.isOnline ? 1 : 0,
      'created_at': member.createdAt,
      'updated_at': member.updatedAt,
    };
  }

  ProjectMember _memberFromMap(Map<String, dynamic> map) {
    return ProjectMember(
      id: map['id'] as String,
      projectId: map['project_id'] as String,
      name: map['name'] as String,
      permission: _permissionFromString(map['permission'] as String),
      shareId: map['share_id'] as String? ?? '',
      lastActiveAt: map['last_active_at'] as int,
      isOnline: (map['is_online'] as int) == 1,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
    );
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
