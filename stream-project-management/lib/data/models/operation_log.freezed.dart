// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'operation_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OperationLog _$OperationLogFromJson(Map<String, dynamic> json) {
  return _OperationLog.fromJson(json);
}

/// @nodoc
mixin _$OperationLog {
  /// UUID v4
  String get id => throw _privateConstructorUsedError;

  /// 所属项目 ID
  String get projectId => throw _privateConstructorUsedError;

  /// 关联任务 ID（可选）
  String? get taskId => throw _privateConstructorUsedError;

  /// 操作人 ID
  String get memberId => throw _privateConstructorUsedError;

  /// 操作人昵称
  String get memberName => throw _privateConstructorUsedError;

  /// 操作类型
  LogAction get action => throw _privateConstructorUsedError;

  /// 修改的字段
  String? get field => throw _privateConstructorUsedError;

  /// 旧值
  String? get oldValue => throw _privateConstructorUsedError;

  /// 新值
  String? get newValue => throw _privateConstructorUsedError;

  /// 时间戳（Unix timestamp）
  int get timestamp => throw _privateConstructorUsedError;

  /// 是否已同步到其他成员
  bool get synced => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OperationLogCopyWith<OperationLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OperationLogCopyWith<$Res> {
  factory $OperationLogCopyWith(
          OperationLog value, $Res Function(OperationLog) then) =
      _$OperationLogCopyWithImpl<$Res, OperationLog>;
  @useResult
  $Res call(
      {String id,
      String projectId,
      String? taskId,
      String memberId,
      String memberName,
      LogAction action,
      String? field,
      String? oldValue,
      String? newValue,
      int timestamp,
      bool synced});
}

/// @nodoc
class _$OperationLogCopyWithImpl<$Res, $Val extends OperationLog>
    implements $OperationLogCopyWith<$Res> {
  _$OperationLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? taskId = freezed,
    Object? memberId = null,
    Object? memberName = null,
    Object? action = null,
    Object? field = freezed,
    Object? oldValue = freezed,
    Object? newValue = freezed,
    Object? timestamp = null,
    Object? synced = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String?,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      memberName: null == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as LogAction,
      field: freezed == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String?,
      oldValue: freezed == oldValue
          ? _value.oldValue
          : oldValue // ignore: cast_nullable_to_non_nullable
              as String?,
      newValue: freezed == newValue
          ? _value.newValue
          : newValue // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      synced: null == synced
          ? _value.synced
          : synced // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OperationLogImplCopyWith<$Res>
    implements $OperationLogCopyWith<$Res> {
  factory _$$OperationLogImplCopyWith(
          _$OperationLogImpl value, $Res Function(_$OperationLogImpl) then) =
      __$$OperationLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String projectId,
      String? taskId,
      String memberId,
      String memberName,
      LogAction action,
      String? field,
      String? oldValue,
      String? newValue,
      int timestamp,
      bool synced});
}

/// @nodoc
class __$$OperationLogImplCopyWithImpl<$Res>
    extends _$OperationLogCopyWithImpl<$Res, _$OperationLogImpl>
    implements _$$OperationLogImplCopyWith<$Res> {
  __$$OperationLogImplCopyWithImpl(
      _$OperationLogImpl _value, $Res Function(_$OperationLogImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? taskId = freezed,
    Object? memberId = null,
    Object? memberName = null,
    Object? action = null,
    Object? field = freezed,
    Object? oldValue = freezed,
    Object? newValue = freezed,
    Object? timestamp = null,
    Object? synced = null,
  }) {
    return _then(_$OperationLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String?,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      memberName: null == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as LogAction,
      field: freezed == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String?,
      oldValue: freezed == oldValue
          ? _value.oldValue
          : oldValue // ignore: cast_nullable_to_non_nullable
              as String?,
      newValue: freezed == newValue
          ? _value.newValue
          : newValue // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      synced: null == synced
          ? _value.synced
          : synced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OperationLogImpl implements _OperationLog {
  const _$OperationLogImpl(
      {required this.id,
      required this.projectId,
      this.taskId,
      required this.memberId,
      required this.memberName,
      required this.action,
      this.field,
      this.oldValue,
      this.newValue,
      required this.timestamp,
      this.synced = false});

  factory _$OperationLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$OperationLogImplFromJson(json);

  /// UUID v4
  @override
  final String id;

  /// 所属项目 ID
  @override
  final String projectId;

  /// 关联任务 ID（可选）
  @override
  final String? taskId;

  /// 操作人 ID
  @override
  final String memberId;

  /// 操作人昵称
  @override
  final String memberName;

  /// 操作类型
  @override
  final LogAction action;

  /// 修改的字段
  @override
  final String? field;

  /// 旧值
  @override
  final String? oldValue;

  /// 新值
  @override
  final String? newValue;

  /// 时间戳（Unix timestamp）
  @override
  final int timestamp;

  /// 是否已同步到其他成员
  @override
  @JsonKey()
  final bool synced;

  @override
  String toString() {
    return 'OperationLog(id: $id, projectId: $projectId, taskId: $taskId, memberId: $memberId, memberName: $memberName, action: $action, field: $field, oldValue: $oldValue, newValue: $newValue, timestamp: $timestamp, synced: $synced)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OperationLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.memberName, memberName) ||
                other.memberName == memberName) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.oldValue, oldValue) ||
                other.oldValue == oldValue) &&
            (identical(other.newValue, newValue) ||
                other.newValue == newValue) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.synced, synced) || other.synced == synced));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, projectId, taskId, memberId,
      memberName, action, field, oldValue, newValue, timestamp, synced);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OperationLogImplCopyWith<_$OperationLogImpl> get copyWith =>
      __$$OperationLogImplCopyWithImpl<_$OperationLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OperationLogImplToJson(
      this,
    );
  }
}

abstract class _OperationLog implements OperationLog {
  const factory _OperationLog(
      {required final String id,
      required final String projectId,
      final String? taskId,
      required final String memberId,
      required final String memberName,
      required final LogAction action,
      final String? field,
      final String? oldValue,
      final String? newValue,
      required final int timestamp,
      final bool synced}) = _$OperationLogImpl;

  factory _OperationLog.fromJson(Map<String, dynamic> json) =
      _$OperationLogImpl.fromJson;

  @override

  /// UUID v4
  String get id;
  @override

  /// 所属项目 ID
  String get projectId;
  @override

  /// 关联任务 ID（可选）
  String? get taskId;
  @override

  /// 操作人 ID
  String get memberId;
  @override

  /// 操作人昵称
  String get memberName;
  @override

  /// 操作类型
  LogAction get action;
  @override

  /// 修改的字段
  String? get field;
  @override

  /// 旧值
  String? get oldValue;
  @override

  /// 新值
  String? get newValue;
  @override

  /// 时间戳（Unix timestamp）
  int get timestamp;
  @override

  /// 是否已同步到其他成员
  bool get synced;
  @override
  @JsonKey(ignore: true)
  _$$OperationLogImplCopyWith<_$OperationLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
