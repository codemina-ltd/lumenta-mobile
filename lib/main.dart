import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/storage/last_read_store.dart';
import 'features/auth/auth_controller.dart';
import 'features/push/push_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  // Restore local read cursors, then kick off session bootstrap (the splash
  // screen shows until it resolves).
  await container.read(lastReadStoreProvider).hydrate();
  unawaited(container.read(authControllerProvider.notifier).bootstrap());

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const LumentaApp(),
    ),
  );

  // FCM lifecycle — no-ops gracefully when Firebase has no native config.
  unawaited(container.read(pushServiceProvider).init());
}
