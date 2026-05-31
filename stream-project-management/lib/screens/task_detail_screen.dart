import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/models/enums.dart';
import '../data/models/task.dart';
import '../state/project_state.dart';
import '../state/task_state.dart';
import '../widgets/status_selector.dart';
import '../widgets/priority_selector.dart';

/// 任务详情页
/// 设计文档 5.5.1：TaskScreen
class TaskDetailScreen extends ConsumerWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskDetailProvider(taskId));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('任务详情', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: 导航到编辑页面
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, ref),
          ),
        ],
      ),
      body: taskAsync.when(
        data: (task) => task != null ? _buildBody(context, ref, task) : _buildNotFound(context),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _buildError(context, error),
      ),
    );
  }

  /// 构建主体内容
  Widget _buildBody(BuildContext context, WidgetRef ref, Task task) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 任务标题
          Text(
            task.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // 状态选择器
          StatusSelector(
            currentStatus: task.status,
            onChanged: (newStatus) {
              ref.read(taskNotifierProvider.notifier).updateStatus(taskId, newStatus);
            },
          ),
          const SizedBox(height: 12),
          // 优先级选择器
          PrioritySelector(
            currentPriority: task.priority,
            onChanged: (newPriority) {
              ref.read(taskNotifierProvider.notifier).updatePriority(taskId, newPriority);
            },
          ),
          const SizedBox(height: 12),
          // 任务描述
          if (task.description.isNotEmpty) ...[
            const Text('描述', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(
              task.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
          ],
          // 截止日期
          if (task.dueDate != null) ...[
            const Text('截止日期', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(
              DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(task.dueDate!)),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
          ],
          // 负责人
          if (task.assigneeId != null) ...[
            const Text('负责人', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(
              task.assigneeId!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
          ],
          // AI 状态
          if (task.aiExecutable) ...[
            const Text('AI 状态', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            _buildAIStatus(context, task.aiStatus),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  /// 构建 AI 状态显示
  Widget _buildAIStatus(BuildContext context, AIStatus status) {
    final color = status == AIStatus.completed
        ? const Color(0xFF4CAF50)
        : status == AIStatus.running
            ? const Color(0xFF2196F3)
            : status == AIStatus.failed
                ? const Color(0xFFF44336)
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

    return Row(
      children: [
        Icon(
          status == AIStatus.completed
              ? Icons.check_circle
              : status == AIStatus.running
                  ? Icons.hourglass_empty
                  : status == AIStatus.failed
                      ? Icons.error
                      : Icons.info,
          color: color,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          status == AIStatus.idle
              ? '空闲'
              : status == AIStatus.running
                  ? '运行中'
                  : status == AIStatus.completed
                      ? '已完成'
                      : '失败',
          style: TextStyle(color: color, fontSize: 16),
        ),
      ],
    );
  }

  /// 构建未找到状态
  Widget _buildNotFound(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('😞', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            '任务未找到',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }

  /// 构建错误状态
  Widget _buildError(BuildContext context, Object error) {
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

  /// 显示删除确认对话框
  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这个任务吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              ref.read(taskNotifierProvider.notifier).deleteTask(taskId, ref.read(selectedProjectIdProvider)!);
              Navigator.of(context).pop();
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
