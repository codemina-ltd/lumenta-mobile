// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Reminder {

 String get id; String? get clientId; String? get messageId;/// NULL = the shared team queue (visible in the portal; the mobile
/// list is mine-only so queue rows normally don't appear here).
 String? get assignedToUserId;/// NULL = created by a smart trigger.
 String? get createdByUserId; String get title; String? get notes;@JsonKey(unknownEnumValue: ReminderPriority.normal) ReminderPriority get priority; String get dueAt;@JsonKey(unknownEnumValue: ReminderStatus.pending) ReminderStatus get status;@JsonKey(unknownEnumValue: ReminderRecurrence.none) ReminderRecurrence get recurrence;@JsonKey(unknownEnumValue: ReminderSource.manual) ReminderSource get source; int get snoozeCount;
/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderCopyWith<Reminder> get copyWith => _$ReminderCopyWithImpl<Reminder>(this as Reminder, _$identity);

  /// Serializes this Reminder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reminder&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.assignedToUserId, assignedToUserId) || other.assignedToUserId == assignedToUserId)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.title, title) || other.title == title)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.source, source) || other.source == source)&&(identical(other.snoozeCount, snoozeCount) || other.snoozeCount == snoozeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,messageId,assignedToUserId,createdByUserId,title,notes,priority,dueAt,status,recurrence,source,snoozeCount);

@override
String toString() {
  return 'Reminder(id: $id, clientId: $clientId, messageId: $messageId, assignedToUserId: $assignedToUserId, createdByUserId: $createdByUserId, title: $title, notes: $notes, priority: $priority, dueAt: $dueAt, status: $status, recurrence: $recurrence, source: $source, snoozeCount: $snoozeCount)';
}


}

