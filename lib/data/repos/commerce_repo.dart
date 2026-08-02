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

  /// A catalog's products — used to resolve the image/name/price behind an
  /// outbound product-card bubble (message rows only carry `retailerId`, not
  /// a product snapshot).
  Future<List<CommerceProduct>> productsForCatalog(String catalogId) async {
    final res = await _dio.get<List<dynamic>>(
      '/commerce/catalogs/$catalogId/products',
    );
    return (res.data ?? const [])
        .map((e) => CommerceProduct.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Full order + line items — used by the inbound cart bubble's "View sent
  /// cart" detail sheet.
  Future<CommerceOrderDetail> orderById(String id) async {
    final res = await _dio.get<Map<String, dynamic>>('/commerce/orders/$id');
    return CommerceOrderDetail.fromJson(res.data!);
  }
}

/// Lightweight read model for a catalog product (no codegen needed).
class CommerceProduct {
  const CommerceProduct({
    required this.id,
    required this.retailerId,
    required this.name,
    required this.priceMinor,
    required this.currency,
    this.imageUrl,
  });

  final String id;
  final String retailerId;
  final String name;
  final int priceMinor;
  final String currency;
  final String? imageUrl;

  factory CommerceProduct.fromJson(Map<String, dynamic> m) => CommerceProduct(
    id: m['id'] as String,
    retailerId: (m['retailerId'] as String?) ?? '',
    name: (m['name'] as String?) ?? '',
    priceMinor: (m['priceMinor'] as num?)?.toInt() ?? 0,
    currency: (m['currency'] as String?) ?? 'USD',
    imageUrl: m['imageUrl'] as String?,
  );
}

/// Lightweight read model for an order line item (no codegen needed).
class CommerceOrderItem {
  const CommerceOrderItem({
    required this.id,
    required this.productRetailerId,
    required this.name,
    required this.quantity,
    required this.unitPriceMinor,
    required this.currency,
  });

  final String id;
  final String productRetailerId;
  final String? name;
  final int quantity;
  final int unitPriceMinor;
  final String currency;

  factory CommerceOrderItem.fromJson(Map<String, dynamic> m) =>
      CommerceOrderItem(
        id: m['id'] as String,
        productRetailerId: (m['productRetailerId'] as String?) ?? '',
        name: m['name'] as String?,
        quantity: (m['quantity'] as num?)?.toInt() ?? 1,
        unitPriceMinor: (m['unitPriceMinor'] as num?)?.toInt() ?? 0,
        currency: (m['currency'] as String?) ?? 'USD',
      );
}

/// `GET /commerce/orders/:id` response — the order plus its line items.
class CommerceOrderDetail {
  const CommerceOrderDetail({required this.order, required this.items});

  final CommerceOrder order;
  final List<CommerceOrderItem> items;

  factory CommerceOrderDetail.fromJson(Map<String, dynamic> m) =>
      CommerceOrderDetail(
        order: CommerceOrder.fromJson(m['order'] as Map<String, dynamic>),
        items: ((m['items'] as List<dynamic>?) ?? const [])
            .map((e) => CommerceOrderItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
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
