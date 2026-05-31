import 'package:flutter/material.dart';
import '../data/models/offline_queue.dart';
import '../services/sync_service.dart';

/// 同步状态徽章组件
/// 设计文档 UI 组件：SyncStatusBadge
class SyncStatusBadge extends StatelessWidget {
  final SyncStatus status;
  final int? pendingCount;

  const SyncStatusBadge({super.key, required this.status, this.pendingCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor().withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: _getStatusColor(),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            _getStatusText(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: _getStatusColor(),
            ),
          ),
          if (status == SyncStatus.pending && pendingCount != null) ...[
            const SizedBox(width: 2),
            Text(
              '($pendingCount)',
              style: TextStyle(fontSize: 9, color: _getStatusColor()),
            ),
          ],
        ],
      ),
    );
  }

  /// 获取状态颜色
  Color _getStatusColor() {
    switch (status) {
      case SyncStatus.synced:
        return const Color(0xFF4CAF50); // 绿色
      case SyncStatus.pending:
        return const Color(0xFFFFC107); // 黄色
      case SyncStatus.inProgress:
        return const Color(0xFF2196F3); // 蓝色
      case SyncStatus.failed:
        return const Color(0xFFF44336); // 红色
      case SyncStatus.offline:
        return const Color(0xFF9E9E9E); // 灰色
    }
  }

  /// 获取状态文本
  String _getStatusText() {
    switch (status) {
      case SyncStatus.synced:
        return '已同步';
      case SyncStatus.pending:
        return '待同步';
      case SyncStatus.inProgress:
        return '同步中';
      case SyncStatus.failed:
        return '失败';
      case SyncStatus.offline:
        return '离线';
    }
  }
}
