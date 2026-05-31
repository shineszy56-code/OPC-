// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectImpl _$$ProjectImplFromJson(Map<String, dynamic> json) =>
    _$ProjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? '📁',
      description: json['description'] as String? ?? '',
      status:
          $enumDecodeNullable(_$ProjectStatusEnumMap, json['status']) ??
          ProjectStatus.active,
      startDate: (json['startDate'] as num).toInt(),
      endDate: (json['endDate'] as num).toInt(),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      aiPrompt: json['aiPrompt'] as String? ?? '',
      ownerId: json['ownerId'] as String,
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
    );

Map<String, dynamic> _$$ProjectImplToJson(_$ProjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'description': instance.description,
      'status': _$ProjectStatusEnumMap[instance.status]!,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'progress': instance.progress,
      'aiPrompt': instance.aiPrompt,
      'ownerId': instance.ownerId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

const _$ProjectStatusEnumMap = {
  ProjectStatus.active: 'active',
  ProjectStatus.completed: 'completed',
  ProjectStatus.archived: 'archived',
};
