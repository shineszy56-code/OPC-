import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/models/enums.dart';
import '../data/models/operation_log.dart';
import '../services/operation_log_service.dart';
import '../state/project_state.dart';

/// 操作日志页面
/// 设计文档 5.5.1：OperationLogScreen
class OperationLogScreen extends ConsumerWidget {
  final String projectId;

  const OperationLogScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(projectLogsProvider(projectId));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          '操作日志',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: logsAsync.when(
        data: (logs) => _buildTimeline(context, logs),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _buildError(context, error),
      ),
    );
  }

  /// 构建时间线
  Widget _buildTimeline(BuildContext context, List<OperationLog> logs) {
    if (logs.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final showDateHeader =
            index == 0 ||
            !_isSameDay(
              DateTime.fromMillisecondsSinceEpoch(log.timestamp),
              DateTime.fromMillisecondsSinceEpoch(logs[index - 1].timestamp),
            );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDateHeader) ...[
              if (index > 0) const SizedBox(height: 16),
              _buildDateHeader(context, log.timestamp),
              const SizedBox(height: 8),
            ],
            _buildLogTile(context, log),
          ],
        );
      },
    );
  }

  /// 构建日期分隔符
  Widget _buildDateHeader(BuildContext context, int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final isToday = _isSameDay(date, now);
    final isYesterday = _isSameDay(date, now.subtract(const Duration(days: 1)));

    String dateText;
    if (isToday) {
      dateText = '今天';
    } else if (isYesterday) {
      dateText = '昨天';
    } else {
      dateText = DateFormat('MM月dd日').format(date);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        dateText,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
        ),
      ),
    );
  }

  /// 构建日志条目
  Widget _buildLogTile(BuildContext context, OperationLog log) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 时间线圆点
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _getActionColor(context, log.action),
                  shape: BoxShape.circle,
                ),
              ),
              if (log != null)
                Container(
                  width: 2,
                  height: 40,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // 日志内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 操作人 + 动作
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: log.memberName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: ' ${log.actionText}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ],
                  ),
                ),
                if (log.field != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${log.field}: ${log.newValue ?? '无'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.onBackground.withOpacity(0.6),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  _formatTime(log.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).colorScheme.onBackground.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📝', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text('暂无操作日志', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            '项目操作记录将显示在这里',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onBackground.withOpacity(0.6),
            ),
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
          Text('加载失败', style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }

  /// 格式化时间
  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('HH:mm').format(date);
  }

  /// 判断是否是同一天
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// 获取操作类型颜色
  Color _getActionColor(BuildContext context, LogAction action) {
    switch (action) {
      case LogAction.create:
        return const Color(0xFF4CAF50);
      case LogAction.update:
        return const Color(0xFF2196F3);
      case LogAction.delete:
        return const Color(0xFFF44336);
      case LogAction.statusChange:
        return const Color(0xFFFFC107);
      case LogAction.progressChange:
        return const Color(0xFF6C63FF);
    }
  }
}

/// 项目操作日志 Provider
final projectLogsProvider = FutureProvider.family<List<OperationLog>, String>((
  ref,
  projectId,
) async {
  final service = OperationLogService();
  return service.getTimeline(projectId);
});
