// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TenantSummaryImpl _$$TenantSummaryImplFromJson(Map<String, dynamic> json) =>
    _$TenantSummaryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      role: json['role'] as String?,
      complianceStatus: json['complianceStatus'] as String?,
      suspendedReason: json['suspendedReason'] as String?,
    );

Map<String, dynamic> _$$TenantSummaryImplToJson(_$TenantSummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'role': instance.role,
      'complianceStatus': instance.complianceStatus,
      'suspendedReason': instance.suspendedReason,
    };
