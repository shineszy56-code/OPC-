import 'dart:convert';

import '../core/crypto/key_manager.dart';
import 'model_router.dart';

/// 统一 AI 网关
/// 设计文档 5.3.1 interface AIGateway
/// 支持本地模型（Ollama）和云端模型（OpenAI/Claude）
class AIGateway {
  AIGateway._();

  static final AIGateway _instance = AIGateway._();

  factory AIGateway() => _instance;

  final _router = ModelRouter();
  final _keyManager = KeyManager();

  /// 通用聊天完成，自动选择最优模型
  /// 设计文档 5.3.1: chatCompletion
  Future<String> chatCompletion({
    required String prompt,
    String? systemPrompt,
    double temperature = 0.7,
    int maxTokens = 2048,
    bool sensitiveData = false,
  }) async {
    // 敏感数据强制使用本地模型
    if (sensitiveData) {
      return _callLocalModel(
        model: await _router.getLocalModelForSensitiveData(),
        prompt: prompt,
        systemPrompt: systemPrompt,
        temperature: temperature,
      );
    }

    // 根据任务类型路由
    final model = await _router.route(prompt);
    final isLocal = _router.isLocalModel(model);

    if (isLocal) {
      try {
        return await _callLocalModel(
          model: model,
          prompt: prompt,
          systemPrompt: systemPrompt,
          temperature: temperature,
        );
      } catch (e) {
        // 本地模型失败，回退云端
        return _callCloudModel(
          model: await _router.getFallbackModel(model),
          prompt: prompt,
          systemPrompt: systemPrompt,
          temperature: temperature,
        );
      }
    } else {
      return _callCloudModel(
        model: model,
        prompt: prompt,
        systemPrompt: systemPrompt,
        temperature: temperature,
      );
    }
  }

  /// 结构化输出，保证返回符合指定 JSON Schema
  /// 设计文档 5.3.1: structuredOutput<T>
  Future<Map<String, dynamic>> structuredOutput({
    required String prompt,
    required Map<String, dynamic> jsonSchema,
    String? systemPrompt,
  }) async {
    final schemaPrompt = '''
$prompt

你必须返回严格符合以下 JSON Schema 的 JSON 对象，不要包含任何其他文字：

${json.encode(jsonSchema)}
''';

    final response = await chatCompletion(
      prompt: schemaPrompt,
      systemPrompt: systemPrompt ??
          '你是一个 JSON 输出助手，只返回有效的 JSON，不要有任何其他文字。',
    );

    try {
      // 提取 JSON（可能包含 markdown 代码块）
      var jsonStr = response;
      if (jsonStr.contains('```json')) {
        jsonStr = jsonStr.split('```json')[1].split('```')[0].trim();
      } else if (jsonStr.contains('```')) {
        jsonStr = jsonStr.split('```')[1].split('```')[0].trim();
      }

      return json.decode(jsonStr) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('AI 返回的结果不是有效的 JSON: $response');
    }
  }

  /// 执行 AI 工作流
  /// 设计文档 5.3.1: executeWorkflow
  Future<Map<String, dynamic>> executeWorkflow({
    required String workflowId,
    required Map<String, dynamic> context,
  }) async {
    // TODO: 从 AIWorkflowRepository 获取工作流定义
    final results = <String, dynamic>{};

    // 模拟执行步骤
    for (var i = 0; i < 3; i++) {
      final stepResult = await chatCompletion(
        prompt: '执行工作流步骤 ${i + 1}，上下文：${context.toString()}',
        systemPrompt: '你是一个工作流执行引擎。',
      );
      results['step_${i + 1}'] = stepResult;
    }

    return results;
  }

  /// 生成嵌入向量
  /// 设计文档 5.3.1: createEmbedding
  /// 第一期可不实现，返回模拟向量
  Future<List<double>> createEmbedding(String text) async {
    // TODO: 集成嵌入模型（如 text-embedding-3-small）
    // 模拟返回 1536 维向量
    return List.generate(1536, (i) => 0.0);
  }

  /// 调用本地模型（通过 Ollama）
  Future<String> _callLocalModel({
    required String model,
    required String prompt,
    String? systemPrompt,
    double temperature = 0.7,
  }) async {
    // TODO: 集成 ollama_dart
    // 当前返回模拟响应
    await Future.delayed(const Duration(seconds: 2));
    return '这是来自本地模型 $model 的响应。';
  }

  /// 调用云端模型
  Future<String> _callCloudModel({
    required String model,
    required String prompt,
    String? systemPrompt,
    double temperature = 0.7,
    int maxTokens = 2048,
  }) async {
    // TODO: 集成 langchain_openai 或 claude_api
    // 需要用户配置 API Key
    final apiKey = await _getCloudApiKey(model);
    if (apiKey == null) {
      throw Exception('未配置 ${model} 的 API Key');
    }

    // 模拟响应
    await Future.delayed(const Duration(seconds: 3));
    return '这是来自云端模型 $model 的响应。';
  }

  /// 获取云端模型 API Key
  Future<String?> _getCloudApiKey(String model) async {
    if (model.contains('gpt') || model.contains('openai')) {
      return _keyManager.readValue('openai_api_key');
    } else if (model.contains('claude') || model.contains('anthropic')) {
      return _keyManager.readValue('claude_api_key');
    }
    return null;
  }

  /// 配置云端模型 API Key
  Future<void> setCloudApiKey(String provider, String apiKey) async {
    await _keyManager.writeValue('${provider}_api_key', apiKey);
  }

  /// 检查是否已配置 API Key
  Future<bool> hasCloudApiKey(String provider) async {
    final key = await _getCloudApiKey(provider);
    return key != null && key.isNotEmpty;
  }
}
