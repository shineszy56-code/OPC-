// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'share_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShareRecord _$ShareRecordFromJson(Map<String, dynamic> json) {
  return _ShareRecord.fromJson(json);
}

/// @nodoc
mixin _$ShareRecord {
  /// UUID v4
  String get id => throw _privateConstructorUsedError;

  /// 关联项目 ID
  String? get projectId => throw _privateConstructorUsedError;

  /// 关联任务 ID
  String? get taskId => throw _privateConstructorUsedError;

  /// 分享类型
  ShareType get type => throw _privateConstructorUsedError;

  /// 权限级别
  MemberPermission get permission => throw _privateConstructorUsedError;

  /// 过期时间（Unix timestamp）
  int get expiresAt => throw _privateConstructorUsedError;

  /// Cloudflare KV 中的键
  String? get cloudflareKey => throw _privateConstructorUsedError;

  /// P2P 连接 ID
  String? get peerId => throw _privateConstructorUsedError;

  /// 创建时间
  int get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShareRecordCopyWith<ShareRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShareRecordCopyWith<$Res> {
  factory $ShareRecordCopyWith(
          ShareRecord value, $Res Function(ShareRecord) then) =
      _$ShareRecordCopyWithImpl<$Res, ShareRecord>;
  @useResult
  $Res call(
      {String id,
      String? projectId,
      String? taskId,
      ShareType type,
      MemberPermission permission,
      int expiresAt,
      String? cloudflareKey,
      String? peerId,
      int createdAt});
}

/// @nodoc
class _$ShareRecordCopyWithImpl<$Res, $Val extends ShareRecord>
    implements $ShareRecordCopyWith<$Res> {
  _$ShareRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = freezed,
    Object? taskId = freezed,
    Object? type = null,
    Object? permission = null,
    Object? expiresAt = null,
    Object? cloudflareKey = freezed,
    Object? peerId = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String?,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ShareType,
      permission: null == permission
          ? _value.permission
          : permission // ignore: cast_nullable_to_non_nullable
              as MemberPermission,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as int,
      cloudflareKey: freezed == cloudflareKey
          ? _value.cloudflareKey
          : cloudflareKey // ignore: cast_nullable_to_non_nullable
              as String?,
      peerId: freezed == peerId
          ? _value.peerId
          : peerId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShareRecordImplCopyWith<$Res>
    implements $ShareRecordCopyWith<$Res> {
  factory _$$ShareRecordImplCopyWith(
          _$ShareRecordImpl value, $Res Function(_$ShareRecordImpl) then) =
      __$$ShareRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? projectId,
      String? taskId,
      ShareType type,
      MemberPermission permission,
      int expiresAt,
      String? cloudflareKey,
      String? peerId,
      int createdAt});
}

/// @nodoc
class __$$ShareRecordImplCopyWithImpl<$Res>
    extends _$ShareRecordCopyWithImpl<$Res, _$ShareRecordImpl>
    implements _$$ShareRecordImplCopyWith<$Res> {
  __$$ShareRecordImplCopyWithImpl(
      _$ShareRecordImpl _value, $Res Function(_$ShareRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = freezed,
    Object? taskId = freezed,
    Object? type = null,
    Object? permission = null,
    Object? expiresAt = null,
    Object? cloudflareKey = freezed,
    Object? peerId = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$ShareRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String?,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ShareType,
      permission: null == permission
          ? _value.permission
          : permission // ignore: cast_nullable_to_non_nullable
              as MemberPermission,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as int,
      cloudflareKey: freezed == cloudflareKey
          ? _value.cloudflareKey
          : cloudflareKey // ignore: cast_nullable_to_non_nullable
              as String?,
      peerId: freezed == peerId
          ? _value.peerId
          : peerId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShareRecordImpl implements _ShareRecord {
  const _$ShareRecordImpl(
      {required this.id,
      this.projectId,
      this.taskId,
      this.type = ShareType.cloudflare,
      this.permission = MemberPermission.read,
      required this.expiresAt,
      this.cloudflareKey,
      this.peerId,
      required this.createdAt});

  factory _$ShareRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShareRecordImplFromJson(json);

  /// UUID v4
  @override
  final String id;

  /// 关联项目 ID
  @override
  final String? projectId;

  /// 关联任务 ID
  @override
  final String? taskId;

  /// 分享类型
  @override
  @JsonKey()
  final ShareType type;

  /// 权限级别
  @override
  @JsonKey()
  final MemberPermission permission;

  /// 过期时间（Unix timestamp）
  @override
  final int expiresAt;

  /// Cloudflare KV 中的键
  @override
  final String? cloudflareKey;

  /// P2P 连接 ID
  @override
  final String? peerId;

  /// 创建时间
  @override
  final int createdAt;

  @override
  String toString() {
    return 'ShareRecord(id: $id, projectId: $projectId, taskId: $taskId, type: $type, permission: $permission, expiresAt: $expiresAt, cloudflareKey: $cloudflareKey, peerId: $peerId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShareRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.permission, permission) ||
                other.permission == permission) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.cloudflareKey, cloudflareKey) ||
                other.cloudflareKey == cloudflareKey) &&
            (identical(other.peerId, peerId) || other.peerId == peerId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, projectId, taskId, type,
      permission, expiresAt, cloudflareKey, peerId, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShareRecordImplCopyWith<_$ShareRecordImpl> get copyWith =>
      __$$ShareRecordImplCopyWithImpl<_$ShareRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShareRecordImplToJson(
      this,
    );
  }
}

abstract class _ShareRecord implements ShareRecord {
  const factory _ShareRecord(
      {required final String id,
      final String? projectId,
      final String? taskId,
      final ShareType type,
      final MemberPermission permission,
      required final int expiresAt,
      final String? cloudflareKey,
      final String? peerId,
      required final int createdAt}) = _$ShareRecordImpl;

  factory _ShareRecord.fromJson(Map<String, dynamic> json) =
      _$ShareRecordImpl.fromJson;

  @override

  /// UUID v4
  String get id;
  @override

  /// 关联项目 ID
  String? get projectId;
  @override

  /// 关联任务 ID
  String? get taskId;
  @override

  /// 分享类型
  ShareType get type;
  @override

  /// 权限级别
  MemberPermission get permission;
  @override

  /// 过期时间（Unix timestamp）
  int get expiresAt;
  @override

  /// Cloudflare KV 中的键
  String? get cloudflareKey;
  @override

  /// P2P 连接 ID
  String? get peerId;
  @override

  /// 创建时间
  int get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ShareRecordImplCopyWith<_$ShareRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
