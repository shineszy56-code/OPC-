import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../core/crypto/key_manager.dart';
import '../data/models/ai_workflow.dart';
import '../data/models/enums.dart';
import '../data/models/operation_log.dart';
import '../data/repositories/operation_log_repository.dart';
import 'ai_gateway.dart';
import 'model_router.dart';

/// AI 工作流引擎
/// 设计文档 5.3：AI 工作流引擎（触发+步骤执行）
class WorkflowEngine {
  WorkflowEngine._();

  static final WorkflowEngine _instance = WorkflowEngine._();

  factory WorkflowEngine() => _instance;

  final _gateway = AIGateway();
  final _router = ModelRouter();
  final _logRepo = OperationLogRepository();
  final _keyManager = KeyManager();

  final _activeWorkflows = <String, WorkflowExecution>{};

  /// 触发工作流
  /// [triggerType] 触发类型
  /// [context] 触发上下文（如任务信息）
  Future<List<WorkflowExecutionResult>> trigger({
    required String triggerType,
    required Map<String, dynamic> context,
  }) async {
    // 查找匹配的工作流
    final matchingWorkflows = await _findMatchingWorkflows(
      triggerType,
      context,
    );
    final results = <WorkflowExecutionResult>[];

    for (final workflow in matchingWorkflows) {
      if (!workflow.enabled) continue;

      final result = await execute(workflow: workflow, context: context);
      results.add(result);
    }

    return results;
  }

  /// 手动执行工作流
  Future<WorkflowExecutionResult> execute({
    required AIWorkflow workflow,
    required Map<String, dynamic> context,
  }) async {
    final executionId = const Uuid().v4();
    final startTime = DateTime.now();

    // 记录活跃执行
    final execution = WorkflowExecution(
      executionId: executionId,
      workflowId: workflow.id,
      workflowName: workflow.name,
      status: WorkflowExecutionStatus.running,
      startTime: startTime,
      context: context,
      stepResults: [],
    );

    _activeWorkflows[executionId] = execution;

    try {
      // 执行所有步骤
      final stepResults = <StepExecutionResult>[];

      for (var i = 0; i < workflow.steps.length; i++) {
        final step = workflow.steps[i];
        final stepResult = await _executeStep(
          step: step,
          context: context,
          stepIndex: i,
        );
        stepResults.add(stepResult);

        // 如果步骤失败且不是条件步骤，终止执行
        if (!stepResult.success && step.type != StepType.condition) {
          break;
        }
      }

      // 完成执行
      final endTime = DateTime.now();
      final result = WorkflowExecutionResult(
        executionId: executionId,
        workflowId: workflow.id,
        workflowName: workflow.name,
        success: stepResults.every((r) => r.success),
        stepResults: stepResults,
        startTime: startTime,
        endTime: endTime,
        output: _buildOutput(stepResults),
      );

      // 记录日志
      await _logWorkflowExecution(workflow, result);

      return result;
    } catch (e) {
      final endTime = DateTime.now();
      return WorkflowExecutionResult(
        executionId: executionId,
        workflowId: workflow.id,
        workflowName: workflow.name,
        success: false,
        stepResults: [],
        startTime: startTime,
        endTime: endTime,
        errorMessage: e.toString(),
      );
    } finally {
      _activeWorkflows.remove(executionId);
    }
  }

  /// 执行单个步骤
  Future<StepExecutionResult> _executeStep({
    required AIStep step,
    required Map<String, dynamic> context,
    required int stepIndex,
  }) async {
    final startTime = DateTime.now();

    try {
      String output;

      switch (step.type) {
        case StepType.prompt:
          // 插值模板变量
          final prompt = _interpolateTemplate(step.promptTemplate, context);
          output = await _gateway.chatCompletion(
            prompt: prompt,
            temperature: 0.7,
          );
          break;

        case StepType.condition:
          // 条件判断
          output = _evaluateCondition(step.promptTemplate, context)
              ? 'true'
              : 'false';
          break;

        case StepType.loop:
          // 循环执行
          output = await _executeLoop(step, context);
          break;

        case StepType.parallel:
          // 并行执行
          output = await _executeParallel(step, context);
          break;
      }

      final endTime = DateTime.now();

      return StepExecutionResult(
        stepId: step.id,
        stepName: step.name,
        success: true,
        output: output,
        startTime: startTime,
        endTime: endTime,
      );
    } catch (e) {
      final endTime = DateTime.now();

      return StepExecutionResult(
        stepId: step.id,
        stepName: step.name,
        success: false,
        output: '',
        startTime: startTime,
        endTime: endTime,
        errorMessage: e.toString(),
      );
    }
  }

