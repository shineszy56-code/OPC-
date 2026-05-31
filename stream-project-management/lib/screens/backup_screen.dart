import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../services/backup_service.dart';

/// 备份服务提供者
final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService();
});

/// 备份与恢复页面
/// 设计文档 5.5.1：BackupScreen
class BackupScreen extends ConsumerWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('备份与恢复',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 本地备份
            const Text('本地备份', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.download, color: Color(0xFF6C63FF)),
                    ),
                    title: const Text('导出到文件'),
                    subtitle: const Text('将项目数据导出为 JSON 文件'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _exportToFile(context, ref),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.upload, color: Color(0xFF4CAF50)),
                    ),
                    title: const Text('从文件恢复'),
                    subtitle: const Text('从 JSON 备份文件恢复数据'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _restoreFromFile(context, ref),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // 加密云备份
            const Text('加密云备份', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5722).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.cloud_upload, color: Color(0xFFFF5722)),
                    ),
                    title: const Text('备份到云端'),
                    subtitle: const Text('端到端加密后上传到 Cloudflare R2'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _backupToCloud(context, ref),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.cloud_download, color: Color(0xFF9C27B0)),
                    ),
                    title: const Text('从云端恢复'),
                    subtitle: const Text('需要密码解密'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _restoreFromCloud(context, ref),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // 本地备份列表
            const Text('本地备份文件', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Expanded(
              child: _buildLocalBackups(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  /// 导出到文件
  Future<void> _exportToFile(BuildContext context, WidgetRef ref) async {
    final service = ref.read(backupServiceProvider);
    final path = await service.exportToPath();
    if (path != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已导出到：$path')),
      );
    }
  }

  /// 从文件恢复
  Future<void> _restoreFromFile(BuildContext context, WidgetRef ref) async {
    final service = ref.read(backupServiceProvider);
    final success = await service.restoreFromPath();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? '恢复成功' : '恢复失败')),
      );
    }
  }

  /// 备份到云端
  Future<void> _backupToCloud(BuildContext context, WidgetRef ref) async {
    final service = ref.read(backupServiceProvider);
    final success = await service.encryptedCloudBackup();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? '云端备份成功' : '云端备份失败')),
      );
    }
  }

  /// 从云端恢复
  Future<void> _restoreFromCloud(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('从云端恢复'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: '请输入备份密码',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isEmpty) return;
              Navigator.of(context).pop();
              final service = ref.read(backupServiceProvider);
              final success = await service.restoreFromCloud(controller.text);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success ? '恢复成功' : '恢复失败')),
                );
              }
            },
            child: const Text('恢复'),
          ),
        ],
      ),
    );
  }

  /// 构建本地备份列表
  Widget _buildLocalBackups(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<FileSystemEntity>>(
      future: ref.read(backupServiceProvider).getLocalBackups(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('暂无本地备份'));
        }
        final files = snapshot.data!;
        return ListView.builder(
          itemCount: files.length,
          itemBuilder: (context, index) {
            final file = files[index] as File;
            final stat = file.statSync();
            final name = file.uri.pathSegments.last;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  '${DateFormat('yyyy-MM-dd HH:mm').format(stat.modified)}\n${stat.size ~/ 1024} KB',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteBackup(context, ref, file.path),
                ),
                onTap: () {
                  // 点击恢复
                },
              ),
            );
          },
        );
      },
    );
  }

  /// 删除备份
  Future<void> _deleteBackup(BuildContext context, WidgetRef ref, String path) async {
    await ref.read(backupServiceProvider).deleteLocalBackup(path);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已删除')),
      );
    }
  }
}
