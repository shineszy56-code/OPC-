import 'package:flutter/material.dart';
import '../data/models/enums.dart';

/// 任务状态选择器
/// 设计文档 UI 组件：StatusSelector（4个大按钮）
class StatusSelector extends StatelessWidget {
  final TaskStatus currentStatus;
  final ValueChanged<TaskStatus>? onChanged;

  const StatusSelector({
    super.key,
    required this.currentStatus,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '任务状态',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          children: TaskStatus.values.map((status) {
            final isSelected = status == currentStatus;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _StatusButton(
                  status: status,
                  isSelected: isSelected,
                  onTap: () => onChanged?.call(status),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// 状态按钮
class _StatusButton extends StatelessWidget {
  final TaskStatus status;
  final bool isSelected;
  final VoidCallback? onTap;

  const _StatusButton({
    super.key,
    required this.status,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? color
                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(_getStatusIcon(status), color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              _getStatusText(status),
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 获取状态颜色
  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return const Color(0xFF9E9E9E);
      case TaskStatus.inProgress:
        return const Color(0xFF2196F3);
      case TaskStatus.done:
        return const Color(0xFF4CAF50);
      case TaskStatus.blocked:
        return const Color(0xFFF44336);
    }
  }

  /// 获取状态图标
  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return Icons.radio_button_unchecked;
      case TaskStatus.inProgress:
        return Icons.hourglass_empty;
      case TaskStatus.done:
        return Icons.check_circle;
      case TaskStatus.blocked:
        return Icons.error;
    }
  }

  /// 获取状态文本
  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return '待办';
      case TaskStatus.inProgress:
        return '进行中';
      case TaskStatus.done:
        return '已完成';
      case TaskStatus.blocked:
        return '已阻塞';
    }
  }
}
