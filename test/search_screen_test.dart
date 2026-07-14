import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/i18n/arb/app_localizations.dart';
import 'package:mobile/core/providers.dart';
import 'package:mobile/data/models/client.dart';
import 'package:mobile/data/models/client_search.dart';
import 'package:mobile/data/repos/search_repo.dart';
import 'package:mobile/features/auth/auth_controller.dart';
import 'package:mobile/features/search/search_screen.dart';

/// Auth stub: authenticated with a fixed tenant, and — crucially — a build()
/// that never touches AuthSession / secure storage.
class _StubAuthController extends AuthController {
  @override
  AuthState build() => const AuthState(
    status: AuthStatus.authenticated,
    activeTenantId: 'tenant-1',
  );
}

class _FakeSearchRepo extends SearchRepo {
  _FakeSearchRepo() : super(Dio());

  final calls = <String>[];

  @override
  Future<List<ClientSearchResult>> searchClients(
    String q, {
    int limit = 8,
  }) async {
    calls.add(q);
    if (q == 'empty') return [];
    return const [
      ClientSearchResult(
        client: Client(
          id: 'c1',
          phoneNumber: '201062866442',
          profileName: 'InShape Clinic',
        ),
        score: 130,
        matches: [
          ClientSearchMatch(source: 'name', snippet: 'InShape Clinic'),
          ClientSearchMatch(
            source: 'message',
            snippet: '…about the inshape order…',
          ),
        ],
      ),
    ];
  }
}

void main() {
  Widget host(_FakeSearchRepo repo) => ProviderScope(
    overrides: [
      authControllerProvider.overrideWith(_StubAuthController.new),
      searchRepoProvider.overrideWithValue(repo),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SearchScreen(),
    ),
  );

  testWidgets('short queries never hit the API', (tester) async {
    final repo = _FakeSearchRepo();
    await tester.pumpWidget(host(repo));

    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump(const Duration(milliseconds: 400));
    expect(repo.calls, isEmpty);
  });

  testWidgets('debounced search renders client, source tag and snippet',
      (tester) async {
    final repo = _FakeSearchRepo();
    await tester.pumpWidget(host(repo));

    await tester.enterText(find.byType(TextField), 'inshape');
    // Inside the debounce window: nothing sent yet.
    await tester.pump(const Duration(milliseconds: 100));
    expect(repo.calls, isEmpty);
    // Past the debounce: one request, results rendered.
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(repo.calls, ['inshape']);
    expect(find.textContaining('InShape'), findsWidgets);
    expect(find.text('Message'), findsOneWidget);
    expect(find.textContaining('order'), findsOneWidget);
    expect(find.text('+201062866442'), findsOneWidget);
  });

  testWidgets('shows the no-results state', (tester) async {
    final repo = _FakeSearchRepo();
    await tester.pumpWidget(host(repo));

    await tester.enterText(find.byType(TextField), 'empty');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.textContaining('No matches'), findsOneWidget);
  });
}
