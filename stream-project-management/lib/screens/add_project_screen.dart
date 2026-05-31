import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../state/project_state.dart';

/// 添加项目页面
class AddProjectScreen extends ConsumerWidget {
  const AddProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();
    var selectedIcon = '📁';
    var selectedDate = DateTime.now();

    final icons = [
      '📁',
      '📊',
      '🚀',
      '🎯',
      '💡',
      '🔧',
      '📱',
      '💻',
      '🎨',
      '📝'
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('新建项目', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图标选择
            const Text('选择图标', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: icons.map((icon) {
                final isSelected = icon == selectedIcon;
                return GestureDetector(
                  onTap: () {
                    selectedIcon = icon;
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF6C63FF).withOpacity(0.1)
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF6C63FF)
                            : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    child: Center(child: Text(icon, style: const TextStyle(fontSize: 24))),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            // 项目名称
            TextField(
              controller: nameController,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                labelText: '项目名称',
                labelStyle: const TextStyle(fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
            const SizedBox(height: 16),
            // 项目描述
            TextField(
              controller: descController,
              style: const TextStyle(fontSize: 18),
              maxLines: 3,
              decoration: InputDecoration(
                labelText: '项目描述（可选）',
                labelStyle: const TextStyle(fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
            const SizedBox(height: 16),
            // 开始日期
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: startDateController,
                    style: const TextStyle(fontSize: 18),
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        selectedDate = date;
                        startDateController.text = DateFormat('yyyy-MM-dd').format(date);
                      }
                    },
                    decoration: InputDecoration(
                      labelText: '开始日期',
                      labelStyle: const TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: endDateController,
                    style: const TextStyle(fontSize: 18),
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate.add(const Duration(days: 30)),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        endDateController.text = DateFormat('yyyy-MM-dd').format(date);
                      }
                    },
                    decoration: InputDecoration(
                      labelText: '结束日期',
                      labelStyle: const TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () async {
            if (nameController.text.isEmpty) return;

            final startDate = startDateController.text.isNotEmpty
                ? DateFormat('yyyy-MM-dd').parse(startDateController.text)
                : DateTime.now();
            final endDate = endDateController.text.isNotEmpty
                ? DateFormat('yyyy-MM-dd').parse(endDateController.text)
                : DateTime.now().add(const Duration(days: 30));

            await ref.read(projectNotifierProvider.notifier).createProject(
                  name: nameController.text,
                  icon: selectedIcon,
                  description: descController.text,
                  startDate: startDate,
                  endDate: endDate,
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
          child: const Text('创建项目', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
        ),
      ),
    );
  }
}
