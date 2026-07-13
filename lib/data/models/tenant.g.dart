// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TenantSummary _$TenantSummaryFromJson(Map<String, dynamic> json) =>
    _TenantSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      role: json['role'] as String?,
      complianceStatus: json['complianceStatus'] as String?,
      suspendedReason: json['suspendedReason'] as String?,
    );

Map<String, dynamic> _$TenantSummaryToJson(_TenantSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'role': instance.role,
      'complianceStatus': instance.complianceStatus,
      'suspendedReason': instance.suspendedReason,
    };
