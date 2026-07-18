// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Message {

 String get id;@JsonKey(unknownEnumValue: MessageDirection.inbound) MessageDirection get direction; String get body;@JsonKey(unknownEnumValue: MessageStatus.sent) MessageStatus get status;@JsonKey(unknownEnumValue: MessageType.unknown) MessageType get messageType; String? get mediaUrl; String? get mediaMimeType; String? get locationLatitude; String? get locationLongitude; String? get locationName; String? get locationAddress;/// Shared-contact cards on an inbound `contacts` message — the API's
/// sanitized copy of Meta's `messages[0].contacts` array. Null for other
/// types and for legacy rows (see [sharedContacts] for the fallback).
 List<dynamic>? get contactsData; String? get transcription; String? get transcriptionStatus;/// Emoji the customer reacted with (webhook writes it onto the reacted-to
/// message row); null / empty when there is no active reaction.
 String? get reaction; Map<String, dynamic>? get providerRawPayload;/// First-class template linkage on outbound template sends (see
/// api/docs/MESSAGE_TEMPLATE_CONTRACT.md): the internal template UUID.
/// Null after the template is deleted (SET NULL FK), on inbound rows,
/// and on legacy pre-backfill rows — see [templateId] for the fallback.
@JsonKey(name: 'templateId') String? get templateIdRaw;/// The ACTUAL values sent with the template — never the template's
/// example values: `{variables, buttonVariables, language, name,
/// category}`. Null on non-template rows.
 Map<String, dynamic>? get templateData;/// Sender (WABA phone number) that carried this message. Null on legacy
/// rows written before sender attribution existed.
 String? get senderId;/// Team member who sent this outbound message ("Sent by …" attribution,
/// mirrors the portal). Response-only field; null on inbound rows and
/// rows whose user no longer exists.
 String? get sentByUserName;/// "Delete for everyone" tombstone. When set, the server has cleared
/// body/media and the bubble renders a "message deleted" placeholder.
 String? get deletedForEveryoneAt; String get createdAt;
/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageCopyWith<Message> get copyWith => _$MessageCopyWithImpl<Message>(this as Message, _$identity);

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Message&&(identical(other.id, id) || other.id == id)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.body, body) || other.body == body)&&(identical(other.status, status) || other.status == status)&&(identical(other.messageType, messageType) || other.messageType == messageType)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.mediaMimeType, mediaMimeType) || other.mediaMimeType == mediaMimeType)&&(identical(other.locationLatitude, locationLatitude) || other.locationLatitude == locationLatitude)&&(identical(other.locationLongitude, locationLongitude) || other.locationLongitude == locationLongitude)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.locationAddress, locationAddress) || other.locationAddress == locationAddress)&&const DeepCollectionEquality().equals(other.contactsData, contactsData)&&(identical(other.transcription, transcription) || other.transcription == transcription)&&(identical(other.transcriptionStatus, transcriptionStatus) || other.transcriptionStatus == transcriptionStatus)&&(identical(other.reaction, reaction) || other.reaction == reaction)&&const DeepCollectionEquality().equals(other.providerRawPayload, providerRawPayload)&&(identical(other.templateIdRaw, templateIdRaw) || other.templateIdRaw == templateIdRaw)&&const DeepCollectionEquality().equals(other.templateData, templateData)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.sentByUserName, sentByUserName) || other.sentByUserName == sentByUserName)&&(identical(other.deletedForEveryoneAt, deletedForEveryoneAt) || other.deletedForEveryoneAt == deletedForEveryoneAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,direction,body,status,messageType,mediaUrl,mediaMimeType,locationLatitude,locationLongitude,locationName,locationAddress,const DeepCollectionEquality().hash(contactsData),transcription,transcriptionStatus,reaction,const DeepCollectionEquality().hash(providerRawPayload),templateIdRaw,const DeepCollectionEquality().hash(templateData),senderId,sentByUserName,deletedForEveryoneAt,createdAt]);

