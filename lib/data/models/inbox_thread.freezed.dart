// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inbox_thread.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

InboxThreadContact _$InboxThreadContactFromJson(Map<String, dynamic> json) {
  return _InboxThreadContact.fromJson(json);
}

/// @nodoc
mixin _$InboxThreadContact {
  String get id => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String? get profileName => throw _privateConstructorUsedError;

  /// Serializes this InboxThreadContact to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InboxThreadContact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InboxThreadContactCopyWith<InboxThreadContact> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InboxThreadContactCopyWith<$Res> {
  factory $InboxThreadContactCopyWith(
    InboxThreadContact value,
    $Res Function(InboxThreadContact) then,
  ) = _$InboxThreadContactCopyWithImpl<$Res, InboxThreadContact>;
  @useResult
  $Res call({String id, String phoneNumber, String? profileName});
}

/// @nodoc
class _$InboxThreadContactCopyWithImpl<$Res, $Val extends InboxThreadContact>
    implements $InboxThreadContactCopyWith<$Res> {
  _$InboxThreadContactCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InboxThreadContact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phoneNumber = null,
    Object? profileName = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            phoneNumber: null == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            profileName: freezed == profileName
                ? _value.profileName
                : profileName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InboxThreadContactImplCopyWith<$Res>
    implements $InboxThreadContactCopyWith<$Res> {
  factory _$$InboxThreadContactImplCopyWith(
    _$InboxThreadContactImpl value,
    $Res Function(_$InboxThreadContactImpl) then,
  ) = __$$InboxThreadContactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String phoneNumber, String? profileName});
}