/// @nodoc
abstract mixin class $ReminderCopyWith<$Res>  {
  factory $ReminderCopyWith(Reminder value, $Res Function(Reminder) _then) = _$ReminderCopyWithImpl;
@useResult
$Res call({
 String id, String? clientId, String? messageId, String? assignedToUserId, String? createdByUserId, String title, String? notes,@JsonKey(unknownEnumValue: ReminderPriority.normal) ReminderPriority priority, String dueAt,@JsonKey(unknownEnumValue: ReminderStatus.pending) ReminderStatus status,@JsonKey(unknownEnumValue: ReminderRecurrence.none) ReminderRecurrence recurrence,@JsonKey(unknownEnumValue: ReminderSource.manual) ReminderSource source, int snoozeCount
});




}
/// @nodoc
class _$ReminderCopyWithImpl<$Res>
    implements $ReminderCopyWith<$Res> {
  _$ReminderCopyWithImpl(this._self, this._then);

  final Reminder _self;
  final $Res Function(Reminder) _then;

/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clientId = freezed,Object? messageId = freezed,Object? assignedToUserId = freezed,Object? createdByUserId = freezed,Object? title = null,Object? notes = freezed,Object? priority = null,Object? dueAt = null,Object? status = null,Object? recurrence = null,Object? source = null,Object? snoozeCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,messageId: freezed == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String?,assignedToUserId: freezed == assignedToUserId ? _self.assignedToUserId : assignedToUserId // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: freezed == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as ReminderPriority,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReminderStatus,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as ReminderRecurrence,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ReminderSource,snoozeCount: null == snoozeCount ? _self.snoozeCount : snoozeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Reminder].
extension ReminderPatterns on Reminder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Reminder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reminder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Reminder value)  $default,){
final _that = this;
switch (_that) {
case _Reminder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Reminder value)?  $default,){
final _that = this;
switch (_that) {
case _Reminder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? clientId,  String? messageId,  String? assignedToUserId,  String? createdByUserId,  String title,  String? notes, @JsonKey(unknownEnumValue: ReminderPriority.normal)  ReminderPriority priority,  String dueAt, @JsonKey(unknownEnumValue: ReminderStatus.pending)  ReminderStatus status, @JsonKey(unknownEnumValue: ReminderRecurrence.none)  ReminderRecurrence recurrence, @JsonKey(unknownEnumValue: ReminderSource.manual)  ReminderSource source,  int snoozeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Reminder() when $default != null:
return $default(_that.id,_that.clientId,_that.messageId,_that.assignedToUserId,_that.createdByUserId,_that.title,_that.notes,_that.priority,_that.dueAt,_that.status,_that.recurrence,_that.source,_that.snoozeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? clientId,  String? messageId,  String? assignedToUserId,  String? createdByUserId,  String title,  String? notes, @JsonKey(unknownEnumValue: ReminderPriority.normal)  ReminderPriority priority,  String dueAt, @JsonKey(unknownEnumValue: ReminderStatus.pending)  ReminderStatus status, @JsonKey(unknownEnumValue: ReminderRecurrence.none)  ReminderRecurrence recurrence, @JsonKey(unknownEnumValue: ReminderSource.manual)  ReminderSource source,  int snoozeCount)  $default,) {final _that = this;
switch (_that) {
case _Reminder():
return $default(_that.id,_that.clientId,_that.messageId,_that.assignedToUserId,_that.createdByUserId,_that.title,_that.notes,_that.priority,_that.dueAt,_that.status,_that.recurrence,_that.source,_that.snoozeCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? clientId,  String? messageId,  String? assignedToUserId,  String? createdByUserId,  String title,  String? notes, @JsonKey(unknownEnumValue: ReminderPriority.normal)  ReminderPriority priority,  String dueAt, @JsonKey(unknownEnumValue: ReminderStatus.pending)  ReminderStatus status, @JsonKey(unknownEnumValue: ReminderRecurrence.none)  ReminderRecurrence recurrence, @JsonKey(unknownEnumValue: ReminderSource.manual)  ReminderSource source,  int snoozeCount)?  $default,) {final _that = this;
switch (_that) {
case _Reminder() when $default != null:
return $default(_that.id,_that.clientId,_that.messageId,_that.assignedToUserId,_that.createdByUserId,_that.title,_that.notes,_that.priority,_that.dueAt,_that.status,_that.recurrence,_that.source,_that.snoozeCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Reminder extends Reminder {
  const _Reminder({required this.id, this.clientId, this.messageId, this.assignedToUserId, this.createdByUserId, required this.title, this.notes, @JsonKey(unknownEnumValue: ReminderPriority.normal) this.priority = ReminderPriority.normal, required this.dueAt, @JsonKey(unknownEnumValue: ReminderStatus.pending) this.status = ReminderStatus.pending, @JsonKey(unknownEnumValue: ReminderRecurrence.none) this.recurrence = ReminderRecurrence.none, @JsonKey(unknownEnumValue: ReminderSource.manual) this.source = ReminderSource.manual, this.snoozeCount = 0}): super._();
  factory _Reminder.fromJson(Map<String, dynamic> json) => _$ReminderFromJson(json);

@override final  String id;
@override final  String? clientId;
@override final  String? messageId;
/// NULL = the shared team queue (visible in the portal; the mobile
/// list is mine-only so queue rows normally don't appear here).
@override final  String? assignedToUserId;
/// NULL = created by a smart trigger.
@override final  String? createdByUserId;
@override final  String title;
@override final  String? notes;
@override@JsonKey(unknownEnumValue: ReminderPriority.normal) final  ReminderPriority priority;
@override final  String dueAt;
@override@JsonKey(unknownEnumValue: ReminderStatus.pending) final  ReminderStatus status;
@override@JsonKey(unknownEnumValue: ReminderRecurrence.none) final  ReminderRecurrence recurrence;
@override@JsonKey(unknownEnumValue: ReminderSource.manual) final  ReminderSource source;
@override@JsonKey() final  int snoozeCount;

/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderCopyWith<_Reminder> get copyWith => __$ReminderCopyWithImpl<_Reminder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReminderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reminder&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.assignedToUserId, assignedToUserId) || other.assignedToUserId == assignedToUserId)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.title, title) || other.title == title)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.source, source) || other.source == source)&&(identical(other.snoozeCount, snoozeCount) || other.snoozeCount == snoozeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,messageId,assignedToUserId,createdByUserId,title,notes,priority,dueAt,status,recurrence,source,snoozeCount);

@override
String toString() {
  return 'Reminder(id: $id, clientId: $clientId, messageId: $messageId, assignedToUserId: $assignedToUserId, createdByUserId: $createdByUserId, title: $title, notes: $notes, priority: $priority, dueAt: $dueAt, status: $status, recurrence: $recurrence, source: $source, snoozeCount: $snoozeCount)';
}


}

