import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/http/dio_client.dart';
import '../data/repos/auth_repo.dart';
import '../data/repos/clients_repo.dart';
import '../data/repos/commerce_repo.dart';
import '../data/repos/contacts_repo.dart';
import '../data/repos/device_repo.dart';
import '../data/repos/inbox_repo.dart';
import '../data/repos/messages_repo.dart';
import '../data/repos/notifications_repo.dart';
import '../data/repos/reminders_repo.dart';
import '../data/repos/senders_repo.dart';
import '../data/repos/templates_repo.dart';
import '../data/repos/tenant_repo.dart';
import '../data/session/auth_session.dart';
import '../data/storage/token_storage.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final authSessionProvider = Provider<AuthSession>((ref) {
  final session = AuthSession(ref.watch(tokenStorageProvider));
  ref.onDispose(session.dispose);
  return session;
});

final dioProvider = Provider<Dio>((ref) {
  return buildDio(ref.watch(authSessionProvider));
});

final authRepoProvider = Provider<AuthRepo>(
  (ref) => AuthRepo(ref.watch(dioProvider)),
);
final tenantRepoProvider = Provider<TenantRepo>(
  (ref) => TenantRepo(ref.watch(dioProvider)),
);
final clientsRepoProvider = Provider<ClientsRepo>(
  (ref) => ClientsRepo(ref.watch(dioProvider)),
);
final messagesRepoProvider = Provider<MessagesRepo>(
  (ref) => MessagesRepo(ref.watch(dioProvider)),
);
final inboxRepoProvider = Provider<InboxRepo>(
  (ref) => InboxRepo(ref.watch(dioProvider)),
);
final contactsRepoProvider = Provider<ContactsRepo>(
  (ref) => ContactsRepo(ref.watch(dioProvider)),
);
final commerceRepoProvider = Provider<CommerceRepo>(
  (ref) => CommerceRepo(ref.watch(dioProvider)),
);
final notificationsRepoProvider = Provider<NotificationsRepo>(
  (ref) => NotificationsRepo(ref.watch(dioProvider)),
);
final remindersRepoProvider = Provider<RemindersRepo>(
  (ref) => RemindersRepo(ref.watch(dioProvider)),
);
final templatesRepoProvider = Provider<TemplatesRepo>(
  (ref) => TemplatesRepo(ref.watch(dioProvider)),
);
final sendersRepoProvider = Provider<SendersRepo>(
  (ref) => SendersRepo(ref.watch(dioProvider)),
);
final deviceRepoProvider = Provider<DeviceRepo>(
  (ref) => DeviceRepo(ref.watch(dioProvider)),
);
