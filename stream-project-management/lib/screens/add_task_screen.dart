import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/models/enums.dart';
import '../data/models/task.dart';
import '../state/ai_state.dart';
import '../state/task_state.dart';

/// 添加任务页面
class AddTaskScreen extends ConsumerWidget {
  final String projectId;

  const AddTaskScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    DateTime? dueDate;
    var selectedPriority = TaskPriority.medium;
    var aiExecutable = false;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          '新建任务',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 任务标题
              TextField(
                controller: titleController,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: '任务标题 *',
                  labelStyle: const TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
              ),
              const SizedBox(height: 16),
              // 任务描述
              TextField(
                controller: descController,
                style: const TextStyle(fontSize: 18),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: '任务描述（可选）',
                  labelStyle: const TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
              ),
              const SizedBox(height: 16),
              // 优先级选择
              const Text(
                '优先级',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildPriorityChip(
                    context,
                    '低',
                    TaskPriority.low,
                    selectedPriority,
                    (p) => selectedPriority = p,
                  ),
                  const SizedBox(width: 8),
                  _buildPriorityChip(
                    context,
                    '中',
                    TaskPriority.medium,
                    selectedPriority,
                    (p) => selectedPriority = p,
                  ),
                  const SizedBox(width: 8),
                  _buildPriorityChip(
                    context,
                    '高',
                    TaskPriority.high,
                    selectedPriority,
                    (p) => selectedPriority = p,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 截止日期
              Row(
                children: [
                  Expanded(
                    child: StatefulBuilder(
                      builder: (context, setState) => InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(
                              const Duration(days: 7),
                            ),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (date != null) {
                            setState(() => dueDate = date);
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: '截止日期（可选）',
                            labelStyle: const TextStyle(fontSize: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                          ),
                          child: Text(
                            dueDate != null
                                ? DateFormat('yyyy-MM-dd').format(dueDate!)
                                : '请选择',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // AI 可执行
              Row(
                children: [
                  Checkbox(
                    value: aiExecutable,
                    onChanged: (value) {
                      aiExecutable = value ?? false;
                    },
                  ),
                  const Text('允许 AI 自动执行', style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () async {
            if (titleController.text.isEmpty) return;

            final taskService = ref.read(taskServiceProvider);
            await taskService.createTask(
              projectId: projectId,
              title: titleController.text,
              description: descController.text,
              priority: selectedPriority,
              dueDate: dueDate,
              aiExecutable: aiExecutable,
            );

            if (context.mounted) {
              Navigator.of(context).pop(true);
            }
          },
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF6C63FF),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            '创建任务',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建优先级选择 Chip
  Widget _buildPriorityChip(
    BuildContext context,
    String label,
    TaskPriority priority,
    TaskPriority selectedPriority,
    Function(TaskPriority) onChanged,
  ) {
    final isSelected = selectedPriority == priority;
    final color = priority == TaskPriority.high
        ? const Color(0xFFF44336)
        : priority == TaskPriority.medium
        ? const Color(0xFFFFC107)
        : const Color(0xFF4CAF50);

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onChanged(priority),
      selectedColor: color.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected
            ? color
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        fontSize: 14,
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