/// @nodoc
class __$$InboxThreadContactImplCopyWithImpl<$Res>
    extends _$InboxThreadContactCopyWithImpl<$Res, _$InboxThreadContactImpl>
    implements _$$InboxThreadContactImplCopyWith<$Res> {
  __$$InboxThreadContactImplCopyWithImpl(
    _$InboxThreadContactImpl _value,
    $Res Function(_$InboxThreadContactImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InboxThreadContact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phoneNumber = null,
    Object? profileName = freezed,
  }) {
    return _then(
      _$InboxThreadContactImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        phoneNumber: null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        profileName: freezed == profileName
            ? _value.profileName
            : profileName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InboxThreadContactImpl implements _InboxThreadContact {
  const _$InboxThreadContactImpl({
    required this.id,
    required this.phoneNumber,
    this.profileName,
  });

  factory _$InboxThreadContactImpl.fromJson(Map<String, dynamic> json) =>
      _$$InboxThreadContactImplFromJson(json);

  @override
  final String id;
  @override
  final String phoneNumber;
  @override
  final String? profileName;

  @override
  String toString() {
    return 'InboxThreadContact(id: $id, phoneNumber: $phoneNumber, profileName: $profileName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InboxThreadContactImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.profileName, profileName) ||
                other.profileName == profileName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, phoneNumber, profileName);

  /// Create a copy of InboxThreadContact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InboxThreadContactImplCopyWith<_$InboxThreadContactImpl> get copyWith =>
      __$$InboxThreadContactImplCopyWithImpl<_$InboxThreadContactImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InboxThreadContactImplToJson(this);
  }
}

abstract class _InboxThreadContact implements InboxThreadContact {
  const factory _InboxThreadContact({
    required final String id,
    required final String phoneNumber,
    final String? profileName,
  }) = _$InboxThreadContactImpl;

  factory _InboxThreadContact.fromJson(Map<String, dynamic> json) =
      _$InboxThreadContactImpl.fromJson;

  @override
  String get id;
  @override
  String get phoneNumber;
  @override
  String? get profileName;

  /// Create a copy of InboxThreadContact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InboxThreadContactImplCopyWith<_$InboxThreadContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InboxThread _$InboxThreadFromJson(Map<String, dynamic> json) {
  return _InboxThread.fromJson(json);
}

/// @nodoc
mixin _$InboxThread {
  String get id => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get assignedUserId => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  String? get snoozedUntil => throw _privateConstructorUsedError;
  String? get lastInboundAt => throw _privateConstructorUsedError;
  String? get lastOutboundAt => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;
  String? get serviceWindowExpiresAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;
  List<InboxLabel> get labels => throw _privateConstructorUsedError;
  InboxThreadContact? get client => throw _privateConstructorUsedError;

  /// Serializes this InboxThread to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InboxThread
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InboxThreadCopyWith<InboxThread> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InboxThreadCopyWith<$Res> {
  factory $InboxThreadCopyWith(
    InboxThread value,
    $Res Function(InboxThread) then,
  ) = _$InboxThreadCopyWithImpl<$Res, InboxThread>;
  @useResult
  $Res call({
    String id,
    String senderId,
    String clientId,
    String status,
    String? assignedUserId,
    String priority,
    String? snoozedUntil,
    String? lastInboundAt,
    String? lastOutboundAt,
    int unreadCount,
    String? serviceWindowExpiresAt,
    String? updatedAt,
    List<InboxLabel> labels,
    InboxThreadContact? client,
  });

  $InboxThreadContactCopyWith<$Res>? get client;
}

/// @nodoc
class _$InboxThreadCopyWithImpl<$Res, $Val extends InboxThread>
    implements $InboxThreadCopyWith<$Res> {
  _$InboxThreadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InboxThread
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? clientId = null,
    Object? status = null,
    Object? assignedUserId = freezed,
    Object? priority = null,
    Object? snoozedUntil = freezed,
    Object? lastInboundAt = freezed,
    Object? lastOutboundAt = freezed,
    Object? unreadCount = null,
    Object? serviceWindowExpiresAt = freezed,
    Object? updatedAt = freezed,
    Object? labels = null,
    Object? client = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            senderId: null == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                      as String,
            clientId: null == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            assignedUserId: freezed == assignedUserId
                ? _value.assignedUserId
                : assignedUserId // ignore: cast_nullable_to_non_nullable
                      as String?,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as String,
            snoozedUntil: freezed == snoozedUntil
                ? _value.snoozedUntil
                : snoozedUntil // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastInboundAt: freezed == lastInboundAt
                ? _value.lastInboundAt
                : lastInboundAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastOutboundAt: freezed == lastOutboundAt
                ? _value.lastOutboundAt
                : lastOutboundAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            unreadCount: null == unreadCount
                ? _value.unreadCount
                : unreadCount // ignore: cast_nullable_to_non_nullable
                      as int,
            serviceWindowExpiresAt: freezed == serviceWindowExpiresAt
                ? _value.serviceWindowExpiresAt
                : serviceWindowExpiresAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            labels: null == labels
                ? _value.labels
                : labels // ignore: cast_nullable_to_non_nullable
                      as List<InboxLabel>,
            client: freezed == client
                ? _value.client
                : client // ignore: cast_nullable_to_non_nullable
                      as InboxThreadContact?,
          )
          as $Val,
    );
  }

  /// Create a copy of InboxThread
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InboxThreadContactCopyWith<$Res>? get client {
    if (_value.client == null) {
      return null;
    }

    return $InboxThreadContactCopyWith<$Res>(_value.client!, (value) {
      return _then(_value.copyWith(client: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InboxThreadImplCopyWith<$Res>
    implements $InboxThreadCopyWith<$Res> {
  factory _$$InboxThreadImplCopyWith(
    _$InboxThreadImpl value,
    $Res Function(_$InboxThreadImpl) then,
  ) = __$$InboxThreadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String senderId,
    String clientId,
    String status,
    String? assignedUserId,
    String priority,
    String? snoozedUntil,
    String? lastInboundAt,
    String? lastOutboundAt,
    int unreadCount,
    String? serviceWindowExpiresAt,
    String? updatedAt,
    List<InboxLabel> labels,
    InboxThreadContact? client,
  });

  @override
  $InboxThreadContactCopyWith<$Res>? get client;
}

/// @nodoc
class __$$InboxThreadImplCopyWithImpl<$Res>
    extends _$InboxThreadCopyWithImpl<$Res, _$InboxThreadImpl>
    implements _$$InboxThreadImplCopyWith<$Res> {
  __$$InboxThreadImplCopyWithImpl(
    _$InboxThreadImpl _value,
    $Res Function(_$InboxThreadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InboxThread
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? clientId = null,
    Object? status = null,
    Object? assignedUserId = freezed,
    Object? priority = null,
    Object? snoozedUntil = freezed,
    Object? lastInboundAt = freezed,
    Object? lastOutboundAt = freezed,
    Object? unreadCount = null,
    Object? serviceWindowExpiresAt = freezed,
    Object? updatedAt = freezed,
    Object? labels = null,
    Object? client = freezed,
  }) {
    return _then(
      _$InboxThreadImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        senderId: null == senderId
            ? _value.senderId
            : senderId // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        assignedUserId: freezed == assignedUserId
            ? _value.assignedUserId
            : assignedUserId // ignore: cast_nullable_to_non_nullable
                  as String?,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as String,
        snoozedUntil: freezed == snoozedUntil
            ? _value.snoozedUntil
            : snoozedUntil // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastInboundAt: freezed == lastInboundAt
            ? _value.lastInboundAt
            : lastInboundAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastOutboundAt: freezed == lastOutboundAt
            ? _value.lastOutboundAt
            : lastOutboundAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        unreadCount: null == unreadCount
            ? _value.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
        serviceWindowExpiresAt: freezed == serviceWindowExpiresAt
            ? _value.serviceWindowExpiresAt
            : serviceWindowExpiresAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        labels: null == labels
            ? _value._labels
            : labels // ignore: cast_nullable_to_non_nullable
                  as List<InboxLabel>,
        client: freezed == client
            ? _value.client
            : client // ignore: cast_nullable_to_non_nullable
                  as InboxThreadContact?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InboxThreadImpl extends _InboxThread {
  const _$InboxThreadImpl({
    required this.id,
    required this.senderId,
    required this.clientId,
    this.status = 'open',
    this.assignedUserId,
    this.priority = 'normal',
    this.snoozedUntil,
    this.lastInboundAt,
    this.lastOutboundAt,
    this.unreadCount = 0,
    this.serviceWindowExpiresAt,
    this.updatedAt,
    final List<InboxLabel> labels = const <InboxLabel>[],
    this.client,
  }) : _labels = labels,
       super._();

  factory _$InboxThreadImpl.fromJson(Map<String, dynamic> json) =>
      _$$InboxThreadImplFromJson(json);

  @override
  final String id;
  @override
  final String senderId;
  @override
  final String clientId;
  @override
  @JsonKey()
  final String status;
  @override
  final String? assignedUserId;
  @override
  @JsonKey()
  final String priority;
  @override
  final String? snoozedUntil;
  @override
  final String? lastInboundAt;
  @override
  final String? lastOutboundAt;
  @override
  @JsonKey()
  final int unreadCount;
  @override
  final String? serviceWindowExpiresAt;
  @override
  final String? updatedAt;
  final List<InboxLabel> _labels;
  @override
  @JsonKey()
  List<InboxLabel> get labels {
    if (_labels is EqualUnmodifiableListView) return _labels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_labels);
  }

  @override
  final InboxThreadContact? client;

  @override
  String toString() {
    return 'InboxThread(id: $id, senderId: $senderId, clientId: $clientId, status: $status, assignedUserId: $assignedUserId, priority: $priority, snoozedUntil: $snoozedUntil, lastInboundAt: $lastInboundAt, lastOutboundAt: $lastOutboundAt, unreadCount: $unreadCount, serviceWindowExpiresAt: $serviceWindowExpiresAt, updatedAt: $updatedAt, labels: $labels, client: $client)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InboxThreadImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.assignedUserId, assignedUserId) ||
                other.assignedUserId == assignedUserId) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.snoozedUntil, snoozedUntil) ||
                other.snoozedUntil == snoozedUntil) &&
            (identical(other.lastInboundAt, lastInboundAt) ||
                other.lastInboundAt == lastInboundAt) &&
            (identical(other.lastOutboundAt, lastOutboundAt) ||
                other.lastOutboundAt == lastOutboundAt) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.serviceWindowExpiresAt, serviceWindowExpiresAt) ||
                other.serviceWindowExpiresAt == serviceWindowExpiresAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._labels, _labels) &&
            (identical(other.client, client) || other.client == client));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    senderId,
    clientId,
    status,
    assignedUserId,
    priority,
    snoozedUntil,
    lastInboundAt,
    lastOutboundAt,
    unreadCount,
    serviceWindowExpiresAt,
    updatedAt,
    const DeepCollectionEquality().hash(_labels),
    client,
  );

  /// Create a copy of InboxThread
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InboxThreadImplCopyWith<_$InboxThreadImpl> get copyWith =>
      __$$InboxThreadImplCopyWithImpl<_$InboxThreadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InboxThreadImplToJson(this);
  }
}

