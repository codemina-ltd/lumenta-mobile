/// A Meta WhatsApp Flow (interactive form). The mobile app only needs enough
/// to resolve a submitted response's raw keys/values into the labels and
/// option titles the customer saw, so this is a lightweight projection of the
/// API's `Flow` entity rather than the full record.
class Flow {
  const Flow({required this.id, required this.name, this.flowJson});

  final String id;
  final String name;

  /// The flow's JSON definition (Meta `{ screens: [...] }` shape). Nullable —
  /// draft flows may not have JSON yet.
  final String? flowJson;

  factory Flow.fromJson(Map<String, dynamic> json) {
    return Flow(
      id: json['id'] as String,
      name: (json['name'] as String?) ?? '',
      flowJson: json['flowJson'] as String?,
    );
  }
}
