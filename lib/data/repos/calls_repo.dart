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
}
