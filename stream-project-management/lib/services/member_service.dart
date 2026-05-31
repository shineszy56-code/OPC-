import 'package:uuid/uuid.dart';

import '../core/crypto/key_manager.dart';
import '../data/models/enums.dart';
import '../data/models/operation_log.dart';
import '../data/models/project_member.dart';
import '../data/repositories/member_repository.dart';
import '../data/repositories/offline_queue_repository.dart';
import '../data/repositories/operation_log_repository.dart';
import 'notification_service.dart';

/// 成员管理服务
/// 设计文档 5.4：MemberService - 成员管理、权限控制、在线状态
class MemberService {
  MemberService._();

  static final MemberService _instance = MemberService._();

  factory MemberService() => _instance;

  final _memberRepo = ProjectMemberRepository();
  final _logRepo = OperationLogRepository();
  final _queueRepo = OfflineQueueRepository();
  final _keyManager = KeyManager();

  /// 添加成员
  Future<ProjectMember> addMember({
    required String projectId,
    required String name,
    MemberPermission permission = MemberPermission.read,
    String? shareId,
  }) async {
    final deviceId = await _keyManager.getDeviceId();
    final now = DateTime.now().millisecondsSinceEpoch;

    final member = ProjectMember(
      id: const Uuid().v4(),
      projectId: projectId,
      name: name,
      permission: permission,
      shareId: shareId ?? '',
      lastActiveAt: now,
      isOnline: false,
      createdAt: now,
      updatedAt: now,
    );

    await _memberRepo.create(member);
    await _logMemberAction(member, LogAction.create, '添加成员', name);
    await _enqueue('create', member);

    return member;
  }

  /// 获取项目所有成员
  Future<List<ProjectMember>> getProjectMembers(String projectId) async {
    return _memberRepo.getByProjectId(projectId);
  }

  /// 更新成员权限
  Future<void> updatePermission(String memberId, MemberPermission newPermission) async {
    final member = await _memberRepo.getById(memberId);
    if (member == null) return;

    await _memberRepo.updatePermission(memberId, newPermission);
    await _logMemberAction(member, LogAction.update, '权限变更', newPermission.name);
    await _enqueue('update', member.copyWith(permission: newPermission));
  }

  /// 更新成员在线状态
  Future<void> updateOnlineStatus(String memberId, bool isOnline) async {
    await _memberRepo.updateOnlineStatus(memberId, isOnline);
  }

  /// 移除成员
  Future<void> removeMember(String memberId) async {
    final member = await _memberRepo.getById(memberId);
    if (member == null) return;

    await _memberRepo.delete(memberId);
    await _logMemberAction(member, LogAction.delete, '移除成员', member.name);
    await _enqueue('delete', {'id': memberId, 'table': 'project_members'});
  }

  /// 获取在线成员数量
  Future<int> getOnlineCount(String projectId) async {
    return _memberRepo.getOnlineCount(projectId);
  }

  /// 检查成员权限
  bool hasPermission(ProjectMember member, MemberPermission required) {
    final permissionLevel = _getPermissionLevel(member.permission);
    final requiredLevel = _getPermissionLevel(required);
    return permissionLevel >= requiredLevel;
  }

  int _getPermissionLevel(MemberPermission permission) {
    switch (permission) {
      case MemberPermission.read:
        return 1;
      case MemberPermission.comment:
        return 2;
      case MemberPermission.edit:
        return 3;
      case MemberPermission.admin:
        return 4;
    }
  }

  /// 记录成员操作日志
  Future<void> _logMemberAction(
    ProjectMember member,
    LogAction action,
    String field,
    String value,
  ) async {
    final deviceId = await _keyManager.getDeviceId();
    await _logRepo.create(OperationLog(
      id: const Uuid().v4(),
      projectId: member.projectId,
      memberId: deviceId,
      memberName: '我',
      action: action,
      field: field,
      newValue: value,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      synced: false,
    ));
  }

  /// 加入离线队列
  Future<void> _enqueue(String operationType, dynamic payload) async {
    await _queueRepo.enqueue(
      operationType: operationType,
      tableName: 'project_members',
      recordId: payload is ProjectMember ? payload.id : payload['id'],
      payload: payload is Map ? payload : payload.toJson(),
    );
  }
}
