// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inbox_thread.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InboxThreadContact {

 String get id; String get phoneNumber; String? get profileName;
/// Create a copy of InboxThreadContact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InboxThreadContactCopyWith<InboxThreadContact> get copyWith => _$InboxThreadContactCopyWithImpl<InboxThreadContact>(this as InboxThreadContact, _$identity);

  /// Serializes this InboxThreadContact to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InboxThreadContact&&(identical(other.id, id) || other.id == id)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.profileName, profileName) || other.profileName == profileName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,phoneNumber,profileName);

@override
String toString() {
  return 'InboxThreadContact(id: $id, phoneNumber: $phoneNumber, profileName: $profileName)';
}


}

/// @nodoc
abstract mixin class $InboxThreadContactCopyWith<$Res>  {
  factory $InboxThreadContactCopyWith(InboxThreadContact value, $Res Function(InboxThreadContact) _then) = _$InboxThreadContactCopyWithImpl;
@useResult
$Res call({
 String id, String phoneNumber, String? profileName
});




}
/// @nodoc
class _$InboxThreadContactCopyWithImpl<$Res>
    implements $InboxThreadContactCopyWith<$Res> {
  _$InboxThreadContactCopyWithImpl(this._self, this._then);

  final InboxThreadContact _self;
  final $Res Function(InboxThreadContact) _then;

/// Create a copy of InboxThreadContact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? phoneNumber = null,Object? profileName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,profileName: freezed == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InboxThreadContact].
extension InboxThreadContactPatterns on InboxThreadContact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InboxThreadContact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InboxThreadContact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InboxThreadContact value)  $default,){
final _that = this;
switch (_that) {
case _InboxThreadContact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InboxThreadContact value)?  $default,){
final _that = this;
switch (_that) {
case _InboxThreadContact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String phoneNumber,  String? profileName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InboxThreadContact() when $default != null:
return $default(_that.id,_that.phoneNumber,_that.profileName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String phoneNumber,  String? profileName)  $default,) {final _that = this;
switch (_that) {
case _InboxThreadContact():
return $default(_that.id,_that.phoneNumber,_that.profileName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String phoneNumber,  String? profileName)?  $default,) {final _that = this;
switch (_that) {
case _InboxThreadContact() when $default != null:
return $default(_that.id,_that.phoneNumber,_that.profileName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InboxThreadContact implements InboxThreadContact {
  const _InboxThreadContact({required this.id, required this.phoneNumber, this.profileName});
  factory _InboxThreadContact.fromJson(Map<String, dynamic> json) => _$InboxThreadContactFromJson(json);

@override final  String id;
@override final  String phoneNumber;
@override final  String? profileName;

/// Create a copy of InboxThreadContact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InboxThreadContactCopyWith<_InboxThreadContact> get copyWith => __$InboxThreadContactCopyWithImpl<_InboxThreadContact>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InboxThreadContactToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InboxThreadContact&&(identical(other.id, id) || other.id == id)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.profileName, profileName) || other.profileName == profileName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,phoneNumber,profileName);

@override
String toString() {
  return 'InboxThreadContact(id: $id, phoneNumber: $phoneNumber, profileName: $profileName)';
}


}

/// @nodoc
abstract mixin class _$InboxThreadContactCopyWith<$Res> implements $InboxThreadContactCopyWith<$Res> {
  factory _$InboxThreadContactCopyWith(_InboxThreadContact value, $Res Function(_InboxThreadContact) _then) = __$InboxThreadContactCopyWithImpl;
@override @useResult
$Res call({
 String id, String phoneNumber, String? profileName
});




}
/// @nodoc
class __$InboxThreadContactCopyWithImpl<$Res>
    implements _$InboxThreadContactCopyWith<$Res> {
  __$InboxThreadContactCopyWithImpl(this._self, this._then);

  final _InboxThreadContact _self;
  final $Res Function(_InboxThreadContact) _then;

/// Create a copy of InboxThreadContact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? phoneNumber = null,Object? profileName = freezed,}) {
  return _then(_InboxThreadContact(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,profileName: freezed == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$InboxThread {

 String get id; String get senderId; String get clientId; String get status; String? get assignedUserId; String get priority; String? get snoozedUntil; String? get lastInboundAt; String? get lastOutboundAt; int get unreadCount; String? get serviceWindowExpiresAt; String? get updatedAt; List<InboxLabel> get labels; InboxThreadContact? get client;
/// Create a copy of InboxThread
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InboxThreadCopyWith<InboxThread> get copyWith => _$InboxThreadCopyWithImpl<InboxThread>(this as InboxThread, _$identity);

  /// Serializes this InboxThread to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InboxThread&&(identical(other.id, id) || other.id == id)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.status, status) || other.status == status)&&(identical(other.assignedUserId, assignedUserId) || other.assignedUserId == assignedUserId)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.snoozedUntil, snoozedUntil) || other.snoozedUntil == snoozedUntil)&&(identical(other.lastInboundAt, lastInboundAt) || other.lastInboundAt == lastInboundAt)&&(identical(other.lastOutboundAt, lastOutboundAt) || other.lastOutboundAt == lastOutboundAt)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.serviceWindowExpiresAt, serviceWindowExpiresAt) || other.serviceWindowExpiresAt == serviceWindowExpiresAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.labels, labels)&&(identical(other.client, client) || other.client == client));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,senderId,clientId,status,assignedUserId,priority,snoozedUntil,lastInboundAt,lastOutboundAt,unreadCount,serviceWindowExpiresAt,updatedAt,const DeepCollectionEquality().hash(labels),client);

@override
String toString() {
  return 'InboxThread(id: $id, senderId: $senderId, clientId: $clientId, status: $status, assignedUserId: $assignedUserId, priority: $priority, snoozedUntil: $snoozedUntil, lastInboundAt: $lastInboundAt, lastOutboundAt: $lastOutboundAt, unreadCount: $unreadCount, serviceWindowExpiresAt: $serviceWindowExpiresAt, updatedAt: $updatedAt, labels: $labels, client: $client)';
}


}

/// @nodoc
abstract mixin class $InboxThreadCopyWith<$Res>  {
  factory $InboxThreadCopyWith(InboxThread value, $Res Function(InboxThread) _then) = _$InboxThreadCopyWithImpl;
@useResult
$Res call({
 String id, String senderId, String clientId, String status, String? assignedUserId, String priority, String? snoozedUntil, String? lastInboundAt, String? lastOutboundAt, int unreadCount, String? serviceWindowExpiresAt, String? updatedAt, List<InboxLabel> labels, InboxThreadContact? client
});


$InboxThreadContactCopyWith<$Res>? get client;

}
/// @nodoc
class _$InboxThreadCopyWithImpl<$Res>
    implements $InboxThreadCopyWith<$Res> {
  _$InboxThreadCopyWithImpl(this._self, this._then);

  final InboxThread _self;
  final $Res Function(InboxThread) _then;

/// Create a copy of InboxThread
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? senderId = null,Object? clientId = null,Object? status = null,Object? assignedUserId = freezed,Object? priority = null,Object? snoozedUntil = freezed,Object? lastInboundAt = freezed,Object? lastOutboundAt = freezed,Object? unreadCount = null,Object? serviceWindowExpiresAt = freezed,Object? updatedAt = freezed,Object? labels = null,Object? client = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,assignedUserId: freezed == assignedUserId ? _self.assignedUserId : assignedUserId // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,snoozedUntil: freezed == snoozedUntil ? _self.snoozedUntil : snoozedUntil // ignore: cast_nullable_to_non_nullable
as String?,lastInboundAt: freezed == lastInboundAt ? _self.lastInboundAt : lastInboundAt // ignore: cast_nullable_to_non_nullable
as String?,lastOutboundAt: freezed == lastOutboundAt ? _self.lastOutboundAt : lastOutboundAt // ignore: cast_nullable_to_non_nullable
as String?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,serviceWindowExpiresAt: freezed == serviceWindowExpiresAt ? _self.serviceWindowExpiresAt : serviceWindowExpiresAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<InboxLabel>,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as InboxThreadContact?,
  ));
}
/// Create a copy of InboxThread
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InboxThreadContactCopyWith<$Res>? get client {
    if (_self.client == null) {
    return null;
  }

  return $InboxThreadContactCopyWith<$Res>(_self.client!, (value) {
    return _then(_self.copyWith(client: value));
  });
}
}


/// Adds pattern-matching-related methods to [InboxThread].
extension InboxThreadPatterns on InboxThread {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InboxThread value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InboxThread() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InboxThread value)  $default,){
final _that = this;
switch (_that) {
case _InboxThread():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InboxThread value)?  $default,){
final _that = this;
switch (_that) {
case _InboxThread() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String senderId,  String clientId,  String status,  String? assignedUserId,  String priority,  String? snoozedUntil,  String? lastInboundAt,  String? lastOutboundAt,  int unreadCount,  String? serviceWindowExpiresAt,  String? updatedAt,  List<InboxLabel> labels,  InboxThreadContact? client)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InboxThread() when $default != null:
return $default(_that.id,_that.senderId,_that.clientId,_that.status,_that.assignedUserId,_that.priority,_that.snoozedUntil,_that.lastInboundAt,_that.lastOutboundAt,_that.unreadCount,_that.serviceWindowExpiresAt,_that.updatedAt,_that.labels,_that.client);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String senderId,  String clientId,  String status,  String? assignedUserId,  String priority,  String? snoozedUntil,  String? lastInboundAt,  String? lastOutboundAt,  int unreadCount,  String? serviceWindowExpiresAt,  String? updatedAt,  List<InboxLabel> labels,  InboxThreadContact? client)  $default,) {final _that = this;
switch (_that) {
case _InboxThread():
return $default(_that.id,_that.senderId,_that.clientId,_that.status,_that.assignedUserId,_that.priority,_that.snoozedUntil,_that.lastInboundAt,_that.lastOutboundAt,_that.unreadCount,_that.serviceWindowExpiresAt,_that.updatedAt,_that.labels,_that.client);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String senderId,  String clientId,  String status,  String? assignedUserId,  String priority,  String? snoozedUntil,  String? lastInboundAt,  String? lastOutboundAt,  int unreadCount,  String? serviceWindowExpiresAt,  String? updatedAt,  List<InboxLabel> labels,  InboxThreadContact? client)?  $default,) {final _that = this;
switch (_that) {
case _InboxThread() when $default != null:
return $default(_that.id,_that.senderId,_that.clientId,_that.status,_that.assignedUserId,_that.priority,_that.snoozedUntil,_that.lastInboundAt,_that.lastOutboundAt,_that.unreadCount,_that.serviceWindowExpiresAt,_that.updatedAt,_that.labels,_that.client);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InboxThread extends InboxThread {
  const _InboxThread({required this.id, required this.senderId, required this.clientId, this.status = 'open', this.assignedUserId, this.priority = 'normal', this.snoozedUntil, this.lastInboundAt, this.lastOutboundAt, this.unreadCount = 0, this.serviceWindowExpiresAt, this.updatedAt, final  List<InboxLabel> labels = const <InboxLabel>[], this.client}): _labels = labels,super._();
  factory _InboxThread.fromJson(Map<String, dynamic> json) => _$InboxThreadFromJson(json);

@override final  String id;
@override final  String senderId;
@override final  String clientId;
@override@JsonKey() final  String status;
@override final  String? assignedUserId;
@override@JsonKey() final  String priority;
@override final  String? snoozedUntil;
@override final  String? lastInboundAt;
@override final  String? lastOutboundAt;
@override@JsonKey() final  int unreadCount;
@override final  String? serviceWindowExpiresAt;
@override final  String? updatedAt;
 final  List<InboxLabel> _labels;
@override@JsonKey() List<InboxLabel> get labels {
  if (_labels is EqualUnmodifiableListView) return _labels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_labels);
}

@override final  InboxThreadContact? client;

/// Create a copy of InboxThread
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InboxThreadCopyWith<_InboxThread> get copyWith => __$InboxThreadCopyWithImpl<_InboxThread>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InboxThreadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InboxThread&&(identical(other.id, id) || other.id == id)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.status, status) || other.status == status)&&(identical(other.assignedUserId, assignedUserId) || other.assignedUserId == assignedUserId)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.snoozedUntil, snoozedUntil) || other.snoozedUntil == snoozedUntil)&&(identical(other.lastInboundAt, lastInboundAt) || other.lastInboundAt == lastInboundAt)&&(identical(other.lastOutboundAt, lastOutboundAt) || other.lastOutboundAt == lastOutboundAt)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.serviceWindowExpiresAt, serviceWindowExpiresAt) || other.serviceWindowExpiresAt == serviceWindowExpiresAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._labels, _labels)&&(identical(other.client, client) || other.client == client));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,senderId,clientId,status,assignedUserId,priority,snoozedUntil,lastInboundAt,lastOutboundAt,unreadCount,serviceWindowExpiresAt,updatedAt,const DeepCollectionEquality().hash(_labels),client);

