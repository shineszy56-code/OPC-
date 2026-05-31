import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../core/database/database_service.dart';
import '../models/ai_workflow.dart';
import '../models/enums.dart';

/// AI 工作流数据仓库
class AIWorkflowRepository {
  AIWorkflowRepository._();

  static final AIWorkflowRepository _instance = AIWorkflowRepository._();

  factory AIWorkflowRepository() => _instance;

  final _dbService = DatabaseService();

  /// 创建 AI 工作流
  Future<String> create(AIWorkflow workflow) async {
    final db = await _dbService.database;
    final data = _workflowToMap(workflow);
    await db.insert('ai_workflows', data);
    return workflow.id;
  }

  /// 获取所有工作流
  Future<List<AIWorkflow>> getAll({bool enabledOnly = false}) async {
    final db = await _dbService.database;
    final where = enabledOnly ? 'enabled = ?' : null;
    final whereArgs = enabledOnly ? [1] : null;

    final results = await db.query(
      'ai_workflows',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'created_at DESC',
    );

    return results.map((map) => _workflowFromMap(map)).toList();
  }

  /// 根据 ID 获取工作流
  Future<AIWorkflow?> getById(String id) async {
    final db = await _dbService.database;
    final results = await db.query(
      'ai_workflows',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return _workflowFromMap(results.first);
  }

  /// 更新工作流
  Future<void> update(AIWorkflow workflow) async {
    final db = await _dbService.database;
    final data = _workflowToMap(workflow);
    data['updated_at'] = DateTime.now().millisecondsSinceEpoch;
    await db.update(
      'ai_workflows',
      data,
      where: 'id = ?',
      whereArgs: [workflow.id],
    );
  }

  /// 启用/禁用工作流
  Future<void> setEnabled(String id, bool enabled) async {
    final db = await _dbService.database;
    await db.update(
      'ai_workflows',
      {'enabled': enabled ? 1 : 0, 'updated_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 删除工作流
  Future<void> delete(String id) async {
    final db = await _dbService.database;
    await db.delete(
      'ai_workflows',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 获取触发器匹配的工作流
  Future<List<AIWorkflow>> getByTriggerType(String triggerType) async {
    final db = await _dbService.database;
    final results = await db.query(
      'ai_workflows',
      where: 'trigger_type = ? AND enabled = ?',
      whereArgs: [triggerType, 1],
    );

    return results.map((map) => _workflowFromMap(map)).toList();
  }

  // ==================== 数据转换 ====================

  Map<String, dynamic> _workflowToMap(AIWorkflow workflow) {
    return {
      'id': workflow.id,
      'name': workflow.name,
      'description': workflow.description,
      'trigger_type': _triggerTypeToString(workflow.trigger.type),
      'trigger_condition': workflow.trigger.condition,
      'steps': json.encode(workflow.steps.map((s) => s.toJson()).toList()),
      'enabled': workflow.enabled ? 1 : 0,
      'created_at': workflow.createdAt,
      'updated_at': workflow.updatedAt,
    };
  }

  AIWorkflow _workflowFromMap(Map<String, dynamic> map) {
    List<AIStep> steps = [];
    if (map['steps'] != null && map['steps'].toString().isNotEmpty) {
      try {
        final List<dynamic> jsonList = json.decode(map['steps'] as String);
        steps = jsonList.map((json) => AIStep.fromJson(json as Map<String, dynamic>)).toList();
      } catch (_) {
        // 忽略解析错误
      }
    }

    return AIWorkflow(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      trigger: WorkflowTrigger(
        type: _triggerTypeFromString(map['trigger_type'] as String),
        condition: map['trigger_condition'] as String?,
      ),
      steps: steps,
      enabled: (map['enabled'] as int? ?? 1) == 1,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
    );
  }

  String _triggerTypeToString(WorkflowTriggerType type) {
    switch (type) {
      case WorkflowTriggerType.manual:
        return 'manual';
      case WorkflowTriggerType.taskCreated:
        return 'task_created';
      case WorkflowTriggerType.taskStatusChanged:
        return 'task_status_changed';
      case WorkflowTriggerType.schedule:
        return 'schedule';
    }
  }

  WorkflowTriggerType _triggerTypeFromString(String type) {
    switch (type) {
      case 'task_created':
        return WorkflowTriggerType.taskCreated;
      case 'task_status_changed':
        return WorkflowTriggerType.taskStatusChanged;
      case 'schedule':
        return WorkflowTriggerType.schedule;
      case 'manual':
      default:
        return WorkflowTriggerType.manual;
    }
  }
}
