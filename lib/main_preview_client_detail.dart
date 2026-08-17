// TEMPORARY visual-verification entrypoint — renders ClientDetailScreen with
// fake data on the simulator (login is reCAPTCHA-gated in dev). Not part of
// the app; delete after verification.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/i18n/arb/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'data/models/client.dart';
import 'data/models/client_phone_number.dart';
import 'data/models/contact_field.dart';
import 'data/models/contact_profile.dart';
import 'data/models/inbox_label.dart';
import 'data/models/inbox_note.dart';
import 'data/models/inbox_thread.dart';
import 'data/models/message.dart';
import 'data/models/reminder.dart';
import 'data/models/scheduled_message.dart';
import 'data/models/smp_call.dart';
import 'data/repos/suppression_repo.dart';
import 'data/repos/tenant_repo.dart';
import 'features/chats/chat_providers.dart';
import 'features/clients/client_detail/client_detail_providers.dart';
import 'features/clients/client_detail/client_detail_screen.dart';
import 'features/inbox/inbox_controller.dart';
import 'features/shared/live_calls_provider.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        clientProvider.overrideWith(
          (ref, id) async => const Client(
            id: 'c1',
            phoneNumber: '15551234567',
            profileName: 'Acme Co',
            createdAt: '2026-03-02T10:00:00Z',
          ),
        ),
        clientPhoneNumbersProvider.overrideWith(
          (ref, id) async => const [
            ClientPhoneNumber(
              id: 'p1',
              clientId: 'c1',
              phoneNumber: '15551234567',
              isPrimary: true,
            ),
            ClientPhoneNumber(
              id: 'p2',
              clientId: 'c1',
              phoneNumber: '15559876543',
              label: 'Office line',
            ),
          ],
        ),
        contactProfileBundleProvider.overrideWith(
          (ref, id) async => const ContactProfileBundle(
            response: ContactProfileResponse(
              profile: ContactProfile(
                id: 'pr1',
                clientId: 'c1',
                lifecycleStageId: 's2',
                optInMarketing: true,
              ),
              fieldValues: {'city': 'Cairo', 'vip': 'true'},
            ),
            stages: [
              ContactLifecycleStage(id: 's1', key: 'lead', label: 'Lead'),
              ContactLifecycleStage(
                id: 's2',
                key: 'customer',
                label: 'Customer',
              ),
            ],
            fields: [
              ContactField(id: 'f1', key: 'city', label: 'City', type: 'text'),
              ContactField(id: 'f2', key: 'vip', label: 'VIP', type: 'boolean'),
              ContactField(
                id: 'f3',
                key: 'budget',
                label: 'Budget',
                type: 'number',
              ),
            ],
          ),
        ),
        clientCtwaProvider.overrideWith((ref, id) async => const []),
        chatInboxThreadProvider.overrideWith(
          (ref, key) async => const InboxThread(
            id: 't1',
            clientId: 'c1',
            status: 'open',
            priority: 'high',
            assignedUserId: 'u1',
            labels: [
              InboxLabel(id: 'l1', name: 'Wholesale'),
              InboxLabel(id: 'l2', name: 'Follow up', color: '#E8A13A'),
            ],
          ),
        ),
        tenantMembersProvider.overrideWith(
          (ref) async => const [
            TenantMemberLite(
              userId: 'u1',
              role: 'AGENT',
              displayName: 'Sara Ahmed',
            ),
          ],
        ),
        threadNotesProvider.overrideWith(
          (ref, threadId) async => const [
            InboxNote(
              id: 'n1',
              threadId: 't1',
              authorUserId: 'u1',
              body: 'Prefers WhatsApp over email. @Sara Ahmed to follow up.',
              createdAt: '2026-08-10T09:30:00Z',
            ),
          ],
        ),
        clientRemindersProvider.overrideWith(
          (ref, id) async => const [
            Reminder(
              id: 'r1',
              clientId: 'c1',
              title: 'Send the renewal quote',
              notes: 'They asked for annual pricing',
              dueAt: '2026-08-18T09:00:00Z',
            ),
          ],
        ),
        clientScheduledMessagesProvider.overrideWith(
          (ref, id) async => [
            ScheduledMessage(
              id: 'sm1',
              tenantId: 'tn1',
              clientId: 'c1',
              templateName: 'renewal_reminder',
              status: ScheduledMessageStatus.pending,
              scheduledFor: DateTime.utc(2026, 8, 20, 9),
              createdAt: '2026-08-15T12:00:00Z',
              updatedAt: '2026-08-15T12:00:00Z',
            ),
          ],
        ),
        clientRecentMessagesProvider.overrideWith(
          (ref, id) async => const <Message>[],
        ),
        clientOrdersProvider.overrideWith((ref, id) async => const []),
        clientCallsProvider.overrideWith((ref, id) async => const []),
        clientSegmentsProvider.overrideWith((ref, id) async => const []),
        clientCampaignsProvider.overrideWith((ref, id) async => const []),
        clientSuppressionsProvider.overrideWith(
          (ref, id) async => const [
            ClientSuppression(
              id: 'sup1',
              scope: 'marketing',
              reason: 'manual',
              source: 'operator',
              createdAt: '2026-08-01T08:00:00Z',
            ),
          ],
        ),
        liveCallsProvider.overrideWith(
          (ref) => Stream.value(const <String, SmpCall>{}),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const ClientDetailScreen(clientId: 'c1'),
      ),
    ),
  );
}