@override
String toString() {
  return 'InboxThread(id: $id, senderId: $senderId, clientId: $clientId, status: $status, assignedUserId: $assignedUserId, priority: $priority, snoozedUntil: $snoozedUntil, lastInboundAt: $lastInboundAt, lastOutboundAt: $lastOutboundAt, unreadCount: $unreadCount, serviceWindowExpiresAt: $serviceWindowExpiresAt, updatedAt: $updatedAt, labels: $labels, client: $client)';
}


}

/// @nodoc
abstract mixin class _$InboxThreadCopyWith<$Res> implements $InboxThreadCopyWith<$Res> {
  factory _$InboxThreadCopyWith(_InboxThread value, $Res Function(_InboxThread) _then) = __$InboxThreadCopyWithImpl;
@override @useResult
$Res call({
 String id, String senderId, String clientId, String status, String? assignedUserId, String priority, String? snoozedUntil, String? lastInboundAt, String? lastOutboundAt, int unreadCount, String? serviceWindowExpiresAt, String? updatedAt, List<InboxLabel> labels, InboxThreadContact? client
});


@override $InboxThreadContactCopyWith<$Res>? get client;

}
/// @nodoc
class __$InboxThreadCopyWithImpl<$Res>
    implements _$InboxThreadCopyWith<$Res> {
  __$InboxThreadCopyWithImpl(this._self, this._then);

  final _InboxThread _self;
  final $Res Function(_InboxThread) _then;

/// Create a copy of InboxThread
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? senderId = null,Object? clientId = null,Object? status = null,Object? assignedUserId = freezed,Object? priority = null,Object? snoozedUntil = freezed,Object? lastInboundAt = freezed,Object? lastOutboundAt = freezed,Object? unreadCount = null,Object? serviceWindowExpiresAt = freezed,Object? updatedAt = freezed,Object? labels = null,Object? client = freezed,}) {
  return _then(_InboxThread(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,assignedUserId: freezed == assignedUserId ? _self.assignedUserId : assignedUserId // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,snoozedUntil: freezed == snoozedUntil ? _self.snoozedUntil : snoozedUntil // ignore: cast_nullable_to_non_nullable
as String?,lastInboundAt: freezed == lastInboundAt ? _self.lastInboundAt : lastInboundAt // ignore: cast_nullable_to_non_nullable
as String?,lastOutboundAt: freezed == lastOutboundAt ? _self.lastOutboundAt : lastOutboundAt // ignore: cast_nullable_to_non_nullable
as String?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,serviceWindowExpiresAt: freezed == serviceWindowExpiresAt ? _self.serviceWindowExpiresAt : serviceWindowExpiresAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,labels: null == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as List<InboxLabel>,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as InboxThreadContact?,
  ));
}

/// Create a copy of InboxThread
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InboxThreadContactCopyWith<$Res>? get client {
    if (_self.client == null) {
    return null;
  }

  return $InboxThreadContactCopyWith<$Res>(_self.client!, (value) {
    return _then(_self.copyWith(client: value));
  });
}
}

// dart format on
