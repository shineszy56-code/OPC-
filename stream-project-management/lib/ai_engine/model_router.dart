/// 模型路由策略
/// 设计文档 5.3.2：模型路由策略
class ModelRouter {
  ModelRouter._();

  static final ModelRouter _instance = ModelRouter._();

  factory ModelRouter() => _instance;

  /// 根据任务类型自动选择最优模型
  /// 返回模型标识符
  Future<String> route(String prompt) async {
    // 根据 prompt 关键词路由
    if (_isSensitiveData(prompt)) {
      return getLocalModelForSensitiveData();
    }

    if (_isTaskBreakdown(prompt) ||
        _isScheduling(prompt) ||
        _isSummary(prompt)) {
      return getLocalModelForGeneral();
    }

    if (_isCodeGeneration(prompt) || _isCopywriting(prompt)) {
      return getCloudModelForCreative();
    }

    if (_isComplexReasoning(prompt) || _isMultimodal(prompt)) {
      return getCloudModelForComplex();
    }

    // 默认使用本地模型
    return getLocalModelForGeneral();
  }

  /// 任务拆解 / 排期 / 总结 → 本地 Qwen2 7B 4bit
  /// 回退 Claude 3.5 Haiku
  String getLocalModelForGeneral() => 'qwen2:7b';

  /// 文案写作 / 代码生成 → 云端 Claude 3.5 Sonnet
  /// 回退 GPT-4o Mini
  String getCloudModelForCreative() => 'claude-3-5-sonnet';

  /// 复杂推理 / 多模态 → 云端 GPT-4o
  /// 回退 Claude 3 Opus
  String getCloudModelForComplex() => 'gpt-4o';

  /// 敏感数据处理 → 本地 Llama 3 8B 4bit
  /// 无回退（保证数据不离开设备）
  String getLocalModelForSensitiveData() => 'llama3:8b';

  /// 获取回退模型
  Future<String> getFallbackModel(String model) async {
    final fallbackMap = {
      'qwen2:7b': 'claude-3-5-haiku',
      'claude-3-5-sonnet': 'gpt-4o-mini',
      'gpt-4o': 'claude-3-opus',
      'llama3:8b': '', // 敏感数据无回退
    };

    return fallbackMap[model] ?? 'qwen2:7b';
  }

  /// 检查模型是否本地模型
  bool isLocalModel(String model) {
    final localModels = ['qwen2:7b', 'llama3:8b', 'qwen2:4b', 'llama3:3b'];
    return localModels.any((m) => model.startsWith(m));
  }

  /// 检查是否是敏感数据处理
  bool _isSensitiveData(String prompt) {
    final keywords = [
      '密码',
      'password',
      '私钥',
      'private_key',
      '身份证',
      'id_card',
      '银行卡',
      'credit_card',
      '敏感',
      'sensitive',
      '保密',
      'confidential',
    ];

    final lowerPrompt = prompt.toLowerCase();
    return keywords.any((kw) => lowerPrompt.contains(kw));
  }

  /// 检测是否是任务拆解请求
  bool _isTaskBreakdown(String prompt) {
    final keywords = ['拆解', 'breakdown', '子任务', 'subtask', '步骤', 'step'];
    final lowerPrompt = prompt.toLowerCase();
    return keywords.any((kw) => lowerPrompt.contains(kw));
  }

  /// 检测是否是排期请求
  bool _isScheduling(String prompt) {
    final keywords = ['排期', 'schedule', '计划', 'plan', '时间线', 'timeline'];
    final lowerPrompt = prompt.toLowerCase();
    return keywords.any((kw) => lowerPrompt.contains(kw));
  }

  /// 检测是否是总结请求
  bool _isSummary(String prompt) {
    final keywords = ['总结', 'summary', '报告', 'report', '汇总'];
    final lowerPrompt = prompt.toLowerCase();
    return keywords.any((kw) => lowerPrompt.contains(kw));
  }

  /// 检测是否是代码生成请求
  bool _isCodeGeneration(String prompt) {
    final keywords = [
      '代码',
      'code',
      '函数',
      'function',
      '类',
      'class',
      '实现',
      'implement',
    ];
    final lowerPrompt = prompt.toLowerCase();
    return keywords.any((kw) => lowerPrompt.contains(kw));
  }

  /// 检测是否是文案写作请求
  bool _isCopywriting(String prompt) {
    final keywords = [
      '文案',
      'copy',
      '文章',
      'article',
      '邮件',
      'email',
      '报告',
      'report',
    ];
    final lowerPrompt = prompt.toLowerCase();
    return keywords.any((kw) => lowerPrompt.contains(kw));
  }

  /// 检测是否是复杂推理请求
  bool _isComplexReasoning(String prompt) {
    final keywords = [
      '分析',
      'analyze',
      '推理',
      'reasoning',
      '比较',
      'compare',
      '评估',
      'evaluate',
    ];
    final lowerPrompt = prompt.toLowerCase();
    return keywords.any((kw) => lowerPrompt.contains(kw));
  }

  /// 检测是否是多模态请求
  bool _isMultimodal(String prompt) {
    return prompt.contains('图片') ||
        prompt.contains('image') ||
        prompt.contains('文件') ||
        prompt.contains('file') ||
        prompt.contains('截图') ||
        prompt.contains('screenshot');
  }

  /// 获取本地模型列表（用于 UI 显示）
  List<LocalModelInfo> getLocalModels() {
    return [
      LocalModelInfo(
        name: 'Qwen2 7B',
        modelId: 'qwen2:7b',
        sizeGB: 4.0,
        description: '任务拆解、排期、总结（推荐）',
        recommended: true,
      ),
      LocalModelInfo(
        name: 'Llama 3 8B',
        modelId: 'llama3:8b',
        sizeGB: 4.5,
        description: '敏感数据处理（无回退）',
        recommended: false,
      ),
      LocalModelInfo(
        name: 'Qwen2 4B',
        modelId: 'qwen2:4b',
        sizeGB: 2.2,
        description: '轻量模型，适合低端设备',
        recommended: false,
      ),
      LocalModelInfo(
        name: 'Llama 3 3B',
        modelId: 'llama3:3b',
        sizeGB: 1.8,
        description: '超轻量模型，极速响应',
        recommended: false,
      ),
    ];
  }

  /// 估算模型下载时间（分钟）
  int estimateDownloadTime(double sizeGB, {int mbps = 50}) {
    final sizeMb = sizeGB * 1024;
    return (sizeMb / mbps).ceil();
  }
}

/// 本地模型信息
class LocalModelInfo {
  final String name;
  final String modelId;
  final double sizeGB;
  final String description;
  final bool recommended;

  LocalModelInfo({
    required this.name,
    required this.modelId,
    required this.sizeGB,
    required this.description,
    required this.recommended,
  });
}