@override
String toString() {
  return 'Message(id: $id, direction: $direction, body: $body, status: $status, messageType: $messageType, mediaUrl: $mediaUrl, mediaMimeType: $mediaMimeType, locationLatitude: $locationLatitude, locationLongitude: $locationLongitude, locationName: $locationName, locationAddress: $locationAddress, contactsData: $contactsData, transcription: $transcription, transcriptionStatus: $transcriptionStatus, reaction: $reaction, providerRawPayload: $providerRawPayload, templateIdRaw: $templateIdRaw, templateData: $templateData, senderId: $senderId, sentByUserName: $sentByUserName, deletedForEveryoneAt: $deletedForEveryoneAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MessageCopyWith<$Res>  {
  factory $MessageCopyWith(Message value, $Res Function(Message) _then) = _$MessageCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: MessageDirection.inbound) MessageDirection direction, String body,@JsonKey(unknownEnumValue: MessageStatus.sent) MessageStatus status,@JsonKey(unknownEnumValue: MessageType.unknown) MessageType messageType, String? mediaUrl, String? mediaMimeType, String? locationLatitude, String? locationLongitude, String? locationName, String? locationAddress, List<dynamic>? contactsData, String? transcription, String? transcriptionStatus, String? reaction, Map<String, dynamic>? providerRawPayload,@JsonKey(name: 'templateId') String? templateIdRaw, Map<String, dynamic>? templateData, String? senderId, String? sentByUserName, String? deletedForEveryoneAt, String createdAt
});




}
/// @nodoc
class _$MessageCopyWithImpl<$Res>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._self, this._then);

  final Message _self;
  final $Res Function(Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? direction = null,Object? body = null,Object? status = null,Object? messageType = null,Object? mediaUrl = freezed,Object? mediaMimeType = freezed,Object? locationLatitude = freezed,Object? locationLongitude = freezed,Object? locationName = freezed,Object? locationAddress = freezed,Object? contactsData = freezed,Object? transcription = freezed,Object? transcriptionStatus = freezed,Object? reaction = freezed,Object? providerRawPayload = freezed,Object? templateIdRaw = freezed,Object? templateData = freezed,Object? senderId = freezed,Object? sentByUserName = freezed,Object? deletedForEveryoneAt = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as MessageDirection,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MessageStatus,messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as MessageType,mediaUrl: freezed == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String?,mediaMimeType: freezed == mediaMimeType ? _self.mediaMimeType : mediaMimeType // ignore: cast_nullable_to_non_nullable
as String?,locationLatitude: freezed == locationLatitude ? _self.locationLatitude : locationLatitude // ignore: cast_nullable_to_non_nullable
as String?,locationLongitude: freezed == locationLongitude ? _self.locationLongitude : locationLongitude // ignore: cast_nullable_to_non_nullable
as String?,locationName: freezed == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String?,locationAddress: freezed == locationAddress ? _self.locationAddress : locationAddress // ignore: cast_nullable_to_non_nullable
as String?,contactsData: freezed == contactsData ? _self.contactsData : contactsData // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,transcription: freezed == transcription ? _self.transcription : transcription // ignore: cast_nullable_to_non_nullable
as String?,transcriptionStatus: freezed == transcriptionStatus ? _self.transcriptionStatus : transcriptionStatus // ignore: cast_nullable_to_non_nullable
as String?,reaction: freezed == reaction ? _self.reaction : reaction // ignore: cast_nullable_to_non_nullable
as String?,providerRawPayload: freezed == providerRawPayload ? _self.providerRawPayload : providerRawPayload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,templateIdRaw: freezed == templateIdRaw ? _self.templateIdRaw : templateIdRaw // ignore: cast_nullable_to_non_nullable
as String?,templateData: freezed == templateData ? _self.templateData : templateData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,senderId: freezed == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String?,sentByUserName: freezed == sentByUserName ? _self.sentByUserName : sentByUserName // ignore: cast_nullable_to_non_nullable
as String?,deletedForEveryoneAt: freezed == deletedForEveryoneAt ? _self.deletedForEveryoneAt : deletedForEveryoneAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Message].
extension MessagePatterns on Message {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Message value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Message value)  $default,){
final _that = this;
switch (_that) {
case _Message():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Message value)?  $default,){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: MessageDirection.inbound)  MessageDirection direction,  String body, @JsonKey(unknownEnumValue: MessageStatus.sent)  MessageStatus status, @JsonKey(unknownEnumValue: MessageType.unknown)  MessageType messageType,  String? mediaUrl,  String? mediaMimeType,  String? locationLatitude,  String? locationLongitude,  String? locationName,  String? locationAddress,  List<dynamic>? contactsData,  String? transcription,  String? transcriptionStatus,  String? reaction,  Map<String, dynamic>? providerRawPayload, @JsonKey(name: 'templateId')  String? templateIdRaw,  Map<String, dynamic>? templateData,  String? senderId,  String? sentByUserName,  String? deletedForEveryoneAt,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.direction,_that.body,_that.status,_that.messageType,_that.mediaUrl,_that.mediaMimeType,_that.locationLatitude,_that.locationLongitude,_that.locationName,_that.locationAddress,_that.contactsData,_that.transcription,_that.transcriptionStatus,_that.reaction,_that.providerRawPayload,_that.templateIdRaw,_that.templateData,_that.senderId,_that.sentByUserName,_that.deletedForEveryoneAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: MessageDirection.inbound)  MessageDirection direction,  String body, @JsonKey(unknownEnumValue: MessageStatus.sent)  MessageStatus status, @JsonKey(unknownEnumValue: MessageType.unknown)  MessageType messageType,  String? mediaUrl,  String? mediaMimeType,  String? locationLatitude,  String? locationLongitude,  String? locationName,  String? locationAddress,  List<dynamic>? contactsData,  String? transcription,  String? transcriptionStatus,  String? reaction,  Map<String, dynamic>? providerRawPayload, @JsonKey(name: 'templateId')  String? templateIdRaw,  Map<String, dynamic>? templateData,  String? senderId,  String? sentByUserName,  String? deletedForEveryoneAt,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _Message():
return $default(_that.id,_that.direction,_that.body,_that.status,_that.messageType,_that.mediaUrl,_that.mediaMimeType,_that.locationLatitude,_that.locationLongitude,_that.locationName,_that.locationAddress,_that.contactsData,_that.transcription,_that.transcriptionStatus,_that.reaction,_that.providerRawPayload,_that.templateIdRaw,_that.templateData,_that.senderId,_that.sentByUserName,_that.deletedForEveryoneAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(unknownEnumValue: MessageDirection.inbound)  MessageDirection direction,  String body, @JsonKey(unknownEnumValue: MessageStatus.sent)  MessageStatus status, @JsonKey(unknownEnumValue: MessageType.unknown)  MessageType messageType,  String? mediaUrl,  String? mediaMimeType,  String? locationLatitude,  String? locationLongitude,  String? locationName,  String? locationAddress,  List<dynamic>? contactsData,  String? transcription,  String? transcriptionStatus,  String? reaction,  Map<String, dynamic>? providerRawPayload, @JsonKey(name: 'templateId')  String? templateIdRaw,  Map<String, dynamic>? templateData,  String? senderId,  String? sentByUserName,  String? deletedForEveryoneAt,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.direction,_that.body,_that.status,_that.messageType,_that.mediaUrl,_that.mediaMimeType,_that.locationLatitude,_that.locationLongitude,_that.locationName,_that.locationAddress,_that.contactsData,_that.transcription,_that.transcriptionStatus,_that.reaction,_that.providerRawPayload,_that.templateIdRaw,_that.templateData,_that.senderId,_that.sentByUserName,_that.deletedForEveryoneAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Message extends Message {
  const _Message({required this.id, @JsonKey(unknownEnumValue: MessageDirection.inbound) required this.direction, this.body = '', @JsonKey(unknownEnumValue: MessageStatus.sent) this.status = MessageStatus.sent, @JsonKey(unknownEnumValue: MessageType.unknown) this.messageType = MessageType.text, this.mediaUrl, this.mediaMimeType, this.locationLatitude, this.locationLongitude, this.locationName, this.locationAddress, final  List<dynamic>? contactsData, this.transcription, this.transcriptionStatus, this.reaction, final  Map<String, dynamic>? providerRawPayload, @JsonKey(name: 'templateId') this.templateIdRaw, final  Map<String, dynamic>? templateData, this.senderId, this.sentByUserName, this.deletedForEveryoneAt, required this.createdAt}): _contactsData = contactsData,_providerRawPayload = providerRawPayload,_templateData = templateData,super._();
  factory _Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

@override final  String id;
@override@JsonKey(unknownEnumValue: MessageDirection.inbound) final  MessageDirection direction;
@override@JsonKey() final  String body;
@override@JsonKey(unknownEnumValue: MessageStatus.sent) final  MessageStatus status;
@override@JsonKey(unknownEnumValue: MessageType.unknown) final  MessageType messageType;
@override final  String? mediaUrl;
@override final  String? mediaMimeType;
@override final  String? locationLatitude;
@override final  String? locationLongitude;
@override final  String? locationName;
@override final  String? locationAddress;
/// Shared-contact cards on an inbound `contacts` message — the API's
/// sanitized copy of Meta's `messages[0].contacts` array. Null for other
/// types and for legacy rows (see [sharedContacts] for the fallback).
 final  List<dynamic>? _contactsData;
/// Shared-contact cards on an inbound `contacts` message — the API's
/// sanitized copy of Meta's `messages[0].contacts` array. Null for other
/// types and for legacy rows (see [sharedContacts] for the fallback).
@override List<dynamic>? get contactsData {
  final value = _contactsData;
  if (value == null) return null;
  if (_contactsData is EqualUnmodifiableListView) return _contactsData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? transcription;
@override final  String? transcriptionStatus;
/// Emoji the customer reacted with (webhook writes it onto the reacted-to
/// message row); null / empty when there is no active reaction.
@override final  String? reaction;
 final  Map<String, dynamic>? _providerRawPayload;
@override Map<String, dynamic>? get providerRawPayload {
  final value = _providerRawPayload;
  if (value == null) return null;
  if (_providerRawPayload is EqualUnmodifiableMapView) return _providerRawPayload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

/// First-class template linkage on outbound template sends (see
/// api/docs/MESSAGE_TEMPLATE_CONTRACT.md): the internal template UUID.
/// Null after the template is deleted (SET NULL FK), on inbound rows,
/// and on legacy pre-backfill rows — see [templateId] for the fallback.
@override@JsonKey(name: 'templateId') final  String? templateIdRaw;
/// The ACTUAL values sent with the template — never the template's
/// example values: `{variables, buttonVariables, language, name,
/// category}`. Null on non-template rows.
 final  Map<String, dynamic>? _templateData;
/// The ACTUAL values sent with the template — never the template's
/// example values: `{variables, buttonVariables, language, name,
/// category}`. Null on non-template rows.
@override Map<String, dynamic>? get templateData {
  final value = _templateData;
  if (value == null) return null;
  if (_templateData is EqualUnmodifiableMapView) return _templateData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

/// Sender (WABA phone number) that carried this message. Null on legacy
/// rows written before sender attribution existed.
@override final  String? senderId;
/// Team member who sent this outbound message ("Sent by …" attribution,
/// mirrors the portal). Response-only field; null on inbound rows and
/// rows whose user no longer exists.
@override final  String? sentByUserName;
/// "Delete for everyone" tombstone. When set, the server has cleared
/// body/media and the bubble renders a "message deleted" placeholder.
@override final  String? deletedForEveryoneAt;
@override final  String createdAt;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageCopyWith<_Message> get copyWith => __$MessageCopyWithImpl<_Message>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Message&&(identical(other.id, id) || other.id == id)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.body, body) || other.body == body)&&(identical(other.status, status) || other.status == status)&&(identical(other.messageType, messageType) || other.messageType == messageType)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.mediaMimeType, mediaMimeType) || other.mediaMimeType == mediaMimeType)&&(identical(other.locationLatitude, locationLatitude) || other.locationLatitude == locationLatitude)&&(identical(other.locationLongitude, locationLongitude) || other.locationLongitude == locationLongitude)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.locationAddress, locationAddress) || other.locationAddress == locationAddress)&&const DeepCollectionEquality().equals(other._contactsData, _contactsData)&&(identical(other.transcription, transcription) || other.transcription == transcription)&&(identical(other.transcriptionStatus, transcriptionStatus) || other.transcriptionStatus == transcriptionStatus)&&(identical(other.reaction, reaction) || other.reaction == reaction)&&const DeepCollectionEquality().equals(other._providerRawPayload, _providerRawPayload)&&(identical(other.templateIdRaw, templateIdRaw) || other.templateIdRaw == templateIdRaw)&&const DeepCollectionEquality().equals(other._templateData, _templateData)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.sentByUserName, sentByUserName) || other.sentByUserName == sentByUserName)&&(identical(other.deletedForEveryoneAt, deletedForEveryoneAt) || other.deletedForEveryoneAt == deletedForEveryoneAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,direction,body,status,messageType,mediaUrl,mediaMimeType,locationLatitude,locationLongitude,locationName,locationAddress,const DeepCollectionEquality().hash(_contactsData),transcription,transcriptionStatus,reaction,const DeepCollectionEquality().hash(_providerRawPayload),templateIdRaw,const DeepCollectionEquality().hash(_templateData),senderId,sentByUserName,deletedForEveryoneAt,createdAt]);

