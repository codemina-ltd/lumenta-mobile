import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/smp_call.dart';
import 'live_calls_provider.dart';
import 'widgets.dart';

/// "On a call with `<team member>`" label for a live SMP call, or an empty box
/// when the client is not on a call. Watching [liveCallForClientProvider]
/// keeps the tenant-wide poll alive while any badge is on screen.
class LiveCallBadge extends ConsumerWidget {
  const LiveCallBadge({super.key, required this.clientId, this.onDark = false});

  final String clientId;

  /// Render for a dark/brand background (the client-detail hero).
  final bool onDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final call = ref.watch(liveCallForClientProvider(clientId));
    if (call == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: StatusPill(
        label: _label(AppLocalizations.of(context), call),
        icon: Icons.phone_in_talk_rounded,
        color: onDark ? Colors.white : AppColors.signal,
        background: onDark
            ? Colors.white.withValues(alpha: 0.22)
            : AppColors.signal.withValues(alpha: 0.14),
      ),
    );
  }
}

/// Full-width strip variant for the chat thread: pinned under the app bar so
/// a teammate opening the conversation immediately sees the client is being
/// called right now.
class LiveCallBanner extends ConsumerWidget {
  const LiveCallBanner({super.key, required this.clientId});

  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final call = ref.watch(liveCallForClientProvider(clientId));
    if (call == null) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      color: AppColors.signal.withValues(alpha: 0.14),
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.lg,
        vertical: Insets.sm,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.phone_in_talk_rounded,
            size: 16,
            color: AppColors.signal,
          ),
          const SizedBox(width: Insets.sm),
          Expanded(
            child: Text(
              _label(AppLocalizations.of(context), call),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelMedium?.copyWith(
                color: AppColors.signal,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _label(AppLocalizations l10n, SmpCall call) {
  final name = call.handlerName;
  return name == null || name.isEmpty
      ? l10n.liveCallInProgress
      : l10n.liveCallWith(name);
}
