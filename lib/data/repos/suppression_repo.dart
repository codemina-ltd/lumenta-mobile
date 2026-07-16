import 'package:dio/dio.dart';

/// Client suppression API client (campaign targeting blocks). Mirrors the
/// portal's SuppressionPanel: list active blocks, add a block, release a block.
/// Adding/releasing is an OWNER/ADMIN action (enforced server-side); the mobile
/// UI hides those controls for other roles.
class SuppressionRepo {
  SuppressionRepo(this._dio);
  final Dio _dio;

  /// `GET /clients/:clientId/suppression` → `{ data: ClientSuppression[] }`
  /// (active blocks only).
  Future<List<ClientSuppression>> forClient(String clientId) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/clients/$clientId/suppression',
    );
    final list = (res.data?['data'] as List<dynamic>? ?? const []);
    return list
        .map((e) => ClientSuppression.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// `POST /clients/:clientId/suppression` — block campaign targeting.
  Future<void> suppress(
    String clientId, {
    required String scope, // marketing | all
    required String reason,
    String? notes,
  }) async {
    await _dio.post<Map<String, dynamic>>(
      '/clients/$clientId/suppression',
      data: {'scope': scope, 'reason': reason, 'notes': ?notes},
    );
  }

  /// `DELETE /clients/:clientId/suppression` — release a block. Pass a `scope`
  /// to release just that scope, or omit to release all.
  Future<void> release(String clientId, {String? scope}) async {
    await _dio.delete<Map<String, dynamic>>(
      '/clients/$clientId/suppression',
      data: {'scope': ?scope},
    );
  }
}

/// Lightweight read model for one active suppression (no codegen needed).
class ClientSuppression {
  const ClientSuppression({
    required this.id,
    required this.scope,
    required this.reason,
    required this.source,
    this.notes,
    this.createdAt,
  });

  final String id;
  final String scope; // marketing | all
  final String reason;
  final String source;
  final String? notes;
  final String? createdAt;

  factory ClientSuppression.fromJson(Map<String, dynamic> m) =>
      ClientSuppression(
        id: m['id'] as String,
        scope: (m['scope'] as String?) ?? 'marketing',
        reason: (m['reason'] as String?) ?? 'manual',
        source: (m['source'] as String?) ?? 'portal',
        notes: m['notes'] as String?,
        createdAt: m['createdAt'] as String?,
      );
}
