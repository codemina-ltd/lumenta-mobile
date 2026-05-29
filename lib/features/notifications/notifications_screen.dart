import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/i18n/arb/app_localizations.dart';
import '../../core/i18n/notification_i18n.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/notification.dart';
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
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null && state.items.isEmpty) {
      return ErrorRetry(onRetry: controller.refresh);
    }
    if (state.items.isEmpty) {
      return EmptyState(
        message: l10n.notificationsEmpty,
        icon: Icons.notifications_none,
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView.separated(
        controller: _scroll,
        itemCount: state.items.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, i) {
          if (i >= state.items.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
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
          return ListTile(
            leading: _SeverityDot(severity: n.severity, unread: !n.isRead),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: n.isRead ? FontWeight.w500 : FontWeight.w700,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (body.isNotEmpty) Text(body),
                const SizedBox(height: 2),
                Text(
                  Fmt.listTimestamp(context, n.createdAtDate),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            isThreeLine: body.isNotEmpty,
            onTap: () => _onTap(n),
          );
        },
      ),
    );
  }
}

class _SeverityDot extends StatelessWidget {
  const _SeverityDot({required this.severity, required this.unread});
  final NotificationSeverity severity;
  final bool unread;

  Color get _color {
    switch (severity) {
      case NotificationSeverity.critical:
        return AppColors.ember;
      case NotificationSeverity.warning:
        return AppColors.amber;
      case NotificationSeverity.success:
        return AppColors.signal;
      case NotificationSeverity.info:
        return AppColors.lilac;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 6,
            backgroundColor: unread ? _color : _color.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
