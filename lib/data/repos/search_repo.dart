import 'package:dio/dio.dart';

import '../models/client_search.dart';

class SearchRepo {
  SearchRepo(this._dio);
  final Dio _dio;

  /// `GET /search/clients` — global fuzzy client search across name, phone,
  /// custom field values, message bodies, internal notes and CTWA ad
  /// headlines. Tenant scoping comes from the `X-Tenant-Id` header the Dio
  /// interceptor already injects. Requires `q.length >= 2` (server-validated).
  Future<List<ClientSearchResult>> searchClients(
    String q, {
    int limit = 8,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/search/clients',
      queryParameters: {'q': q, 'limit': limit},
    );
    final results = res.data!['results'] as List<dynamic>;
    return results
        .map((r) => ClientSearchResult.fromJson(r as Map<String, dynamic>))
        .toList();
  }
}
