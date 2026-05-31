import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'share_record.freezed.dart';
part 'share_record.g.dart';

/// 分享记录模型
/// 对应设计文档 interface ShareRecord
@freezed
class ShareRecord with _$ShareRecord {
  const factory ShareRecord({
    /// UUID v4
    required String id,

    /// 关联项目 ID
    String? projectId,

    /// 关联任务 ID
    String? taskId,

    /// 分享类型
    @Default(ShareType.cloudflare) ShareType type,

    /// 权限级别
    @Default(MemberPermission.read) MemberPermission permission,

    /// 过期时间（Unix timestamp）
    required int expiresAt,

    /// Cloudflare KV 中的键
    String? cloudflareKey,

    /// P2P 连接 ID
    String? peerId,

    /// 创建时间
    required int createdAt,
  }) = _ShareRecord;

  factory ShareRecord.fromJson(Map<String, dynamic> json) =>
      _$ShareRecordFromJson(json);
}

/// ShareRecord 扩展方法
extension ShareRecordX on ShareRecord {
  /// 是否已过期
  bool get isExpired => DateTime.now().millisecondsSinceEpoch > expiresAt;

  /// 是否 Cloudflare 类型
  bool get isCloudflare => type == ShareType.cloudflare;

  /// 是否 P2P 类型
  bool get isP2P => type == ShareType.p2p;

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

  /// 剩余有效时间文本
  String get remainingTimeText {
    final now = DateTime.now().millisecondsSinceEpoch;
    final remaining = expiresAt - now;
    if (remaining <= 0) return '已过期';
    final days = remaining ~/ (24 * 60 * 60 * 1000);
    if (days > 0) return '$days 天';
    final hours = remaining ~/ (60 * 60 * 1000);
    if (hours > 0) return '$hours 小时';
    final minutes = remaining ~/ (60 * 1000);
    return '$minutes 分钟';
  }
}
