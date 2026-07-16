import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/i18n/arb/app_localizations.dart';
import 'package:mobile/core/providers.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/data/models/client.dart';
import 'package:mobile/data/models/contact_field.dart';
import 'package:mobile/data/models/contact_profile.dart';
import 'package:mobile/data/models/inbox_thread.dart';
import 'package:mobile/data/models/message.dart';
import 'package:mobile/data/models/paginated.dart';
import 'package:mobile/data/repos/campaigns_repo.dart';
import 'package:mobile/data/repos/clients_repo.dart';
import 'package:mobile/data/repos/commerce_repo.dart';
import 'package:mobile/data/repos/contacts_repo.dart';
import 'package:mobile/data/repos/inbox_repo.dart';
import 'package:mobile/data/repos/messages_repo.dart';
import 'package:mobile/data/repos/segments_repo.dart';
import 'package:mobile/data/repos/suppression_repo.dart';
import 'package:mobile/data/repos/tenant_repo.dart';
import 'package:mobile/features/auth/auth_controller.dart';
import 'package:mobile/features/clients/client_detail/client_detail_screen.dart';

/// Authenticated stub with a fixed tenant that never touches AuthSession.
class _StubAuth extends AuthController {
  @override
  AuthState build() => const AuthState(
    status: AuthStatus.authenticated,
    activeTenantId: 'tenant-1',
  );
}

class _FakeClients extends ClientsRepo {
  _FakeClients() : super(Dio());
  @override
  Future<Client> getById(String id) async => const Client(
    id: 'c1',
    phoneNumber: '15551234567',
    profileName: 'Acme Co',
  );
}

class _FakeMessages extends MessagesRepo {
  _FakeMessages() : super(Dio());
  @override
  Future<Paginated<Message>> thread(
    String clientId, {
    int page = 1,
    int limit = 30,
    String? senderId,
  }) async => const Paginated<Message>(
    data: [],
    total: 0,
    page: 1,
    limit: 5,
    totalPages: 1,
  );
}

class _FakeCommerce extends CommerceRepo {
  _FakeCommerce() : super(Dio());
  @override
  Future<List<CommerceOrder>> ordersForClient(String clientId) async =>
      const [];
}

class _FakeContacts extends ContactsRepo {
  _FakeContacts() : super(Dio());
  @override
  Future<ContactProfileResponse> profile(String clientId) async =>
      const ContactProfileResponse();
  @override
  Future<List<ContactLifecycleStage>> lifecycleStages() async => const [];
  @override
  Future<List<ContactField>> fields() async => const [];
  @override
  Future<List<CtwaReferral>> ctwa(String clientId) async => const [];
}

class _FakeInbox extends InboxRepo {
  _FakeInbox() : super(Dio());
  @override
  Future<Paginated<InboxThread>> threads({
    String? status,
    String? assignedUserId,
    bool? unassigned,
    String? labelId,
    String? senderId,
    String? clientId,
    String? search,
    int page = 1,
    int limit = 30,
  }) async => const Paginated<InboxThread>(
    data: [],
    total: 0,
    page: 1,
    limit: 1,
    totalPages: 1,
  );
}

class _FakeSegments extends SegmentsRepo {
  _FakeSegments() : super(Dio());
  @override
  Future<List<ClientSegment>> forClient(String clientId) async => const [];
}

class _FakeCampaigns extends CampaignsRepo {
  _FakeCampaigns() : super(Dio());
  @override
  Future<List<ClientCampaign>> forClient(String clientId) async => const [];
}

class _FakeSuppression extends SuppressionRepo {
  _FakeSuppression() : super(Dio());
  @override
  Future<List<ClientSuppression>> forClient(String clientId) async => const [];
}

class _FakeTenant extends TenantRepo {
  _FakeTenant() : super(Dio());
  @override
  Future<List<TenantMemberLite>> members(String tenantId) async => const [];
}

void main() {
  Widget host() => ProviderScope(
    overrides: [
      authControllerProvider.overrideWith(_StubAuth.new),
      clientsRepoProvider.overrideWithValue(_FakeClients()),
      messagesRepoProvider.overrideWithValue(_FakeMessages()),
      commerceRepoProvider.overrideWithValue(_FakeCommerce()),
      contactsRepoProvider.overrideWithValue(_FakeContacts()),
      inboxRepoProvider.overrideWithValue(_FakeInbox()),
      segmentsRepoProvider.overrideWithValue(_FakeSegments()),
      campaignsRepoProvider.overrideWithValue(_FakeCampaigns()),
      suppressionRepoProvider.overrideWithValue(_FakeSuppression()),
      tenantRepoProvider.overrideWithValue(_FakeTenant()),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const ClientDetailScreen(clientId: 'c1'),
    ),
  );

  testWidgets('renders the hero, metrics and every section without error', (
    tester,
  ) async {
    // A tall surface so the lazy ListView builds every section in one pass.
    tester.view.physicalSize = const Size(1000, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(host());
    await tester.pumpAndSettle();

    // Hero.
    expect(find.text('Acme Co'), findsOneWidget);
    expect(find.text('+15551234567'), findsOneWidget);

    // Section titles (each rendered once).
    expect(find.text('Segments'), findsOneWidget);
    expect(find.text('Campaigns'), findsOneWidget);
    expect(find.text('Suppression'), findsOneWidget);
    expect(find.text('Recent messages'), findsOneWidget);

    // Empty states resolved from the fakes.
    expect(find.text('Not in any segment'), findsOneWidget);
    // Team + notes both surface the no-thread state.
    expect(
      find.text('No conversation thread yet — nothing to assign.'),
      findsWidgets,
    );
  });
}
