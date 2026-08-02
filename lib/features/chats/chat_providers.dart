import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/channel_thread.dart';
import '../../data/models/client.dart';
import '../../data/models/conversation_sender.dart';
import '../../data/models/inbox_thread.dart';
import '../../data/models/message.dart';
import '../../data/models/scheduled_message.dart';
import '../../data/models/sender.dart';
import '../../data/models/template.dart';
import '../../data/repos/commerce_repo.dart';
import '../auth/auth_controller.dart';
import '../shared/tenant_features.dart';

/// Single client for the chat header (cached per client id).
final clientProvider = FutureProvider.autoDispose.family<Client, String>((
  ref,
  id,
) async {
  return ref.read(clientsRepoProvider).getById(id);
});

/// Senders that have message history with this client — one thread tab each.
/// Invalidated by [ThreadController] after a successful send so a first
/// message via a new sender materialises its tab.
final conversationSendersProvider = FutureProvider.autoDispose
    .family<List<ConversationSender>, String>((ref, clientId) async {
      return ref.read(messagesRepoProvider).conversationSenders(clientId);
    });

/// The client's non-WhatsApp (Instagram/Messenger/SMS/email) threads — most
/// recently active first. Powers the chat channel tabs and the channel reply
/// composer. Invalidated by [ThreadController] after a channel send so the
/// window state stays fresh.
///
/// Feature flags (audit item D6) refine the data-gating: threads on a channel
/// the tenant's plan/operator disabled are dropped, so no tab or composer
/// affordance surfaces for them. When the flags fetch fails, the data-gating
/// stands alone (fail-open — see [channelFeatureEnabled]).
final clientChannelThreadsProvider = FutureProvider.autoDispose
    .family<List<ChannelThread>, String>((ref, clientId) async {
      Map<String, bool>? flags;
      try {
        flags = await ref.watch(tenantFeaturesProvider.future);
      } catch (_) {
        flags = null; // Flags unavailable — fall back to data-gating.
      }
      if (allChannelFeaturesDisabled(flags)) return const [];
      final threads = await ref.read(inboxRepoProvider).channelThreads(clientId);
      return threads
          .where((t) => channelFeatureEnabled(flags, t.channelType))
          .toList();
    });

/// The channel thread tab to auto-select when the chat opens — mirrors the
/// portal's ChatDetail auto-select: peek at the merged thread's first page
/// and, when the client's most recent inbound message arrived on a
/// non-WhatsApp channel, land on that channel's tab instead of the default
/// WhatsApp sender. Null (no extra fetch) when the client has no channel
/// threads; null on any failure so the chat falls back to the sender scope.
final autoSelectChannelThreadProvider = FutureProvider.autoDispose
    .family<String?, String>((ref, clientId) async {
      try {
        final threads = await ref.watch(
          clientChannelThreadsProvider(clientId).future,
        );
        if (threads.isEmpty) return null;
        final page = await ref
            .read(messagesRepoProvider)
            .thread(clientId, limit: 20);
        final latest = page.data.isEmpty
            ? null
            : page.data.firstWhere(
                (m) => m.direction == MessageDirection.inbound,
                orElse: () => page.data.first,
              );
        if (latest == null ||
            latest.channelType == null ||
            latest.channelType == 'whatsapp') {
          return null;
        }
        return threads
            .where((t) => t.channelAccountId == latest.channelAccountId)
            .firstOrNull
            ?.id;
      } catch (_) {
        return null;
      }
    });

/// All tenant senders (composer binding + "Start conversation via…").
/// Re-created whenever the active tenant changes, so the list re-scopes.
final tenantSendersProvider = FutureProvider.autoDispose<List<Sender>>((
  ref,
) async {
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

/// A single Team Inbox thread by id — the channel-tab counterpart of
/// [chatInboxThreadProvider]: a channel thread IS an inbox thread, so the
/// app-bar note/assign actions act on it directly instead of guessing via
/// the client's most recent thread.
final inboxThreadByIdProvider = FutureProvider.autoDispose
    .family<InboxThread, String>((ref, threadId) async {
      return ref.read(inboxRepoProvider).thread(threadId);
    });

/// Template detail behind an outbound template message — drives the rich
/// template bubble (header media, footer, buttons, carousel). Cached for the
/// session (NOT autoDispose) so scrolling a thread doesn't refetch the same
/// template per recycled bubble; re-scoped when the active tenant changes.
final chatTemplateProvider = FutureProvider.family<Template, String>((
  ref,
  templateId,
) async {
  ref.watch(authControllerProvider.select((s) => s.activeTenantId));
  return ref.read(templatesRepoProvider).byId(templateId);
});

/// A catalog's products behind an outbound product-card bubble (image/name/
/// price). Cached for the session (NOT autoDispose), same rationale as
/// [chatTemplateProvider] — scrolling a thread shouldn't refetch the same
/// catalog per recycled bubble; re-scoped when the active tenant changes.
final chatProductsProvider =
    FutureProvider.family<List<CommerceProduct>, String>((
      ref,
      catalogId,
    ) async {
      ref.watch(authControllerProvider.select((s) => s.activeTenantId));
      return ref.read(commerceRepoProvider).productsForCatalog(catalogId);
    });

/// Full order + line items behind an inbound cart bubble's "View sent cart"
/// detail sheet. Same session-cached, tenant-rescoped rationale as
/// [chatTemplateProvider].
final chatOrderProvider = FutureProvider.family<CommerceOrderDetail, String>((
  ref,
  orderId,
) async {
  ref.watch(authControllerProvider.select((s) => s.activeTenantId));
  return ref.read(commerceRepoProvider).orderById(orderId);
});

/// Pending/failed scheduled messages for a client — the thread's inline
/// feed (merged into `_buildRows` alongside real messages, sorted by
/// `scheduledFor`). No polling: refetched on screen entry (first watch) and
/// pull-to-refresh (`ref.invalidate`), same as every other list in the app.
final chatScheduledMessagesProvider = FutureProvider.autoDispose
    .family<List<ScheduledMessage>, String>((ref, clientId) async {
      final page = await ref
          .read(scheduledMessagesRepoProvider)
          .list(clientId, status: 'pending,failed', limit: 50);
      return page.data;
    });

/// Auth headers for loading proxied media (`/messages/:id/media`).
final mediaHeadersProvider = Provider<Map<String, String>>((ref) {
  final session = ref.watch(authSessionProvider);
  return {
    if (session.accessToken != null)
      'Authorization': 'Bearer ${session.accessToken}',
    if (session.activeTenantId != null) 'X-Tenant-Id': session.activeTenantId!,
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
