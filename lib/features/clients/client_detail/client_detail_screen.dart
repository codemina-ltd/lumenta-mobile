import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/client.dart';
import '../../chats/chat_providers.dart';
import '../../shared/live_call_badge.dart';
import '../../shared/skeletons.dart';
import '../../shared/widgets.dart';
import 'client_calls_card.dart';
import 'client_campaigns_card.dart';
import 'client_detail_providers.dart';
import 'client_notes_card.dart';
import 'client_orders_card.dart';
import 'client_profile_card.dart';
import 'client_recent_messages_card.dart';
import 'client_reminders_card.dart';
import 'client_scheduled_messages_card.dart';
import 'client_segments_card.dart';
import 'client_suppression_card.dart';
import 'client_team_card.dart';

/// Full contact profile, reached by tapping the client name in the chat header.
/// A collapsing brand hero carries the contact's identity and a primary
/// "open chat" action; a unified stat strip sits beneath it, and the CRM
/// sections are grouped (profile & team · activity · marketing & commerce) so
/// the long scroll reads as one system. Each section owns its own query and
/// loads independently.
class ClientDetailScreen extends ConsumerWidget {
  const ClientDetailScreen({
    super.key,
    required this.clientId,
    this.highlightNoteId,
  });
  final String clientId;

  /// Deep-link target (`/clients/:clientId?noteId=…` from mention/assignment
  /// notifications): once the notes card loads, scroll to and briefly
  /// highlight this note.
  final String? highlightNoteId;

  Future<void> _copy(BuildContext context, String text, String message) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final clientAsync = ref.watch(clientProvider(clientId));

