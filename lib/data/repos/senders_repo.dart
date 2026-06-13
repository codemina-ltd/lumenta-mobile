import 'package:dio/dio.dart';

import '../models/sender.dart';

class SendersRepo {
  SendersRepo(this._dio);
  final Dio _dio;

  /// `GET /senders` — all WhatsApp senders connected to the active tenant.
  /// Returns `{ data: [...] }` (no pagination envelope).
  Future<List<Sender>> findAll() async {
    final res = await _dio.get<Map<String, dynamic>>('/senders');
    return (res.data!['data'] as List<dynamic>? ?? const [])
        .map((e) => Sender.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
