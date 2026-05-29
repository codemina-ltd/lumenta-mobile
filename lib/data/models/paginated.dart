/// Mirrors the API's `{ data, meta }` page envelope used by clients/messages.
class Paginated<T> {
  const Paginated({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  final List<T> data;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  bool get hasMore => page < totalPages;

  factory Paginated.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson,
  ) {
    final meta = (json['meta'] as Map<String, dynamic>?) ?? const {};
    final items = (json['data'] as List<dynamic>? ?? const [])
        .map((e) => itemFromJson(e as Map<String, dynamic>))
        .toList();
    return Paginated<T>(
      data: items,
      total: (meta['total'] as num?)?.toInt() ?? items.length,
      page: (meta['page'] as num?)?.toInt() ?? 1,
      limit: (meta['limit'] as num?)?.toInt() ?? items.length,
      totalPages: (meta['totalPages'] as num?)?.toInt() ?? 1,
    );
  }
}

/// Cursor-paginated envelope used by `/notifications` (`{ data, nextCursor }`).
class CursorPage<T> {
  const CursorPage({required this.data, required this.nextCursor});

  final List<T> data;
  final String? nextCursor;

  factory CursorPage.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson,
  ) {
    return CursorPage<T>(
      data: (json['data'] as List<dynamic>? ?? const [])
          .map((e) => itemFromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['nextCursor'] as String?,
    );
  }
}
