// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjectMember _$ProjectMemberFromJson(Map<String, dynamic> json) {
  return _ProjectMember.fromJson(json);
}

/// @nodoc
mixin _$ProjectMember {
  /// UUID v4
  String get id => throw _privateConstructorUsedError;

  /// 所属项目 ID
  String get projectId => throw _privateConstructorUsedError;

  /// 成员昵称（本地自定义，不存储在云端）
  String get name => throw _privateConstructorUsedError;

  /// 权限级别
  MemberPermission get permission => throw _privateConstructorUsedError;

  /// 关联的分享记录 ID
  String get shareId => throw _privateConstructorUsedError;

  /// 最后活跃时间
  int get lastActiveAt => throw _privateConstructorUsedError;

  /// 在线状态（本地计算）
  bool get isOnline => throw _privateConstructorUsedError;

  /// 创建时间
  int get createdAt => throw _privateConstructorUsedError;

  /// 更新时间
  int get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProjectMemberCopyWith<ProjectMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectMemberCopyWith<$Res> {
  factory $ProjectMemberCopyWith(
          ProjectMember value, $Res Function(ProjectMember) then) =
      _$ProjectMemberCopyWithImpl<$Res, ProjectMember>;
  @useResult
  $Res call(
      {String id,
      String projectId,
      String name,
      MemberPermission permission,
      String shareId,
      int lastActiveAt,
      bool isOnline,
      int createdAt,
      int updatedAt});
}

/// @nodoc
class _$ProjectMemberCopyWithImpl<$Res, $Val extends ProjectMember>
    implements $ProjectMemberCopyWith<$Res> {
  _$ProjectMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? name = null,
    Object? permission = null,
    Object? shareId = null,
    Object? lastActiveAt = null,
    Object? isOnline = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      permission: null == permission
          ? _value.permission
          : permission // ignore: cast_nullable_to_non_nullable
              as MemberPermission,
      shareId: null == shareId
          ? _value.shareId
          : shareId // ignore: cast_nullable_to_non_nullable
              as String,
      lastActiveAt: null == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as int,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
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
}

/// @nodoc
abstract class _$$ProjectMemberImplCopyWith<$Res>
    implements $ProjectMemberCopyWith<$Res> {
  factory _$$ProjectMemberImplCopyWith(
          _$ProjectMemberImpl value, $Res Function(_$ProjectMemberImpl) then) =
      __$$ProjectMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String projectId,
      String name,
      MemberPermission permission,
      String shareId,
      int lastActiveAt,
      bool isOnline,
      int createdAt,
      int updatedAt});
}

/// @nodoc
class __$$ProjectMemberImplCopyWithImpl<$Res>
    extends _$ProjectMemberCopyWithImpl<$Res, _$ProjectMemberImpl>
    implements _$$ProjectMemberImplCopyWith<$Res> {
  __$$ProjectMemberImplCopyWithImpl(
      _$ProjectMemberImpl _value, $Res Function(_$ProjectMemberImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? name = null,
    Object? permission = null,
    Object? shareId = null,
    Object? lastActiveAt = null,
    Object? isOnline = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ProjectMemberImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      permission: null == permission
          ? _value.permission
          : permission // ignore: cast_nullable_to_non_nullable
              as MemberPermission,
      shareId: null == shareId
          ? _value.shareId
          : shareId // ignore: cast_nullable_to_non_nullable
              as String,
      lastActiveAt: null == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as int,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
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
class _$ProjectMemberImpl implements _ProjectMember {
  const _$ProjectMemberImpl(
      {required this.id,
      required this.projectId,
      required this.name,
      this.permission = MemberPermission.read,
      this.shareId = '',
      required this.lastActiveAt,
      this.isOnline = false,
      required this.createdAt,
      required this.updatedAt});

  factory _$ProjectMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectMemberImplFromJson(json);

  /// UUID v4
  @override
  final String id;

  /// 所属项目 ID
  @override
  final String projectId;

  /// 成员昵称（本地自定义，不存储在云端）
  @override
  final String name;

  /// 权限级别
  @override
  @JsonKey()
  final MemberPermission permission;

  /// 关联的分享记录 ID
  @override
  @JsonKey()
  final String shareId;

  /// 最后活跃时间
  @override
  final int lastActiveAt;

  /// 在线状态（本地计算）
  @override
  @JsonKey()
  final bool isOnline;

  /// 创建时间
  @override
  final int createdAt;

  /// 更新时间
  @override
  final int updatedAt;

  @override
  String toString() {
    return 'ProjectMember(id: $id, projectId: $projectId, name: $name, permission: $permission, shareId: $shareId, lastActiveAt: $lastActiveAt, isOnline: $isOnline, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.permission, permission) ||
                other.permission == permission) &&
            (identical(other.shareId, shareId) || other.shareId == shareId) &&
            (identical(other.lastActiveAt, lastActiveAt) ||
                other.lastActiveAt == lastActiveAt) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, projectId, name, permission,
      shareId, lastActiveAt, isOnline, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectMemberImplCopyWith<_$ProjectMemberImpl> get copyWith =>
      __$$ProjectMemberImplCopyWithImpl<_$ProjectMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectMemberImplToJson(
      this,
    );
  }
}

abstract class _ProjectMember implements ProjectMember {
  const factory _ProjectMember(
      {required final String id,
      required final String projectId,
      required final String name,
      final MemberPermission permission,
      final String shareId,
      required final int lastActiveAt,
      final bool isOnline,
      required final int createdAt,
      required final int updatedAt}) = _$ProjectMemberImpl;

  factory _ProjectMember.fromJson(Map<String, dynamic> json) =
      _$ProjectMemberImpl.fromJson;

  @override

  /// UUID v4
  String get id;
  @override

  /// 所属项目 ID
  String get projectId;
  @override

  /// 成员昵称（本地自定义，不存储在云端）
  String get name;
  @override

  /// 权限级别
  MemberPermission get permission;
  @override

  /// 关联的分享记录 ID
  String get shareId;
  @override

  /// 最后活跃时间
  int get lastActiveAt;
  @override

  /// 在线状态（本地计算）
  bool get isOnline;
  @override

  /// 创建时间
  int get createdAt;
  @override

  /// 更新时间
  int get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ProjectMemberImplCopyWith<_$ProjectMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
