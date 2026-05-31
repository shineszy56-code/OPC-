import 'dart:async';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/models/enums.dart';
import '../data/models/share_record.dart';
import '../services/share_service.dart';
import '../state/project_state.dart';

/// 分享服务提供者
final shareServiceProvider = Provider<ShareService>((ref) {
  return ShareService();
});

/// 分享管理页面
/// 设计文档 5.5.1：ShareScreen
class ShareScreen extends ConsumerWidget {
  final String projectId;

  const ShareScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          '分享管理',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _ShareBody(projectId: projectId),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateShareDialog(context, ref),
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// 显示创建分享对话框
  Future<void> _showCreateShareDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    Duration? selectedDuration;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('创建分享链接'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('权限级别', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              _buildPermissionSelector(context, ref),
              const SizedBox(height: 16),
              const Text('有效期', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              DropdownButton<Duration>(
                value: selectedDuration,
                hint: const Text('选择有效期'),
                isExpanded: true,
                items: const [
                  DropdownMenuItem(
                    value: Duration(hours: 1),
                    child: Text('1 小时'),
                  ),
                  DropdownMenuItem(
                    value: Duration(hours: 24),
                    child: Text('1 天'),
                  ),
                  DropdownMenuItem(
                    value: Duration(days: 7),
                    child: Text('7 天'),
                  ),
                  DropdownMenuItem(
                    value: Duration(days: 30),
                    child: Text('30 天'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedDuration = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: selectedDuration != null
                  ? () async {
                      Navigator.of(context).pop();
                      await _createShareLink(context, ref, selectedDuration!);
                    }
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
              ),
              child: const Text('创建'),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建权限选择器
  Widget _buildPermissionSelector(BuildContext context, WidgetRef ref) {
    final selectedPermission = ref.watch(_selectedPermissionProvider);

    return Column(
      children: [
        _buildPermissionTile(
          context,
          ref,
          MemberPermission.read,
          '只读',
          '只能查看项目内容',
          Icons.visibility,
        ),
        _buildPermissionTile(
          context,
          ref,
          MemberPermission.comment,
          '评论',
          '可以查看和评论',
          Icons.comment,
        ),
        _buildPermissionTile(
          context,
          ref,
          MemberPermission.edit,
          '编辑',
          '可以编辑任务状态',
          Icons.edit,
        ),
        _buildPermissionTile(
          context,
          ref,
          MemberPermission.admin,
          '管理',
          '可以管理成员和设置',
          Icons.admin_panel_settings,
        ),
      ],
    );
  }

  /// 构建权限选择项
  Widget _buildPermissionTile(
    BuildContext context,
    WidgetRef ref,
    MemberPermission permission,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final selectedPermission = ref.watch(_selectedPermissionProvider);

    return RadioListTile<MemberPermission>(
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      secondary: Icon(icon),
      value: permission,
      groupValue: selectedPermission,
      onChanged: (value) {
        ref.read(_selectedPermissionProvider.notifier).state = value!;
      },
    );
  }

  /// 创建分享链接
  Future<void> _createShareLink(
    BuildContext context,
    WidgetRef ref,
    Duration ttl,
  ) async {
    try {
      final shareService = ref.read(shareServiceProvider);
      final shareUrl = await shareService.createShareLink(
        projectId: projectId,
        permission: ref.read(_selectedPermissionProvider),
        ttl: ttl,
      );

      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('分享链接已创建'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('复制以下链接并分享给协作者：'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(shareUrl),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('关闭'),
              ),
              FilledButton(
                onPressed: () {
                  // 复制到剪贴板
                  // TODO: 实现复制功能
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('链接已复制')));
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                ),
                child: const Text('复制'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('创建分享链接失败：$e')));
      }
    }
  }
}

/// 分享管理主体
class _ShareBody extends ConsumerWidget {
  final String projectId;

  const _ShareBody({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sharesAsync = ref.watch(projectSharesProvider(projectId));

    return sharesAsync.when(
      data: (shares) {
        if (shares.isEmpty) {
          return _buildEmptyState(context);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: shares.length,
          itemBuilder: (context, index) {
            final share = shares[index];
            return _buildShareCard(context, ref, share);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _buildErrorState(context, error),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔗', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text('暂无分享链接', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            '点击 + 创建分享链接',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
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
          Text('加载失败', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 构建分享卡片
  Widget _buildShareCard(
    BuildContext context,
    WidgetRef ref,
    ShareRecord share,
  ) {
    final permissionText = _getPermissionText(share.permission);
    final permissionColor = _getPermissionColor(share.permission);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: permissionColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    permissionText,
                    style: TextStyle(
                      color: permissionColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showRevokeDialog(context, ref, share.id),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '创建时间：${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.fromMillisecondsSinceEpoch(share.createdAt))}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              '过期时间：${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.fromMillisecondsSinceEpoch(share.expiresAt))}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              '剩余时间：${share.remainingTimeText}',
              style: const TextStyle(fontSize: 12),
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

  /// 显示撤销确认对话框
  Future<void> _showRevokeDialog(
    BuildContext context,
    WidgetRef ref,
    String shareId,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('撤销分享'),
        content: const Text('确定要撤销此分享链接吗？撤销后协作者将无法访问。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                final shareService = ref.read(shareServiceProvider);
                await shareService.revokeShare(shareId);
                ref.invalidate(projectSharesProvider(projectId));
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('分享链接已撤销')));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('撤销失败：$e')));
                }
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('撤销'),
          ),
        ],
      ),
    );
  }
}

/// 选中的权限 Provider
final _selectedPermissionProvider = StateProvider<MemberPermission>(
  (ref) => MemberPermission.read,
);

/// 项目分享列表 Provider
final projectSharesProvider = FutureProvider.family<List<ShareRecord>, String>((
  ref,
  projectId,
) async {
  final shareService = ref.watch(shareServiceProvider);
  return shareService.getProjectShares(projectId);
});
