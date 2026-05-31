import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/ai_workflow.dart';
import '../state/ai_state.dart';
import '../state/project_state.dart';

/// AI 中心页面
/// 设计文档 5.5.1：AICenterScreen
class AICenterScreen extends ConsumerWidget {
  const AICenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiState = ref.watch(aiStateNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'AI 中心',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI 快速操作
            Text('快速操作', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _buildQuickActionCard(
              context,
              icon: Icons.psychology,
              title: '拆解任务',
              description: 'AI 自动将任务拆解为子任务',
              color: const Color(0xFF6C63FF),
              onTap: () => _showTaskBreakdownDialog(context, ref),
            ),
            const SizedBox(height: 8),
            _buildQuickActionCard(
              context,
              icon: Icons.summarize,
              title: '生成总结',
              description: 'AI 生成项目进度总结报告',
              color: const Color(0xFF4CAF50),
              onTap: () => _generateSummary(context, ref),
            ),
            const SizedBox(height: 8),
            _buildQuickActionCard(
              context,
              icon: Icons.schedule,
              title: '排期预测',
              description: 'AI 预测任务完成时间',
              color: const Color(0xFFFFC107),
              onTap: () {},
            ),
            const SizedBox(height: 24),
            // AI 工作流
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('AI 工作流', style: Theme.of(context).textTheme.titleMedium),
                TextButton(onPressed: () {}, child: const Text('管理')),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildWorkflowList(context, ref, aiState)),
          ],
        ),
      ),
    );
  }

  /// 构建快速操作卡片
  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建工作流列表
  Widget _buildWorkflowList(
    BuildContext context,
    WidgetRef ref,
    AIState aiState,
  ) {
    // TODO: 从 AI 服务获取工作流列表
    final workflows = <AIWorkflow>[];

    if (workflows.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🤖', style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text('暂无工作流', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: workflows.length,
      itemBuilder: (context, index) {
        final workflow = workflows[index];
        return _buildWorkflowCard(context, workflow);
      },
    );
  }

  /// 构建工作流卡片
  Widget _buildWorkflowCard(BuildContext context, AIWorkflow workflow) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        value: workflow.enabled,
        onChanged: (value) {
          // TODO: 启用/禁用工作流
        },
        title: Text(
          workflow.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          workflow.description,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        activeColor: const Color(0xFF6C63FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// 显示任务拆解对话框
  void _showTaskBreakdownDialog(BuildContext context, WidgetRef ref) {
    final taskTitleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI 任务拆解'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: taskTitleController,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                labelText: '任务标题',
                labelStyle: const TextStyle(fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
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
            onPressed: () {
              final title = taskTitleController.text.trim();
              if (title.isNotEmpty) {
                ref
                    .read(aiStateNotifierProvider.notifier)
                    .executeBreakdown(title);
                Navigator.of(context).pop();
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('拆解', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// 生成项目总结
  void _generateSummary(BuildContext context, WidgetRef ref) {
    final projectId = ref.read(selectedProjectIdProvider);
    if (projectId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先选择一个项目')));
      return;
    }

    ref.read(aiStateNotifierProvider.notifier).executeProjectSummary(projectId);
  }
}
