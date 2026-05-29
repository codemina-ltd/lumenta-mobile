import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant.freezed.dart';
part 'tenant.g.dart';

/// One workspace membership from `GET /v1/tenants`.
@freezed
class TenantSummary with _$TenantSummary {
  const factory TenantSummary({
    required String id,
    required String name,
    String? slug,
    String? role,
    String? complianceStatus,
    String? suspendedReason,
  }) = _TenantSummary;

  const TenantSummary._();

  factory TenantSummary.fromJson(Map<String, dynamic> json) =>
      _$TenantSummaryFromJson(json);

  /// Absent/empty compliance status means active (matches portal convention).
  bool get isActive =>
      complianceStatus == null ||
      complianceStatus!.isEmpty ||
      complianceStatus == 'active';
}
