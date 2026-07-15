import 'package:dio/dio.dart';

import '../models/paginated.dart';
import '../models/template.dart';

class TemplatesRepo {
  TemplatesRepo(this._dio);
  final Dio _dio;

  /// `GET /templates?status=approved` — the only templates sendable from chat.
  /// Mirrors the portal picker, which fetches `limit: 100` with no pagination.
  /// [forSenderId] narrows to templates the sender can actually deliver
  /// (WABA-aware filter, plan §3) — used by the per-sender thread composer.
  Future<Paginated<Template>> approved({
    String? search,
    String? forSenderId,
    int page = 1,
    int limit = 100,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/templates',
      queryParameters: {
        'status': 'approved',
        'limit': limit,
        'page': page,
        'forSenderId': ?forSenderId,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return Paginated.fromJson(res.data!, Template.fromJson);
  }

  /// `GET /templates/:id` — full template detail, enriched by the API with
  /// fresh presigned media URLs (`headerMediaUrl`, `carouselCards[].mediaUrl`)
  /// so chat bubbles can render header images and carousel card media.
  Future<Template> byId(String id) async {
    final res = await _dio.get<Map<String, dynamic>>('/templates/$id');
    return Template.fromJson(res.data!);
  }
}
