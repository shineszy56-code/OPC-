import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'project_member.freezed.dart';
part 'project_member.g.dart';

/// 项目成员模型
/// 对应设计文档 interface ProjectMember
@freezed
class ProjectMember with _$ProjectMember {
  const factory ProjectMember({
    /// UUID v4
    required String id,

    /// 所属项目 ID
    required String projectId,

    /// 成员昵称（本地自定义，不存储在云端）
    required String name,

    /// 权限级别
    @Default(MemberPermission.read) MemberPermission permission,

    /// 关联的分享记录 ID
    @Default('') String shareId,

    /// 最后活跃时间
    required int lastActiveAt,

    /// 在线状态（本地计算）
    @Default(false) bool isOnline,

    /// 创建时间
    required int createdAt,

    /// 更新时间
    required int updatedAt,
  }) = _ProjectMember;

  factory ProjectMember.fromJson(Map<String, dynamic> json) =>
      _$ProjectMemberFromJson(json);
}

/// ProjectMember 扩展方法
extension ProjectMemberX on ProjectMember {
  /// 是否只读
  bool get isReadOnly => permission == MemberPermission.read;

  /// 可评论
  bool get canComment =>
      permission == MemberPermission.comment ||
      permission == MemberPermission.edit ||
      permission == MemberPermission.admin;

  /// 可编辑
  bool get canEdit =>
      permission == MemberPermission.edit ||
      permission == MemberPermission.admin;

  /// 是管理员
  bool get isAdmin => permission == MemberPermission.admin;

  /// 权限显示文本
  String get permissionText {
    switch (permission) {
      case MemberPermission.read:
        return '只读';
      case MemberPermission.comment:
        return '评论';
      case MemberPermission.edit:
        return '编辑';
      case MemberPermission.admin:
        return '管理';
    }
  }

  /// 权限颜色
  int get permissionColor {
    switch (permission) {
      case MemberPermission.read:
        return 0xFF9E9E9E;
      case MemberPermission.comment:
        return 0xFF2196F3;
      case MemberPermission.edit:
        return 0xFF4CAF50;
      case MemberPermission.admin:
        return 0xFF6C63FF;
    }
  }
}
