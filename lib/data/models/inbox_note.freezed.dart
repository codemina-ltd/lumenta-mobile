// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inbox_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

InboxNote _$InboxNoteFromJson(Map<String, dynamic> json) {
  return _InboxNote.fromJson(json);
}

/// @nodoc
mixin _$InboxNote {
  String get id => throw _privateConstructorUsedError;
  String get threadId => throw _privateConstructorUsedError;
  String get authorUserId => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this InboxNote to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InboxNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InboxNoteCopyWith<InboxNote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InboxNoteCopyWith<$Res> {
  factory $InboxNoteCopyWith(InboxNote value, $Res Function(InboxNote) then) =
      _$InboxNoteCopyWithImpl<$Res, InboxNote>;
  @useResult
  $Res call({
    String id,
    String threadId,
    String authorUserId,
    String body,
    String? createdAt,
  });
}

/// @nodoc
class _$InboxNoteCopyWithImpl<$Res, $Val extends InboxNote>
    implements $InboxNoteCopyWith<$Res> {
  _$InboxNoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InboxNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? threadId = null,
    Object? authorUserId = null,
    Object? body = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            threadId: null == threadId
                ? _value.threadId
                : threadId // ignore: cast_nullable_to_non_nullable
                      as String,
            authorUserId: null == authorUserId
                ? _value.authorUserId
                : authorUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InboxNoteImplCopyWith<$Res>
    implements $InboxNoteCopyWith<$Res> {
  factory _$$InboxNoteImplCopyWith(
    _$InboxNoteImpl value,
    $Res Function(_$InboxNoteImpl) then,
  ) = __$$InboxNoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String threadId,
    String authorUserId,
    String body,
    String? createdAt,
  });
}

/// @nodoc
class __$$InboxNoteImplCopyWithImpl<$Res>
    extends _$InboxNoteCopyWithImpl<$Res, _$InboxNoteImpl>
    implements _$$InboxNoteImplCopyWith<$Res> {
  __$$InboxNoteImplCopyWithImpl(
    _$InboxNoteImpl _value,
    $Res Function(_$InboxNoteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InboxNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? threadId = null,
    Object? authorUserId = null,
    Object? body = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$InboxNoteImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        threadId: null == threadId
            ? _value.threadId
            : threadId // ignore: cast_nullable_to_non_nullable
                  as String,
        authorUserId: null == authorUserId
            ? _value.authorUserId
            : authorUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InboxNoteImpl extends _InboxNote {
  const _$InboxNoteImpl({
    required this.id,
    required this.threadId,
    required this.authorUserId,
    required this.body,
    this.createdAt,
  }) : super._();

  factory _$InboxNoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$InboxNoteImplFromJson(json);

  @override
  final String id;
  @override
  final String threadId;
  @override
  final String authorUserId;
  @override
  final String body;
  @override
  final String? createdAt;

  @override
  String toString() {
    return 'InboxNote(id: $id, threadId: $threadId, authorUserId: $authorUserId, body: $body, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InboxNoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.authorUserId, authorUserId) ||
                other.authorUserId == authorUserId) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, threadId, authorUserId, body, createdAt);

  /// Create a copy of InboxNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InboxNoteImplCopyWith<_$InboxNoteImpl> get copyWith =>
      __$$InboxNoteImplCopyWithImpl<_$InboxNoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InboxNoteImplToJson(this);
  }
}

abstract class _InboxNote extends InboxNote {
  const factory _InboxNote({
    required final String id,
    required final String threadId,
    required final String authorUserId,
    required final String body,
    final String? createdAt,
  }) = _$InboxNoteImpl;
  const _InboxNote._() : super._();

  factory _InboxNote.fromJson(Map<String, dynamic> json) =
      _$InboxNoteImpl.fromJson;

  @override
  String get id;
  @override
  String get threadId;
  @override
  String get authorUserId;
  @override
  String get body;
  @override
  String? get createdAt;

  /// Create a copy of InboxNote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InboxNoteImplCopyWith<_$InboxNoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
