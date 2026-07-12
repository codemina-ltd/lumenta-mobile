import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Immutable snapshot of the per-chat last-read timestamps. Watching widgets
/// query it directly (`isUnread`); mutations go through [LastReadStore].
@immutable
class LastReadState {
  const LastReadState(this._map);

  final Map<String, String> _map;

  DateTime? lastRead(String clientId) {
    final iso = _map[clientId];
    return iso == null ? null : DateTime.tryParse(iso);
  }

  /// Returns true if [lastMessageAt] is newer than the stored last-read.
  bool isUnread(String clientId, DateTime? lastMessageAt) {
    if (lastMessageAt == null) return false;
    final read = lastRead(clientId);
    if (read == null) return true;
    return lastMessageAt.isAfter(read);
  }
}

/// Per-chat last-read timestamps kept on-device (D7). The schema has no
/// per-user inbound read state, so unread badges are driven locally.
class LastReadStore extends Notifier<LastReadState> {
  static const _storage = FlutterSecureStorage();
  static const _key = 'chat_last_read';

  Map<String, String> _map = {};
  bool _loaded = false;

  @override
  LastReadState build() => const LastReadState({});

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    final raw = await _storage.read(key: _key);
    if (raw != null) {
      try {
        _map = Map<String, String>.from(jsonDecode(raw) as Map);
      } catch (_) {
        _map = {};
      }
    }
    _loaded = true;
    state = LastReadState(Map.unmodifiable(_map));
  }

  Future<void> hydrate() => _ensureLoaded();

  Future<void> markRead(String clientId, DateTime when) async {
    await _ensureLoaded();
    final existing = state.lastRead(clientId);
    if (existing != null && !when.isAfter(existing)) return;
    _map[clientId] = when.toIso8601String();
    await _storage.write(key: _key, value: jsonEncode(_map));
    state = LastReadState(Map.unmodifiable(_map));
  }
}

final lastReadStoreProvider = NotifierProvider<LastReadStore, LastReadState>(
  LastReadStore.new,
);
