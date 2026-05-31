import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/models/project.dart';
import '../state/ai_state.dart';
import '../state/member_state.dart';
import '../state/project_state.dart';
import '../state/task_state.dart';
import '../widgets/project_card.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'share_screen.dart';
import 'task_detail_screen.dart';

/// 项目详情页
/// 设计文档 5.5.1：ProjectScreen
class ProjectScreen extends ConsumerWidget {
  final String projectId;

  const ProjectScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(selectedProjectProvider);
    final tasksAsync = ref.watch(projectTasksProvider(projectId));
    final membersAsync = ref.watch(projectMembersProvider(projectId));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: projectAsync.when(
          data: (project) => Row(
            children: [
              Text(project?.icon ?? '📁', style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  project?.name ?? '项目详情',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          loading: () => const Text('加载中...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          error: (_, __) => const Text('项目详情', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ShareScreen(projectId: projectId)),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(selectedProjectProvider);
          ref.invalidate(projectTasksProvider(projectId));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 项目进度卡片
                projectAsync.when(
                  data: (project) => project != null
                      ? _buildProgressCard(context, project)
                      : const SizedBox.shrink(),
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 24),
                // 任务列表
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('任务', style: Theme.of(context).textTheme.titleMedium),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AddTaskScreen(projectId: projectId),
                          ),
                        );
                      },
                      child: const Text('+ 添加任务'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                tasksAsync.when(
                  data: (tasks) => tasks.isEmpty
                      ? _buildEmptyTasks(context)
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return TaskCard(
                              task: task,
                              onTap: () {
                                ref.read(selectedTaskIdProvider.notifier).state = task.id;
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => TaskDetailScreen(taskId: task.id),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Text('加载任务失败'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => AddTaskScreen(projectId: projectId)),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// 构建进度卡片
  Widget _buildProgressCard(BuildContext context, Project project) {
    final progress = project.progress;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('项目进度', style: Theme.of(context).textTheme.titleMedium),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建空任务状态
  Widget _buildEmptyTasks(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text('📝', style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text('暂无任务', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text(
            '点击 + 添加任务开始管理',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
