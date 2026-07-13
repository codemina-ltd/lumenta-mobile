// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_sender.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConversationSender {

 String get senderId; String? get displayName; String? get displayPhoneNumber;@JsonKey(unknownEnumValue: SenderStatus.pending) SenderStatus get senderStatus; bool get isDefault; int get messageCount; String? get lastMessageAt;@JsonKey(unknownEnumValue: MessageDirection.inbound) MessageDirection? get lastMessageDirection;
/// Create a copy of ConversationSender
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationSenderCopyWith<ConversationSender> get copyWith => _$ConversationSenderCopyWithImpl<ConversationSender>(this as ConversationSender, _$identity);

  /// Serializes this ConversationSender to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationSender&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.displayPhoneNumber, displayPhoneNumber) || other.displayPhoneNumber == displayPhoneNumber)&&(identical(other.senderStatus, senderStatus) || other.senderStatus == senderStatus)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.messageCount, messageCount) || other.messageCount == messageCount)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.lastMessageDirection, lastMessageDirection) || other.lastMessageDirection == lastMessageDirection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,senderId,displayName,displayPhoneNumber,senderStatus,isDefault,messageCount,lastMessageAt,lastMessageDirection);

@override
String toString() {
  return 'ConversationSender(senderId: $senderId, displayName: $displayName, displayPhoneNumber: $displayPhoneNumber, senderStatus: $senderStatus, isDefault: $isDefault, messageCount: $messageCount, lastMessageAt: $lastMessageAt, lastMessageDirection: $lastMessageDirection)';
}


}

/// @nodoc
abstract mixin class $ConversationSenderCopyWith<$Res>  {
  factory $ConversationSenderCopyWith(ConversationSender value, $Res Function(ConversationSender) _then) = _$ConversationSenderCopyWithImpl;
@useResult
$Res call({
 String senderId, String? displayName, String? displayPhoneNumber,@JsonKey(unknownEnumValue: SenderStatus.pending) SenderStatus senderStatus, bool isDefault, int messageCount, String? lastMessageAt,@JsonKey(unknownEnumValue: MessageDirection.inbound) MessageDirection? lastMessageDirection
});




}
/// @nodoc
class _$ConversationSenderCopyWithImpl<$Res>
    implements $ConversationSenderCopyWith<$Res> {
  _$ConversationSenderCopyWithImpl(this._self, this._then);

  final ConversationSender _self;
  final $Res Function(ConversationSender) _then;

/// Create a copy of ConversationSender
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? senderId = null,Object? displayName = freezed,Object? displayPhoneNumber = freezed,Object? senderStatus = null,Object? isDefault = null,Object? messageCount = null,Object? lastMessageAt = freezed,Object? lastMessageDirection = freezed,}) {
  return _then(_self.copyWith(
senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,displayPhoneNumber: freezed == displayPhoneNumber ? _self.displayPhoneNumber : displayPhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,senderStatus: null == senderStatus ? _self.senderStatus : senderStatus // ignore: cast_nullable_to_non_nullable
as SenderStatus,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,messageCount: null == messageCount ? _self.messageCount : messageCount // ignore: cast_nullable_to_non_nullable
as int,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as String?,lastMessageDirection: freezed == lastMessageDirection ? _self.lastMessageDirection : lastMessageDirection // ignore: cast_nullable_to_non_nullable
as MessageDirection?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationSender].
extension ConversationSenderPatterns on ConversationSender {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationSender value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationSender() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationSender value)  $default,){
final _that = this;
switch (_that) {
case _ConversationSender():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationSender value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationSender() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String senderId,  String? displayName,  String? displayPhoneNumber, @JsonKey(unknownEnumValue: SenderStatus.pending)  SenderStatus senderStatus,  bool isDefault,  int messageCount,  String? lastMessageAt, @JsonKey(unknownEnumValue: MessageDirection.inbound)  MessageDirection? lastMessageDirection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationSender() when $default != null:
return $default(_that.senderId,_that.displayName,_that.displayPhoneNumber,_that.senderStatus,_that.isDefault,_that.messageCount,_that.lastMessageAt,_that.lastMessageDirection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String senderId,  String? displayName,  String? displayPhoneNumber, @JsonKey(unknownEnumValue: SenderStatus.pending)  SenderStatus senderStatus,  bool isDefault,  int messageCount,  String? lastMessageAt, @JsonKey(unknownEnumValue: MessageDirection.inbound)  MessageDirection? lastMessageDirection)  $default,) {final _that = this;
switch (_that) {
case _ConversationSender():
return $default(_that.senderId,_that.displayName,_that.displayPhoneNumber,_that.senderStatus,_that.isDefault,_that.messageCount,_that.lastMessageAt,_that.lastMessageDirection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String senderId,  String? displayName,  String? displayPhoneNumber, @JsonKey(unknownEnumValue: SenderStatus.pending)  SenderStatus senderStatus,  bool isDefault,  int messageCount,  String? lastMessageAt, @JsonKey(unknownEnumValue: MessageDirection.inbound)  MessageDirection? lastMessageDirection)?  $default,) {final _that = this;
switch (_that) {
case _ConversationSender() when $default != null:
return $default(_that.senderId,_that.displayName,_that.displayPhoneNumber,_that.senderStatus,_that.isDefault,_that.messageCount,_that.lastMessageAt,_that.lastMessageDirection);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationSender extends ConversationSender {
  const _ConversationSender({required this.senderId, this.displayName, this.displayPhoneNumber, @JsonKey(unknownEnumValue: SenderStatus.pending) this.senderStatus = SenderStatus.pending, this.isDefault = false, this.messageCount = 0, this.lastMessageAt, @JsonKey(unknownEnumValue: MessageDirection.inbound) this.lastMessageDirection}): super._();
  factory _ConversationSender.fromJson(Map<String, dynamic> json) => _$ConversationSenderFromJson(json);

@override final  String senderId;
@override final  String? displayName;
@override final  String? displayPhoneNumber;
@override@JsonKey(unknownEnumValue: SenderStatus.pending) final  SenderStatus senderStatus;
@override@JsonKey() final  bool isDefault;
@override@JsonKey() final  int messageCount;
@override final  String? lastMessageAt;
@override@JsonKey(unknownEnumValue: MessageDirection.inbound) final  MessageDirection? lastMessageDirection;

/// Create a copy of ConversationSender
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationSenderCopyWith<_ConversationSender> get copyWith => __$ConversationSenderCopyWithImpl<_ConversationSender>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationSenderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationSender&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.displayPhoneNumber, displayPhoneNumber) || other.displayPhoneNumber == displayPhoneNumber)&&(identical(other.senderStatus, senderStatus) || other.senderStatus == senderStatus)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.messageCount, messageCount) || other.messageCount == messageCount)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.lastMessageDirection, lastMessageDirection) || other.lastMessageDirection == lastMessageDirection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,senderId,displayName,displayPhoneNumber,senderStatus,isDefault,messageCount,lastMessageAt,lastMessageDirection);