abstract class _InboxThread extends InboxThread {
  const factory _InboxThread({
    required final String id,
    required final String senderId,
    required final String clientId,
    final String status,
    final String? assignedUserId,
    final String priority,
    final String? snoozedUntil,
    final String? lastInboundAt,
    final String? lastOutboundAt,
    final int unreadCount,
    final String? serviceWindowExpiresAt,
    final String? updatedAt,
    final List<InboxLabel> labels,
    final InboxThreadContact? client,
  }) = _$InboxThreadImpl;
  const _InboxThread._() : super._();

  factory _InboxThread.fromJson(Map<String, dynamic> json) =
      _$InboxThreadImpl.fromJson;

  @override
  String get id;
  @override
  String get senderId;
  @override
  String get clientId;
  @override
  String get status;
  @override
  String? get assignedUserId;
  @override
  String get priority;
  @override
  String? get snoozedUntil;
  @override
  String? get lastInboundAt;
  @override
  String? get lastOutboundAt;
  @override
  int get unreadCount;
  @override
  String? get serviceWindowExpiresAt;
  @override
  String? get updatedAt;
  @override
  List<InboxLabel> get labels;
  @override
  InboxThreadContact? get client;

  /// Create a copy of InboxThread
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InboxThreadImplCopyWith<_$InboxThreadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
