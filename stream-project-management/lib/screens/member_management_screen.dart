import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/enums.dart';
import '../data/models/project_member.dart';
import '../state/member_state.dart';
import '../widgets/member_avatar.dart';

/// 成员管理页面
/// 设计文档 5.5.1：MemberManagementScreen
class MemberManagementScreen extends ConsumerWidget {
  final String projectId;

  const MemberManagementScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(projectMembersProvider(projectId));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('成员管理', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: membersAsync.when(
        data: (members) => members.isEmpty
            ? _buildEmptyState(context)
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return _buildMemberCard(context, ref, member);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _buildErrorState(context, error),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMemberDialog(context, ref),
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('👥', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            '还没有成员',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            '点击右下角 + 添加协作者',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }

  /// 构建成员卡片
  Widget _buildMemberCard(
    BuildContext context,
    WidgetRef ref,
    ProjectMember member,
  ) {
    final color = _getPermissionColor(member.permission);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: MemberAvatar(
          name: member.name,
          isOnline: member.isOnline,
          size: 40,
        ),
        title: Text(member.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        subtitle: Text(
          '${_getPermissionText(member.permission)} · ${_formatTime(member.lastActiveAt)}',
          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
        ),
        trailing: PopupMenuButton<MemberPermission>(
          onSelected: (permission) async {
            await ref.read(memberNotifierProvider.notifier).updatePermission(
                  member.id,
                  permission,
                );
          },
          itemBuilder: (context) => MemberPermission.values.map((p) {
            return PopupMenuItem(
              value: p,
              child: Text(_getPermissionText(p)),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 构建错误状态
  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('😞', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            '加载失败',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }

  /// 显示添加成员对话框
  void _showAddMemberDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    var selectedPermission = MemberPermission.read;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('添加成员'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: '成员昵称',
                  labelStyle: const TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
              ),
              const SizedBox(height: 16),
              const Text('权限级别', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              ...MemberPermission.values.map((p) {
                return RadioListTile<MemberPermission>(
                  title: Text(_getPermissionText(p)),
                  value: p,
                  groupValue: selectedPermission,
                  onChanged: (value) => setState(() => selectedPermission = value!),
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () async {
                if (nameController.text.isEmpty) return;
                await ref.read(memberNotifierProvider.notifier).addMember(
                      projectId: projectId,
                      name: nameController.text,
                      permission: selectedPermission,
                    );
                if (context.mounted) Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
              ),
              child: const Text('添加'),
            ),
          ],
        ),
      ),
    );
  }

  /// 获取权限文本
  String _getPermissionText(MemberPermission permission) {
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

  /// 获取权限颜色
  Color _getPermissionColor(MemberPermission permission) {
    switch (permission) {
      case MemberPermission.read:
        return Colors.grey;
      case MemberPermission.comment:
        return const Color(0xFF2196F3);
      case MemberPermission.edit:
        return const Color(0xFF4CAF50);
      case MemberPermission.admin:
        return const Color(0xFF6C63FF);
    }
  }

  /// 格式化时间
  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return '刚刚';
    if (difference.inMinutes < 60) return '${difference.inMinutes} 分钟前';
    if (difference.inHours < 24) return '${difference.inHours} 小时前';
    return '${date.month}-${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
