// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Conversation {

/// Client id (the chat is keyed by client).
@JsonKey(readValue: _clientId) String get clientId;/// Null for channel-only contacts (Instagram/Messenger) that have no
/// WhatsApp phone number.
 String? get phoneNumber;/// Channel-owned WhatsApp profile name (KAN-301: never workspace-edited).
 String? get profileName;/// KAN-301 — this workspace's own name for the client (JSON `displayName`).
@JsonKey(name: 'displayName') String? get workspaceName;/// KAN-301 — effective name from the API ([workspaceName] else
/// [profileName]); null on servers predating the field.
 String? get name; String? get lastMessageBody;@JsonKey(unknownEnumValue: MessageType.text) MessageType? get lastMessageType;@JsonKey(unknownEnumValue: MessageDirection.inbound) MessageDirection? get lastMessageDirection;/// Channel the last message travelled on ('whatsapp' | 'instagram' |
/// 'messenger'). The API defaults it to 'whatsapp', so only non-WhatsApp
/// values are worth surfacing; null on servers predating the field.
 String? get lastMessageChannelType; String? get lastMessageAt;/// Delivery status of the last message (outbound: sent / delivered /
/// read / failed). Null on servers predating the field.
@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) MessageStatus? get lastMessageStatus;/// Inbound messages newer than this member's server-side read cursor.
/// Null on servers predating the field (the app then falls back to the
/// on-device cursor).
 int? get unreadCount;/// When this member pinned the chat (server-side, follows the member
/// across devices); null when not pinned.
 String? get pinnedAt;
/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationCopyWith<Conversation> get copyWith => _$ConversationCopyWithImpl<Conversation>(this as Conversation, _$identity);

  /// Serializes this Conversation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Conversation&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.profileName, profileName) || other.profileName == profileName)&&(identical(other.workspaceName, workspaceName) || other.workspaceName == workspaceName)&&(identical(other.name, name) || other.name == name)&&(identical(other.lastMessageBody, lastMessageBody) || other.lastMessageBody == lastMessageBody)&&(identical(other.lastMessageType, lastMessageType) || other.lastMessageType == lastMessageType)&&(identical(other.lastMessageDirection, lastMessageDirection) || other.lastMessageDirection == lastMessageDirection)&&(identical(other.lastMessageChannelType, lastMessageChannelType) || other.lastMessageChannelType == lastMessageChannelType)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.lastMessageStatus, lastMessageStatus) || other.lastMessageStatus == lastMessageStatus)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.pinnedAt, pinnedAt) || other.pinnedAt == pinnedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,clientId,phoneNumber,profileName,workspaceName,name,lastMessageBody,lastMessageType,lastMessageDirection,lastMessageChannelType,lastMessageAt,lastMessageStatus,unreadCount,pinnedAt);

@override
String toString() {
  return 'Conversation(clientId: $clientId, phoneNumber: $phoneNumber, profileName: $profileName, workspaceName: $workspaceName, name: $name, lastMessageBody: $lastMessageBody, lastMessageType: $lastMessageType, lastMessageDirection: $lastMessageDirection, lastMessageChannelType: $lastMessageChannelType, lastMessageAt: $lastMessageAt, lastMessageStatus: $lastMessageStatus, unreadCount: $unreadCount, pinnedAt: $pinnedAt)';
}


}

