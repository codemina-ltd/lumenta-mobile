import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../data/models/contact_field.dart';
import '../../../data/models/contact_profile.dart';
import '../../../data/models/inbox_note.dart';
import '../../../data/models/message.dart';
import '../../../data/models/reminder.dart';
import '../../../data/models/smp_call.dart';
import '../../../data/repos/campaigns_repo.dart';
import '../../../data/repos/commerce_repo.dart';
import '../../../data/repos/contacts_repo.dart';
import '../../../data/repos/segments_repo.dart';
import '../../../data/repos/suppression_repo.dart';

/// The five most recent messages for a client (newest first), for the
/// client-detail "Recent messages" card and the "last message" hero metric.
final clientRecentMessagesProvider = FutureProvider.autoDispose
    .family<List<Message>, String>((ref, clientId) async {
      final page = await ref
          .read(messagesRepoProvider)
          .thread(clientId, page: 1, limit: 5);
      return page.data;
    });

/// A client's WhatsApp orders (also feeds the "orders" hero metric).
final clientOrdersProvider = FutureProvider.autoDispose
    .family<List<CommerceOrder>, String>((ref, clientId) async {
      return ref.read(commerceRepoProvider).ordersForClient(clientId);
    });

/// A client's SMP call log (newest first), for the "Calls" card.
final clientCallsProvider = FutureProvider.autoDispose
    .family<List<SmpCall>, String>((ref, clientId) async {
      return ref.read(callsRepoProvider).listForClient(clientId);
    });

/// Contact CRM profile bundled with the tenant's lifecycle stages and custom
/// field definitions — everything the profile card needs in one shot.
final contactProfileBundleProvider = FutureProvider.autoDispose
    .family<ContactProfileBundle, String>((ref, clientId) async {
      final repo = ref.read(contactsRepoProvider);
      final results = await Future.wait([
        repo.profile(clientId),
        repo.lifecycleStages(),
        repo.fields(),
      ]);
      return ContactProfileBundle(
        response: results[0] as ContactProfileResponse,
        stages: results[1] as List<ContactLifecycleStage>,
        fields: results[2] as List<ContactField>,
      );
    });

/// Click-to-WhatsApp acquisition referrals ("Came from …" banner).
final clientCtwaProvider = FutureProvider.autoDispose
    .family<List<CtwaReferral>, String>((ref, clientId) async {
      return ref.read(contactsRepoProvider).ctwa(clientId);
    });

/// Segments (audience lists) the client belongs to.
final clientSegmentsProvider = FutureProvider.autoDispose
    .family<List<ClientSegment>, String>((ref, clientId) async {
      return ref.read(segmentsRepoProvider).forClient(clientId);
    });

/// Campaigns that targeted this client, with the client's delivery outcome.
final clientCampaignsProvider = FutureProvider.autoDispose
    .family<List<ClientCampaign>, String>((ref, clientId) async {
      return ref.read(campaignsRepoProvider).forClient(clientId);
    });

/// Active campaign-targeting suppressions on the client.
final clientSuppressionsProvider = FutureProvider.autoDispose
    .family<List<ClientSuppression>, String>((ref, clientId) async {
      return ref.read(suppressionRepoProvider).forClient(clientId);
    });

/// The client's open reminders (due-time ascending), for the "Reminders"
/// card — unlike the Reminders tab this is tenant-wide, not mine-only.
final clientRemindersProvider = FutureProvider.autoDispose
    .family<List<Reminder>, String>((ref, clientId) async {
      final page = await ref
          .read(remindersRepoProvider)
          .list(clientId: clientId, limit: 20);
      return page.data;
    });

/// Internal notes on a Team Inbox thread (keyed by thread id).
final threadNotesProvider = FutureProvider.autoDispose
    .family<List<InboxNote>, String>((ref, threadId) async {
      return ref.read(inboxRepoProvider).notes(threadId);
    });

/// Contact profile + the tenant-level option lists it renders against.
class ContactProfileBundle {
  const ContactProfileBundle({
    required this.response,
    required this.stages,
    required this.fields,
  });

  final ContactProfileResponse response;
  final List<ContactLifecycleStage> stages;
  final List<ContactField> fields;
}
