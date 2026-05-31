// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttachmentImpl _$$AttachmentImplFromJson(Map<String, dynamic> json) =>
    _$AttachmentImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      mimeType: json['mimeType'] as String,
      size: (json['size'] as num).toInt(),
      uploadedAt: (json['uploadedAt'] as num).toInt(),
    );

Map<String, dynamic> _$$AttachmentImplToJson(_$AttachmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
      'mimeType': instance.mimeType,
      'size': instance.size,
      'uploadedAt': instance.uploadedAt,
    };

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
  id: json['id'] as String,
  projectId: json['projectId'] as String,
  parentId: json['parentId'] as String?,
  title: json['title'] as String,
  description: json['description'] as String? ?? '',
  status:
      $enumDecodeNullable(_$TaskStatusEnumMap, json['status']) ??
      TaskStatus.todo,
  priority:
      $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']) ??
      TaskPriority.medium,
  dueDate: (json['dueDate'] as num?)?.toInt(),
  assigneeId: json['assigneeId'] as String?,
  aiExecutable: json['aiExecutable'] as bool? ?? false,
  aiStatus:
      $enumDecodeNullable(_$AIStatusEnumMap, json['aiStatus']) ?? AIStatus.idle,
  aiResult: json['aiResult'] as String?,
  attachments:
      (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: (json['createdAt'] as num).toInt(),
  updatedAt: (json['updatedAt'] as num).toInt(),
  lastModifiedBy: json['lastModifiedBy'] as String? ?? '',
);

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'parentId': instance.parentId,
      'title': instance.title,
      'description': instance.description,
      'status': _$TaskStatusEnumMap[instance.status]!,
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'dueDate': instance.dueDate,
      'assigneeId': instance.assigneeId,
      'aiExecutable': instance.aiExecutable,
      'aiStatus': _$AIStatusEnumMap[instance.aiStatus]!,
      'aiResult': instance.aiResult,
      'attachments': instance.attachments,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'lastModifiedBy': instance.lastModifiedBy,
    };

const _$TaskStatusEnumMap = {
  TaskStatus.todo: 'todo',
  TaskStatus.inProgress: 'inProgress',
  TaskStatus.done: 'done',
  TaskStatus.blocked: 'blocked',
};

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'low',
  TaskPriority.medium: 'medium',
  TaskPriority.high: 'high',
};

const _$AIStatusEnumMap = {
  AIStatus.idle: 'idle',
  AIStatus.running: 'running',
  AIStatus.completed: 'completed',
  AIStatus.failed: 'failed',
};
