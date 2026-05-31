// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShareRecordImpl _$$ShareRecordImplFromJson(Map<String, dynamic> json) =>
    _$ShareRecordImpl(
      id: json['id'] as String,
      projectId: json['projectId'] as String?,
      taskId: json['taskId'] as String?,
      type:
          $enumDecodeNullable(_$ShareTypeEnumMap, json['type']) ??
          ShareType.cloudflare,
      permission:
          $enumDecodeNullable(_$MemberPermissionEnumMap, json['permission']) ??
          MemberPermission.read,
      expiresAt: (json['expiresAt'] as num).toInt(),
      cloudflareKey: json['cloudflareKey'] as String?,
      peerId: json['peerId'] as String?,
      createdAt: (json['createdAt'] as num).toInt(),
    );

Map<String, dynamic> _$$ShareRecordImplToJson(_$ShareRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'taskId': instance.taskId,
      'type': _$ShareTypeEnumMap[instance.type]!,
      'permission': _$MemberPermissionEnumMap[instance.permission]!,
      'expiresAt': instance.expiresAt,
      'cloudflareKey': instance.cloudflareKey,
      'peerId': instance.peerId,
      'createdAt': instance.createdAt,
    };

const _$ShareTypeEnumMap = {
  ShareType.cloudflare: 'cloudflare',
  ShareType.p2p: 'p2p',
};

const _$MemberPermissionEnumMap = {
  MemberPermission.read: 'read',
  MemberPermission.comment: 'comment',
  MemberPermission.edit: 'edit',
  MemberPermission.admin: 'admin',
};
