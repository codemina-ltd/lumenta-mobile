import 'package:dio/dio.dart';

import '../models/client.dart';
import '../models/paginated.dart';

class ClientsRepo {
  ClientsRepo(this._dio);
  final Dio _dio;

  /// `GET /clients` — tenant-scoped, searchable, paginated.
  Future<Paginated<Client>> list({
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/clients',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return Paginated.fromJson(res.data!, Client.fromJson);
  }

  /// `GET /clients/:id` — single client (used for the chat header on deep links).
  Future<Client> getById(String id) async {
    final res = await _dio.get<Map<String, dynamic>>('/clients/$id');
    return Client.fromJson(res.data!);
  }
}
