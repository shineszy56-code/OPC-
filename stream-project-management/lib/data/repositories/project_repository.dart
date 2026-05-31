import 'package:flutter/foundation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../core/database/database_schema.dart';
import '../../core/database/database_service.dart';
import '../models/enums.dart';
import '../models/project.dart';

/// 项目数据仓库
/// 封装 projects 表的 CRUD 操作
class ProjectRepository {
  ProjectRepository._();

  static final ProjectRepository _instance = ProjectRepository._();

  factory ProjectRepository() => _instance;

  final _dbService = DatabaseService();

  /// 创建项目
  Future<String> create(Project project) async {
    final db = await _dbService.database;
    final data = _projectToMap(project);
    await db.insert('projects', data);
    return project.id;
  }

  /// 获取所有项目
  Future<List<Project>> getAll({
    bool includeArchived = false,
    String? statusFilter,
  }) async {
    final db = await _dbService.database;
    String? where;
    List<dynamic>? whereArgs;

    if (!includeArchived) {
      where = 'status != ?';
      whereArgs = ['archived'];
    }

    if (statusFilter != null) {
      final clause = where != null ? '$where AND status = ?' : 'status = ?';
      where = clause;
      whereArgs = whereArgs ?? []..add(statusFilter);
    }

    final results = await db.query(
      'projects',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'updated_at DESC',
    );

    return results.map((map) => _projectFromMap(map)).toList();
  }

  /// 根据 ID 获取项目
  Future<Project?> getById(String id) async {
    final db = await _dbService.database;
    final results = await db.query(
      'projects',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return _projectFromMap(results.first);
  }

  /// 更新项目
  Future<void> update(Project project) async {
    final db = await _dbService.database;
    final data = _projectToMap(project);
    data['updated_at'] = DateTime.now().millisecondsSinceEpoch;
    await db.update(
      'projects',
      data,
      where: 'id = ?',
      whereArgs: [project.id],
    );
  }

  /// 删除项目（软删除：归档）
  Future<void> archive(String id) async {
    final db = await _dbService.database;
    await db.update(
      'projects',
      {'status': 'archived', 'updated_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 硬删除项目
  Future<void> delete(String id) async {
    final db = await _dbService.database;
    await db.delete(
      'projects',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 更新项目进度
  Future<void> updateProgress(String projectId, double progress) async {
    final db = await _dbService.database;
    await db.update(
      'projects',
      {'progress': progress, 'updated_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [projectId],
    );
  }

  /// 自动计算项目进度（基于任务完成比例）
  Future<double> calculateProgress(String projectId) async {
    final db = await _dbService.database;
    final totalResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE project_id = ? AND parent_id IS NULL',
      [projectId],
    );
    final total = totalResult.first['count'] as int;

    if (total == 0) return 0.0;

    final doneResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE project_id = ? AND status = ? AND parent_id IS NULL',
      [projectId, 'done'],
    );
    final done = doneResult.first['count'] as int;

    return done / total;
  }

  /// 监听项目列表变化
  Stream<List<Project>> watchAll({bool includeArchived = false}) async* {
    final db = await _dbService.database;
    yield await getAll(includeArchived: includeArchived);

    // 简化的监听实现，实际应使用 sqflite 的 onChange
    // 或使用 Riverpod 的 watch 机制
  }

  /// 搜索项目
  Future<List<Project>> search(String query) async {
    final db = await _dbService.database;
    final results = await db.query(
      'projects',
      where: 'name LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'updated_at DESC',
    );

    return results.map((map) => _projectFromMap(map)).toList();
  }

  // ==================== 数据转换 ====================

  Map<String, dynamic> _projectToMap(Project project) {
    return {
      'id': project.id,
      'name': project.name,
      'icon': project.icon,
      'description': project.description,
      'status': _statusToString(project.status),
      'start_date': project.startDate,
      'end_date': project.endDate,
      'progress': project.progress,
      'ai_prompt': project.aiPrompt,
      'owner_id': project.ownerId,
      'created_at': project.createdAt,
      'updated_at': project.updatedAt,
    };
  }

  Project _projectFromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as String,
      name: map['name'] as String,
      icon: map['icon'] as String? ?? '📁',
      description: map['description'] as String? ?? '',
      status: _statusFromString(map['status'] as String),
      startDate: map['start_date'] as int,
      endDate: map['end_date'] as int,
      progress: (map['progress'] as num).toDouble(),
      aiPrompt: map['ai_prompt'] as String? ?? '',
      ownerId: map['owner_id'] as String,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
    );
  }

  String _statusToString(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.active:
        return 'active';
      case ProjectStatus.completed:
        return 'completed';
      case ProjectStatus.archived:
        return 'archived';
    }
  }

  ProjectStatus _statusFromString(String status) {
    switch (status) {
      case 'completed':
        return ProjectStatus.completed;
      case 'archived':
        return ProjectStatus.archived;
      case 'active':
      default:
        return ProjectStatus.active;
    }
  }
}
