import 'package:flutter/material.dart';

/// 成员头像组件
/// 设计文档 UI 组件：MemberAvatar（含在线状态绿点）
class MemberAvatar extends StatelessWidget {
  final String name;
  final bool isOnline;
  final double size;

  const MemberAvatar({
    super.key,
    required this.name,
    this.isOnline = false,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 头像主体
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: _getAvatarColor(name),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?',
              style: TextStyle(
                fontSize: size * 0.4,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        // 在线状态绿点
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// 根据名称生成稳定的颜色
  Color _getAvatarColor(String name) {
    final colors = [
      const Color(0xFF6C63FF), // 主色
      const Color(0xFF4CAF50), // 绿色
      const Color(0xFF2196F3), // 蓝色
      const Color(0xFFFFC107), // 黄色
      const Color(0xFFFF5722), // 橙色
      const Color(0xFF9C27B0), // 紫色
    ];

    final hash = name.hashCode.abs();
    return colors[hash % colors.length];
  }
}
