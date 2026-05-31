import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'task.freezed.dart';
part 'task.g.dart';

/// 附件模型
@freezed
class Attachment with _$Attachment {
  const factory Attachment({
    required String id,
    required String name,
    required String url,
    required String mimeType,
    required int size,
    required int uploadedAt,
  }) = _Attachment;

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);
}

/// 任务模型
/// 对应设计文档 interface Task
@freezed
class Task with _$Task {
  const factory Task({
    /// UUID v4
    required String id,

    /// 所属项目 ID
    required String projectId,

    /// 父任务 ID（子任务）
    String? parentId,

    /// 任务标题
    required String title,

    /// 任务描述
    @Default('') String description,

    /// 任务状态
    @Default(TaskStatus.todo) TaskStatus status,

    /// 优先级
    @Default(TaskPriority.medium) TaskPriority priority,

    /// 截止日期（Unix timestamp）
    int? dueDate,

    /// 负责人 ID
    String? assigneeId,

    /// 是否可由 AI 自动执行
    @Default(false) bool aiExecutable,

    /// AI 执行状态
    @Default(AIStatus.idle) AIStatus aiStatus,

    /// AI 生成结果 JSON
    String? aiResult,

    /// 附件列表
    @Default([]) List<Attachment> attachments,

    /// 创建时间
    required int createdAt,

    /// 更新时间
    required int updatedAt,

    /// 最后修改人 ID
    @Default('') String lastModifiedBy,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

/// 任务草稿（用于批量创建）
class TaskDraft {
  final String title;
  final String? description;
  final TaskPriority priority;
  final DateTime? dueDate;
  final String? assigneeId;
  final bool aiExecutable;
  final String? parentId;

  TaskDraft({
    required this.title,
    this.description,
    this.priority = TaskPriority.medium,
    this.dueDate,
    this.assigneeId,
    this.aiExecutable = false,
    this.parentId,
  });
}

/// Task 扩展方法
extension TaskX on Task {
  /// 是否待办
  bool get isTodo => status == TaskStatus.todo;

  /// 进行中
  bool get isInProgress => status == TaskStatus.inProgress;

  /// 是否完成
  bool get isDone => status == TaskStatus.done;

  /// 是否被阻塞
  bool get isBlocked => status == TaskStatus.blocked;

  /// 状态显示文本
  String get statusText {
    switch (status) {
      case TaskStatus.todo:
        return '待办';
      case TaskStatus.inProgress:
        return '进行中';
      case TaskStatus.done:
        return '已完成';
      case TaskStatus.blocked:
        return '已阻塞';
    }
  }

  /// 优先级显示文本
  String get priorityText {
    switch (priority) {
      case TaskPriority.low:
        return '低';
      case TaskPriority.medium:
        return '中';
      case TaskPriority.high:
        return '高';
    }
  }

  /// 优先级颜色
  Color get priorityColor {
    switch (priority) {
      case TaskPriority.low:
        return const Color(0xFF4CAF50); // 绿色
      case TaskPriority.medium:
        return const Color(0xFFFFC107); // 黄色
      case TaskPriority.high:
        return const Color(0xFFF44336); // 红色
    }
  }

  /// 状态颜色
  Color get statusColor {
    switch (status) {
      case TaskStatus.todo:
        return const Color(0xFF9E9E9E); // 灰色
      case TaskStatus.inProgress:
        return const Color(0xFF2196F3); // 蓝色
      case TaskStatus.done:
        return const Color(0xFF4CAF50); // 绿色
      case TaskStatus.blocked:
        return const Color(0xFFF44336); // 红色
    }
  }
}