  /// 插值模板变量
  String _interpolateTemplate(String template, Map<String, dynamic> context) {
    var result = template;
    context.forEach((key, value) {
      result = result.replaceAll('{{$key}}', value?.toString() ?? '');
    });
    return result;
  }

  /// 评估条件
  bool _evaluateCondition(String condition, Map<String, dynamic> context) {
    // 简化的条件评估
    // 实际实现应使用表达式解析器
    try {
      // 支持简单条件：{{variable}} == "value"
      for (final entry in context.entries) {
        final placeholder = '{{${entry.key}}}';
        condition = condition.replaceAll(
          placeholder,
          entry.value?.toString() ?? '',
        );
      }

      // 简单评估
      if (condition.contains('==')) {
        final parts = condition.split('==');
        return parts[0].trim() ==
            parts[1].trim().replaceAll('"', '').replaceAll("'", '');
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// 执行循环
  Future<String> _executeLoop(AIStep step, Map<String, dynamic> context) async {
    // TODO: 实现循环逻辑
    return 'Loop executed';
  }

  /// 执行并行步骤
  Future<String> _executeParallel(
    AIStep step,
    Map<String, dynamic> context,
  ) async {
    // TODO: 实现并行执行逻辑
    return 'Parallel executed';
  }

  /// 构建输出
  String _buildOutput(List<StepExecutionResult> stepResults) {
    final buffer = StringBuffer();
    for (final result in stepResults) {
      buffer.writeln('## ${result.stepName}');
      buffer.writeln(result.output);
      buffer.writeln();
    }
    return buffer.toString();
  }

  /// 查找匹配的工作流
  Future<List<AIWorkflow>> _findMatchingWorkflows(
    String triggerType,
    Map<String, dynamic> context,
  ) async {
    // TODO: 从数据库读取工作流
    // 当前返回空列表
    return [];
  }

  /// 记录工作流执行日志
  Future<void> _logWorkflowExecution(
    AIWorkflow workflow,
    WorkflowExecutionResult result,
  ) async {
    final deviceId = await _keyManager.getDeviceId();
    await _logRepo.create(
      OperationLog(
        id: const Uuid().v4(),
        projectId: result.context?['projectId'] ?? '',
        memberId: deviceId,
        memberName: 'AI Workflow',
        action: LogAction.update,
        field: 'workflow_execution',
        oldValue: workflow.name,
        newValue: result.success ? '成功' : '失败: ${result.errorMessage}',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        synced: false,
      ),
    );
  }

  /// 获取活跃执行
  List<WorkflowExecution> getActiveExecutions() {
    return _activeWorkflows.values.toList();
  }

  /// 取消执行
  Future<void> cancelExecution(String executionId) async {
    _activeWorkflows.remove(executionId);
  }
}

/// 工作流执行记录
class WorkflowExecution {
  final String executionId;
  final String workflowId;
  final String workflowName;
  final WorkflowExecutionStatus status;
  final DateTime startTime;
  final DateTime? endTime;
  final Map<String, dynamic> context;
  final List<StepExecutionResult> stepResults;

  WorkflowExecution({
    required this.executionId,
    required this.workflowId,
    required this.workflowName,
    required this.status,
    required this.startTime,
    this.endTime,
    required this.context,
    required this.stepResults,
  });
}

/// 工作流执行结果
class WorkflowExecutionResult {
  final String executionId;
  final String workflowId;
  final String workflowName;
  final bool success;
  final List<StepExecutionResult> stepResults;
  final DateTime startTime;
  final DateTime endTime;
  final String? output;
  final String? errorMessage;
  final Map<String, dynamic>? context;

  WorkflowExecutionResult({
    required this.executionId,
    required this.workflowId,
    required this.workflowName,
    required this.success,
    required this.stepResults,
    required this.startTime,
    required this.endTime,
    this.output,
    this.errorMessage,
    this.context,
  });
}

/// 步骤执行结果
class StepExecutionResult {
  final String stepId;
  final String stepName;
  final bool success;
  final String output;
  final DateTime startTime;
  final DateTime endTime;
  final String? errorMessage;

  StepExecutionResult({
    required this.stepId,
    required this.stepName,
    required this.success,
    required this.output,
    required this.startTime,
    required this.endTime,
    this.errorMessage,
  });
}

/// 工作流执行状态
enum WorkflowExecutionStatus { pending, running, completed, failed, cancelled }
