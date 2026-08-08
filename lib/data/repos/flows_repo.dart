import 'package:dio/dio.dart';

import '../models/flow.dart';
import '../models/paginated.dart';

class FlowsRepo {
  FlowsRepo(this._dio);
  final Dio _dio;

  /// `GET /flows?limit=100` — every flow in the tenant with its JSON
  /// definition, so a flow response's raw keys/values render as the labels and
  /// option titles the customer saw. Mirrors the portal, which fetches
  /// `limit: 100` unfiltered and matches a submission to a flow by field-name
  /// overlap (the message itself carries no flow id).
  Future<List<Flow>> list({int limit = 100}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/flows',
      queryParameters: {'page': 1, 'limit': limit},
    );
    return Paginated.fromJson(res.data!, Flow.fromJson).data;
  }
}
