import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/client.dart';
import '../../data/models/conversation_sender.dart';
import '../../data/models/inbox_thread.dart';
import '../../data/models/sender.dart';
import '../auth/auth_controller.dart';

/// Single client for the chat header (cached per client id).
final clientProvider =
    FutureProvider.autoDispose.family<Client, String>((ref, id) async {
  return ref.read(clientsRepoProvider).getById(id);
});

/// Senders that have message history with this client — one thread tab each.
/// Invalidated by [ThreadController] after a successful send so a first
/// message via a new sender materialises its tab.
final conversationSendersProvider = FutureProvider.autoDispose
    .family<List<ConversationSender>, String>((ref, clientId) async {
  return ref.read(messagesRepoProvider).conversationSenders(clientId);
});

/// All tenant senders (composer binding + "Start conversation via…").
/// Re-created whenever the active tenant changes, so the list re-scopes.
final tenantSendersProvider =
    FutureProvider.autoDispose<List<Sender>>((ref) async {
  ref.watch(authControllerProvider.select((s) => s.activeTenantId));
  return ref.read(sendersRepoProvider).findAll();
});

/// The Team Inbox thread behind a chat — assignment lives on the thread
/// (keyed by client + sender), not on the conversation. Null when no thread
/// exists yet (no messages persisted for this scope), which hides the assign
/// action. The key is structurally identical to ThreadKey; it is spelled out
/// here so this file stays below thread_controller in the import graph.
final chatInboxThreadProvider = FutureProvider.autoDispose
    .family<InboxThread?, ({String clientId, String? senderId})>((
      ref,
      key,
    ) async {
      final page = await ref
          .read(inboxRepoProvider)
          .threads(clientId: key.clientId, senderId: key.senderId, limit: 1);
      return page.data.isEmpty ? null : page.data.first;
    });

/// Auth headers for loading proxied media (`/messages/:id/media`).
final mediaHeadersProvider = Provider<Map<String, String>>((ref) {
  final session = ref.watch(authSessionProvider);
  return {
    if (session.accessToken != null)
      'Authorization': 'Bearer ${session.accessToken}',
    if (session.activeTenantId != null)
      'X-Tenant-Id': session.activeTenantId!,
  };
});

/// Downloads proxied media bytes through the authenticated Dio (for audio).
final mediaBytesLoaderProvider =
    Provider<Future<Uint8List?> Function(String url)>((ref) {
  final dio = ref.watch(dioProvider);
  return (url) async {
    try {
      final res = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final data = res.data;
      return data == null ? null : Uint8List.fromList(data);
    } on DioException {
      return null;
    }
  };
});
