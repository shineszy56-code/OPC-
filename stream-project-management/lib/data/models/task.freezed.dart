// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Attachment _$AttachmentFromJson(Map<String, dynamic> json) {
  return _Attachment.fromJson(json);
}

/// @nodoc
mixin _$Attachment {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get mimeType => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  int get uploadedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AttachmentCopyWith<Attachment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttachmentCopyWith<$Res> {
  factory $AttachmentCopyWith(
          Attachment value, $Res Function(Attachment) then) =
      _$AttachmentCopyWithImpl<$Res, Attachment>;
  @useResult
  $Res call(
      {String id,
      String name,
      String url,
      String mimeType,
      int size,
      int uploadedAt});
}

/// @nodoc
class _$AttachmentCopyWithImpl<$Res, $Val extends Attachment>
    implements $AttachmentCopyWith<$Res> {
  _$AttachmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? url = null,
    Object? mimeType = null,
    Object? size = null,
    Object? uploadedAt = null,
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
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      uploadedAt: null == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AttachmentImplCopyWith<$Res>
    implements $AttachmentCopyWith<$Res> {
  factory _$$AttachmentImplCopyWith(
          _$AttachmentImpl value, $Res Function(_$AttachmentImpl) then) =
      __$$AttachmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String url,
      String mimeType,
      int size,
      int uploadedAt});
}

/// @nodoc
class __$$AttachmentImplCopyWithImpl<$Res>
    extends _$AttachmentCopyWithImpl<$Res, _$AttachmentImpl>
    implements _$$AttachmentImplCopyWith<$Res> {
  __$$AttachmentImplCopyWithImpl(
      _$AttachmentImpl _value, $Res Function(_$AttachmentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? url = null,
    Object? mimeType = null,
    Object? size = null,
    Object? uploadedAt = null,
  }) {
    return _then(_$AttachmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      uploadedAt: null == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AttachmentImpl implements _Attachment {
  const _$AttachmentImpl(
      {required this.id,
      required this.name,
      required this.url,
      required this.mimeType,
      required this.size,
      required this.uploadedAt});

  factory _$AttachmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttachmentImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String url;
  @override
  final String mimeType;
  @override
  final int size;
  @override
  final int uploadedAt;

  @override
  String toString() {
    return 'Attachment(id: $id, name: $name, url: $url, mimeType: $mimeType, size: $size, uploadedAt: $uploadedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttachmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.uploadedAt, uploadedAt) ||
                other.uploadedAt == uploadedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, url, mimeType, size, uploadedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AttachmentImplCopyWith<_$AttachmentImpl> get copyWith =>
      __$$AttachmentImplCopyWithImpl<_$AttachmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttachmentImplToJson(
      this,
    );
  }
}

abstract class _Attachment implements Attachment {
  const factory _Attachment(
      {required final String id,
      required final String name,
      required final String url,
      required final String mimeType,
      required final int size,
      required final int uploadedAt}) = _$AttachmentImpl;

  factory _Attachment.fromJson(Map<String, dynamic> json) =
      _$AttachmentImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get url;
  @override
  String get mimeType;
  @override
  int get size;
  @override
  int get uploadedAt;
  @override
  @JsonKey(ignore: true)
  _$$AttachmentImplCopyWith<_$AttachmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Task _$TaskFromJson(Map<String, dynamic> json) {
  return _Task.fromJson(json);
}

/// @nodoc
mixin _$Task {
  /// UUID v4
  String get id => throw _privateConstructorUsedError;

  /// 所属项目 ID
  String get projectId => throw _privateConstructorUsedError;

  /// 父任务 ID（子任务）
  String? get parentId => throw _privateConstructorUsedError;

  /// 任务标题
  String get title => throw _privateConstructorUsedError;

  /// 任务描述
  String get description => throw _privateConstructorUsedError;

  /// 任务状态
  TaskStatus get status => throw _privateConstructorUsedError;

  /// 优先级
  TaskPriority get priority => throw _privateConstructorUsedError;

  /// 截止日期（Unix timestamp）
  int? get dueDate => throw _privateConstructorUsedError;

  /// 负责人 ID
  String? get assigneeId => throw _privateConstructorUsedError;

  /// 是否可由 AI 自动执行
  bool get aiExecutable => throw _privateConstructorUsedError;

  /// AI 执行状态
  AIStatus get aiStatus => throw _privateConstructorUsedError;

  /// AI 生成结果 JSON
  String? get aiResult => throw _privateConstructorUsedError;

  /// 附件列表
  List<Attachment> get attachments => throw _privateConstructorUsedError;

  /// 创建时间
  int get createdAt => throw _privateConstructorUsedError;

  /// 更新时间
  int get updatedAt => throw _privateConstructorUsedError;

  /// 最后修改人 ID
  String get lastModifiedBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res, Task>;
  @useResult
  $Res call(
      {String id,
      String projectId,
      String? parentId,
      String title,
      String description,
      TaskStatus status,
      TaskPriority priority,
      int? dueDate,
      String? assigneeId,
      bool aiExecutable,
      AIStatus aiStatus,
      String? aiResult,
      List<Attachment> attachments,
      int createdAt,
      int updatedAt,
      String lastModifiedBy});
}

/// @nodoc
class _$TaskCopyWithImpl<$Res, $Val extends Task>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? parentId = freezed,
    Object? title = null,
    Object? description = null,
    Object? status = null,
    Object? priority = null,
    Object? dueDate = freezed,
    Object? assigneeId = freezed,
    Object? aiExecutable = null,
    Object? aiStatus = null,
    Object? aiResult = freezed,
    Object? attachments = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastModifiedBy = null,
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
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as int?,
      assigneeId: freezed == assigneeId
          ? _value.assigneeId
          : assigneeId // ignore: cast_nullable_to_non_nullable
              as String?,
      aiExecutable: null == aiExecutable
          ? _value.aiExecutable
          : aiExecutable // ignore: cast_nullable_to_non_nullable
              as bool,
      aiStatus: null == aiStatus
          ? _value.aiStatus
          : aiStatus // ignore: cast_nullable_to_non_nullable
              as AIStatus,
      aiResult: freezed == aiResult
          ? _value.aiResult
          : aiResult // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Attachment>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
      lastModifiedBy: null == lastModifiedBy
          ? _value.lastModifiedBy
          : lastModifiedBy // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
          _$TaskImpl value, $Res Function(_$TaskImpl) then) =
      __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String projectId,
      String? parentId,
      String title,
      String description,
      TaskStatus status,
      TaskPriority priority,
      int? dueDate,
      String? assigneeId,
      bool aiExecutable,
      AIStatus aiStatus,
      String? aiResult,
      List<Attachment> attachments,
      int createdAt,
      int updatedAt,
      String lastModifiedBy});
}

