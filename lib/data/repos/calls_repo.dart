import 'package:dio/dio.dart';

import '../models/paginated.dart';
import '../models/smp_call.dart';

/// SMP call-log API client. Mobile is a read surface: list a contact's calls
/// for the client-detail "Calls" card.
class CallsRepo {
  CallsRepo(this._dio);
  final Dio _dio;

  /// `GET /smp/calls?clientId=…` — a contact's call history, newest first.
  Future<List<SmpCall>> listForClient(String clientId) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/smp/calls',
      queryParameters: {'clientId': clientId, 'page': 1, 'limit': 50},
    );
    return Paginated.fromJson(res.data!, SmpCall.fromJson).data;
  }

  /// `GET /smp/calls/live` — calls currently in progress on a rep's phone,
  /// tenant-wide. Poll target for the "in call with …" indicators.
  Future<List<SmpCall>> listLive() async {
    final res = await _dio.get<Map<String, dynamic>>('/smp/calls/live');
    final data = res.data!['data'] as List<dynamic>? ?? const [];
    return data
        .map((e) => SmpCall.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
