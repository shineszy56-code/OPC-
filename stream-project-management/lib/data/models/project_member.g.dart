// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectMemberImpl _$$ProjectMemberImplFromJson(Map<String, dynamic> json) =>
    _$ProjectMemberImpl(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      name: json['name'] as String,
      permission:
          $enumDecodeNullable(_$MemberPermissionEnumMap, json['permission']) ??
              MemberPermission.read,
      shareId: json['shareId'] as String? ?? '',
      lastActiveAt: (json['lastActiveAt'] as num).toInt(),
      isOnline: json['isOnline'] as bool? ?? false,
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
    );

Map<String, dynamic> _$$ProjectMemberImplToJson(_$ProjectMemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'name': instance.name,
      'permission': _$MemberPermissionEnumMap[instance.permission]!,
      'shareId': instance.shareId,
      'lastActiveAt': instance.lastActiveAt,
      'isOnline': instance.isOnline,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

const _$MemberPermissionEnumMap = {
  MemberPermission.read: 'read',
  MemberPermission.comment: 'comment',
  MemberPermission.edit: 'edit',
  MemberPermission.admin: 'admin',
};
