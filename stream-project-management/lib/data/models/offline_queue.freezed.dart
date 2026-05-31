// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offline_queue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OfflineQueueItem _$OfflineQueueItemFromJson(Map<String, dynamic> json) {
  return _OfflineQueueItem.fromJson(json);
}

/// @nodoc
mixin _$OfflineQueueItem {
  /// UUID v4
  String get id => throw _privateConstructorUsedError;

  /// 操作类型：create / update / delete
  String get operationType => throw _privateConstructorUsedError;

  /// 表名
  String get tableName => throw _privateConstructorUsedError;

  /// 记录 ID
  String get recordId => throw _privateConstructorUsedError;

  /// 操作负载（JSON 字符串）
  String get payload => throw _privateConstructorUsedError;

  /// 时间戳（Unix timestamp）
  int get timestamp => throw _privateConstructorUsedError;

  /// 重试次数
  int get retryCount => throw _privateConstructorUsedError;

  /// 状态
  OfflineQueueStatus get status => throw _privateConstructorUsedError;

  /// 错误信息
  String? get errorMessage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OfflineQueueItemCopyWith<OfflineQueueItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OfflineQueueItemCopyWith<$Res> {
  factory $OfflineQueueItemCopyWith(
    OfflineQueueItem value,
    $Res Function(OfflineQueueItem) then,
  ) = _$OfflineQueueItemCopyWithImpl<$Res, OfflineQueueItem>;
  @useResult
  $Res call({
    String id,
    String operationType,
    String tableName,
    String recordId,
    String payload,
    int timestamp,
    int retryCount,
    OfflineQueueStatus status,
    String? errorMessage,
  });
}

/// @nodoc
class _$OfflineQueueItemCopyWithImpl<$Res, $Val extends OfflineQueueItem>
    implements $OfflineQueueItemCopyWith<$Res> {
  _$OfflineQueueItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? operationType = null,
    Object? tableName = null,
    Object? recordId = null,
    Object? payload = null,
    Object? timestamp = null,
    Object? retryCount = null,
    Object? status = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            operationType: null == operationType
                ? _value.operationType
                : operationType // ignore: cast_nullable_to_non_nullable
                      as String,
            tableName: null == tableName
                ? _value.tableName
                : tableName // ignore: cast_nullable_to_non_nullable
                      as String,
            recordId: null == recordId
                ? _value.recordId
                : recordId // ignore: cast_nullable_to_non_nullable
                      as String,
            payload: null == payload
                ? _value.payload
                : payload // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as int,
            retryCount: null == retryCount
                ? _value.retryCount
                : retryCount // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as OfflineQueueStatus,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OfflineQueueItemImplCopyWith<$Res>
    implements $OfflineQueueItemCopyWith<$Res> {
  factory _$$OfflineQueueItemImplCopyWith(
    _$OfflineQueueItemImpl value,
    $Res Function(_$OfflineQueueItemImpl) then,
  ) = __$$OfflineQueueItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String operationType,
    String tableName,
    String recordId,
    String payload,
    int timestamp,
    int retryCount,
    OfflineQueueStatus status,
    String? errorMessage,
  });
}

/// @nodoc
class __$$OfflineQueueItemImplCopyWithImpl<$Res>
    extends _$OfflineQueueItemCopyWithImpl<$Res, _$OfflineQueueItemImpl>
    implements _$$OfflineQueueItemImplCopyWith<$Res> {
  __$$OfflineQueueItemImplCopyWithImpl(
    _$OfflineQueueItemImpl _value,
    $Res Function(_$OfflineQueueItemImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? operationType = null,
    Object? tableName = null,
    Object? recordId = null,
    Object? payload = null,
    Object? timestamp = null,
    Object? retryCount = null,
    Object? status = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$OfflineQueueItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        operationType: null == operationType
            ? _value.operationType
            : operationType // ignore: cast_nullable_to_non_nullable
                  as String,
        tableName: null == tableName
            ? _value.tableName
            : tableName // ignore: cast_nullable_to_non_nullable
                  as String,
        recordId: null == recordId
            ? _value.recordId
            : recordId // ignore: cast_nullable_to_non_nullable
                  as String,
        payload: null == payload
            ? _value.payload
            : payload // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as int,
        retryCount: null == retryCount
            ? _value.retryCount
            : retryCount // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as OfflineQueueStatus,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OfflineQueueItemImpl implements _OfflineQueueItem {
  const _$OfflineQueueItemImpl({
    required this.id,
    required this.operationType,
    required this.tableName,
    required this.recordId,
    required this.payload,
    required this.timestamp,
    this.retryCount = 0,
    this.status = OfflineQueueStatus.pending,
    this.errorMessage,
  });

  factory _$OfflineQueueItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OfflineQueueItemImplFromJson(json);

  /// UUID v4
  @override
  final String id;

  /// 操作类型：create / update / delete
  @override
  final String operationType;

  /// 表名
  @override
  final String tableName;

  /// 记录 ID
  @override
  final String recordId;

  /// 操作负载（JSON 字符串）
  @override
  final String payload;

  /// 时间戳（Unix timestamp）
  @override
  final int timestamp;

  /// 重试次数
  @override
  @JsonKey()
  final int retryCount;

  /// 状态
  @override
  @JsonKey()
  final OfflineQueueStatus status;

  /// 错误信息
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'OfflineQueueItem(id: $id, operationType: $operationType, tableName: $tableName, recordId: $recordId, payload: $payload, timestamp: $timestamp, retryCount: $retryCount, status: $status, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfflineQueueItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.operationType, operationType) ||
                other.operationType == operationType) &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.recordId, recordId) ||
                other.recordId == recordId) &&
            (identical(other.payload, payload) || other.payload == payload) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    operationType,
    tableName,
    recordId,
    payload,
    timestamp,
    retryCount,
    status,
    errorMessage,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OfflineQueueItemImplCopyWith<_$OfflineQueueItemImpl> get copyWith =>
      __$$OfflineQueueItemImplCopyWithImpl<_$OfflineQueueItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OfflineQueueItemImplToJson(this);
  }
}

abstract class _OfflineQueueItem implements OfflineQueueItem {
  const factory _OfflineQueueItem({
    required final String id,
    required final String operationType,
    required final String tableName,
    required final String recordId,
    required final String payload,
    required final int timestamp,
    final int retryCount,
    final OfflineQueueStatus status,
    final String? errorMessage,
  }) = _$OfflineQueueItemImpl;

  factory _OfflineQueueItem.fromJson(Map<String, dynamic> json) =
      _$OfflineQueueItemImpl.fromJson;

  @override
  /// UUID v4
  String get id;
  @override
  /// 操作类型：create / update / delete
  String get operationType;
  @override
  /// 表名
  String get tableName;
  @override
  /// 记录 ID
  String get recordId;
  @override
  /// 操作负载（JSON 字符串）
  String get payload;
  @override
  /// 时间戳（Unix timestamp）
  int get timestamp;
  @override
  /// 重试次数
  int get retryCount;
  @override
  /// 状态
  OfflineQueueStatus get status;
  @override
  /// 错误信息
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$OfflineQueueItemImplCopyWith<_$OfflineQueueItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
