import 'dart:async';

import 'model_router.dart';

/// 本地模型运行时
/// 设计文档 5.3：本地模型运行时（Ollama + TFLite）
class LocalModelRuntime {
  LocalModelRuntime._();

  static final LocalModelRuntime _instance = LocalModelRuntime._();

  factory LocalModelRuntime() => _instance;

  bool _isOllamaRunning = false;

  /// 初始化 Ollama 客户端
  Future<bool> initOllama({String baseUrl = 'http://localhost:11434'}) async {
    // TODO: 集成 ollama_dart 客户端
    // 当前为 stub 实现
    _isOllamaRunning = false;
    return false;
  }

  /// 启动 Ollama 服务（移动端需要启动本地服务）
  Future<bool> startOllamaService() async {
    return _isOllamaRunning;
  }

  /// 检查模型是否已下载
  Future<bool> isModelAvailable(String modelName) async {
    return false;
  }

  /// 下载模型
  Future<void> pullModel(
    String modelName, {
    required Function(double progress) onProgress,
  }) async {
    // TODO: 实现模型下载
  }

  /// 生成文本（聊天）
  Future<String> generateText({
    required String model,
    required String prompt,
    String? systemPrompt,
    double temperature = 0.7,
    int maxTokens = 2048,
  }) async {
    // TODO: 集成 ollama_dart 的聊天 API
    throw Exception('Ollama 未初始化，请先启动 Ollama 服务');
  }

  /// 生成嵌入向量
  Future<List<double>> generateEmbedding({
    required String model,
    required String text,
  }) async {
    // TODO: 集成 ollama_dart 的嵌入 API
    throw Exception('Ollama 未初始化');
  }

  /// 停止模型运行（释放内存）
  Future<void> stopModel(String model) async {
    // Ollama 会自动管理内存
  }

  /// 获取已下载的模型列表
  Future<List<LocalModelInfo>> getDownloadedModels() async {
    return [];
  }

  /// 删除本地模型
  Future<void> deleteModel(String modelName) async {
    // TODO: 实现模型删除
  }

  /// 释放资源
  void dispose() {
    _isOllamaRunning = false;
  }

  /// Ollama 是否正在运行
  bool get isOllamaRunning => _isOllamaRunning;
}
