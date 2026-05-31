import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/enums.dart';
import '../data/models/project_member.dart';
import '../services/member_service.dart';

/// 项目成员列表
final projectMembersProvider =
    FutureProvider.family<List<ProjectMember>, String>((ref, projectId) async {
      final service = MemberService();
      return service.getProjectMembers(projectId);
    });

/// 在线成员数量
final onlineMemberCountProvider = FutureProvider.family<int, String>((
  ref,
  projectId,
) async {
  final service = MemberService();
  return service.getOnlineCount(projectId);
});

/// 成员操作 Notifier
final memberNotifierProvider = NotifierProvider<MemberNotifier, void>(
  MemberNotifier.new,
);

class MemberNotifier extends Notifier<void> {
  @override
  void build() {}

  /// 添加成员
  Future<ProjectMember> addMember({
    required String projectId,
    required String name,
    MemberPermission permission = MemberPermission.read,
  }) async {
    final service = MemberService();
    final member = await service.addMember(
      projectId: projectId,
      name: name,
      permission: permission,
    );

    ref.invalidate(projectMembersProvider(projectId));
    return member;
  }

  /// 更新权限
  Future<void> updatePermission(
    String memberId,
    MemberPermission newPermission,
  ) async {
    final service = MemberService();
    await service.updatePermission(memberId, newPermission);
  }

  /// 移除成员
  Future<void> removeMember(String memberId, String projectId) async {
    final service = MemberService();
    await service.removeMember(memberId);

    ref.invalidate(projectMembersProvider(projectId));
  }

  /// 更新在线状态
  Future<void> updateOnlineStatus(String memberId, bool isOnline) async {
    final service = MemberService();
    await service.updateOnlineStatus(memberId, isOnline);
  }
}
