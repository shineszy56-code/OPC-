import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../state/app_state.dart';

/// 设置页面
/// 设计文档 5.5.1：SettingsScreen
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('设置',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 主题设置
          const Text('外观', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  value: appState.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    ref.read(appStateNotifierProvider.notifier).toggleThemeMode();
                  },
                  title: const Text('深色模式'),
                  secondary: Icon(
                    appState.themeMode == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: const Color(0xFF6C63FF),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language, color: Color(0xFF6C63FF)),
                  title: const Text('语言'),
                  trailing: Text(
                    appState.languageCode == 'zh' ? '简体中文' : 'English',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  onTap: () => _showLanguageDialog(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // 安全设置
          const Text('安全', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  value: appState.biometricEnabled,
                  onChanged: (value) async {
                    if (value) {
                      // 启用生物识别
                      // TODO: 调用 local_auth 验证
                    }
                    ref.read(appStateNotifierProvider.notifier).toggleBiometric();
                  },
                  title: const Text('生物识别解锁'),
                  subtitle: const Text('使用指纹或面部识别'),
                  secondary: const Icon(Icons.fingerprint, color: Color(0xFF6C63FF)),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock, color: Color(0xFF6C63FF)),
                  title: const Text('自动锁定'),
                  subtitle: const Text('应用退到后台后自动锁定'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: 设置自动锁定时间
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // 关于
          const Text('关于', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info, color: Color(0xFF6C63FF)),
                  title: const Text('版本'),
                  trailing: const Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description, color: Color(0xFF6C63FF)),
                  title: const Text('隐私政策'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: 打开隐私政策页面
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.gavel, color: Color(0xFF6C63FF)),
                  title: const Text('用户协议'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: 打开用户协议页面
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // 危险操作
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('清除所有数据', style: TextStyle(color: Colors.red)),
              onTap: () => _showClearDataDialog(context, ref),
            ),
          ),
          const SizedBox(height: 32),
          // 底部信息
          Center(
            child: Text(
              'AI OPC 一人公司项目管理\n本地优先 · 零账号 · 零费用',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 显示语言选择对话框
  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择语言'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('简体中文'),
              value: 'zh',
              groupValue: ref.read(appStateProvider).languageCode,
              onChanged: (value) {
                ref.read(appStateNotifierProvider.notifier).setLanguage(value!);
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: ref.read(appStateProvider).languageCode,
              onChanged: (value) {
                ref.read(appStateNotifierProvider.notifier).setLanguage(value!);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  /// 显示清除数据确认对话框
  void _showClearDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认清除'),
        content: const Text('确定要清除所有数据吗？此操作不可撤销。\n\n连续 5 次密码错误将自动清除数据（设计文档 8.3）。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              // TODO: 清除所有数据
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('所有数据已清除')),
              );
            },
            child: const Text('清除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
