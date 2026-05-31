import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'ai_workflow.freezed.dart';
part 'ai_workflow.g.dart';

/// AI 工作流步骤
@freezed
class AIStep with _$AIStep {
  const factory AIStep({
    /// 步骤 ID
    required String id,

    /// 步骤名称
    required String name,

    /// 步骤描述
    @Default('') String description,

    /// 步骤类型
    @Default(StepType.prompt) StepType type,

    /// 提示词模板
    @Default('') String promptTemplate,

    /// 模型选择（可选，不填则使用路由策略）
    String? model,

    /// 步骤输出是否作为下一步的输入
    @Default(true) bool passOutput,

    /// 超时时间（秒）
    @Default(60) int timeoutSeconds,
  }) = _AIStep;

  factory AIStep.fromJson(Map<String, dynamic> json) => _$AIStepFromJson(json);
}

/// 步骤类型枚举
enum StepType { prompt, condition, loop, parallel }

/// AI 工作流触发条件
@freezed
class WorkflowTrigger with _$WorkflowTrigger {
  const factory WorkflowTrigger({
    /// 触发类型
    required WorkflowTriggerType type,

    /// 触发条件表达式
    String? condition,
  }) = _WorkflowTrigger;

  factory WorkflowTrigger.fromJson(Map<String, dynamic> json) =>
      _$WorkflowTriggerFromJson(json);
}

/// AI 工作流模型
/// 对应设计文档 interface AIWorkflow
@freezed
class AIWorkflow with _$AIWorkflow {
  const factory AIWorkflow({
    /// UUID v4
    required String id,

    /// 工作流名称
    required String name,

    /// 工作流描述
    @Default('') String description,

    /// 触发条件
    required WorkflowTrigger trigger,

    /// 工作流步骤列表
    @Default([]) List<AIStep> steps,

    /// 是否启用
    @Default(true) bool enabled,

    /// 创建时间
    required int createdAt,

    /// 更新时间
    required int updatedAt,
  }) = _AIWorkflow;

  factory AIWorkflow.fromJson(Map<String, dynamic> json) =>
      _$AIWorkflowFromJson(json);
}

/// AIWorkflow 扩展方法
extension AIWorkflowX on AIWorkflow {
  /// 步骤数量
  int get stepCount => steps.length;

  /// 是否手动触发
  bool get isManual => trigger.type == WorkflowTriggerType.manual;

  /// 状态显示文本
  String get statusText => enabled ? '已启用' : '已禁用';

  /// 触发类型显示文本
  String get triggerText {
    switch (trigger.type) {
      case WorkflowTriggerType.manual:
        return '手动触发';
      case WorkflowTriggerType.taskCreated:
        return '任务创建时';
      case WorkflowTriggerType.taskStatusChanged:
        return '任务状态变更时';
      case WorkflowTriggerType.schedule:
        return '定时触发';
    }
  }
}
