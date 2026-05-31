import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/ai_workflow.dart';
import '../data/models/task.dart';
import '../services/ai_service.dart';
import '../services/task_service.dart';
import 'project_state.dart';


/// AI 任务拆解结果
final aiBreakdownResultProvider =
    FutureProvider.family<List<TaskDraft>, String>((ref, taskTitle) async {
  final service = ref.watch(aiServiceProvider);
  final taskService = ref.watch(taskServiceProvider);
  final projectId = ref.watch(selectedProjectIdProvider);

  if (projectId == null) return [];

  final task = await taskService.getTaskById(ref.watch(selectedTaskIdProvider) ?? '');
  if (task == null) return [];

  return service.breakdownTask(
    projectId: projectId,
    taskTitle: taskTitle,
    taskDescription: task.description.isNotEmpty == true ? task.description : null,
  );
});

/// AI 项目总结
final aiProjectSummaryProvider =
    FutureProvider.family<String, String>((ref, projectId) async {
  final service = ref.watch(aiServiceProvider);
  return service.generateProjectSummary(projectId);
});

/// AI 任务描述生成
final aiTaskDescriptionProvider =
    FutureProvider.family<String, String>((ref, taskTitle) async {
  final service = ref.watch(aiServiceProvider);
  return service.generateTaskDescription(taskTitle);
});

/// AI 建议的截止日期
final aiSuggestedDueDateProvider =
    FutureProvider.family<DateTime?, String>((ref, taskTitle) async {
  final service = ref.watch(aiServiceProvider);
  return service.suggestDueDate(taskTitle);
});

/// AI 服务工作器
final aiServiceProvider = Provider<AIService>((ref) {
  return AIService();
});

/// 任务服务工作器
final taskServiceProvider = Provider<TaskService>((ref) {
  return TaskService();
});

/// 选中的任务 ID
final selectedTaskIdProvider = StateProvider<String?>((ref) => null);

/// AI 执行状态
final aiExecutionStatusProvider = StateProvider<AIExecutionStatus>((ref) {
  return AIExecutionStatus.idle;
});

/// AI 执行结果
final aiExecutionResultProvider = StateProvider<String?>((ref) => null);

/// AI 工作流列表
final aiWorkflowsProvider = FutureProvider<List<AIWorkflow>>((ref) async {
  final service = ref.watch(aiServiceProvider);
  // TODO: 实现 getWorkflows 方法
  return [];
});

/// AI 工作流执行
final aiWorkflowExecutionProvider =
    FutureProvider.family<AIWorkflowExecutionResult, String>((ref, workflowId) async {
  final service = ref.watch(aiServiceProvider);
  final context = <String, dynamic>{};
  // TODO: 实现 executeWorkflow 方法
  throw UnimplementedError('executeWorkflow not implemented');
});

/// AI 状态 Notifier
final aiStateNotifierProvider =
    NotifierProvider<AISateNotifier, AIState>(AISateNotifier.new);

class AISateNotifier extends Notifier<AIState> {
  @override
  AIState build() {
    return const AIState();
  }

  /// 执行任务拆解
  Future<void> executeBreakdown(String taskTitle) async {
    state = state.copyWith(
      executionStatus: AIExecutionStatus.running,
      executionResult: null,
      error: null,
    );

    try {
      final service = ref.read(aiServiceProvider);
      final projectId = ref.read(selectedProjectIdProvider);
      if (projectId == null) {
        throw Exception('未选中项目');
      }

      final result = await service.breakdownTask(
        projectId: projectId,
        taskTitle: taskTitle,
      );

      state = state.copyWith(
        executionStatus: AIExecutionStatus.completed,
        executionResult: '拆解完成，生成 ${result.length} 个子任务',
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        executionStatus: AIExecutionStatus.failed,
        executionResult: null,
        error: e.toString(),
      );
    }
  }

  /// 执行项目总结
  Future<void> executeProjectSummary(String projectId) async {
    state = state.copyWith(
      executionStatus: AIExecutionStatus.running,
      executionResult: null,
      error: null,
    );

    try {
      final service = ref.read(aiServiceProvider);
      final result = await service.generateProjectSummary(projectId);

      state = state.copyWith(
        executionStatus: AIExecutionStatus.completed,
        executionResult: result,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        executionStatus: AIExecutionStatus.failed,
        executionResult: null,
        error: e.toString(),
      );
    }
  }

  /// 重置状态
  void reset() {
    state = const AIState();
  }
}

/// AI 状态
class AIState {
  final AIExecutionStatus executionStatus;
  final String? executionResult;
  final String? error;

  const AIState({
    this.executionStatus = AIExecutionStatus.idle,
    this.executionResult,
    this.error,
  });

  AIState copyWith({
    AIExecutionStatus? executionStatus,
    String? executionResult,
    String? error,
  }) {
    return AIState(
      executionStatus: executionStatus ?? this.executionStatus,
      executionResult: executionResult ?? this.executionResult,
      error: error ?? this.error,
    );
  }
}

/// AI 执行状态枚举
enum AIExecutionStatus {
  idle,
  running,
  completed,
  failed,
}

/// AI 工作流执行结果
class AIWorkflowExecutionResult {
  final String workflowId;
  final String workflowName;
  final bool success;
  final String? output;
  final String? error;

  AIWorkflowExecutionResult({
    required this.workflowId,
    required this.workflowName,
    required this.success,
    this.output,
    this.error,
  });
}
