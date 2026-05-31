// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_workflow.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AIStep _$AIStepFromJson(Map<String, dynamic> json) {
  return _AIStep.fromJson(json);
}

/// @nodoc
mixin _$AIStep {
  /// 步骤 ID
  String get id => throw _privateConstructorUsedError;

  /// 步骤名称
  String get name => throw _privateConstructorUsedError;

  /// 步骤描述
  String get description => throw _privateConstructorUsedError;

  /// 步骤类型
  StepType get type => throw _privateConstructorUsedError;

  /// 提示词模板
  String get promptTemplate => throw _privateConstructorUsedError;

  /// 模型选择（可选，不填则使用路由策略）
  String? get model => throw _privateConstructorUsedError;

  /// 步骤输出是否作为下一步的输入
  bool get passOutput => throw _privateConstructorUsedError;

  /// 超时时间（秒）
  int get timeoutSeconds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AIStepCopyWith<AIStep> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIStepCopyWith<$Res> {
  factory $AIStepCopyWith(AIStep value, $Res Function(AIStep) then) =
      _$AIStepCopyWithImpl<$Res, AIStep>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      StepType type,
      String promptTemplate,
      String? model,
      bool passOutput,
      int timeoutSeconds});
}

/// @nodoc
class _$AIStepCopyWithImpl<$Res, $Val extends AIStep>
    implements $AIStepCopyWith<$Res> {
  _$AIStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? type = null,
    Object? promptTemplate = null,
    Object? model = freezed,
    Object? passOutput = null,
    Object? timeoutSeconds = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StepType,
      promptTemplate: null == promptTemplate
          ? _value.promptTemplate
          : promptTemplate // ignore: cast_nullable_to_non_nullable
              as String,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      passOutput: null == passOutput
          ? _value.passOutput
          : passOutput // ignore: cast_nullable_to_non_nullable
              as bool,
      timeoutSeconds: null == timeoutSeconds
          ? _value.timeoutSeconds
          : timeoutSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIStepImplCopyWith<$Res> implements $AIStepCopyWith<$Res> {
  factory _$$AIStepImplCopyWith(
          _$AIStepImpl value, $Res Function(_$AIStepImpl) then) =
      __$$AIStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      StepType type,
      String promptTemplate,
      String? model,
      bool passOutput,
      int timeoutSeconds});
}

/// @nodoc
class __$$AIStepImplCopyWithImpl<$Res>
    extends _$AIStepCopyWithImpl<$Res, _$AIStepImpl>
    implements _$$AIStepImplCopyWith<$Res> {
  __$$AIStepImplCopyWithImpl(
      _$AIStepImpl _value, $Res Function(_$AIStepImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? type = null,
    Object? promptTemplate = null,
    Object? model = freezed,
    Object? passOutput = null,
    Object? timeoutSeconds = null,
  }) {
    return _then(_$AIStepImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StepType,
      promptTemplate: null == promptTemplate
          ? _value.promptTemplate
          : promptTemplate // ignore: cast_nullable_to_non_nullable
              as String,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      passOutput: null == passOutput
          ? _value.passOutput
          : passOutput // ignore: cast_nullable_to_non_nullable
              as bool,
      timeoutSeconds: null == timeoutSeconds
          ? _value.timeoutSeconds
          : timeoutSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AIStepImpl implements _AIStep {
  const _$AIStepImpl(
      {required this.id,
      required this.name,
      this.description = '',
      this.type = StepType.prompt,
      this.promptTemplate = '',
      this.model,
      this.passOutput = true,
      this.timeoutSeconds = 60});

  factory _$AIStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIStepImplFromJson(json);

  /// 步骤 ID
  @override
  final String id;

  /// 步骤名称
  @override
  final String name;

  /// 步骤描述
  @override
  @JsonKey()
  final String description;

  /// 步骤类型
  @override
  @JsonKey()
  final StepType type;

  /// 提示词模板
  @override
  @JsonKey()
  final String promptTemplate;

  /// 模型选择（可选，不填则使用路由策略）
  @override
  final String? model;

  /// 步骤输出是否作为下一步的输入
  @override
  @JsonKey()
  final bool passOutput;

  /// 超时时间（秒）
  @override
  @JsonKey()
  final int timeoutSeconds;

  @override
  String toString() {
    return 'AIStep(id: $id, name: $name, description: $description, type: $type, promptTemplate: $promptTemplate, model: $model, passOutput: $passOutput, timeoutSeconds: $timeoutSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIStepImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.promptTemplate, promptTemplate) ||
                other.promptTemplate == promptTemplate) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.passOutput, passOutput) ||
                other.passOutput == passOutput) &&
            (identical(other.timeoutSeconds, timeoutSeconds) ||
                other.timeoutSeconds == timeoutSeconds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, type,
      promptTemplate, model, passOutput, timeoutSeconds);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AIStepImplCopyWith<_$AIStepImpl> get copyWith =>
      __$$AIStepImplCopyWithImpl<_$AIStepImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIStepImplToJson(
      this,
    );
  }
}

