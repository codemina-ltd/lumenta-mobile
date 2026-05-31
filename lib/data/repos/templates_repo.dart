import 'package:dio/dio.dart';

import '../models/paginated.dart';
import '../models/template.dart';

class TemplatesRepo {
  TemplatesRepo(this._dio);
  final Dio _dio;

  /// `GET /templates?status=approved` — the only templates sendable from chat.
  /// Mirrors the portal picker, which fetches `limit: 100` with no pagination.
  Future<Paginated<Template>> approved({
    String? search,
    int page = 1,
    int limit = 100,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/templates',
      queryParameters: {
        'status': 'approved',
        'limit': limit,
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return Paginated.fromJson(res.data!, Template.fromJson);
  }
}
