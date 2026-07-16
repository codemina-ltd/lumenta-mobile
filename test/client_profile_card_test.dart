import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/i18n/arb/app_localizations.dart';
import 'package:mobile/core/providers.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/data/models/contact_field.dart';
import 'package:mobile/data/models/contact_profile.dart';
import 'package:mobile/data/repos/contacts_repo.dart';
import 'package:mobile/features/clients/client_detail/client_profile_card.dart';

/// Fake contacts repo: one text custom field, captures the last field write.
class _FakeContacts extends ContactsRepo {
  _FakeContacts() : super(Dio());

  String? lastKey;
  Object? lastValue;

  @override
  Future<ContactProfileResponse> profile(String clientId) async =>
      const ContactProfileResponse();
  @override
  Future<List<ContactLifecycleStage>> lifecycleStages() async => const [];
  @override
  Future<List<ContactField>> fields() async => const [
    ContactField(id: 'f1', key: 'city', label: 'City', type: 'text'),
  ];
  @override
  Future<void> setFieldValue(String clientId, String key, Object? value) async {
    lastKey = key;
    lastValue = value;
  }
}

void main() {
  testWidgets('editing a text custom field persists via setFieldValue', (
    tester,
  ) async {
    final repo = _FakeContacts();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [contactsRepoProvider.overrideWithValue(repo)],
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: SingleChildScrollView(
              child: ClientProfileCard(clientId: 'c1'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // The field renders empty; tapping opens the editor dialog.
    expect(find.text('City'), findsOneWidget);
    await tester.tap(find.text('City'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Cairo');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(repo.lastKey, 'city');
    expect(repo.lastValue, 'Cairo');
  });
}
