import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/integration_service.dart';
import '../state/integration_state.dart';

/// 第三方工具集成页面
/// 设计文档 5.5.1：IntegrationScreen
class IntegrationScreen extends ConsumerWidget {
  const IntegrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(integrationStatusProvider);
    final status = statusAsync.valueOrNull ??
        IntegrationStatus(
          githubConfigured: false,
          cursorConfigured: false,
          claudeConfigured: false,
        );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('第三方集成', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // GitHub 集成
          _buildIntegrationCard(
            context: context,
            title: 'GitHub',
            description: '同步代码提交记录',
            icon: Icons.code,
            color: const Color(0xFF6C63FF),
            isConfigured: status.githubConfigured,
            onTap: () => _showGithubConfigDialog(context, ref),
          ),
          const SizedBox(height: 12),
          // Cursor 集成
          _buildIntegrationCard(
            context: context,
            title: 'Cursor',
            description: '同步 Cursor 使用记录',
            icon: Icons.edit_note,
            color: const Color(0xFF4CAF50),
            isConfigured: status.cursorConfigured,
            onTap: () => _showCursorConfigDialog(context, ref),
          ),
          const SizedBox(height: 12),
          // Claude 集成
          _buildIntegrationCard(
            context: context,
            title: 'Claude',
            description: '同步 Claude 使用记录',
            icon: Icons.psychology,
            color: const Color(0xFFFF5722),
            isConfigured: status.claudeConfigured,
            onTap: () => _showClaudeConfigDialog(context, ref),
          ),
          const SizedBox(height: 24),
          // 同步按钮
          FilledButton(
            onPressed: () => _syncAll(context, ref),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('同步所有', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// 构建集成卡片
  Widget _buildIntegrationCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required bool isConfigured,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        subtitle: Text(
          isConfigured ? '已配置' : description,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        trailing: Icon(
          isConfigured ? Icons.check_circle : Icons.chevron_right,
          color: isConfigured ? Colors.green : null,
        ),
        onTap: onTap,
      ),
    );
  }

  /// 显示 GitHub 配置对话框
  void _showGithubConfigDialog(BuildContext context, WidgetRef ref) {
    final tokenController = TextEditingController();
    final usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('配置 GitHub'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tokenController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Personal Access Token',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: '用户名',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              final service = ref.read(integrationServiceProvider);
              await service.configureGithub(
                token: tokenController.text,
                username: usernameController.text,
              );
              if (context.mounted) {
                Navigator.of(context).pop();
                ref.invalidate(integrationStatusProvider);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  /// 显示 Cursor 配置对话框
  void _showCursorConfigDialog(BuildContext context, WidgetRef ref) {
    final apiKeyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('配置 Cursor'),
        content: TextField(
          controller: apiKeyController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'API Key',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              final service = ref.read(integrationServiceProvider);
              await service.configureCursor(apiKeyController.text);
              if (context.mounted) {
                Navigator.of(context).pop();
                ref.invalidate(integrationStatusProvider);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  /// 显示 Claude 配置对话框
  void _showClaudeConfigDialog(BuildContext context, WidgetRef ref) {
    final apiKeyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('配置 Claude'),
        content: TextField(
          controller: apiKeyController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'API Key',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              final service = ref.read(integrationServiceProvider);
              await service.configureClaude(apiKeyController.text);
              if (context.mounted) {
                Navigator.of(context).pop();
                ref.invalidate(integrationStatusProvider);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  /// 同步所有集成
  Future<void> _syncAll(BuildContext context, WidgetRef ref) async {
    final service = ref.read(integrationServiceProvider);
    final result = await service.syncAll('');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('同步完成: GitHub ${result.githubCommits} 条, Cursor ${result.cursorUsage} 条, Claude ${result.claudeUsage} 条')),
      );
    }
  }
}

/// 集成状态 Provider
final integrationStatusProvider = FutureProvider<IntegrationStatus>((ref) async {
  final service = ref.watch(integrationServiceProvider);
  return service.getStatus();
});
