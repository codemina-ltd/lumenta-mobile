// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inbox_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InboxNote {

 String get id; String get threadId; String get authorUserId; String get body; String? get createdAt;
/// Create a copy of InboxNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InboxNoteCopyWith<InboxNote> get copyWith => _$InboxNoteCopyWithImpl<InboxNote>(this as InboxNote, _$identity);

  /// Serializes this InboxNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InboxNote&&(identical(other.id, id) || other.id == id)&&(identical(other.threadId, threadId) || other.threadId == threadId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,threadId,authorUserId,body,createdAt);

@override
String toString() {
  return 'InboxNote(id: $id, threadId: $threadId, authorUserId: $authorUserId, body: $body, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $InboxNoteCopyWith<$Res>  {
  factory $InboxNoteCopyWith(InboxNote value, $Res Function(InboxNote) _then) = _$InboxNoteCopyWithImpl;
@useResult
$Res call({
 String id, String threadId, String authorUserId, String body, String? createdAt
});




}
/// @nodoc
class _$InboxNoteCopyWithImpl<$Res>
    implements $InboxNoteCopyWith<$Res> {
  _$InboxNoteCopyWithImpl(this._self, this._then);

  final InboxNote _self;
  final $Res Function(InboxNote) _then;

/// Create a copy of InboxNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? threadId = null,Object? authorUserId = null,Object? body = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,threadId: null == threadId ? _self.threadId : threadId // ignore: cast_nullable_to_non_nullable
as String,authorUserId: null == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InboxNote].
extension InboxNotePatterns on InboxNote {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InboxNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InboxNote() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InboxNote value)  $default,){
final _that = this;
switch (_that) {
case _InboxNote():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InboxNote value)?  $default,){
final _that = this;
switch (_that) {
case _InboxNote() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String threadId,  String authorUserId,  String body,  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InboxNote() when $default != null:
return $default(_that.id,_that.threadId,_that.authorUserId,_that.body,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String threadId,  String authorUserId,  String body,  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _InboxNote():
return $default(_that.id,_that.threadId,_that.authorUserId,_that.body,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String threadId,  String authorUserId,  String body,  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _InboxNote() when $default != null:
return $default(_that.id,_that.threadId,_that.authorUserId,_that.body,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InboxNote extends InboxNote {
  const _InboxNote({required this.id, required this.threadId, required this.authorUserId, required this.body, this.createdAt}): super._();
  factory _InboxNote.fromJson(Map<String, dynamic> json) => _$InboxNoteFromJson(json);

@override final  String id;
@override final  String threadId;
@override final  String authorUserId;
@override final  String body;
@override final  String? createdAt;

/// Create a copy of InboxNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InboxNoteCopyWith<_InboxNote> get copyWith => __$InboxNoteCopyWithImpl<_InboxNote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InboxNoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InboxNote&&(identical(other.id, id) || other.id == id)&&(identical(other.threadId, threadId) || other.threadId == threadId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,threadId,authorUserId,body,createdAt);

@override
String toString() {
  return 'InboxNote(id: $id, threadId: $threadId, authorUserId: $authorUserId, body: $body, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$InboxNoteCopyWith<$Res> implements $InboxNoteCopyWith<$Res> {
  factory _$InboxNoteCopyWith(_InboxNote value, $Res Function(_InboxNote) _then) = __$InboxNoteCopyWithImpl;
@override @useResult
$Res call({
 String id, String threadId, String authorUserId, String body, String? createdAt
});




}
/// @nodoc
class __$InboxNoteCopyWithImpl<$Res>
    implements _$InboxNoteCopyWith<$Res> {
  __$InboxNoteCopyWithImpl(this._self, this._then);

  final _InboxNote _self;
  final $Res Function(_InboxNote) _then;

/// Create a copy of InboxNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? threadId = null,Object? authorUserId = null,Object? body = null,Object? createdAt = freezed,}) {
  return _then(_InboxNote(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,threadId: null == threadId ? _self.threadId : threadId // ignore: cast_nullable_to_non_nullable
as String,authorUserId: null == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
