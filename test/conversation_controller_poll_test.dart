import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/providers.dart';
import 'package:mobile/data/models/conversation_controller.dart';
import 'package:mobile/data/repos/clients_repo.dart';
import 'package:mobile/features/chats/chat_providers.dart';

/// Answers the controller lookup from a script: `null` status = success.
class _FakeClientsRepo extends ClientsRepo {
  _FakeClientsRepo() : super(Dio());

  int calls = 0;
  int? failWith;

  @override
  Future<ConversationControllerState> conversationController(
    String clientId, {
    String? senderId,
  }) async {
    calls++;
    final status = failWith;
    if (status != null) {
      final options = RequestOptions(
        path: '/clients/$clientId/conversation-controller',
      );
      throw DioException(
        requestOptions: options,
        response: Response<void>(requestOptions: options, statusCode: status),
        type: DioExceptionType.badResponse,
      );
    }
    return ConversationControllerState.fromMap({'controller': 'released'});
  }
}

void main() {
  const key = (clientId: 'c1', senderId: null);

  /// Opens the chip's provider the way the chat screen does and returns the
  /// fake repo counting its lookups.
  _FakeClientsRepo open(WidgetTester tester, {int? failWith}) {
    final repo = _FakeClientsRepo()..failWith = failWith;
    final container = ProviderContainer(
      overrides: [clientsRepoProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    final sub = container.listen(
      conversationControllerProvider(key),
      (_, _) {},
      onError: (_, _) {},
    );
    addTearDown(sub.close);
    return repo;
  }

  Future<void> advance(WidgetTester tester, Duration total) async {
    for (var t = Duration.zero; t < total; t += const Duration(seconds: 1)) {
      await tester.pump(const Duration(seconds: 1));
    }
  }

  testWidgets('re-polls every 30s while the lookup succeeds', (tester) async {
    final repo = open(tester);
    await tester.pump();
    expect(repo.calls, 1);
    await advance(tester, const Duration(seconds: 95));
    expect(repo.calls, 4);
  });

  testWidgets('a 403 ends the polling: no retry, no re-poll', (tester) async {
    final repo = open(tester, failWith: 403);
    await tester.pump();
    expect(repo.calls, 1);
    await advance(tester, const Duration(minutes: 5));
    expect(repo.calls, 1);
  });

  testWidgets('a 403 on a later poll ends the polling', (tester) async {
    final repo = open(tester);
    await tester.pump();
    repo.failWith = 403;
    await advance(tester, const Duration(seconds: 31));
    expect(repo.calls, 2);
    await advance(tester, const Duration(minutes: 5));
    expect(repo.calls, 2);
  });

  testWidgets('a transient failure is polled again on the 30s cadence', (
    tester,
  ) async {
    final repo = open(tester, failWith: 503);
    await tester.pump();
    expect(repo.calls, 1);
    await advance(tester, const Duration(seconds: 29));
    expect(repo.calls, 1);
    repo.failWith = null;
    await advance(tester, const Duration(seconds: 2));
    expect(repo.calls, 2);
    await advance(tester, const Duration(seconds: 30));
    expect(repo.calls, 3);
  });
}
