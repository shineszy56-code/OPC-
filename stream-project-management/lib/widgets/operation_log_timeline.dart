import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/enums.dart';
import '../data/models/operation_log.dart';
import '../services/operation_log_service.dart';

/// 操作日志时间线组件
/// 设计文档 UI 组件：OperationLogTimeline
class OperationLogTimeline extends StatelessWidget {
  final List<OperationLog> logs;
  final int? maxItems;

  const OperationLogTimeline({
    super.key,
    required this.logs,
    this.maxItems,
  });

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return _buildEmptyState(context);
    }

    final displayLogs = maxItems != null && logs.length > maxItems!
        ? logs.sublist(0, maxItems!)
        : logs;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayLogs.length,
      itemBuilder: (context, index) {
        final log = displayLogs[index];
        final showDateHeader = index == 0 ||
            !_isSameDay(
              DateTime.fromMillisecondsSinceEpoch(log.timestamp),
              DateTime.fromMillisecondsSinceEpoch(
                displayLogs[index - 1].timestamp,
              ),
            );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDateHeader) ...[
              if (index > 0) const SizedBox(height: 16),
              _buildDateHeader(context, log.timestamp),
              const SizedBox(height: 8),
            ],
            _buildLogItem(context, log),
            if (index < displayLogs.length - 1) const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '📝',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '暂无操作日志',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// 构建日期分隔符
  Widget _buildDateHeader(BuildContext context, int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final isToday = _isSameDay(date, now);
    final isYesterday = _isSameDay(
      date,
      now.subtract(const Duration(days: 1)),
    );

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
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ) ??
            TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
      ),
    );
  }

  /// 构建日志条目
  Widget _buildLogItem(BuildContext context, OperationLog log) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 时间线圆点
        Column(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _getActionColor(log.action),
                shape: BoxShape.circle,
              ),
            ),
            if (log != logs.last) ...[
              Container(
                width: 2,
                height: 40,
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              ),
            ],
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
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: ' ${log.actionText}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              // 详细信息
              if (log.field != null) ...[
                Text(
                  '${log.field}: ${log.newValue ?? '无'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 2),
              // 时间
              Text(
                _formatTime(log.timestamp),
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 获取操作类型颜色
  Color _getActionColor(LogAction action) {
    switch (action) {
      case LogAction.create:
        return const Color(0xFF4CAF50); // 绿色
      case LogAction.update:
        return const Color(0xFF2196F3); // 蓝色
      case LogAction.delete:
        return const Color(0xFFF44336); // 红色
      case LogAction.statusChange:
        return const Color(0xFFFFC107); // 黄色
      case LogAction.progressChange:
        return const Color(0xFF6C63FF); // 主色
    }
    return const Color(0xFF9E9E9E); // 默认灰色
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
}
