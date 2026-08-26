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

 String get id; String get threadId; String get authorUserId; String get body; String? get createdAt;/// KAN-186 — emoji reactions aggregated by the API (read-only here).
 List<InboxNoteReaction> get reactions;
/// Create a copy of InboxNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InboxNoteCopyWith<InboxNote> get copyWith => _$InboxNoteCopyWithImpl<InboxNote>(this as InboxNote, _$identity);

  /// Serializes this InboxNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InboxNote&&(identical(other.id, id) || other.id == id)&&(identical(other.threadId, threadId) || other.threadId == threadId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.reactions, reactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,threadId,authorUserId,body,createdAt,const DeepCollectionEquality().hash(reactions));

@override
String toString() {
  return 'InboxNote(id: $id, threadId: $threadId, authorUserId: $authorUserId, body: $body, createdAt: $createdAt, reactions: $reactions)';
}


}

/// @nodoc
abstract mixin class $InboxNoteCopyWith<$Res>  {
  factory $InboxNoteCopyWith(InboxNote value, $Res Function(InboxNote) _then) = _$InboxNoteCopyWithImpl;
@useResult
$Res call({
 String id, String threadId, String authorUserId, String body, String? createdAt, List<InboxNoteReaction> reactions
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? threadId = null,Object? authorUserId = null,Object? body = null,Object? createdAt = freezed,Object? reactions = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,threadId: null == threadId ? _self.threadId : threadId // ignore: cast_nullable_to_non_nullable
as String,authorUserId: null == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<InboxNoteReaction>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String threadId,  String authorUserId,  String body,  String? createdAt,  List<InboxNoteReaction> reactions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InboxNote() when $default != null:
return $default(_that.id,_that.threadId,_that.authorUserId,_that.body,_that.createdAt,_that.reactions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String threadId,  String authorUserId,  String body,  String? createdAt,  List<InboxNoteReaction> reactions)  $default,) {final _that = this;
switch (_that) {
case _InboxNote():
return $default(_that.id,_that.threadId,_that.authorUserId,_that.body,_that.createdAt,_that.reactions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String threadId,  String authorUserId,  String body,  String? createdAt,  List<InboxNoteReaction> reactions)?  $default,) {final _that = this;
switch (_that) {
case _InboxNote() when $default != null:
return $default(_that.id,_that.threadId,_that.authorUserId,_that.body,_that.createdAt,_that.reactions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InboxNote extends InboxNote {
  const _InboxNote({required this.id, required this.threadId, required this.authorUserId, required this.body, this.createdAt, final  List<InboxNoteReaction> reactions = const <InboxNoteReaction>[]}): _reactions = reactions,super._();
  factory _InboxNote.fromJson(Map<String, dynamic> json) => _$InboxNoteFromJson(json);

@override final  String id;
@override final  String threadId;
@override final  String authorUserId;
@override final  String body;
@override final  String? createdAt;
/// KAN-186 — emoji reactions aggregated by the API (read-only here).
 final  List<InboxNoteReaction> _reactions;
/// KAN-186 — emoji reactions aggregated by the API (read-only here).
@override@JsonKey() List<InboxNoteReaction> get reactions {
  if (_reactions is EqualUnmodifiableListView) return _reactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reactions);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InboxNote&&(identical(other.id, id) || other.id == id)&&(identical(other.threadId, threadId) || other.threadId == threadId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._reactions, _reactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,threadId,authorUserId,body,createdAt,const DeepCollectionEquality().hash(_reactions));

@override
String toString() {
  return 'InboxNote(id: $id, threadId: $threadId, authorUserId: $authorUserId, body: $body, createdAt: $createdAt, reactions: $reactions)';
}


}

/// @nodoc
abstract mixin class _$InboxNoteCopyWith<$Res> implements $InboxNoteCopyWith<$Res> {
  factory _$InboxNoteCopyWith(_InboxNote value, $Res Function(_InboxNote) _then) = __$InboxNoteCopyWithImpl;
@override @useResult
$Res call({
 String id, String threadId, String authorUserId, String body, String? createdAt, List<InboxNoteReaction> reactions
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? threadId = null,Object? authorUserId = null,Object? body = null,Object? createdAt = freezed,Object? reactions = null,}) {
  return _then(_InboxNote(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,threadId: null == threadId ? _self.threadId : threadId // ignore: cast_nullable_to_non_nullable
as String,authorUserId: null == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,reactions: null == reactions ? _self._reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<InboxNoteReaction>,
  ));
}


}


/// @nodoc
mixin _$InboxNoteReaction {

 String get emoji; int get count; List<String> get userIds; bool get reactedByMe;
/// Create a copy of InboxNoteReaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InboxNoteReactionCopyWith<InboxNoteReaction> get copyWith => _$InboxNoteReactionCopyWithImpl<InboxNoteReaction>(this as InboxNoteReaction, _$identity);

  /// Serializes this InboxNoteReaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InboxNoteReaction&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other.userIds, userIds)&&(identical(other.reactedByMe, reactedByMe) || other.reactedByMe == reactedByMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emoji,count,const DeepCollectionEquality().hash(userIds),reactedByMe);

@override
String toString() {
  return 'InboxNoteReaction(emoji: $emoji, count: $count, userIds: $userIds, reactedByMe: $reactedByMe)';
}


}

/// @nodoc
abstract mixin class $InboxNoteReactionCopyWith<$Res>  {
  factory $InboxNoteReactionCopyWith(InboxNoteReaction value, $Res Function(InboxNoteReaction) _then) = _$InboxNoteReactionCopyWithImpl;
@useResult
$Res call({
 String emoji, int count, List<String> userIds, bool reactedByMe
});




}
/// @nodoc
class _$InboxNoteReactionCopyWithImpl<$Res>
    implements $InboxNoteReactionCopyWith<$Res> {
  _$InboxNoteReactionCopyWithImpl(this._self, this._then);

  final InboxNoteReaction _self;
  final $Res Function(InboxNoteReaction) _then;

/// Create a copy of InboxNoteReaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emoji = null,Object? count = null,Object? userIds = null,Object? reactedByMe = null,}) {
  return _then(_self.copyWith(
emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,userIds: null == userIds ? _self.userIds : userIds // ignore: cast_nullable_to_non_nullable
as List<String>,reactedByMe: null == reactedByMe ? _self.reactedByMe : reactedByMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [InboxNoteReaction].
extension InboxNoteReactionPatterns on InboxNoteReaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InboxNoteReaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InboxNoteReaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InboxNoteReaction value)  $default,){
final _that = this;
switch (_that) {
case _InboxNoteReaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InboxNoteReaction value)?  $default,){
final _that = this;
switch (_that) {
case _InboxNoteReaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String emoji,  int count,  List<String> userIds,  bool reactedByMe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InboxNoteReaction() when $default != null:
return $default(_that.emoji,_that.count,_that.userIds,_that.reactedByMe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String emoji,  int count,  List<String> userIds,  bool reactedByMe)  $default,) {final _that = this;
switch (_that) {
case _InboxNoteReaction():
return $default(_that.emoji,_that.count,_that.userIds,_that.reactedByMe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String emoji,  int count,  List<String> userIds,  bool reactedByMe)?  $default,) {final _that = this;
switch (_that) {
case _InboxNoteReaction() when $default != null:
return $default(_that.emoji,_that.count,_that.userIds,_that.reactedByMe);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InboxNoteReaction implements InboxNoteReaction {
  const _InboxNoteReaction({required this.emoji, this.count = 0, final  List<String> userIds = const <String>[], this.reactedByMe = false}): _userIds = userIds;
  factory _InboxNoteReaction.fromJson(Map<String, dynamic> json) => _$InboxNoteReactionFromJson(json);

@override final  String emoji;
@override@JsonKey() final  int count;
 final  List<String> _userIds;
@override@JsonKey() List<String> get userIds {
  if (_userIds is EqualUnmodifiableListView) return _userIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_userIds);
}

@override@JsonKey() final  bool reactedByMe;

/// Create a copy of InboxNoteReaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InboxNoteReactionCopyWith<_InboxNoteReaction> get copyWith => __$InboxNoteReactionCopyWithImpl<_InboxNoteReaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InboxNoteReactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InboxNoteReaction&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other._userIds, _userIds)&&(identical(other.reactedByMe, reactedByMe) || other.reactedByMe == reactedByMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emoji,count,const DeepCollectionEquality().hash(_userIds),reactedByMe);

@override
String toString() {
  return 'InboxNoteReaction(emoji: $emoji, count: $count, userIds: $userIds, reactedByMe: $reactedByMe)';
}


}

/// @nodoc
abstract mixin class _$InboxNoteReactionCopyWith<$Res> implements $InboxNoteReactionCopyWith<$Res> {
  factory _$InboxNoteReactionCopyWith(_InboxNoteReaction value, $Res Function(_InboxNoteReaction) _then) = __$InboxNoteReactionCopyWithImpl;
@override @useResult
$Res call({
 String emoji, int count, List<String> userIds, bool reactedByMe
});




}
/// @nodoc
class __$InboxNoteReactionCopyWithImpl<$Res>
    implements _$InboxNoteReactionCopyWith<$Res> {
  __$InboxNoteReactionCopyWithImpl(this._self, this._then);

  final _InboxNoteReaction _self;
  final $Res Function(_InboxNoteReaction) _then;

/// Create a copy of InboxNoteReaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emoji = null,Object? count = null,Object? userIds = null,Object? reactedByMe = null,}) {
  return _then(_InboxNoteReaction(
emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,userIds: null == userIds ? _self._userIds : userIds // ignore: cast_nullable_to_non_nullable
as List<String>,reactedByMe: null == reactedByMe ? _self.reactedByMe : reactedByMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
