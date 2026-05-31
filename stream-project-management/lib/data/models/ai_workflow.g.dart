// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_workflow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIStepImpl _$$AIStepImplFromJson(Map<String, dynamic> json) => _$AIStepImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String? ?? '',
  type: $enumDecodeNullable(_$StepTypeEnumMap, json['type']) ?? StepType.prompt,
  promptTemplate: json['promptTemplate'] as String? ?? '',
  model: json['model'] as String?,
  passOutput: json['passOutput'] as bool? ?? true,
  timeoutSeconds: (json['timeoutSeconds'] as num?)?.toInt() ?? 60,
);

Map<String, dynamic> _$$AIStepImplToJson(_$AIStepImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$StepTypeEnumMap[instance.type]!,
      'promptTemplate': instance.promptTemplate,
      'model': instance.model,
      'passOutput': instance.passOutput,
      'timeoutSeconds': instance.timeoutSeconds,
    };

const _$StepTypeEnumMap = {
  StepType.prompt: 'prompt',
  StepType.condition: 'condition',
  StepType.loop: 'loop',
  StepType.parallel: 'parallel',
};

_$WorkflowTriggerImpl _$$WorkflowTriggerImplFromJson(
  Map<String, dynamic> json,
) => _$WorkflowTriggerImpl(
  type: $enumDecode(_$WorkflowTriggerTypeEnumMap, json['type']),
  condition: json['condition'] as String?,
);

Map<String, dynamic> _$$WorkflowTriggerImplToJson(
  _$WorkflowTriggerImpl instance,
) => <String, dynamic>{
  'type': _$WorkflowTriggerTypeEnumMap[instance.type]!,
  'condition': instance.condition,
};

const _$WorkflowTriggerTypeEnumMap = {
  WorkflowTriggerType.manual: 'manual',
  WorkflowTriggerType.taskCreated: 'taskCreated',
  WorkflowTriggerType.taskStatusChanged: 'taskStatusChanged',
  WorkflowTriggerType.schedule: 'schedule',
};

_$AIWorkflowImpl _$$AIWorkflowImplFromJson(Map<String, dynamic> json) =>
    _$AIWorkflowImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      trigger: WorkflowTrigger.fromJson(
        json['trigger'] as Map<String, dynamic>,
      ),
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map((e) => AIStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      enabled: json['enabled'] as bool? ?? true,
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
    );

Map<String, dynamic> _$$AIWorkflowImplToJson(_$AIWorkflowImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'trigger': instance.trigger,
      'steps': instance.steps,
      'enabled': instance.enabled,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
