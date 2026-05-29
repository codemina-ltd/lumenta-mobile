import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/storage/last_read_store.dart';
import 'features/auth/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  // Restore local read cursors, then kick off session bootstrap (the splash
  // screen shows until it resolves). Firebase/FCM init lands in Phase 6.
  await container.read(lastReadStoreProvider).hydrate();
  unawaited(container.read(authControllerProvider.notifier).bootstrap());

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const LumentaApp(),
    ),
  );
}
