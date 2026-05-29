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
}