/// @nodoc
class __$$TaskImplCopyWithImpl<$Res>
    extends _$TaskCopyWithImpl<$Res, _$TaskImpl>
    implements _$$TaskImplCopyWith<$Res> {
  __$$TaskImplCopyWithImpl(_$TaskImpl _value, $Res Function(_$TaskImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? parentId = freezed,
    Object? title = null,
    Object? description = null,
    Object? status = null,
    Object? priority = null,
    Object? dueDate = freezed,
    Object? assigneeId = freezed,
    Object? aiExecutable = null,
    Object? aiStatus = null,
    Object? aiResult = freezed,
    Object? attachments = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastModifiedBy = null,
  }) {
    return _then(_$TaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as int?,
      assigneeId: freezed == assigneeId
          ? _value.assigneeId
          : assigneeId // ignore: cast_nullable_to_non_nullable
              as String?,
      aiExecutable: null == aiExecutable
          ? _value.aiExecutable
          : aiExecutable // ignore: cast_nullable_to_non_nullable
              as bool,
      aiStatus: null == aiStatus
          ? _value.aiStatus
          : aiStatus // ignore: cast_nullable_to_non_nullable
              as AIStatus,
      aiResult: freezed == aiResult
          ? _value.aiResult
          : aiResult // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Attachment>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
      lastModifiedBy: null == lastModifiedBy
          ? _value.lastModifiedBy
          : lastModifiedBy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskImpl implements _Task {
  const _$TaskImpl(
      {required this.id,
      required this.projectId,
      this.parentId,
      required this.title,
      this.description = '',
      this.status = TaskStatus.todo,
      this.priority = TaskPriority.medium,
      this.dueDate,
      this.assigneeId,
      this.aiExecutable = false,
      this.aiStatus = AIStatus.idle,
      this.aiResult,
      final List<Attachment> attachments = const [],
      required this.createdAt,
      required this.updatedAt,
      this.lastModifiedBy = ''})
      : _attachments = attachments;

  factory _$TaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskImplFromJson(json);

  /// UUID v4
  @override
  final String id;

  /// 所属项目 ID
  @override
  final String projectId;

  /// 父任务 ID（子任务）
  @override
  final String? parentId;

  /// 任务标题
  @override
  final String title;

  /// 任务描述
  @override
  @JsonKey()
  final String description;

  /// 任务状态
  @override
  @JsonKey()
  final TaskStatus status;

  /// 优先级
  @override
  @JsonKey()
  final TaskPriority priority;

  /// 截止日期（Unix timestamp）
  @override
  final int? dueDate;

  /// 负责人 ID
  @override
  final String? assigneeId;

  /// 是否可由 AI 自动执行
  @override
  @JsonKey()
  final bool aiExecutable;

  /// AI 执行状态
  @override
  @JsonKey()
  final AIStatus aiStatus;

  /// AI 生成结果 JSON
  @override
  final String? aiResult;

  /// 附件列表
  final List<Attachment> _attachments;

  /// 附件列表
  @override
  @JsonKey()
  List<Attachment> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  /// 创建时间
  @override
  final int createdAt;

  /// 更新时间
  @override
  final int updatedAt;

  /// 最后修改人 ID
  @override
  @JsonKey()
  final String lastModifiedBy;

  @override
  String toString() {
    return 'Task(id: $id, projectId: $projectId, parentId: $parentId, title: $title, description: $description, status: $status, priority: $priority, dueDate: $dueDate, assigneeId: $assigneeId, aiExecutable: $aiExecutable, aiStatus: $aiStatus, aiResult: $aiResult, attachments: $attachments, createdAt: $createdAt, updatedAt: $updatedAt, lastModifiedBy: $lastModifiedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.assigneeId, assigneeId) ||
                other.assigneeId == assigneeId) &&
            (identical(other.aiExecutable, aiExecutable) ||
                other.aiExecutable == aiExecutable) &&
            (identical(other.aiStatus, aiStatus) ||
                other.aiStatus == aiStatus) &&
            (identical(other.aiResult, aiResult) ||
                other.aiResult == aiResult) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastModifiedBy, lastModifiedBy) ||
                other.lastModifiedBy == lastModifiedBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      projectId,
      parentId,
      title,
      description,
      status,
      priority,
      dueDate,
      assigneeId,
      aiExecutable,
      aiStatus,
      aiResult,
      const DeepCollectionEquality().hash(_attachments),
      createdAt,
      updatedAt,
      lastModifiedBy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskImplToJson(
      this,
    );
  }
}

abstract class _Task implements Task {
  const factory _Task(
      {required final String id,
      required final String projectId,
      final String? parentId,
      required final String title,
      final String description,
      final TaskStatus status,
      final TaskPriority priority,
      final int? dueDate,
      final String? assigneeId,
      final bool aiExecutable,
      final AIStatus aiStatus,
      final String? aiResult,
      final List<Attachment> attachments,
      required final int createdAt,
      required final int updatedAt,
      final String lastModifiedBy}) = _$TaskImpl;

  factory _Task.fromJson(Map<String, dynamic> json) = _$TaskImpl.fromJson;

  @override

  /// UUID v4
  String get id;
  @override

  /// 所属项目 ID
  String get projectId;
  @override

  /// 父任务 ID（子任务）
  String? get parentId;
  @override

  /// 任务标题
  String get title;
  @override

  /// 任务描述
  String get description;
  @override

  /// 任务状态
  TaskStatus get status;
  @override

  /// 优先级
  TaskPriority get priority;
  @override

  /// 截止日期（Unix timestamp）
  int? get dueDate;
  @override

  /// 负责人 ID
  String? get assigneeId;
  @override

  /// 是否可由 AI 自动执行
  bool get aiExecutable;
  @override

  /// AI 执行状态
  AIStatus get aiStatus;
  @override

  /// AI 生成结果 JSON
  String? get aiResult;
  @override

  /// 附件列表
  List<Attachment> get attachments;
  @override

  /// 创建时间
  int get createdAt;
  @override

  /// 更新时间
  int get updatedAt;
  @override

  /// 最后修改人 ID
  String get lastModifiedBy;
  @override
  @JsonKey(ignore: true)
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
