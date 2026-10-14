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

/// KAN-301 — the Edit-name sheet writes the workspace display name through
/// `PATCH /contacts/:id/profile`, the hero shows the WhatsApp name as a
/// secondary line once they differ, and "Use WhatsApp name" clears it.

class _StubAuth extends AuthController {
  @override
  AuthState build() => const AuthState(
    status: AuthStatus.authenticated,
    activeTenantId: 'tenant-1',
  );
}

/// In-memory client whose workspace name follows the fake contacts repo.
class _Store {
  String? workspaceName;
  Client get client => Client(
    id: 'c1',
    phoneNumber: '15551234567',
    profileName: 'Mo WA',
    workspaceName: workspaceName,
    name: workspaceName ?? 'Mo WA',
  );
}

class _FakeClients extends ClientsRepo {
  _FakeClients(this.store) : super(Dio());
  final _Store store;
  @override
  Future<Client> getById(String id) async => store.client;
}

class _FakeContacts extends ContactsRepo {
  _FakeContacts(this.store, {this.forbid = false}) : super(Dio());
  final _Store store;
  final bool forbid;
  final sent = <String?>[];

  @override
  Future<ContactProfileResponse> profile(String clientId) async =>
      const ContactProfileResponse();
  @override
  Future<List<ContactLifecycleStage>> lifecycleStages() async => const [];
  @override
  Future<List<ContactField>> fields() async => const [];
  @override
  Future<List<CtwaReferral>> ctwa(String clientId) async => const [];

  @override
  Future<ContactProfile> updateProfile(
    String clientId, {
    Object? lifecycleStageId = const Object(),
    bool? optInMarketing,
    String? displayName,
    String? locale,
  }) async {
    sent.add(displayName);
    if (forbid) {
      throw DioException(
        requestOptions: RequestOptions(path: '/contacts/$clientId/profile'),
        response: Response(
          requestOptions: RequestOptions(path: '/contacts/$clientId/profile'),
          statusCode: 403,
        ),
      );
    }
    store.workspaceName = (displayName == null || displayName.trim().isEmpty)
        ? null
        : displayName.trim();
    return ContactProfile(
      id: 'pr1',
      clientId: clientId,
      displayName: store.workspaceName,
    );
  }
}

class _FakeMessages extends MessagesRepo {
  _FakeMessages() : super(Dio());
  @override
  Future<Paginated<Message>> thread(
    String clientId, {
    int page = 1,
    int limit = 30,
    String? senderId,
    String? channelAccountId,
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
  Widget host(_Store store, _FakeContacts contacts) => ProviderScope(
    overrides: [
      authControllerProvider.overrideWith(_StubAuth.new),
      clientsRepoProvider.overrideWithValue(_FakeClients(store)),
      messagesRepoProvider.overrideWithValue(_FakeMessages()),
      commerceRepoProvider.overrideWithValue(_FakeCommerce()),
      contactsRepoProvider.overrideWithValue(contacts),
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

  void sizeView(WidgetTester tester) {
    tester.view.physicalSize = const Size(1000, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets(
    'renames the client for this workspace and shows the WhatsApp name underneath',
    (tester) async {
      sizeView(tester);
      final store = _Store();
      final contacts = _FakeContacts(store);
      await tester.pumpWidget(host(store, contacts));
      await tester.pumpAndSettle();

      // Starts on the WhatsApp name, no secondary line.
      expect(find.text('Mo WA'), findsWidgets);
      expect(find.textContaining('WhatsApp name:'), findsNothing);

      await tester.tap(find.byKey(const ValueKey('client-edit-name')));
      await tester.pumpAndSettle();
      expect(find.text('Edit name'), findsOneWidget);
      // Sheet shows the WhatsApp name but no reset action while unset.
      expect(find.text('WhatsApp name: Mo WA'), findsOneWidget);
      expect(find.text('Use WhatsApp name'), findsNothing);

      await tester.enterText(find.byType(TextField), '  Ahmed — VIP ');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(contacts.sent, ['Ahmed — VIP']);
      expect(find.text('Name updated'), findsOneWidget);
      // Hero now shows the workspace name + the WhatsApp name as a secondary line.
      expect(find.text('Ahmed — VIP'), findsWidgets);
      expect(find.text('WhatsApp name: Mo WA'), findsOneWidget);
    },
  );

  testWidgets('"Use WhatsApp name" clears the workspace override', (
    tester,
  ) async {
    sizeView(tester);
    final store = _Store()..workspaceName = 'Ahmed — VIP';
    final contacts = _FakeContacts(store);
    await tester.pumpWidget(host(store, contacts));
    await tester.pumpAndSettle();
    expect(find.text('WhatsApp name: Mo WA'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('client-edit-name')));
    await tester.pumpAndSettle();
    expect(find.text('Use WhatsApp name'), findsOneWidget);
    await tester.tap(find.text('Use WhatsApp name'));
    await tester.pumpAndSettle();

    expect(contacts.sent, ['']);
    expect(find.text('Showing the WhatsApp name again'), findsOneWidget);
    expect(find.text('WhatsApp name: Mo WA'), findsNothing);
    expect(find.text('Mo WA'), findsWidgets);
  });

  testWidgets('a 403 hides the edit action for the session', (tester) async {
    sizeView(tester);
    final store = _Store();
    final contacts = _FakeContacts(store, forbid: true);
    await tester.pumpWidget(host(store, contacts));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('client-edit-name')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Nope');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(
      find.text("You don't have permission to edit this client's name"),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('client-edit-name')), findsNothing);
    expect(store.workspaceName, isNull);
  });
}
