import 'package:dio/dio.dart';

/// WhatsApp Commerce API client (LUMENTA_GROWTH plan §5). Mobile is the
/// operate surface: view a contact's orders and update status (§14).
class CommerceRepo {
  CommerceRepo(this._dio);
  final Dio _dio;

  Future<List<CommerceOrder>> ordersForClient(String clientId) async {
    final res = await _dio.get<List<dynamic>>(
      '/commerce/orders',
      queryParameters: {'clientId': clientId},
    );
    return (res.data ?? const [])
        .map((e) => CommerceOrder.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CommerceOrder> updateStatus(String id, String status) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/commerce/orders/$id/status',
      data: {'status': status},
    );
    return CommerceOrder.fromJson(res.data!);
  }
}

/// Lightweight read model for an order (no codegen needed).
class CommerceOrder {
  const CommerceOrder({
    required this.id,
    required this.status,
    required this.subtotalMinor,
    required this.currency,
    this.placedAt,
  });

  final String id;
  final String status;
  final int subtotalMinor;
  final String currency;
  final String? placedAt;

  String get subtotalDisplay =>
      '${(subtotalMinor / 100).toStringAsFixed(2)} $currency';

  factory CommerceOrder.fromJson(Map<String, dynamic> m) => CommerceOrder(
    id: m['id'] as String,
    status: (m['status'] as String?) ?? 'pending',
    subtotalMinor: (m['subtotalMinor'] as num?)?.toInt() ?? 0,
    currency: (m['currency'] as String?) ?? 'USD',
    placedAt: m['placedAt'] as String?,
  );
}