@override
String toString() {
  return 'Message(id: $id, direction: $direction, body: $body, status: $status, messageType: $messageType, mediaUrl: $mediaUrl, mediaMimeType: $mediaMimeType, locationLatitude: $locationLatitude, locationLongitude: $locationLongitude, locationName: $locationName, locationAddress: $locationAddress, contactsData: $contactsData, transcription: $transcription, transcriptionStatus: $transcriptionStatus, reaction: $reaction, providerRawPayload: $providerRawPayload, templateIdRaw: $templateIdRaw, templateData: $templateData, senderId: $senderId, sentByUserName: $sentByUserName, deletedForEveryoneAt: $deletedForEveryoneAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MessageCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$MessageCopyWith(_Message value, $Res Function(_Message) _then) = __$MessageCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: MessageDirection.inbound) MessageDirection direction, String body,@JsonKey(unknownEnumValue: MessageStatus.sent) MessageStatus status,@JsonKey(unknownEnumValue: MessageType.unknown) MessageType messageType, String? mediaUrl, String? mediaMimeType, String? locationLatitude, String? locationLongitude, String? locationName, String? locationAddress, List<dynamic>? contactsData, String? transcription, String? transcriptionStatus, String? reaction, Map<String, dynamic>? providerRawPayload,@JsonKey(name: 'templateId') String? templateIdRaw, Map<String, dynamic>? templateData, String? senderId, String? sentByUserName, String? deletedForEveryoneAt, String createdAt
});




}
/// @nodoc
class __$MessageCopyWithImpl<$Res>
    implements _$MessageCopyWith<$Res> {
  __$MessageCopyWithImpl(this._self, this._then);

  final _Message _self;
  final $Res Function(_Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? direction = null,Object? body = null,Object? status = null,Object? messageType = null,Object? mediaUrl = freezed,Object? mediaMimeType = freezed,Object? locationLatitude = freezed,Object? locationLongitude = freezed,Object? locationName = freezed,Object? locationAddress = freezed,Object? contactsData = freezed,Object? transcription = freezed,Object? transcriptionStatus = freezed,Object? reaction = freezed,Object? providerRawPayload = freezed,Object? templateIdRaw = freezed,Object? templateData = freezed,Object? senderId = freezed,Object? sentByUserName = freezed,Object? deletedForEveryoneAt = freezed,Object? createdAt = null,}) {
  return _then(_Message(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as MessageDirection,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MessageStatus,messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as MessageType,mediaUrl: freezed == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String?,mediaMimeType: freezed == mediaMimeType ? _self.mediaMimeType : mediaMimeType // ignore: cast_nullable_to_non_nullable
as String?,locationLatitude: freezed == locationLatitude ? _self.locationLatitude : locationLatitude // ignore: cast_nullable_to_non_nullable
as String?,locationLongitude: freezed == locationLongitude ? _self.locationLongitude : locationLongitude // ignore: cast_nullable_to_non_nullable
as String?,locationName: freezed == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String?,locationAddress: freezed == locationAddress ? _self.locationAddress : locationAddress // ignore: cast_nullable_to_non_nullable
as String?,contactsData: freezed == contactsData ? _self._contactsData : contactsData // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,transcription: freezed == transcription ? _self.transcription : transcription // ignore: cast_nullable_to_non_nullable
as String?,transcriptionStatus: freezed == transcriptionStatus ? _self.transcriptionStatus : transcriptionStatus // ignore: cast_nullable_to_non_nullable
as String?,reaction: freezed == reaction ? _self.reaction : reaction // ignore: cast_nullable_to_non_nullable
as String?,providerRawPayload: freezed == providerRawPayload ? _self._providerRawPayload : providerRawPayload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,templateIdRaw: freezed == templateIdRaw ? _self.templateIdRaw : templateIdRaw // ignore: cast_nullable_to_non_nullable
as String?,templateData: freezed == templateData ? _self._templateData : templateData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,senderId: freezed == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String?,sentByUserName: freezed == sentByUserName ? _self.sentByUserName : sentByUserName // ignore: cast_nullable_to_non_nullable
as String?,deletedForEveryoneAt: freezed == deletedForEveryoneAt ? _self.deletedForEveryoneAt : deletedForEveryoneAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
