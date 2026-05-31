// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_queue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OfflineQueueItemImpl _$$OfflineQueueItemImplFromJson(
  Map<String, dynamic> json,
) => _$OfflineQueueItemImpl(
  id: json['id'] as String,
  operationType: json['operationType'] as String,
  tableName: json['tableName'] as String,
  recordId: json['recordId'] as String,
  payload: json['payload'] as String,
  timestamp: (json['timestamp'] as num).toInt(),
  retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
  status:
      $enumDecodeNullable(_$OfflineQueueStatusEnumMap, json['status']) ??
      OfflineQueueStatus.pending,
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$$OfflineQueueItemImplToJson(
  _$OfflineQueueItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'operationType': instance.operationType,
  'tableName': instance.tableName,
  'recordId': instance.recordId,
  'payload': instance.payload,
  'timestamp': instance.timestamp,
  'retryCount': instance.retryCount,
  'status': _$OfflineQueueStatusEnumMap[instance.status]!,
  'errorMessage': instance.errorMessage,
};

const _$OfflineQueueStatusEnumMap = {
  OfflineQueueStatus.pending: 'pending',
  OfflineQueueStatus.synced: 'synced',
  OfflineQueueStatus.failed: 'failed',
};
