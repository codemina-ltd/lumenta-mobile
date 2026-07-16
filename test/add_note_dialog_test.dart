import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/i18n/arb/app_localizations.dart';
import 'package:mobile/core/providers.dart';
import 'package:mobile/data/models/inbox_note.dart';
import 'package:mobile/data/models/inbox_thread.dart';
import 'package:mobile/data/repos/inbox_repo.dart';
import 'package:mobile/data/repos/tenant_repo.dart';
import 'package:mobile/features/chats/widgets/add_note_dialog.dart';
import 'package:mobile/features/inbox/inbox_controller.dart';

/// Captures the last `addNote` call so tests can assert the body + mentions
/// payload the composer built (the interesting part of the mention feature).
class _FakeInboxRepo extends InboxRepo {
  _FakeInboxRepo() : super(Dio());

  String? lastBody;
  List<Map<String, dynamic>>? lastMentions;

  @override
  Future<InboxNote> addNote(
    String id,
    String body, {
    List<Map<String, dynamic>> mentions = const [],
  }) async {
    lastBody = body;
    lastMentions = mentions;
    return InboxNote(
      id: 'note-1',
      threadId: id,
      authorUserId: 'me',
      body: body,
    );
  }
}

const _members = [
  TenantMemberLite(
    userId: 'u-alice',
    role: 'MEMBER',
    displayName: 'Alice Adams',
  ),
  TenantMemberLite(userId: 'u-bob', role: 'MEMBER', displayName: 'Bob Stone'),
];

const _thread = InboxThread(id: 'thread-1', senderId: 's1', clientId: 'c1');

Widget _host(
  _FakeInboxRepo repo, {
  List<TenantMemberLite> members = _members,
}) => ProviderScope(
  overrides: [
    tenantMembersProvider.overrideWith((ref) async => members),
    inboxRepoProvider.overrideWithValue(repo),
  ],
  child: MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Consumer(
      builder: (context, ref, _) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => showAddNoteDialog(context, ref, _thread),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  ),
);

String _fieldText(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).controller!.text;

void main() {
  testWidgets(
    'a teammate picked from the @ dropdown rides along as a mention',
    (tester) async {
      final repo = _FakeInboxRepo();
      await tester.pumpWidget(_host(repo));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle(); // members future resolves, dialog opens

      // Typing `@` + a fragment opens the teammate picker filtered by name.
      await tester.enterText(find.byType(TextField), 'FYI @al');
      await tester.pump();
      expect(find.text('Alice Adams'), findsOneWidget);
      expect(find.text('Bob Stone'), findsNothing);

      // Picking inserts the `@Name` token into the note.
      await tester.tap(find.text('Alice Adams'));
      await tester.pump();
      expect(_fieldText(tester), 'FYI @Alice Adams ');

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(repo.lastBody, 'FYI @Alice Adams');
      expect(repo.lastMentions, [
        {'user_id': 'u-alice'},
      ]);
    },
  );

  testWidgets('a plain note sends no mentions', (tester) async {
    final repo = _FakeInboxRepo();
    await tester.pumpWidget(_host(repo));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'call the client back');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(repo.lastBody, 'call the client back');
    expect(repo.lastMentions, isEmpty);
  });

  testWidgets('erasing the @name token drops the mention', (tester) async {
    final repo = _FakeInboxRepo();
    await tester.pumpWidget(_host(repo));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'FYI @al');
    await tester.pump();
    await tester.tap(find.text('Alice Adams'));
    await tester.pump();

    // Author changes their mind and replaces the note with plain text.
    await tester.enterText(find.byType(TextField), 'never mind');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(repo.lastBody, 'never mind');
    expect(repo.lastMentions, isEmpty);
  });
}
