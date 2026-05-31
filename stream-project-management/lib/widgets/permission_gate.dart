import 'package:flutter/material.dart';

import '../data/models/enums.dart';

/// 权限门控组件
/// 设计文档 UI 组件：PermissionGate（按权限显示/隐藏组件）
class PermissionGate extends StatelessWidget {
  final MemberPermission requiredPermission;
  final Widget child;
  final Widget? fallback;

  const PermissionGate({
    super.key,
    required this.requiredPermission,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: 从状态获取当前用户权限
    // 当前简化为始终显示
    return child;
  }

  /// 检查权限是否满足
  static bool hasPermission(
    MemberPermission current,
    MemberPermission required,
  ) {
    final currentLevel = _getPermissionLevel(current);
    final requiredLevel = _getPermissionLevel(required);
    return currentLevel >= requiredLevel;
  }

  /// 获取权限等级
  static int _getPermissionLevel(MemberPermission permission) {
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
}
