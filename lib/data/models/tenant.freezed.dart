// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tenant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TenantSummary _$TenantSummaryFromJson(Map<String, dynamic> json) {
  return _TenantSummary.fromJson(json);
}

/// @nodoc
mixin _$TenantSummary {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get slug => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  String? get complianceStatus => throw _privateConstructorUsedError;
  String? get suspendedReason => throw _privateConstructorUsedError;

  /// Serializes this TenantSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TenantSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TenantSummaryCopyWith<TenantSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TenantSummaryCopyWith<$Res> {
  factory $TenantSummaryCopyWith(
    TenantSummary value,
    $Res Function(TenantSummary) then,
  ) = _$TenantSummaryCopyWithImpl<$Res, TenantSummary>;
  @useResult
  $Res call({
    String id,
    String name,
    String? slug,
    String? role,
    String? complianceStatus,
    String? suspendedReason,
  });
}

/// @nodoc
class _$TenantSummaryCopyWithImpl<$Res, $Val extends TenantSummary>
    implements $TenantSummaryCopyWith<$Res> {
  _$TenantSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TenantSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = freezed,
    Object? role = freezed,
    Object? complianceStatus = freezed,
    Object? suspendedReason = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            slug: freezed == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String?,
            role: freezed == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String?,
            complianceStatus: freezed == complianceStatus
                ? _value.complianceStatus
                : complianceStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            suspendedReason: freezed == suspendedReason
                ? _value.suspendedReason
                : suspendedReason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TenantSummaryImplCopyWith<$Res>
    implements $TenantSummaryCopyWith<$Res> {
  factory _$$TenantSummaryImplCopyWith(
    _$TenantSummaryImpl value,
    $Res Function(_$TenantSummaryImpl) then,
  ) = __$$TenantSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? slug,
    String? role,
    String? complianceStatus,
    String? suspendedReason,
  });
}

/// @nodoc
class __$$TenantSummaryImplCopyWithImpl<$Res>
    extends _$TenantSummaryCopyWithImpl<$Res, _$TenantSummaryImpl>
    implements _$$TenantSummaryImplCopyWith<$Res> {
  __$$TenantSummaryImplCopyWithImpl(
    _$TenantSummaryImpl _value,
    $Res Function(_$TenantSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TenantSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = freezed,
    Object? role = freezed,
    Object? complianceStatus = freezed,
    Object? suspendedReason = freezed,
  }) {
    return _then(
      _$TenantSummaryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: freezed == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String?,
        role: freezed == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String?,
        complianceStatus: freezed == complianceStatus
            ? _value.complianceStatus
            : complianceStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        suspendedReason: freezed == suspendedReason
            ? _value.suspendedReason
            : suspendedReason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TenantSummaryImpl extends _TenantSummary {
  const _$TenantSummaryImpl({
    required this.id,
    required this.name,
    this.slug,
    this.role,
    this.complianceStatus,
    this.suspendedReason,
  }) : super._();

  factory _$TenantSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TenantSummaryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? slug;
  @override
  final String? role;
  @override
  final String? complianceStatus;
  @override
  final String? suspendedReason;

  @override
  String toString() {
    return 'TenantSummary(id: $id, name: $name, slug: $slug, role: $role, complianceStatus: $complianceStatus, suspendedReason: $suspendedReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TenantSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.complianceStatus, complianceStatus) ||
                other.complianceStatus == complianceStatus) &&
            (identical(other.suspendedReason, suspendedReason) ||
                other.suspendedReason == suspendedReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    slug,
    role,
    complianceStatus,
    suspendedReason,
  );

  /// Create a copy of TenantSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TenantSummaryImplCopyWith<_$TenantSummaryImpl> get copyWith =>
      __$$TenantSummaryImplCopyWithImpl<_$TenantSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TenantSummaryImplToJson(this);
  }
}

abstract class _TenantSummary extends TenantSummary {
  const factory _TenantSummary({
    required final String id,
    required final String name,
    final String? slug,
    final String? role,
    final String? complianceStatus,
    final String? suspendedReason,
  }) = _$TenantSummaryImpl;
  const _TenantSummary._() : super._();

  factory _TenantSummary.fromJson(Map<String, dynamic> json) =
      _$TenantSummaryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get slug;
  @override
  String? get role;
  @override
  String? get complianceStatus;
  @override
  String? get suspendedReason;

  /// Create a copy of TenantSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TenantSummaryImplCopyWith<_$TenantSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
