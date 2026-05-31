import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'operation_log.freezed.dart';
part 'operation_log.g.dart';

/// 操作日志模型
/// 对应设计文档 interface OperationLog
@freezed
class OperationLog with _$OperationLog {
  const factory OperationLog({
    /// UUID v4
    required String id,

    /// 所属项目 ID
    required String projectId,

    /// 关联任务 ID（可选）
    String? taskId,

    /// 操作人 ID
    required String memberId,

    /// 操作人昵称
    required String memberName,

    /// 操作类型
    required LogAction action,

    /// 修改的字段
    String? field,

    /// 旧值
    String? oldValue,

    /// 新值
    String? newValue,

    /// 时间戳（Unix timestamp）
    required int timestamp,

    /// 是否已同步到其他成员
    @Default(false) bool synced,
  }) = _OperationLog;

  factory OperationLog.fromJson(Map<String, dynamic> json) =>
      _$OperationLogFromJson(json);
}

/// OperationLog 扩展方法
extension OperationLogX on OperationLog {
  /// 操作类型显示文本
  String get actionText {
    switch (action) {
      case LogAction.create:
        return '创建';
      case LogAction.update:
        return '更新';
      case LogAction.delete:
        return '删除';
      case LogAction.statusChange:
        return '状态变更';
      case LogAction.progressChange:
        return '进度变更';
    }
  }

  /// 格式化的时间字符串
  String get timeText {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)} '
        '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  /// 操作描述
  String get description {
    final buffer = StringBuffer();
    buffer.write(memberName);
    buffer.write(actionText);

    if (field != null && oldValue != null && newValue != null) {
      buffer.write(' $field: $oldValue → $newValue');
    } else if (field != null && newValue != null) {
      buffer.write(' $field 为 $newValue');
    }

    return buffer.toString();
  }
}
