import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/conversation_controller.dart';
import '../../inbox/inbox_controller.dart';
import '../chat_providers.dart';

/// Chip text for the controller state — "Lume · محمد", "Human agent · Sara",
/// "Chatbot", … Mirrors the portal's `controller.*Named` strings. [nameOf]
/// resolves a human assignee's user id to a display name (null = unknown).
String controllerChipLabel(
  AppLocalizations l10n,
  ConversationControllerState state,
  String? Function(String userId) nameOf,
) {
  final detail = state.controller == ConversationControllerKind.human
      ? (state.assignedUserId == null ? null : nameOf(state.assignedUserId!))
      : state.label;
  return switch (state.controller) {
    ConversationControllerKind.human =>
      detail == null
          ? l10n.controllerHuman
          : l10n.controllerHumanNamed(detail),
    ConversationControllerKind.chatbot =>
      detail == null
          ? l10n.controllerChatbot
          : l10n.controllerChatbotNamed(detail),
    ConversationControllerKind.journey =>
      detail == null
          ? l10n.controllerJourney
          : l10n.controllerJourneyNamed(detail),
    ConversationControllerKind.lume =>
      detail == null ? l10n.controllerLume : l10n.controllerLumeNamed(detail),
    ConversationControllerKind.released => l10n.controllerReleased,
  };
}

/// One-line explanation shown when the chip is tapped.
String controllerChipHint(
  AppLocalizations l10n,
  ConversationControllerState state, {
  DateTime? now,
}) {
  return switch (state.controller) {
    ConversationControllerKind.human => l10n.controllerHintHuman(
      state.until == null
          ? '—'
          : DateFormat.jm(l10n.localeName).format(state.until!.toLocal()),
    ),
    ConversationControllerKind.chatbot => l10n.controllerHintChatbot,
    ConversationControllerKind.journey => l10n.controllerHintJourney,
    ConversationControllerKind.lume => l10n.controllerHintLume,
    ConversationControllerKind.released => l10n.controllerHintReleased,
  };
}

/// Header strip under the chat app bar: a pill saying who is answering this
/// conversation right now (KAN-34), like the portal's chat header. Renders
/// nothing until the first lookup lands, and stays on the last known state
/// while a re-poll is in flight so the header never flickers.
class ConversationControllerBar extends ConsumerWidget {
  const ConversationControllerBar({
    super.key,
    required this.clientId,
    this.senderId,
  });

  final String clientId;
  final String? senderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref
        .watch(
          conversationControllerProvider((
            clientId: clientId,
            senderId: senderId,
          )),
        )
        .value;
    if (state == null) return const SizedBox.shrink();
    final members = ref.watch(tenantMembersProvider).value;
    String? nameOf(String userId) =>
        members?.where((m) => m.userId == userId).firstOrNull?.displayName;

    final l10n = AppLocalizations.of(context);
    final look = _lookFor(context, state.controller);
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.lg, Insets.xs, Insets.lg, 0),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Tooltip(
          message: controllerChipHint(l10n, state),
          triggerMode: TooltipTriggerMode.tap,
          showDuration: const Duration(seconds: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Insets.sm + 2,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: look.background,
              borderRadius: BorderRadius.circular(Radii.pill),
              border: Border.all(color: look.color.withValues(alpha: 0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(look.icon, size: 14, color: look.color),
                const SizedBox(width: Insets.xs + 1),
                Flexible(
                  child: Text(
                    controllerChipLabel(l10n, state, nameOf),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.labelMedium?.copyWith(
                      color: look.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ({Color color, Color background, IconData icon}) _lookFor(
    BuildContext context,
    ConversationControllerKind kind,
  ) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final scheme = context.scheme;
    Color tint(Color c) => c.withValues(alpha: dark ? 0.18 : 0.12);
    return switch (kind) {
      ConversationControllerKind.human => (
        color: dark ? AppColors.signal : AppColors.signalDeep,
        background: tint(AppColors.signal),
        icon: Icons.person_rounded,
      ),
      ConversationControllerKind.chatbot => (
        color: dark ? AppColors.lilac : const Color(0xFF6E55D6),
        background: tint(AppColors.lilac),
        icon: Icons.smart_toy_outlined,
      ),
      ConversationControllerKind.journey => (
        color: dark ? AppColors.amber : const Color(0xFFB07A10),
        background: tint(AppColors.amber),
        icon: Icons.bolt_rounded,
      ),
      ConversationControllerKind.lume => (
        color: dark ? AppColors.lumeOnDark : AppColors.lume,
        background: tint(AppColors.lume),
        icon: Icons.smart_toy_rounded,
      ),
      ConversationControllerKind.released => (
        color: scheme.onSurfaceVariant,
        background: scheme.onSurface.withValues(alpha: dark ? 0.10 : 0.06),
        icon: Icons.pause_circle_outline_rounded,
      ),
    };
  }
}
