/// Who controls a client conversation right now (KAN-34), resolved by the
/// API in runtime precedence order: human takeover pause → active chatbot
/// session → active journey run → Lume coverage → released.
enum ConversationControllerKind { human, chatbot, journey, lume, released }

class ConversationControllerState {
  const ConversationControllerState({
    required this.controller,
    this.label,
    this.assignedUserId,
    this.until,
  });

  final ConversationControllerKind controller;

  /// Chatbot / journey / assistant display name; null for human / released.
  final String? label;

  /// For [ConversationControllerKind.human]: the paused thread's assignee.
  final String? assignedUserId;

  /// For [ConversationControllerKind.human]: when the takeover pause lapses.
  final DateTime? until;

  factory ConversationControllerState.fromMap(Map<String, dynamic> m) {
    final raw = (m['controller'] as String?) ?? 'released';
    final kind = ConversationControllerKind.values
        .where((k) => k.name == raw)
        .firstOrNull;
    final untilRaw = m['until'] as String?;
    return ConversationControllerState(
      // Unknown kinds from a newer API degrade to "released" rather than
      // crashing the header.
      controller: kind ?? ConversationControllerKind.released,
      label: _nonEmpty(m['label'] as String?),
      assignedUserId: _nonEmpty(m['assignedUserId'] as String?),
      until: untilRaw == null ? null : DateTime.tryParse(untilRaw),
    );
  }

  static String? _nonEmpty(String? s) {
    final t = s?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}