/// @nodoc
abstract mixin class _$ReminderCopyWith<$Res> implements $ReminderCopyWith<$Res> {
  factory _$ReminderCopyWith(_Reminder value, $Res Function(_Reminder) _then) = __$ReminderCopyWithImpl;
@override @useResult
$Res call({
 String id, String? clientId, String? messageId, String? assignedToUserId, String? createdByUserId, String title, String? notes,@JsonKey(unknownEnumValue: ReminderPriority.normal) ReminderPriority priority, String dueAt,@JsonKey(unknownEnumValue: ReminderStatus.pending) ReminderStatus status,@JsonKey(unknownEnumValue: ReminderRecurrence.none) ReminderRecurrence recurrence,@JsonKey(unknownEnumValue: ReminderSource.manual) ReminderSource source, int snoozeCount
});




}
/// @nodoc
class __$ReminderCopyWithImpl<$Res>
    implements _$ReminderCopyWith<$Res> {
  __$ReminderCopyWithImpl(this._self, this._then);

  final _Reminder _self;
  final $Res Function(_Reminder) _then;

/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clientId = freezed,Object? messageId = freezed,Object? assignedToUserId = freezed,Object? createdByUserId = freezed,Object? title = null,Object? notes = freezed,Object? priority = null,Object? dueAt = null,Object? status = null,Object? recurrence = null,Object? source = null,Object? snoozeCount = null,}) {
  return _then(_Reminder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,messageId: freezed == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String?,assignedToUserId: freezed == assignedToUserId ? _self.assignedToUserId : assignedToUserId // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: freezed == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as ReminderPriority,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReminderStatus,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as ReminderRecurrence,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ReminderSource,snoozeCount: null == snoozeCount ? _self.snoozeCount : snoozeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ReminderSummary {

 int get overdue; int get dueToday; int get upcoming;
/// Create a copy of ReminderSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderSummaryCopyWith<ReminderSummary> get copyWith => _$ReminderSummaryCopyWithImpl<ReminderSummary>(this as ReminderSummary, _$identity);

  /// Serializes this ReminderSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderSummary&&(identical(other.overdue, overdue) || other.overdue == overdue)&&(identical(other.dueToday, dueToday) || other.dueToday == dueToday)&&(identical(other.upcoming, upcoming) || other.upcoming == upcoming));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,overdue,dueToday,upcoming);

@override
String toString() {
  return 'ReminderSummary(overdue: $overdue, dueToday: $dueToday, upcoming: $upcoming)';
}


}

/// @nodoc
abstract mixin class $ReminderSummaryCopyWith<$Res>  {
  factory $ReminderSummaryCopyWith(ReminderSummary value, $Res Function(ReminderSummary) _then) = _$ReminderSummaryCopyWithImpl;
@useResult
$Res call({
 int overdue, int dueToday, int upcoming
});




}
/// @nodoc
class _$ReminderSummaryCopyWithImpl<$Res>
    implements $ReminderSummaryCopyWith<$Res> {
  _$ReminderSummaryCopyWithImpl(this._self, this._then);

  final ReminderSummary _self;
  final $Res Function(ReminderSummary) _then;

/// Create a copy of ReminderSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? overdue = null,Object? dueToday = null,Object? upcoming = null,}) {
  return _then(_self.copyWith(
overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as int,dueToday: null == dueToday ? _self.dueToday : dueToday // ignore: cast_nullable_to_non_nullable
as int,upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReminderSummary].
extension ReminderSummaryPatterns on ReminderSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderSummary value)  $default,){
final _that = this;
switch (_that) {
case _ReminderSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int overdue,  int dueToday,  int upcoming)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReminderSummary() when $default != null:
return $default(_that.overdue,_that.dueToday,_that.upcoming);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int overdue,  int dueToday,  int upcoming)  $default,) {final _that = this;
switch (_that) {
case _ReminderSummary():
return $default(_that.overdue,_that.dueToday,_that.upcoming);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int overdue,  int dueToday,  int upcoming)?  $default,) {final _that = this;
switch (_that) {
case _ReminderSummary() when $default != null:
return $default(_that.overdue,_that.dueToday,_that.upcoming);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReminderSummary implements ReminderSummary {
  const _ReminderSummary({this.overdue = 0, this.dueToday = 0, this.upcoming = 0});
  factory _ReminderSummary.fromJson(Map<String, dynamic> json) => _$ReminderSummaryFromJson(json);

@override@JsonKey() final  int overdue;
@override@JsonKey() final  int dueToday;
@override@JsonKey() final  int upcoming;

/// Create a copy of ReminderSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderSummaryCopyWith<_ReminderSummary> get copyWith => __$ReminderSummaryCopyWithImpl<_ReminderSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReminderSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderSummary&&(identical(other.overdue, overdue) || other.overdue == overdue)&&(identical(other.dueToday, dueToday) || other.dueToday == dueToday)&&(identical(other.upcoming, upcoming) || other.upcoming == upcoming));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,overdue,dueToday,upcoming);

@override
String toString() {
  return 'ReminderSummary(overdue: $overdue, dueToday: $dueToday, upcoming: $upcoming)';
}


}

/// @nodoc
abstract mixin class _$ReminderSummaryCopyWith<$Res> implements $ReminderSummaryCopyWith<$Res> {
  factory _$ReminderSummaryCopyWith(_ReminderSummary value, $Res Function(_ReminderSummary) _then) = __$ReminderSummaryCopyWithImpl;
@override @useResult
$Res call({
 int overdue, int dueToday, int upcoming
});




}
/// @nodoc
class __$ReminderSummaryCopyWithImpl<$Res>
    implements _$ReminderSummaryCopyWith<$Res> {
  __$ReminderSummaryCopyWithImpl(this._self, this._then);

  final _ReminderSummary _self;
  final $Res Function(_ReminderSummary) _then;

/// Create a copy of ReminderSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? overdue = null,Object? dueToday = null,Object? upcoming = null,}) {
  return _then(_ReminderSummary(
overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as int,dueToday: null == dueToday ? _self.dueToday : dueToday // ignore: cast_nullable_to_non_nullable
as int,upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
