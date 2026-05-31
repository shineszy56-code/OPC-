import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'project.freezed.dart';
part 'project.g.dart';

/// 项目模型
/// 对应设计文档 interface Project
@freezed
class Project with _$Project {
  const factory Project({
    /// UUID v4
    required String id,

    /// 项目名称
    required String name,

    /// emoji 图标字符
    @Default('📁') String icon,

    /// 项目描述
    @Default('') String description,

    /// 项目状态
    @Default(ProjectStatus.active) ProjectStatus status,

    /// 开始日期（Unix timestamp）
    required int startDate,

    /// 结束日期（Unix timestamp）
    required int endDate,

    /// 进度 0-100，自动计算
    @Default(0.0) double progress,

    /// 项目级 AI 指令
    @Default('') String aiPrompt,

    /// 项目创建者 ID
    required String ownerId,

    /// 创建时间
    required int createdAt,

    /// 更新时间
    required int updatedAt,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}

/// Project 扩展方法
extension ProjectX on Project {
  /// 是否活跃
  bool get isActive => status == ProjectStatus.active;

  /// 是否已完成
  bool get isCompleted => status == ProjectStatus.completed;

  /// 是否已归档
  bool get isArchived => status == ProjectStatus.archived;

  /// 状态显示文本
  String get statusText {
    switch (status) {
      case ProjectStatus.active:
        return '进行中';
      case ProjectStatus.completed:
        return '已完成';
      case ProjectStatus.archived:
        return '已归档';
    }
  }

  /// 进度显示文本
  String get progressText => '${(progress * 100).toInt()}%';
}
