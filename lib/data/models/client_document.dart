/// KAN-177 — one Client Document Center file (estimation, contract, other
/// paperwork). Mobile is read-only: list + open via a short-lived signed URL;
/// upload/delete happen on the web portal.
class ClientDocument {
  const ClientDocument({
    required this.id,
    required this.category,
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
    this.note,
    this.createdAt,
    this.linkedActivityIds = const [],
  });

  final String id;
  final String category;
  final String fileName;
  final String mimeType;
  final int sizeBytes;
  final String? note;
  final DateTime? createdAt;

  /// Ids of task activities this document is attached to.
  final List<String> linkedActivityIds;

  factory ClientDocument.fromJson(Map<String, dynamic> json) {
    return ClientDocument(
      id: json['id'] as String,
      category: (json['category'] as String?) ?? 'other',
      fileName: (json['fileName'] as String?) ?? '',
      mimeType: (json['mimeType'] as String?) ?? '',
      sizeBytes: (json['sizeBytes'] as num?)?.toInt() ?? 0,
      note: json['note'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      linkedActivityIds:
          (json['linkedActivityIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }
}
