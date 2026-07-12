import 'package:dio/dio.dart';

import '../models/tenant.dart';

class TenantRepo {
  TenantRepo(this._dio);
  final Dio _dio;

  /// `GET /tenants` → `{ data: TenantSummary[] }`.
  Future<List<TenantSummary>> listMine() async {
    final res = await _dio.get<Map<String, dynamic>>('/tenants');
    final list = (res.data?['data'] as List<dynamic>? ?? const []);
    return list
        .map((e) => TenantSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// `GET /tenants/:id/members` — every user in the workspace, for the
  /// inbox assignee picker. Caller must be a member of the tenant.
  Future<List<TenantMemberLite>> members(String tenantId) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/tenants/$tenantId/members',
    );
    final list = (res.data?['data'] as List<dynamic>? ?? const []);
    return list
        .map((e) => TenantMemberLite.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}

/// Minimal member shape for pickers (mirrors [InboxLabelLite]'s approach:
/// no freezed model where only id + display name are needed).
class TenantMemberLite {
  const TenantMemberLite({
    required this.userId,
    required this.role,
    required this.displayName,
  });

  final String userId;
  final String role;
  final String displayName;

  factory TenantMemberLite.fromMap(Map<String, dynamic> m) {
    final user = m['user'] as Map<String, dynamic>? ?? const {};
    final name = (user['name'] as String?)?.trim();
    return TenantMemberLite(
      userId: m['userId'] as String,
      role: (m['role'] as String?) ?? 'MEMBER',
      displayName: (name != null && name.isNotEmpty)
          ? name
          : (user['email'] as String?) ?? (m['userId'] as String),
    );
  }
}
