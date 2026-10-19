import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Immutable snapshot of the pinned chats, most recently pinned first.
/// Widgets read [isPinned] / [rank]; mutations go through [PinnedChatsStore].
@immutable
class PinnedChatsState {
  const PinnedChatsState(this.order);

  /// Client ids in pin order — index 0 is the most recently pinned.
  final List<String> order;

  bool isPinned(String clientId) => order.contains(clientId);

  /// Position in the pinned block, or null when not pinned.
  int? rank(String clientId) {
    final i = order.indexOf(clientId);
    return i < 0 ? null : i;
  }
}

/// Pinned chats kept on-device, like the last-read cursor: the server has no
/// per-member pin state for conversations, so pins live in secure storage and
/// follow the device, not the account. Client ids are UUIDs, so one flat list
/// is safe across workspaces.
class PinnedChatsStore extends Notifier<PinnedChatsState> {
  static const _storage = FlutterSecureStorage();
  static const _key = 'chat_pinned';

  List<String> _order = [];
  bool _loaded = false;

  @override
  PinnedChatsState build() => const PinnedChatsState([]);

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    final raw = await _storage.read(key: _key);
    if (raw != null) {
      try {
        _order = List<String>.from(jsonDecode(raw) as List);
      } catch (_) {
        _order = [];
      }
    }
    _loaded = true;
    state = PinnedChatsState(List.unmodifiable(_order));
  }

  Future<void> hydrate() => _ensureLoaded();

  /// Pins [clientId] (moving it to the front) or unpins it when already
  /// pinned. Returns the new pinned state.
  Future<bool> toggle(String clientId) async {
    await _ensureLoaded();
    final wasPinned = _order.remove(clientId);
    if (!wasPinned) _order.insert(0, clientId);
    await _storage.write(key: _key, value: jsonEncode(_order));
    state = PinnedChatsState(List.unmodifiable(_order));
    return !wasPinned;
  }
}

final pinnedChatsStoreProvider =
    NotifierProvider<PinnedChatsStore, PinnedChatsState>(PinnedChatsStore.new);
