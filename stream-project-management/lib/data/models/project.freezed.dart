// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Project _$ProjectFromJson(Map<String, dynamic> json) {
  return _Project.fromJson(json);
}

/// @nodoc
mixin _$Project {
  /// UUID v4
  String get id => throw _privateConstructorUsedError;

  /// 项目名称
  String get name => throw _privateConstructorUsedError;

  /// emoji 图标字符
  String get icon => throw _privateConstructorUsedError;

  /// 项目描述
  String get description => throw _privateConstructorUsedError;

  /// 项目状态
  ProjectStatus get status => throw _privateConstructorUsedError;

  /// 开始日期（Unix timestamp）
  int get startDate => throw _privateConstructorUsedError;

  /// 结束日期（Unix timestamp）
  int get endDate => throw _privateConstructorUsedError;

  /// 进度 0-100，自动计算
  double get progress => throw _privateConstructorUsedError;

  /// 项目级 AI 指令
  String get aiPrompt => throw _privateConstructorUsedError;

  /// 项目创建者 ID
  String get ownerId => throw _privateConstructorUsedError;

  /// 创建时间
  int get createdAt => throw _privateConstructorUsedError;

  /// 更新时间
  int get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProjectCopyWith<Project> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectCopyWith<$Res> {
  factory $ProjectCopyWith(Project value, $Res Function(Project) then) =
      _$ProjectCopyWithImpl<$Res, Project>;
  @useResult
  $Res call({
    String id,
    String name,
    String icon,
    String description,
    ProjectStatus status,
    int startDate,
    int endDate,
    double progress,
    String aiPrompt,
    String ownerId,
    int createdAt,
    int updatedAt,
  });
}

/// @nodoc
class _$ProjectCopyWithImpl<$Res, $Val extends Project>
    implements $ProjectCopyWith<$Res> {
  _$ProjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = null,
    Object? description = null,
    Object? status = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? progress = null,
    Object? aiPrompt = null,
    Object? ownerId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ProjectStatus,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as int,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as int,
            progress: null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as double,
            aiPrompt: null == aiPrompt
                ? _value.aiPrompt
                : aiPrompt // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as int,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProjectImplCopyWith<$Res> implements $ProjectCopyWith<$Res> {
  factory _$$ProjectImplCopyWith(
    _$ProjectImpl value,
    $Res Function(_$ProjectImpl) then,
  ) = __$$ProjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String icon,
    String description,
    ProjectStatus status,
    int startDate,
    int endDate,
    double progress,
    String aiPrompt,
    String ownerId,
    int createdAt,
    int updatedAt,
  });
}

/// @nodoc
class __$$ProjectImplCopyWithImpl<$Res>
    extends _$ProjectCopyWithImpl<$Res, _$ProjectImpl>
    implements _$$ProjectImplCopyWith<$Res> {
  __$$ProjectImplCopyWithImpl(
    _$ProjectImpl _value,
    $Res Function(_$ProjectImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = null,
    Object? description = null,
    Object? status = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? progress = null,
    Object? aiPrompt = null,
    Object? ownerId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ProjectImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ProjectStatus,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as int,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as int,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
        aiPrompt: null == aiPrompt
            ? _value.aiPrompt
            : aiPrompt // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as int,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectImpl implements _Project {
  const _$ProjectImpl({
    required this.id,
    required this.name,
    this.icon = '📁',
    this.description = '',
    this.status = ProjectStatus.active,
    required this.startDate,
    required this.endDate,
    this.progress = 0.0,
    this.aiPrompt = '',
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$ProjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectImplFromJson(json);

  /// UUID v4
  @override
  final String id;

  /// 项目名称
  @override
  final String name;

  /// emoji 图标字符
  @override
  @JsonKey()
  final String icon;

  /// 项目描述
  @override
  @JsonKey()
  final String description;

  /// 项目状态
  @override
  @JsonKey()
  final ProjectStatus status;

  /// 开始日期（Unix timestamp）
  @override
  final int startDate;

  /// 结束日期（Unix timestamp）
  @override
  final int endDate;

  /// 进度 0-100，自动计算
  @override
  @JsonKey()
  final double progress;

  /// 项目级 AI 指令
  @override
  @JsonKey()
  final String aiPrompt;

  /// 项目创建者 ID
  @override
  final String ownerId;

  /// 创建时间
  @override
  final int createdAt;

  /// 更新时间
  @override
  final int updatedAt;

  @override
  String toString() {
    return 'Project(id: $id, name: $name, icon: $icon, description: $description, status: $status, startDate: $startDate, endDate: $endDate, progress: $progress, aiPrompt: $aiPrompt, ownerId: $ownerId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.aiPrompt, aiPrompt) ||
                other.aiPrompt == aiPrompt) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
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
    icon,
    description,
    status,
    startDate,
    endDate,
    progress,
    aiPrompt,
    ownerId,
    createdAt,
    updatedAt,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectImplCopyWith<_$ProjectImpl> get copyWith =>
      __$$ProjectImplCopyWithImpl<_$ProjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectImplToJson(this);
  }
}

abstract class _Project implements Project {
  const factory _Project({
    required final String id,
    required final String name,
    final String icon,
    final String description,
    final ProjectStatus status,
    required final int startDate,
    required final int endDate,
    final double progress,
    final String aiPrompt,
    required final String ownerId,
    required final int createdAt,
    required final int updatedAt,
  }) = _$ProjectImpl;

  factory _Project.fromJson(Map<String, dynamic> json) = _$ProjectImpl.fromJson;

  @override
  /// UUID v4
  String get id;
  @override
  /// 项目名称
  String get name;
  @override
  /// emoji 图标字符
  String get icon;
  @override
  /// 项目描述
  String get description;
  @override
  /// 项目状态
  ProjectStatus get status;
  @override
  /// 开始日期（Unix timestamp）
  int get startDate;
  @override
  /// 结束日期（Unix timestamp）
  int get endDate;
  @override
  /// 进度 0-100，自动计算
  double get progress;
  @override
  /// 项目级 AI 指令
  String get aiPrompt;
  @override
  /// 项目创建者 ID
  String get ownerId;
  @override
  /// 创建时间
  int get createdAt;
  @override
  /// 更新时间
  int get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ProjectImplCopyWith<_$ProjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
