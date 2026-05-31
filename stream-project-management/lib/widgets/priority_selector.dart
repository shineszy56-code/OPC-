import 'package:flutter/material.dart';

import '../data/models/enums.dart';

/// 任务优先级选择器
/// 设计文档 UI 组件：PrioritySelector（3 个按钮）
class PrioritySelector extends StatelessWidget {
  final TaskPriority currentPriority;
  final ValueChanged<TaskPriority>? onChanged;

  const PrioritySelector({
    super.key,
    required this.currentPriority,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '优先级',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          children: TaskPriority.values.map((priority) {
            final isSelected = priority == currentPriority;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _PriorityButton(
                  priority: priority,
                  isSelected: isSelected,
                  onTap: () => onChanged?.call(priority),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// 优先级按钮
class _PriorityButton extends StatelessWidget {
  final TaskPriority priority;
  final bool isSelected;
  final VoidCallback? onTap;

  const _PriorityButton({
    super.key,
    required this.priority,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getPriorityColor(priority);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Center(
          child: Text(
            _getPriorityText(priority),
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? color : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }

  /// 获取优先级颜色
  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return const Color(0xFF4CAF50);
      case TaskPriority.medium:
        return const Color(0xFFFFC107);
      case TaskPriority.high:
        return const Color(0xFFF44336);
    }
  }

  /// 获取优先级文本
  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return '低';
      case TaskPriority.medium:
        return '中';
      case TaskPriority.high:
        return '高';
    }
  }
}