    return Scaffold(
      body: clientAsync.when(
        loading: () => _LoadingScaffold(title: l10n.clientDetailTitle),
        error: (_, _) => _ErrorScaffold(
          title: l10n.clientDetailTitle,
          message: l10n.clientDetailLoadError,
          onRetry: () => ref.invalidate(clientProvider(clientId)),
        ),
        data: (client) {
          final groups = <({String title, List<Widget> cards})>[
            (
              title: l10n.clientDetailGroupProfile,
              cards: [
                ClientProfileCard(clientId: clientId),
                ClientTeamCard(clientId: clientId),
              ],
            ),
            (
              title: l10n.clientDetailGroupActivity,
              cards: [
                ClientRemindersCard(clientId: clientId),
                ClientScheduledMessagesCard(clientId: clientId),
                ClientNotesCard(
                  clientId: clientId,
                  highlightNoteId: highlightNoteId,
                ),
                ClientRecentMessagesCard(clientId: clientId),
                ClientCallsCard(clientId: clientId),
              ],
            ),
            (
              title: l10n.clientDetailGroupCommerce,
              cards: [
                ClientOrdersCard(clientId: clientId),
                ClientCampaignsCard(clientId: clientId),
                ClientSegmentsCard(clientId: clientId),
                ClientSuppressionCard(clientId: clientId),
              ],
            ),
          ];

          final children = <Widget>[
            _PrimaryAction(clientId: clientId),
            const SizedBox(height: Insets.lg),
            _StatCard(clientId: clientId, client: client),
          ];
          for (final g in groups) {
            children
              ..add(const SizedBox(height: Insets.xl))
              ..add(_SectionHeader(g.title))
              ..add(const SizedBox(height: Insets.md));
            for (var i = 0; i < g.cards.length; i++) {
              if (i > 0) children.add(const SizedBox(height: Insets.lg));
              children.add(g.cards[i]);
            }
          }

          return CustomScrollView(
            // A deep-linked note may live many cards below the fold; force
            // every section to build up front so it exists to scroll/highlight
            // instead of staying unbuilt beyond the default cache extent.
            scrollCacheExtent: highlightNoteId != null
                ? const ScrollCacheExtent.pixels(10000)
                : null,
            slivers: [
              _HeroAppBar(
                client: client,
                onCopyPhone: () {
                  final phone = client.phoneNumber;
                  if (phone != null) {
                    _copy(context, phone, l10n.messageCopied);
                  }
                },
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  Insets.lg,
                  Insets.lg,
                  Insets.lg,
                  Insets.xxxl,
                ),
                sliver: SliverList.list(children: children),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Hero ─────────────────────────────────────────────────────────────────────

/// Collapsing brand header. Expanded: avatar, name, copyable phone, lifecycle
/// stage and acquisition source. As it collapses the identity fades out and the
/// contact name condenses into the pinned toolbar.
class _HeroAppBar extends ConsumerWidget {
  const _HeroAppBar({required this.client, required this.onCopyPhone});

  final Client client;
  final VoidCallback onCopyPhone;

  static const double _expandedHeight = 236;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final topPad = MediaQuery.paddingOf(context).top;

    // Lifecycle stage label (if the contact has one) for a hero pill.
    final bundle = ref
        .watch(contactProfileBundleProvider(client.id))
        .asData
        ?.value;
    String? stageLabel;
    final stageId = bundle?.response.profile?.lifecycleStageId;
    if (stageId != null) {
      stageLabel = bundle!.stages
          .where((s) => s.id == stageId)
          .firstOrNull
          ?.label;
    }

    // Click-to-WhatsApp acquisition source ("Came from …").
    final ctwa = ref.watch(clientCtwaProvider(client.id)).asData?.value;
    final source = (ctwa != null && ctwa.isNotEmpty) ? ctwa.first.label : null;

    return SliverAppBar(
      pinned: true,
      expandedHeight: _expandedHeight,
      backgroundColor: AppColors.deepForest,
      foregroundColor: AppColors.onDarkHigh,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final maxExtent = _expandedHeight + topPad;
          final minExtent = kToolbarHeight + topPad;
          final t =
              ((maxExtent - constraints.maxHeight) / (maxExtent - minExtent))
                  .clamp(0.0, 1.0);
          final expandedOpacity = (1 - t * 1.5).clamp(0.0, 1.0);
          final collapsedOpacity = ((t - 0.55) / 0.45).clamp(0.0, 1.0);

          return Container(
            decoration: BoxDecoration(gradient: context.brand.brand),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Collapsed toolbar title — the contact name beside the back
                // button once the hero has scrolled away.
                Positioned(
                  top: topPad,
                  height: kToolbarHeight,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: collapsedOpacity,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: 56,
                          end: Insets.lg,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            client.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.titleLarge?.copyWith(
                              color: AppColors.onDarkHigh,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Expanded identity block, anchored to the bottom.
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    ignoring: expandedOpacity < 0.05,
                    child: Opacity(
                      opacity: expandedOpacity,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: topPad + kToolbarHeight * 0.4,
                          left: Insets.lg,
                          right: Insets.lg,
                          bottom: Insets.lg,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InitialsAvatar(
                                  initials: client.initials,
                                  radius: 30,
                                ),
                                const SizedBox(width: Insets.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        client.displayName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.text.headlineSmall
                                            ?.copyWith(
                                              color: AppColors.onDarkHigh,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      if (client.phoneNumber != null) ...[
                                        const SizedBox(height: 2),
                                        _PhoneChip(
                                          phone: client.phoneNumber!,
                                          onCopy: onCopyPhone,
                                        ),
                                      ],
                                      LiveCallBadge(
                                        clientId: client.id,
                                        onDark: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (stageLabel != null || source != null) ...[
                              const SizedBox(height: Insets.md),
                              Wrap(
                                spacing: Insets.sm,
                                runSpacing: Insets.xs,
                                children: [
                                  if (stageLabel != null)
                                    _HeroPill(
                                      icon: Icons.timeline_rounded,
                                      label: stageLabel,
                                    ),
                                  if (source != null)
                                    _HeroPill(
                                      icon: Icons.campaign_rounded,
                                      label: '${l10n.contactCameFrom} $source',
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Copyable phone line shown on the dark hero gradient.
class _PhoneChip extends StatelessWidget {
  const _PhoneChip({required this.phone, required this.onCopy});
  final String phone;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCopy,
      borderRadius: BorderRadius.circular(Radii.pill),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '+$phone',
              style: context.text.bodyMedium?.copyWith(
                color: AppColors.onDarkMed,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.copy_rounded, size: 14, color: AppColors.onDarkMed),
          ],
        ),
      ),
    );
  }
}

/// Translucent light pill used for hero metadata (lifecycle, acquisition).
class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.onDarkHigh.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.onDarkHigh),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelSmall?.copyWith(
                color: AppColors.onDarkHigh,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Primary action ───────────────────────────────────────────────────────────

/// The one clear primary action for a contact: jump into their conversation.
class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction({required this.clientId});
  final String clientId;

  void _openConversation(BuildContext context) {
    // We usually arrive here from the chat, so returning there is a pop; from
    // any other entry point, navigate to the conversation instead.
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/chats/$clientId');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FilledButton.icon(
      onPressed: () => _openConversation(context),
      icon: const Icon(Icons.chat_bubble_rounded, size: 20),
      label: Text(l10n.clientDetailOpenChat),
    );
  }
}

// ── Stat card ────────────────────────────────────────────────────────────────

/// Unified stat strip: joined date, last-message time, order count and the
/// (copyable) contact id, in one cohesive card rather than four loose tiles.
class _StatCard extends ConsumerWidget {
  const _StatCard({required this.clientId, required this.client});
  final String clientId;
  final Client client;

  String _joined(BuildContext context) {
    final raw = client.createdAt;
    final parsed = raw == null ? null : DateTime.tryParse(raw)?.toLocal();
    if (parsed == null) return '—';
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(parsed);
  }

  String _shortId(String id) => id.length > 14
      ? '${id.substring(0, 8)}…${id.substring(id.length - 4)}'
      : id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final messages = ref.watch(clientRecentMessagesProvider(clientId));
    final orders = ref.watch(clientOrdersProvider(clientId));

    // Recent-messages endpoint returns oldest→newest; the last item is newest.
    final newest = messages.asData?.value.isNotEmpty == true
        ? messages.asData!.value.last.createdAtDate
        : null;

    final lineColor = context.scheme.outlineVariant;

    Widget statRow(List<Widget> cells) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: cells[0]),
          VerticalDivider(width: 1, thickness: 1, color: lineColor),
          Expanded(child: cells[1]),
        ],
      ),
    );

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          statRow([
            _StatCell(
              icon: Icons.event_available_outlined,
              label: l10n.clientDetailJoined,
              value: _joined(context),
            ),
            _StatCell(
              icon: Icons.chat_bubble_outline_rounded,
              label: l10n.clientDetailLastMessage,
              value: newest != null
                  ? Fmt.listTimestamp(context, newest)
                  : l10n.clientDetailNoMessages,
            ),
          ]),
          Divider(height: 1, thickness: 1, color: lineColor),
          statRow([
            _StatCell(
              icon: Icons.shopping_bag_outlined,
              label: l10n.ordersTitle,
              value: '${orders.asData?.value.length ?? 0}',
            ),
            _StatCell(
              icon: Icons.badge_outlined,
              label: l10n.clientDetailContactId,
              value: _shortId(client.id),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: client.id));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.clientDetailCopiedId)),
                  );
                }
              },
            ),
          ]),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.md,
          vertical: Insets.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: context.scheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.labelSmall?.copyWith(
                      color: context.scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.copy_rounded,
                    size: 13,
                    color: context.scheme.onSurfaceVariant,
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section header ───────────────────────────────────────────────────────────

/// Small uppercase label that groups the CRM sections beneath it.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: Insets.xs),
      child: Text(
        title.toUpperCase(),
        style: context.text.labelSmall?.copyWith(
          color: context.scheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ── Loading / error scaffolds ────────────────────────────────────────────────

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const SkeletonList(count: 4),
    );
  }
}

class _ErrorScaffold extends StatelessWidget {
  const _ErrorScaffold({
    required this.title,
    required this.message,
    required this.onRetry,
  });
  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ErrorRetry(message: message, onRetry: onRetry),
    );
  }
}