/// @nodoc
abstract mixin class $ConversationCopyWith<$Res>  {
  factory $ConversationCopyWith(Conversation value, $Res Function(Conversation) _then) = _$ConversationCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: _clientId) String clientId, String? phoneNumber, String? profileName,@JsonKey(name: 'displayName') String? workspaceName, String? name, String? lastMessageBody,@JsonKey(unknownEnumValue: MessageType.text) MessageType? lastMessageType,@JsonKey(unknownEnumValue: MessageDirection.inbound) MessageDirection? lastMessageDirection, String? lastMessageChannelType, String? lastMessageAt,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) MessageStatus? lastMessageStatus, int? unreadCount, String? pinnedAt
});




}
/// @nodoc
class _$ConversationCopyWithImpl<$Res>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._self, this._then);

  final Conversation _self;
  final $Res Function(Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clientId = null,Object? phoneNumber = freezed,Object? profileName = freezed,Object? workspaceName = freezed,Object? name = freezed,Object? lastMessageBody = freezed,Object? lastMessageType = freezed,Object? lastMessageDirection = freezed,Object? lastMessageChannelType = freezed,Object? lastMessageAt = freezed,Object? lastMessageStatus = freezed,Object? unreadCount = freezed,Object? pinnedAt = freezed,}) {
  return _then(_self.copyWith(
clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,profileName: freezed == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String?,workspaceName: freezed == workspaceName ? _self.workspaceName : workspaceName // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,lastMessageBody: freezed == lastMessageBody ? _self.lastMessageBody : lastMessageBody // ignore: cast_nullable_to_non_nullable
as String?,lastMessageType: freezed == lastMessageType ? _self.lastMessageType : lastMessageType // ignore: cast_nullable_to_non_nullable
as MessageType?,lastMessageDirection: freezed == lastMessageDirection ? _self.lastMessageDirection : lastMessageDirection // ignore: cast_nullable_to_non_nullable
as MessageDirection?,lastMessageChannelType: freezed == lastMessageChannelType ? _self.lastMessageChannelType : lastMessageChannelType // ignore: cast_nullable_to_non_nullable
as String?,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as String?,lastMessageStatus: freezed == lastMessageStatus ? _self.lastMessageStatus : lastMessageStatus // ignore: cast_nullable_to_non_nullable
as MessageStatus?,unreadCount: freezed == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int?,pinnedAt: freezed == pinnedAt ? _self.pinnedAt : pinnedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Conversation].
extension ConversationPatterns on Conversation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Conversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Conversation value)  $default,){
final _that = this;
switch (_that) {
case _Conversation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Conversation value)?  $default,){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: _clientId)  String clientId,  String? phoneNumber,  String? profileName, @JsonKey(name: 'displayName')  String? workspaceName,  String? name,  String? lastMessageBody, @JsonKey(unknownEnumValue: MessageType.text)  MessageType? lastMessageType, @JsonKey(unknownEnumValue: MessageDirection.inbound)  MessageDirection? lastMessageDirection,  String? lastMessageChannelType,  String? lastMessageAt, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  MessageStatus? lastMessageStatus,  int? unreadCount,  String? pinnedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.clientId,_that.phoneNumber,_that.profileName,_that.workspaceName,_that.name,_that.lastMessageBody,_that.lastMessageType,_that.lastMessageDirection,_that.lastMessageChannelType,_that.lastMessageAt,_that.lastMessageStatus,_that.unreadCount,_that.pinnedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: _clientId)  String clientId,  String? phoneNumber,  String? profileName, @JsonKey(name: 'displayName')  String? workspaceName,  String? name,  String? lastMessageBody, @JsonKey(unknownEnumValue: MessageType.text)  MessageType? lastMessageType, @JsonKey(unknownEnumValue: MessageDirection.inbound)  MessageDirection? lastMessageDirection,  String? lastMessageChannelType,  String? lastMessageAt, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  MessageStatus? lastMessageStatus,  int? unreadCount,  String? pinnedAt)  $default,) {final _that = this;
switch (_that) {
case _Conversation():
return $default(_that.clientId,_that.phoneNumber,_that.profileName,_that.workspaceName,_that.name,_that.lastMessageBody,_that.lastMessageType,_that.lastMessageDirection,_that.lastMessageChannelType,_that.lastMessageAt,_that.lastMessageStatus,_that.unreadCount,_that.pinnedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: _clientId)  String clientId,  String? phoneNumber,  String? profileName, @JsonKey(name: 'displayName')  String? workspaceName,  String? name,  String? lastMessageBody, @JsonKey(unknownEnumValue: MessageType.text)  MessageType? lastMessageType, @JsonKey(unknownEnumValue: MessageDirection.inbound)  MessageDirection? lastMessageDirection,  String? lastMessageChannelType,  String? lastMessageAt, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  MessageStatus? lastMessageStatus,  int? unreadCount,  String? pinnedAt)?  $default,) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.clientId,_that.phoneNumber,_that.profileName,_that.workspaceName,_that.name,_that.lastMessageBody,_that.lastMessageType,_that.lastMessageDirection,_that.lastMessageChannelType,_that.lastMessageAt,_that.lastMessageStatus,_that.unreadCount,_that.pinnedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Conversation extends Conversation {
  const _Conversation({@JsonKey(readValue: _clientId) required this.clientId, this.phoneNumber, this.profileName, @JsonKey(name: 'displayName') this.workspaceName, this.name, this.lastMessageBody, @JsonKey(unknownEnumValue: MessageType.text) this.lastMessageType, @JsonKey(unknownEnumValue: MessageDirection.inbound) this.lastMessageDirection, this.lastMessageChannelType, this.lastMessageAt, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) this.lastMessageStatus, this.unreadCount, this.pinnedAt}): super._();
  factory _Conversation.fromJson(Map<String, dynamic> json) => _$ConversationFromJson(json);