@override
String toString() {
  return 'ConversationSender(senderId: $senderId, displayName: $displayName, displayPhoneNumber: $displayPhoneNumber, senderStatus: $senderStatus, isDefault: $isDefault, messageCount: $messageCount, lastMessageAt: $lastMessageAt, lastMessageDirection: $lastMessageDirection)';
}


}

/// @nodoc
abstract mixin class _$ConversationSenderCopyWith<$Res> implements $ConversationSenderCopyWith<$Res> {
  factory _$ConversationSenderCopyWith(_ConversationSender value, $Res Function(_ConversationSender) _then) = __$ConversationSenderCopyWithImpl;
@override @useResult
$Res call({
 String senderId, String? displayName, String? displayPhoneNumber,@JsonKey(unknownEnumValue: SenderStatus.pending) SenderStatus senderStatus, bool isDefault, int messageCount, String? lastMessageAt,@JsonKey(unknownEnumValue: MessageDirection.inbound) MessageDirection? lastMessageDirection
});




}
/// @nodoc
class __$ConversationSenderCopyWithImpl<$Res>
    implements _$ConversationSenderCopyWith<$Res> {
  __$ConversationSenderCopyWithImpl(this._self, this._then);

  final _ConversationSender _self;
  final $Res Function(_ConversationSender) _then;

/// Create a copy of ConversationSender
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? senderId = null,Object? displayName = freezed,Object? displayPhoneNumber = freezed,Object? senderStatus = null,Object? isDefault = null,Object? messageCount = null,Object? lastMessageAt = freezed,Object? lastMessageDirection = freezed,}) {
  return _then(_ConversationSender(
senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,displayPhoneNumber: freezed == displayPhoneNumber ? _self.displayPhoneNumber : displayPhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,senderStatus: null == senderStatus ? _self.senderStatus : senderStatus // ignore: cast_nullable_to_non_nullable
as SenderStatus,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,messageCount: null == messageCount ? _self.messageCount : messageCount // ignore: cast_nullable_to_non_nullable
as int,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as String?,lastMessageDirection: freezed == lastMessageDirection ? _self.lastMessageDirection : lastMessageDirection // ignore: cast_nullable_to_non_nullable
as MessageDirection?,
  ));
}


}

// dart format on
