// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OperationLogImpl _$$OperationLogImplFromJson(Map<String, dynamic> json) =>
    _$OperationLogImpl(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      taskId: json['taskId'] as String?,
      memberId: json['memberId'] as String,
      memberName: json['memberName'] as String,
      action: $enumDecode(_$LogActionEnumMap, json['action']),
      field: json['field'] as String?,
      oldValue: json['oldValue'] as String?,
      newValue: json['newValue'] as String?,
      timestamp: (json['timestamp'] as num).toInt(),
      synced: json['synced'] as bool? ?? false,
    );

Map<String, dynamic> _$$OperationLogImplToJson(_$OperationLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'taskId': instance.taskId,
      'memberId': instance.memberId,
      'memberName': instance.memberName,
      'action': _$LogActionEnumMap[instance.action]!,
      'field': instance.field,
      'oldValue': instance.oldValue,
      'newValue': instance.newValue,
      'timestamp': instance.timestamp,
      'synced': instance.synced,
    };

const _$LogActionEnumMap = {
  LogAction.create: 'create',
  LogAction.update: 'update',
  LogAction.delete: 'delete',
  LogAction.statusChange: 'statusChange',
  LogAction.progressChange: 'progressChange',
};
