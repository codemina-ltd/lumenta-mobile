import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/i18n/arb/app_localizations.dart';
import '../../core/i18n/notification_i18n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/notification.dart';
import '../shared/skeletons.dart';
import '../shared/widgets.dart';
import 'notifications_controller.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels >=
          _scroll.position.maxScrollExtent - 320) {
        ref.read(notificationsControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// Extracts a client id from a notification so taps can deep-link to a chat.
  String? _clientIdFor(AppNotification n) {
    if (n.resourceType == 'client' && n.resourceId != null) {
      return n.resourceId;
    }
    final url = n.actionUrl;
    if (url != null) {
      final m = RegExp(r'/(?:conversations|clients|chats)/([\w-]+)')
          .firstMatch(url);
      if (m != null) return m.group(1);
    }
    if (n.eventKey.startsWith('conversation.') && n.resourceId != null) {
      return n.resourceId;
    }
    return null;
  }

  void _onTap(AppNotification n) {
    ref.read(notificationsControllerProvider.notifier).markRead(n.id);
    final clientId = _clientIdFor(n);
    if (clientId != null) {
      context.go('/chats/$clientId');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final state = ref.watch(notificationsControllerProvider);
    final controller = ref.read(notificationsControllerProvider.notifier);

    if (state.loading) {
      return const SkeletonList(count: 8);
    }
    if (state.error != null && state.items.isEmpty) {
      return ErrorRetry(onRetry: controller.refresh);
    }
    if (state.items.isEmpty) {
      return EmptyState(
        title: l10n.notificationsEmpty,
        message: l10n.notificationsEmpty,
        icon: Icons.notifications_none_rounded,
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView.separated(
        controller: _scroll,
        padding: const EdgeInsets.only(bottom: Insets.lg),
        itemCount: state.items.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => Divider(
          height: 1,
          indent: 72,
          endIndent: Insets.lg,
          color: context.scheme.outlineVariant,
        ),
        itemBuilder: (context, i) {
          if (i >= state.items.length) {
            return const Padding(
              padding: EdgeInsets.all(Insets.lg),
              child: Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                ),
              ),
            );
          }
          final n = state.items[i];
          final title = NotificationI18n.resolve(
            locale,
            n.titleKey,
            n.titleParams,
          );
          final body = NotificationI18n.resolve(
            locale,
            n.bodyKey,
            n.bodyParams,
          );
          return _NotificationRow(
            severity: n.severity,
            unread: !n.isRead,
            title: title,
            body: body,
            timestamp: Fmt.listTimestamp(context, n.createdAtDate),
            onTap: () => _onTap(n),
          );
        },
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    required this.severity,
    required this.unread,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.onTap,
  });

  final NotificationSeverity severity;
  final bool unread;
  final String title;
  final String body;
  final String timestamp;
  final VoidCallback onTap;

  ({Color color, IconData icon}) get _style {
    switch (severity) {
      case NotificationSeverity.critical:
        return (color: AppColors.ember, icon: Icons.error_rounded);
      case NotificationSeverity.warning:
        return (color: AppColors.amber, icon: Icons.warning_amber_rounded);
      case NotificationSeverity.success:
        return (color: AppColors.signal, icon: Icons.check_circle_rounded);
      case NotificationSeverity.info:
        return (color: AppColors.lilac, icon: Icons.info_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _style;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: unread ? s.color.withValues(alpha: 0.05) : null,
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: Insets.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: s.color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(Radii.md),
              ),
              child: Icon(s.icon, color: s.color, size: 20),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.titleSmall?.copyWith(
                            fontWeight:
                                unread ? FontWeight.w700 : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (unread) ...[
                        const SizedBox(width: Insets.sm),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: s.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (body.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodyMedium?.copyWith(
                        color: context.scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: Insets.sm),
                  Text(
                    timestamp,
                    style: context.text.labelSmall?.copyWith(
                      color: context.scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