/// Client id (the chat is keyed by client).
@override@JsonKey(readValue: _clientId) final  String clientId;
/// Null for channel-only contacts (Instagram/Messenger) that have no
/// WhatsApp phone number.
@override final  String? phoneNumber;
/// Channel-owned WhatsApp profile name (KAN-301: never workspace-edited).
@override final  String? profileName;
/// KAN-301 — this workspace's own name for the client (JSON `displayName`).
@override@JsonKey(name: 'displayName') final  String? workspaceName;
/// KAN-301 — effective name from the API ([workspaceName] else
/// [profileName]); null on servers predating the field.
@override final  String? name;
@override final  String? lastMessageBody;
@override@JsonKey(unknownEnumValue: MessageType.text) final  MessageType? lastMessageType;
@override@JsonKey(unknownEnumValue: MessageDirection.inbound) final  MessageDirection? lastMessageDirection;
/// Channel the last message travelled on ('whatsapp' | 'instagram' |
/// 'messenger'). The API defaults it to 'whatsapp', so only non-WhatsApp
/// values are worth surfacing; null on servers predating the field.
@override final  String? lastMessageChannelType;
@override final  String? lastMessageAt;
/// Delivery status of the last message (outbound: sent / delivered /
/// read / failed). Null on servers predating the field.
@override@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) final  MessageStatus? lastMessageStatus;
/// Inbound messages newer than this member's server-side read cursor.
/// Null on servers predating the field (the app then falls back to the
/// on-device cursor).
@override final  int? unreadCount;
/// When this member pinned the chat (server-side, follows the member
/// across devices); null when not pinned.
@override final  String? pinnedAt;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationCopyWith<_Conversation> get copyWith => __$ConversationCopyWithImpl<_Conversation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Conversation&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.profileName, profileName) || other.profileName == profileName)&&(identical(other.workspaceName, workspaceName) || other.workspaceName == workspaceName)&&(identical(other.name, name) || other.name == name)&&(identical(other.lastMessageBody, lastMessageBody) || other.lastMessageBody == lastMessageBody)&&(identical(other.lastMessageType, lastMessageType) || other.lastMessageType == lastMessageType)&&(identical(other.lastMessageDirection, lastMessageDirection) || other.lastMessageDirection == lastMessageDirection)&&(identical(other.lastMessageChannelType, lastMessageChannelType) || other.lastMessageChannelType == lastMessageChannelType)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.lastMessageStatus, lastMessageStatus) || other.lastMessageStatus == lastMessageStatus)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.pinnedAt, pinnedAt) || other.pinnedAt == pinnedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,clientId,phoneNumber,profileName,workspaceName,name,lastMessageBody,lastMessageType,lastMessageDirection,lastMessageChannelType,lastMessageAt,lastMessageStatus,unreadCount,pinnedAt);

@override
String toString() {
  return 'Conversation(clientId: $clientId, phoneNumber: $phoneNumber, profileName: $profileName, workspaceName: $workspaceName, name: $name, lastMessageBody: $lastMessageBody, lastMessageType: $lastMessageType, lastMessageDirection: $lastMessageDirection, lastMessageChannelType: $lastMessageChannelType, lastMessageAt: $lastMessageAt, lastMessageStatus: $lastMessageStatus, unreadCount: $unreadCount, pinnedAt: $pinnedAt)';
}


}

/// @nodoc
abstract mixin class _$ConversationCopyWith<$Res> implements $ConversationCopyWith<$Res> {
  factory _$ConversationCopyWith(_Conversation value, $Res Function(_Conversation) _then) = __$ConversationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: _clientId) String clientId, String? phoneNumber, String? profileName,@JsonKey(name: 'displayName') String? workspaceName, String? name, String? lastMessageBody,@JsonKey(unknownEnumValue: MessageType.text) MessageType? lastMessageType,@JsonKey(unknownEnumValue: MessageDirection.inbound) MessageDirection? lastMessageDirection, String? lastMessageChannelType, String? lastMessageAt,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) MessageStatus? lastMessageStatus, int? unreadCount, String? pinnedAt
});




}
/// @nodoc
class __$ConversationCopyWithImpl<$Res>
    implements _$ConversationCopyWith<$Res> {
  __$ConversationCopyWithImpl(this._self, this._then);

  final _Conversation _self;
  final $Res Function(_Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clientId = null,Object? phoneNumber = freezed,Object? profileName = freezed,Object? workspaceName = freezed,Object? name = freezed,Object? lastMessageBody = freezed,Object? lastMessageType = freezed,Object? lastMessageDirection = freezed,Object? lastMessageChannelType = freezed,Object? lastMessageAt = freezed,Object? lastMessageStatus = freezed,Object? unreadCount = freezed,Object? pinnedAt = freezed,}) {
  return _then(_Conversation(
clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,profileName: freezed == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String?,workspaceName: freezed == workspaceName ? _self.workspaceName : workspaceName // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,lastMessageBody: freezed == lastMessageBody ? _self.lastMessageBody : lastMessageBody // ignore: cast_nullable_to_non_nullable
as String?,lastMessageType: freezed == lastMessageType ? _self.lastMessageType : lastMessageType // ignore: cast_nullable_to_non_nullable
as MessageType?,lastMessageDirection: freezed == lastMessageDirection ? _self.lastMessageDirection : lastMessageDirection // ignore: cast_nullable_to_non_nullable
as MessageDirection?,lastMessageChannelType: freezed == lastMessageChannelType ? _self.lastMessageChannelType : lastMessageChannelType // ignore: cast_nullable_to_non_nullable
as String?,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as String?,lastMessageStatus: freezed == lastMessageStatus ? _self.lastMessageStatus : lastMessageStatus // ignore: cast_nullable_to_non_nullable
as MessageStatus?,unreadCount: freezed == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int?,pinnedAt: freezed == pinnedAt ? _self.pinnedAt : pinnedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
