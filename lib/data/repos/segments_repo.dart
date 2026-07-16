import 'package:dio/dio.dart';

/// Segments (audience lists) API client. The mobile client-detail screen only
/// reads which segments a contact belongs to; management stays in the portal.
class SegmentsRepo {
  SegmentsRepo(this._dio);
  final Dio _dio;

  /// `GET /segments/by-client/:clientId` → `{ data: Segment[] }`.
  Future<List<ClientSegment>> forClient(String clientId) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/segments/by-client/$clientId',
    );
    final list = (res.data?['data'] as List<dynamic>? ?? const []);
    return list
        .map((e) => ClientSegment.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

/// Lightweight read model for a segment tag (no codegen needed).
class ClientSegment {
  const ClientSegment({required this.id, required this.name});

  final String id;
  final String name;

  factory ClientSegment.fromJson(Map<String, dynamic> m) =>
      ClientSegment(id: m['id'] as String, name: (m['name'] as String?) ?? '');
}
