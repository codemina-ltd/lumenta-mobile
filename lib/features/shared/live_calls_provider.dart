import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/smp_call.dart';

/// How often the app re-checks for live calls while an interested screen is
/// on screen (autoDispose stops the loop when nothing watches).
const _pollInterval = Duration(seconds: 15);

/// Tenant-wide "who is on a call right now", keyed by client id, polled from
/// `GET /smp/calls/live`. SMP is an optional integration and this is a purely
/// decorative signal, so failures yield an empty map instead of an error —
/// screens never break because live-call lookup is unavailable.
final liveCallsProvider = StreamProvider.autoDispose<Map<String, SmpCall>>((
  ref,
) {
  final repo = ref.watch(callsRepoProvider);
  final controller = StreamController<Map<String, SmpCall>>();

  Future<void> tick() async {
    try {
      final calls = await repo.listLive();
      if (controller.isClosed) return;
      controller.add({
        for (final c in calls)
          if (c.clientId != null && c.inProgress) c.clientId!: c,
      });
    } catch (_) {
      if (!controller.isClosed) controller.add(const {});
    }
  }

  tick();
  final timer = Timer.periodic(_pollInterval, (_) => tick());
  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });
  return controller.stream;
});

/// The live call with a specific client, or null when none. Watch this from
/// row/header widgets — it only rebuilds them when that client's entry flips.
final liveCallForClientProvider = Provider.autoDispose
    .family<SmpCall?, String>((ref, clientId) {
      return ref
          .watch(liveCallsProvider)
          .maybeWhen(data: (m) => m[clientId], orElse: () => null);
    });