abstract class _AIStep implements AIStep {
  const factory _AIStep(
      {required final String id,
      required final String name,
      final String description,
      final StepType type,
      final String promptTemplate,
      final String? model,
      final bool passOutput,
      final int timeoutSeconds}) = _$AIStepImpl;

  factory _AIStep.fromJson(Map<String, dynamic> json) = _$AIStepImpl.fromJson;

  @override

  /// 步骤 ID
  String get id;
  @override

  /// 步骤名称
  String get name;
  @override

  /// 步骤描述
  String get description;
  @override

  /// 步骤类型
  StepType get type;
  @override

  /// 提示词模板
  String get promptTemplate;
  @override

  /// 模型选择（可选，不填则使用路由策略）
  String? get model;
  @override

  /// 步骤输出是否作为下一步的输入
  bool get passOutput;
  @override

  /// 超时时间（秒）
  int get timeoutSeconds;
  @override
  @JsonKey(ignore: true)
  _$$AIStepImplCopyWith<_$AIStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkflowTrigger _$WorkflowTriggerFromJson(Map<String, dynamic> json) {
  return _WorkflowTrigger.fromJson(json);
}

/// @nodoc
mixin _$WorkflowTrigger {
  /// 触发类型
  WorkflowTriggerType get type => throw _privateConstructorUsedError;

  /// 触发条件表达式
  String? get condition => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkflowTriggerCopyWith<WorkflowTrigger> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowTriggerCopyWith<$Res> {
  factory $WorkflowTriggerCopyWith(
          WorkflowTrigger value, $Res Function(WorkflowTrigger) then) =
      _$WorkflowTriggerCopyWithImpl<$Res, WorkflowTrigger>;
  @useResult
  $Res call({WorkflowTriggerType type, String? condition});
}

/// @nodoc
class _$WorkflowTriggerCopyWithImpl<$Res, $Val extends WorkflowTrigger>
    implements $WorkflowTriggerCopyWith<$Res> {
  _$WorkflowTriggerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? condition = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as WorkflowTriggerType,
      condition: freezed == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowTriggerImplCopyWith<$Res>
    implements $WorkflowTriggerCopyWith<$Res> {
  factory _$$WorkflowTriggerImplCopyWith(_$WorkflowTriggerImpl value,
          $Res Function(_$WorkflowTriggerImpl) then) =
      __$$WorkflowTriggerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({WorkflowTriggerType type, String? condition});
}

/// @nodoc
class __$$WorkflowTriggerImplCopyWithImpl<$Res>
    extends _$WorkflowTriggerCopyWithImpl<$Res, _$WorkflowTriggerImpl>
    implements _$$WorkflowTriggerImplCopyWith<$Res> {
  __$$WorkflowTriggerImplCopyWithImpl(
      _$WorkflowTriggerImpl _value, $Res Function(_$WorkflowTriggerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? condition = freezed,
  }) {
    return _then(_$WorkflowTriggerImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as WorkflowTriggerType,
      condition: freezed == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowTriggerImpl implements _WorkflowTrigger {
  const _$WorkflowTriggerImpl({required this.type, this.condition});

  factory _$WorkflowTriggerImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowTriggerImplFromJson(json);

  /// 触发类型
  @override
  final WorkflowTriggerType type;

  /// 触发条件表达式
  @override
  final String? condition;

  @override
  String toString() {
    return 'WorkflowTrigger(type: $type, condition: $condition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowTriggerImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.condition, condition) ||
                other.condition == condition));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, condition);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowTriggerImplCopyWith<_$WorkflowTriggerImpl> get copyWith =>
      __$$WorkflowTriggerImplCopyWithImpl<_$WorkflowTriggerImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowTriggerImplToJson(
      this,
    );
  }
}

abstract class _WorkflowTrigger implements WorkflowTrigger {
  const factory _WorkflowTrigger(
      {required final WorkflowTriggerType type,
      final String? condition}) = _$WorkflowTriggerImpl;

  factory _WorkflowTrigger.fromJson(Map<String, dynamic> json) =
      _$WorkflowTriggerImpl.fromJson;

  @override

  /// 触发类型
  WorkflowTriggerType get type;
  @override

  /// 触发条件表达式
  String? get condition;
  @override
  @JsonKey(ignore: true)
  _$$WorkflowTriggerImplCopyWith<_$WorkflowTriggerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AIWorkflow _$AIWorkflowFromJson(Map<String, dynamic> json) {
  return _AIWorkflow.fromJson(json);
}

/// @nodoc
mixin _$AIWorkflow {
  /// UUID v4
  String get id => throw _privateConstructorUsedError;

  /// 工作流名称
  String get name => throw _privateConstructorUsedError;

  /// 工作流描述
  String get description => throw _privateConstructorUsedError;

  /// 触发条件
  WorkflowTrigger get trigger => throw _privateConstructorUsedError;

  /// 工作流步骤列表
  List<AIStep> get steps => throw _privateConstructorUsedError;

  /// 是否启用
  bool get enabled => throw _privateConstructorUsedError;

  /// 创建时间
  int get createdAt => throw _privateConstructorUsedError;

  /// 更新时间
  int get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AIWorkflowCopyWith<AIWorkflow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIWorkflowCopyWith<$Res> {
  factory $AIWorkflowCopyWith(
          AIWorkflow value, $Res Function(AIWorkflow) then) =
      _$AIWorkflowCopyWithImpl<$Res, AIWorkflow>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      WorkflowTrigger trigger,
      List<AIStep> steps,
      bool enabled,
      int createdAt,
      int updatedAt});

  $WorkflowTriggerCopyWith<$Res> get trigger;
}

/// @nodoc
class _$AIWorkflowCopyWithImpl<$Res, $Val extends AIWorkflow>
    implements $AIWorkflowCopyWith<$Res> {
  _$AIWorkflowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? trigger = null,
    Object? steps = null,
    Object? enabled = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      trigger: null == trigger
          ? _value.trigger
          : trigger // ignore: cast_nullable_to_non_nullable
              as WorkflowTrigger,
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<AIStep>,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $WorkflowTriggerCopyWith<$Res> get trigger {
    return $WorkflowTriggerCopyWith<$Res>(_value.trigger, (value) {
      return _then(_value.copyWith(trigger: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AIWorkflowImplCopyWith<$Res>
    implements $AIWorkflowCopyWith<$Res> {
  factory _$$AIWorkflowImplCopyWith(
          _$AIWorkflowImpl value, $Res Function(_$AIWorkflowImpl) then) =
      __$$AIWorkflowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      WorkflowTrigger trigger,
      List<AIStep> steps,
      bool enabled,
      int createdAt,
      int updatedAt});

  @override
  $WorkflowTriggerCopyWith<$Res> get trigger;
}

/// @nodoc
class __$$AIWorkflowImplCopyWithImpl<$Res>
    extends _$AIWorkflowCopyWithImpl<$Res, _$AIWorkflowImpl>
    implements _$$AIWorkflowImplCopyWith<$Res> {
  __$$AIWorkflowImplCopyWithImpl(
      _$AIWorkflowImpl _value, $Res Function(_$AIWorkflowImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? trigger = null,
    Object? steps = null,
    Object? enabled = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$AIWorkflowImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      trigger: null == trigger
          ? _value.trigger
          : trigger // ignore: cast_nullable_to_non_nullable
              as WorkflowTrigger,
      steps: null == steps
          ? _value._steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<AIStep>,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AIWorkflowImpl implements _AIWorkflow {
  const _$AIWorkflowImpl(
      {required this.id,
      required this.name,
      this.description = '',
      required this.trigger,
      final List<AIStep> steps = const [],
      this.enabled = true,
      required this.createdAt,
      required this.updatedAt})
      : _steps = steps;

  factory _$AIWorkflowImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIWorkflowImplFromJson(json);

  /// UUID v4
  @override
  final String id;

  /// 工作流名称
  @override
  final String name;

  /// 工作流描述
  @override
  @JsonKey()
  final String description;

  /// 触发条件
  @override
  final WorkflowTrigger trigger;

  /// 工作流步骤列表
  final List<AIStep> _steps;

  /// 工作流步骤列表
  @override
  @JsonKey()
  List<AIStep> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  /// 是否启用
  @override
  @JsonKey()
  final bool enabled;

  /// 创建时间
  @override
  final int createdAt;

  /// 更新时间
  @override
  final int updatedAt;

  @override
  String toString() {
    return 'AIWorkflow(id: $id, name: $name, description: $description, trigger: $trigger, steps: $steps, enabled: $enabled, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIWorkflowImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.trigger, trigger) || other.trigger == trigger) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      trigger,
      const DeepCollectionEquality().hash(_steps),
      enabled,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AIWorkflowImplCopyWith<_$AIWorkflowImpl> get copyWith =>
      __$$AIWorkflowImplCopyWithImpl<_$AIWorkflowImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIWorkflowImplToJson(
      this,
    );
  }
}

abstract class _AIWorkflow implements AIWorkflow {
  const factory _AIWorkflow(
      {required final String id,
      required final String name,
      final String description,
      required final WorkflowTrigger trigger,
      final List<AIStep> steps,
      final bool enabled,
      required final int createdAt,
      required final int updatedAt}) = _$AIWorkflowImpl;

  factory _AIWorkflow.fromJson(Map<String, dynamic> json) =
      _$AIWorkflowImpl.fromJson;

  @override

  /// UUID v4
  String get id;
  @override

  /// 工作流名称
  String get name;
  @override

  /// 工作流描述
  String get description;
  @override

  /// 触发条件
  WorkflowTrigger get trigger;
  @override

  /// 工作流步骤列表
  List<AIStep> get steps;
  @override

  /// 是否启用
  bool get enabled;
  @override

  /// 创建时间
  int get createdAt;
  @override

  /// 更新时间
  int get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$AIWorkflowImplCopyWith<_$AIWorkflowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
