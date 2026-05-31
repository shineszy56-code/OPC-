import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:langchain/langchain.dart';
import 'package:uuid/uuid.dart';

import '../core/crypto/key_manager.dart';
import '../data/models/ai_workflow.dart';
import '../data/models/enums.dart';
import '../data/models/task.dart';
import '../data/repositories/ai_workflow_repository.dart';
import '../data/repositories/offline_queue_repository.dart';
import 'project_service.dart';
import 'task_service.dart';

/// AI 引擎服务
/// 设计文档 5.3 + 5.4：AIService - AI网关调用、任务拆解、总结生成
class AIService {
  AIService._();

  static final AIService _instance = AIService._();

  factory AIService() => _instance;

  final _workflowRepo = AIWorkflowRepository();
  final _queueRepo = OfflineQueueRepository();
  final _keyManager = KeyManager();
  final _taskService = TaskService();
  final _projectService = ProjectService();

  /// 任务拆解（AI 生成子任务）
  /// 返回 TaskDraft 列表
  Future<List<TaskDraft>> breakdownTask({
    required String projectId,
    required String taskTitle,
    String? taskDescription,
  }) async {
    final prompt =
        '''
你是一个项目管理助手。请将以下任务拆解为 3-8 个子任务。

任务标题：$taskTitle
${taskDescription != null ? "任务描述：$taskDescription" : ""}

要求：
1. 每个子任务都是可独立执行的
2. 子任务应该覆盖完成该任务所需的所有步骤
3. 返回 JSON 格式，包含 title、description、priority（low/medium/high）

返回格式：
{
  "subtasks": [
    {"title": "...", "description": "...", "priority": "medium"}
  ]
}
''';

    try {
      final response = await _callAI(prompt, model: 'qwen2:7b');
      final data = json.decode(response);
      final subtasks = data['subtasks'] as List<dynamic>;

      return subtasks.map((json) {
        final priorityStr = json['priority'] as String? ?? 'medium';
        return TaskDraft(
          title: json['title'] as String,
          description: json['description'] as String? ?? '',
          priority: _parsePriority(priorityStr),
        );
      }).toList();
    } catch (e) {
      // 回退：返回默认子任务
      return [
        TaskDraft(title: '研究并收集资料', priority: TaskPriority.medium),
        TaskDraft(title: '制定执行方案', priority: TaskPriority.high),
        TaskDraft(title: '执行并提交结果', priority: TaskPriority.medium),
      ];
    }
  }

  /// 生成项目总结
  Future<String> generateProjectSummary(String projectId) async {
    final project = await _projectService.getProjectById(projectId);
    if (project == null) return '项目不存在';

    final tasks = await _taskService.getProjectTasks(projectId);
    final doneTasks = tasks.where((t) => t.isDone).length;
    final totalTasks = tasks.length;

    final prompt =
        '''
请为以下项目生成一份简洁的进度总结报告：

项目名称：${project.name}
项目描述：${project.description}
总任务数：$totalTasks
已完成：$doneTasks
进度：${(project.progress * 100).toInt()}%

要求：
1. 总结当前进度
2. 指出可能的风险或阻碍
3. 给出下一步建议
4. 控制在 200 字以内
''';

    try {
      return await _callAI(prompt, model: 'qwen2:7b');
    } catch (e) {
      return '无法生成总结，请稍后重试。';
    }
  }

  /// 生成任务描述（AI 辅助填写）
  Future<String> generateTaskDescription(String taskTitle) async {
    final prompt =
        '''
请为以下任务生成一段简洁的描述（100字以内）：

任务标题：$taskTitle

要求：说明任务目标、关键步骤和验收标准。
''';

    try {
      return await _callAI(prompt, model: 'qwen2:7b');
    } catch (e) {
      return '';
    }
  }

  /// 执行 AI 工作流
  Future<void> executeWorkflow(
    String workflowId,
    Map<String, dynamic> context,
  ) async {
    final workflow = await _workflowRepo.getById(workflowId);
    if (workflow == null || !workflow.enabled) return;

    for (final step in workflow.steps) {
      await _executeStep(step, context);
    }
  }

  /// 获取 AI 建议的截止日期
  Future<DateTime?> suggestDueDate(String taskTitle) async {
    final prompt =
        '''
请为以下任务建议一个合理的截止日期（天数，从今天开始计算）：

任务标题：$taskTitle

只返回一个数字（天数），例如：3、7、14、30
''';

    try {
      final response = await _callAI(prompt, model: 'qwen2:7b');
      final days = int.tryParse(response.trim());
      if (days != null) {
        return DateTime.now().add(Duration(days: days));
      }
    } catch (_) {
      // 忽略错误
    }
    return null;
  }

  /// 调用 AI 模型
  /// 遵循设计文档 5.3.2 的模型路由策略
  Future<String> _callAI(String prompt, {String? model}) async {
    // 优先使用本地模型
    if (model?.contains('qwen') == true || model?.contains('llama') == true) {
      try {
        return await _callLocalModel(model!, prompt);
      } catch (e) {
        // 本地模型失败，回退到云端
      }
    }

    // 云端模型
    return _callCloudModel(prompt);
  }

  /// 调用本地模型（通过 Ollama）
  Future<String> _callLocalModel(String model, String prompt) async {
    // TODO: 集成 ollama_dart
    // 当前返回模拟响应
    await Future.delayed(const Duration(seconds: 1));
    return '{"subtasks": [{"title": "示例子任务", "description": "由 AI 生成", "priority": "medium"}]}';
  }

  /// 调用云端模型
  Future<String> _callCloudModel(String prompt) async {
    // TODO: 集成 langchain_openai 或 claude_api
    // 需要用户配置 API Key
    await Future.delayed(const Duration(seconds: 2));
    return 'AI 响应需要配置 API Key';
  }

  /// 执行工作流步骤
  Future<void> _executeStep(AIStep step, Map<String, dynamic> context) async {
    switch (step.type) {
      case StepType.prompt:
        final prompt = _interpolate(step.promptTemplate, context);
        final result = await _callAI(prompt, model: step.model);
        if (step.passOutput) {
          context['last_output'] = result;
        }
      case StepType.condition:
      // TODO: 实现条件判断
      case StepType.loop:
      // TODO: 实现循环
      case StepType.parallel:
      // TODO: 实现并行执行
    }
  }

  /// 插值模板变量
  String _interpolate(String template, Map<String, dynamic> context) {
    var result = template;
    context.forEach((key, value) {
      result = result.replaceAll('{{$key}}', value.toString());
    });
    return result;
  }

  TaskPriority _parsePriority(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return TaskPriority.high;
      case 'low':
        return TaskPriority.low;
      case 'medium':
      default:
        return TaskPriority.medium;
    }
  }
}
