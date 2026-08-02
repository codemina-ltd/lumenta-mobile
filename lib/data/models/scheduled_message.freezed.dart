// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheduled_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduledMessage {

 String get id; String get tenantId; String get clientId; String? get senderId; String? get createdByUserId; String? get templateId; String get templateName; String get templateLanguage;/// Body variables keyed by placeholder (positional "1"/"2" or named);
/// values may be numbers on the wire, so this stays `dynamic` — use
/// [variablesAsStrings] to feed them back into a fill form.
 Map<String, dynamic>? get templateVariables; Map<String, String>? get buttonVariables;/// Preview text with variables already substituted — render this in the
/// bubble/card, mirroring the sent-message body.
 String? get renderedBody; DateTime get scheduledFor;/// IANA timezone the picker was shown in, when known.
 String? get timezone;@JsonKey(unknownEnumValue: ScheduledMessageStatus.pending) ScheduledMessageStatus get status; String? get jobId; String? get sentMessageId; String? get sentAt; String? get cancelledByUserId; String? get cancelledAt; String? get cancellationReason;/// Populated when [status] is `failed`.
 String? get errorMessage; String get createdAt; String get updatedAt;
/// Create a copy of ScheduledMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduledMessageCopyWith<ScheduledMessage> get copyWith => _$ScheduledMessageCopyWithImpl<ScheduledMessage>(this as ScheduledMessage, _$identity);

  /// Serializes this ScheduledMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduledMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.templateName, templateName) || other.templateName == templateName)&&(identical(other.templateLanguage, templateLanguage) || other.templateLanguage == templateLanguage)&&const DeepCollectionEquality().equals(other.templateVariables, templateVariables)&&const DeepCollectionEquality().equals(other.buttonVariables, buttonVariables)&&(identical(other.renderedBody, renderedBody) || other.renderedBody == renderedBody)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.status, status) || other.status == status)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.sentMessageId, sentMessageId) || other.sentMessageId == sentMessageId)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.cancelledByUserId, cancelledByUserId) || other.cancelledByUserId == cancelledByUserId)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,tenantId,clientId,senderId,createdByUserId,templateId,templateName,templateLanguage,const DeepCollectionEquality().hash(templateVariables),const DeepCollectionEquality().hash(buttonVariables),renderedBody,scheduledFor,timezone,status,jobId,sentMessageId,sentAt,cancelledByUserId,cancelledAt,cancellationReason,errorMessage,createdAt,updatedAt]);

@override
String toString() {
  return 'ScheduledMessage(id: $id, tenantId: $tenantId, clientId: $clientId, senderId: $senderId, createdByUserId: $createdByUserId, templateId: $templateId, templateName: $templateName, templateLanguage: $templateLanguage, templateVariables: $templateVariables, buttonVariables: $buttonVariables, renderedBody: $renderedBody, scheduledFor: $scheduledFor, timezone: $timezone, status: $status, jobId: $jobId, sentMessageId: $sentMessageId, sentAt: $sentAt, cancelledByUserId: $cancelledByUserId, cancelledAt: $cancelledAt, cancellationReason: $cancellationReason, errorMessage: $errorMessage, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ScheduledMessageCopyWith<$Res>  {
  factory $ScheduledMessageCopyWith(ScheduledMessage value, $Res Function(ScheduledMessage) _then) = _$ScheduledMessageCopyWithImpl;
@useResult
$Res call({
 String id, String tenantId, String clientId, String? senderId, String? createdByUserId, String? templateId, String templateName, String templateLanguage, Map<String, dynamic>? templateVariables, Map<String, String>? buttonVariables, String? renderedBody, DateTime scheduledFor, String? timezone,@JsonKey(unknownEnumValue: ScheduledMessageStatus.pending) ScheduledMessageStatus status, String? jobId, String? sentMessageId, String? sentAt, String? cancelledByUserId, String? cancelledAt, String? cancellationReason, String? errorMessage, String createdAt, String updatedAt
});




}
/// @nodoc
class _$ScheduledMessageCopyWithImpl<$Res>
    implements $ScheduledMessageCopyWith<$Res> {
  _$ScheduledMessageCopyWithImpl(this._self, this._then);

  final ScheduledMessage _self;
  final $Res Function(ScheduledMessage) _then;

/// Create a copy of ScheduledMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tenantId = null,Object? clientId = null,Object? senderId = freezed,Object? createdByUserId = freezed,Object? templateId = freezed,Object? templateName = null,Object? templateLanguage = null,Object? templateVariables = freezed,Object? buttonVariables = freezed,Object? renderedBody = freezed,Object? scheduledFor = null,Object? timezone = freezed,Object? status = null,Object? jobId = freezed,Object? sentMessageId = freezed,Object? sentAt = freezed,Object? cancelledByUserId = freezed,Object? cancelledAt = freezed,Object? cancellationReason = freezed,Object? errorMessage = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,senderId: freezed == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: freezed == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String?,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String?,templateName: null == templateName ? _self.templateName : templateName // ignore: cast_nullable_to_non_nullable
as String,templateLanguage: null == templateLanguage ? _self.templateLanguage : templateLanguage // ignore: cast_nullable_to_non_nullable
as String,templateVariables: freezed == templateVariables ? _self.templateVariables : templateVariables // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,buttonVariables: freezed == buttonVariables ? _self.buttonVariables : buttonVariables // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,renderedBody: freezed == renderedBody ? _self.renderedBody : renderedBody // ignore: cast_nullable_to_non_nullable
as String?,scheduledFor: null == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScheduledMessageStatus,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,sentMessageId: freezed == sentMessageId ? _self.sentMessageId : sentMessageId // ignore: cast_nullable_to_non_nullable
as String?,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as String?,cancelledByUserId: freezed == cancelledByUserId ? _self.cancelledByUserId : cancelledByUserId // ignore: cast_nullable_to_non_nullable
as String?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as String?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduledMessage].
extension ScheduledMessagePatterns on ScheduledMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduledMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduledMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduledMessage value)  $default,){
final _that = this;
switch (_that) {
case _ScheduledMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduledMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduledMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tenantId,  String clientId,  String? senderId,  String? createdByUserId,  String? templateId,  String templateName,  String templateLanguage,  Map<String, dynamic>? templateVariables,  Map<String, String>? buttonVariables,  String? renderedBody,  DateTime scheduledFor,  String? timezone, @JsonKey(unknownEnumValue: ScheduledMessageStatus.pending)  ScheduledMessageStatus status,  String? jobId,  String? sentMessageId,  String? sentAt,  String? cancelledByUserId,  String? cancelledAt,  String? cancellationReason,  String? errorMessage,  String createdAt,  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduledMessage() when $default != null:
return $default(_that.id,_that.tenantId,_that.clientId,_that.senderId,_that.createdByUserId,_that.templateId,_that.templateName,_that.templateLanguage,_that.templateVariables,_that.buttonVariables,_that.renderedBody,_that.scheduledFor,_that.timezone,_that.status,_that.jobId,_that.sentMessageId,_that.sentAt,_that.cancelledByUserId,_that.cancelledAt,_that.cancellationReason,_that.errorMessage,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tenantId,  String clientId,  String? senderId,  String? createdByUserId,  String? templateId,  String templateName,  String templateLanguage,  Map<String, dynamic>? templateVariables,  Map<String, String>? buttonVariables,  String? renderedBody,  DateTime scheduledFor,  String? timezone, @JsonKey(unknownEnumValue: ScheduledMessageStatus.pending)  ScheduledMessageStatus status,  String? jobId,  String? sentMessageId,  String? sentAt,  String? cancelledByUserId,  String? cancelledAt,  String? cancellationReason,  String? errorMessage,  String createdAt,  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ScheduledMessage():
return $default(_that.id,_that.tenantId,_that.clientId,_that.senderId,_that.createdByUserId,_that.templateId,_that.templateName,_that.templateLanguage,_that.templateVariables,_that.buttonVariables,_that.renderedBody,_that.scheduledFor,_that.timezone,_that.status,_that.jobId,_that.sentMessageId,_that.sentAt,_that.cancelledByUserId,_that.cancelledAt,_that.cancellationReason,_that.errorMessage,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tenantId,  String clientId,  String? senderId,  String? createdByUserId,  String? templateId,  String templateName,  String templateLanguage,  Map<String, dynamic>? templateVariables,  Map<String, String>? buttonVariables,  String? renderedBody,  DateTime scheduledFor,  String? timezone, @JsonKey(unknownEnumValue: ScheduledMessageStatus.pending)  ScheduledMessageStatus status,  String? jobId,  String? sentMessageId,  String? sentAt,  String? cancelledByUserId,  String? cancelledAt,  String? cancellationReason,  String? errorMessage,  String createdAt,  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ScheduledMessage() when $default != null:
return $default(_that.id,_that.tenantId,_that.clientId,_that.senderId,_that.createdByUserId,_that.templateId,_that.templateName,_that.templateLanguage,_that.templateVariables,_that.buttonVariables,_that.renderedBody,_that.scheduledFor,_that.timezone,_that.status,_that.jobId,_that.sentMessageId,_that.sentAt,_that.cancelledByUserId,_that.cancelledAt,_that.cancellationReason,_that.errorMessage,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduledMessage extends ScheduledMessage {
  const _ScheduledMessage({required this.id, required this.tenantId, required this.clientId, this.senderId, this.createdByUserId, this.templateId, required this.templateName, this.templateLanguage = 'en', final  Map<String, dynamic>? templateVariables, final  Map<String, String>? buttonVariables, this.renderedBody, required this.scheduledFor, this.timezone, @JsonKey(unknownEnumValue: ScheduledMessageStatus.pending) this.status = ScheduledMessageStatus.pending, this.jobId, this.sentMessageId, this.sentAt, this.cancelledByUserId, this.cancelledAt, this.cancellationReason, this.errorMessage, required this.createdAt, required this.updatedAt}): _templateVariables = templateVariables,_buttonVariables = buttonVariables,super._();
  factory _ScheduledMessage.fromJson(Map<String, dynamic> json) => _$ScheduledMessageFromJson(json);

@override final  String id;
@override final  String tenantId;
@override final  String clientId;
@override final  String? senderId;
@override final  String? createdByUserId;
@override final  String? templateId;
@override final  String templateName;
@override@JsonKey() final  String templateLanguage;
/// Body variables keyed by placeholder (positional "1"/"2" or named);
/// values may be numbers on the wire, so this stays `dynamic` — use
/// [variablesAsStrings] to feed them back into a fill form.
 final  Map<String, dynamic>? _templateVariables;
/// Body variables keyed by placeholder (positional "1"/"2" or named);
/// values may be numbers on the wire, so this stays `dynamic` — use
/// [variablesAsStrings] to feed them back into a fill form.
@override Map<String, dynamic>? get templateVariables {
  final value = _templateVariables;
  if (value == null) return null;
  if (_templateVariables is EqualUnmodifiableMapView) return _templateVariables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, String>? _buttonVariables;
@override Map<String, String>? get buttonVariables {
  final value = _buttonVariables;
  if (value == null) return null;
  if (_buttonVariables is EqualUnmodifiableMapView) return _buttonVariables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

/// Preview text with variables already substituted — render this in the
/// bubble/card, mirroring the sent-message body.
@override final  String? renderedBody;
@override final  DateTime scheduledFor;
/// IANA timezone the picker was shown in, when known.
@override final  String? timezone;
@override@JsonKey(unknownEnumValue: ScheduledMessageStatus.pending) final  ScheduledMessageStatus status;
@override final  String? jobId;
@override final  String? sentMessageId;
@override final  String? sentAt;
@override final  String? cancelledByUserId;
@override final  String? cancelledAt;
@override final  String? cancellationReason;
/// Populated when [status] is `failed`.
@override final  String? errorMessage;
@override final  String createdAt;
@override final  String updatedAt;

/// Create a copy of ScheduledMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduledMessageCopyWith<_ScheduledMessage> get copyWith => __$ScheduledMessageCopyWithImpl<_ScheduledMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduledMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduledMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.templateName, templateName) || other.templateName == templateName)&&(identical(other.templateLanguage, templateLanguage) || other.templateLanguage == templateLanguage)&&const DeepCollectionEquality().equals(other._templateVariables, _templateVariables)&&const DeepCollectionEquality().equals(other._buttonVariables, _buttonVariables)&&(identical(other.renderedBody, renderedBody) || other.renderedBody == renderedBody)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.status, status) || other.status == status)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.sentMessageId, sentMessageId) || other.sentMessageId == sentMessageId)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.cancelledByUserId, cancelledByUserId) || other.cancelledByUserId == cancelledByUserId)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,tenantId,clientId,senderId,createdByUserId,templateId,templateName,templateLanguage,const DeepCollectionEquality().hash(_templateVariables),const DeepCollectionEquality().hash(_buttonVariables),renderedBody,scheduledFor,timezone,status,jobId,sentMessageId,sentAt,cancelledByUserId,cancelledAt,cancellationReason,errorMessage,createdAt,updatedAt]);

@override
String toString() {
  return 'ScheduledMessage(id: $id, tenantId: $tenantId, clientId: $clientId, senderId: $senderId, createdByUserId: $createdByUserId, templateId: $templateId, templateName: $templateName, templateLanguage: $templateLanguage, templateVariables: $templateVariables, buttonVariables: $buttonVariables, renderedBody: $renderedBody, scheduledFor: $scheduledFor, timezone: $timezone, status: $status, jobId: $jobId, sentMessageId: $sentMessageId, sentAt: $sentAt, cancelledByUserId: $cancelledByUserId, cancelledAt: $cancelledAt, cancellationReason: $cancellationReason, errorMessage: $errorMessage, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ScheduledMessageCopyWith<$Res> implements $ScheduledMessageCopyWith<$Res> {
  factory _$ScheduledMessageCopyWith(_ScheduledMessage value, $Res Function(_ScheduledMessage) _then) = __$ScheduledMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String tenantId, String clientId, String? senderId, String? createdByUserId, String? templateId, String templateName, String templateLanguage, Map<String, dynamic>? templateVariables, Map<String, String>? buttonVariables, String? renderedBody, DateTime scheduledFor, String? timezone,@JsonKey(unknownEnumValue: ScheduledMessageStatus.pending) ScheduledMessageStatus status, String? jobId, String? sentMessageId, String? sentAt, String? cancelledByUserId, String? cancelledAt, String? cancellationReason, String? errorMessage, String createdAt, String updatedAt
});




}
/// @nodoc
class __$ScheduledMessageCopyWithImpl<$Res>
    implements _$ScheduledMessageCopyWith<$Res> {
  __$ScheduledMessageCopyWithImpl(this._self, this._then);

  final _ScheduledMessage _self;
  final $Res Function(_ScheduledMessage) _then;

/// Create a copy of ScheduledMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tenantId = null,Object? clientId = null,Object? senderId = freezed,Object? createdByUserId = freezed,Object? templateId = freezed,Object? templateName = null,Object? templateLanguage = null,Object? templateVariables = freezed,Object? buttonVariables = freezed,Object? renderedBody = freezed,Object? scheduledFor = null,Object? timezone = freezed,Object? status = null,Object? jobId = freezed,Object? sentMessageId = freezed,Object? sentAt = freezed,Object? cancelledByUserId = freezed,Object? cancelledAt = freezed,Object? cancellationReason = freezed,Object? errorMessage = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ScheduledMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,senderId: freezed == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: freezed == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String?,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String?,templateName: null == templateName ? _self.templateName : templateName // ignore: cast_nullable_to_non_nullable
as String,templateLanguage: null == templateLanguage ? _self.templateLanguage : templateLanguage // ignore: cast_nullable_to_non_nullable
as String,templateVariables: freezed == templateVariables ? _self._templateVariables : templateVariables // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,buttonVariables: freezed == buttonVariables ? _self._buttonVariables : buttonVariables // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,renderedBody: freezed == renderedBody ? _self.renderedBody : renderedBody // ignore: cast_nullable_to_non_nullable
as String?,scheduledFor: null == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScheduledMessageStatus,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,sentMessageId: freezed == sentMessageId ? _self.sentMessageId : sentMessageId // ignore: cast_nullable_to_non_nullable
as String?,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as String?,cancelledByUserId: freezed == cancelledByUserId ? _self.cancelledByUserId : cancelledByUserId // ignore: cast_nullable_to_non_nullable
as String?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as String?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ScheduledMessageEvent {

 String get id; String get scheduledMessageId; String get tenantId;@JsonKey(unknownEnumValue: ScheduledMessageEventType.scheduled) ScheduledMessageEventType get eventType; String? get actorUserId; String get actorKind; Map<String, dynamic>? get metadata; String get createdAt;
/// Create a copy of ScheduledMessageEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduledMessageEventCopyWith<ScheduledMessageEvent> get copyWith => _$ScheduledMessageEventCopyWithImpl<ScheduledMessageEvent>(this as ScheduledMessageEvent, _$identity);

  /// Serializes this ScheduledMessageEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduledMessageEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.scheduledMessageId, scheduledMessageId) || other.scheduledMessageId == scheduledMessageId)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.actorUserId, actorUserId) || other.actorUserId == actorUserId)&&(identical(other.actorKind, actorKind) || other.actorKind == actorKind)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scheduledMessageId,tenantId,eventType,actorUserId,actorKind,const DeepCollectionEquality().hash(metadata),createdAt);

@override
String toString() {
  return 'ScheduledMessageEvent(id: $id, scheduledMessageId: $scheduledMessageId, tenantId: $tenantId, eventType: $eventType, actorUserId: $actorUserId, actorKind: $actorKind, metadata: $metadata, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ScheduledMessageEventCopyWith<$Res>  {
  factory $ScheduledMessageEventCopyWith(ScheduledMessageEvent value, $Res Function(ScheduledMessageEvent) _then) = _$ScheduledMessageEventCopyWithImpl;
@useResult
$Res call({
 String id, String scheduledMessageId, String tenantId,@JsonKey(unknownEnumValue: ScheduledMessageEventType.scheduled) ScheduledMessageEventType eventType, String? actorUserId, String actorKind, Map<String, dynamic>? metadata, String createdAt
});




}
/// @nodoc
class _$ScheduledMessageEventCopyWithImpl<$Res>
    implements $ScheduledMessageEventCopyWith<$Res> {
  _$ScheduledMessageEventCopyWithImpl(this._self, this._then);

  final ScheduledMessageEvent _self;
  final $Res Function(ScheduledMessageEvent) _then;

/// Create a copy of ScheduledMessageEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? scheduledMessageId = null,Object? tenantId = null,Object? eventType = null,Object? actorUserId = freezed,Object? actorKind = null,Object? metadata = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scheduledMessageId: null == scheduledMessageId ? _self.scheduledMessageId : scheduledMessageId // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as ScheduledMessageEventType,actorUserId: freezed == actorUserId ? _self.actorUserId : actorUserId // ignore: cast_nullable_to_non_nullable
as String?,actorKind: null == actorKind ? _self.actorKind : actorKind // ignore: cast_nullable_to_non_nullable
as String,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduledMessageEvent].
extension ScheduledMessageEventPatterns on ScheduledMessageEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduledMessageEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduledMessageEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduledMessageEvent value)  $default,){
final _that = this;
switch (_that) {
case _ScheduledMessageEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduledMessageEvent value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduledMessageEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String scheduledMessageId,  String tenantId, @JsonKey(unknownEnumValue: ScheduledMessageEventType.scheduled)  ScheduledMessageEventType eventType,  String? actorUserId,  String actorKind,  Map<String, dynamic>? metadata,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduledMessageEvent() when $default != null:
return $default(_that.id,_that.scheduledMessageId,_that.tenantId,_that.eventType,_that.actorUserId,_that.actorKind,_that.metadata,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String scheduledMessageId,  String tenantId, @JsonKey(unknownEnumValue: ScheduledMessageEventType.scheduled)  ScheduledMessageEventType eventType,  String? actorUserId,  String actorKind,  Map<String, dynamic>? metadata,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _ScheduledMessageEvent():
return $default(_that.id,_that.scheduledMessageId,_that.tenantId,_that.eventType,_that.actorUserId,_that.actorKind,_that.metadata,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String scheduledMessageId,  String tenantId, @JsonKey(unknownEnumValue: ScheduledMessageEventType.scheduled)  ScheduledMessageEventType eventType,  String? actorUserId,  String actorKind,  Map<String, dynamic>? metadata,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ScheduledMessageEvent() when $default != null:
return $default(_that.id,_that.scheduledMessageId,_that.tenantId,_that.eventType,_that.actorUserId,_that.actorKind,_that.metadata,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduledMessageEvent extends ScheduledMessageEvent {
  const _ScheduledMessageEvent({required this.id, required this.scheduledMessageId, required this.tenantId, @JsonKey(unknownEnumValue: ScheduledMessageEventType.scheduled) required this.eventType, this.actorUserId, this.actorKind = 'user', final  Map<String, dynamic>? metadata, required this.createdAt}): _metadata = metadata,super._();
  factory _ScheduledMessageEvent.fromJson(Map<String, dynamic> json) => _$ScheduledMessageEventFromJson(json);

@override final  String id;
@override final  String scheduledMessageId;
@override final  String tenantId;
@override@JsonKey(unknownEnumValue: ScheduledMessageEventType.scheduled) final  ScheduledMessageEventType eventType;
@override final  String? actorUserId;
@override@JsonKey() final  String actorKind;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String createdAt;

/// Create a copy of ScheduledMessageEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduledMessageEventCopyWith<_ScheduledMessageEvent> get copyWith => __$ScheduledMessageEventCopyWithImpl<_ScheduledMessageEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduledMessageEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduledMessageEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.scheduledMessageId, scheduledMessageId) || other.scheduledMessageId == scheduledMessageId)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.actorUserId, actorUserId) || other.actorUserId == actorUserId)&&(identical(other.actorKind, actorKind) || other.actorKind == actorKind)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scheduledMessageId,tenantId,eventType,actorUserId,actorKind,const DeepCollectionEquality().hash(_metadata),createdAt);

@override
String toString() {
  return 'ScheduledMessageEvent(id: $id, scheduledMessageId: $scheduledMessageId, tenantId: $tenantId, eventType: $eventType, actorUserId: $actorUserId, actorKind: $actorKind, metadata: $metadata, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ScheduledMessageEventCopyWith<$Res> implements $ScheduledMessageEventCopyWith<$Res> {
  factory _$ScheduledMessageEventCopyWith(_ScheduledMessageEvent value, $Res Function(_ScheduledMessageEvent) _then) = __$ScheduledMessageEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String scheduledMessageId, String tenantId,@JsonKey(unknownEnumValue: ScheduledMessageEventType.scheduled) ScheduledMessageEventType eventType, String? actorUserId, String actorKind, Map<String, dynamic>? metadata, String createdAt
});




}
/// @nodoc
class __$ScheduledMessageEventCopyWithImpl<$Res>
    implements _$ScheduledMessageEventCopyWith<$Res> {
  __$ScheduledMessageEventCopyWithImpl(this._self, this._then);

  final _ScheduledMessageEvent _self;
  final $Res Function(_ScheduledMessageEvent) _then;

/// Create a copy of ScheduledMessageEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? scheduledMessageId = null,Object? tenantId = null,Object? eventType = null,Object? actorUserId = freezed,Object? actorKind = null,Object? metadata = freezed,Object? createdAt = null,}) {
  return _then(_ScheduledMessageEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scheduledMessageId: null == scheduledMessageId ? _self.scheduledMessageId : scheduledMessageId // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as ScheduledMessageEventType,actorUserId: freezed == actorUserId ? _self.actorUserId : actorUserId // ignore: cast_nullable_to_non_nullable
as String?,actorKind: null == actorKind ? _self.actorKind : actorKind // ignore: cast_nullable_to_non_nullable
as String,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
