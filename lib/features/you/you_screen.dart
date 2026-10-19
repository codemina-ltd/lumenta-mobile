import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/user.dart';
import '../auth/auth_controller.dart';
import '../push/push_service.dart';
import '../shared/widgets.dart';

/// Initials for the signed-in user (name, else email), shared by the You tab
/// and the nav-bar avatar.
String userInitials(User? user) {
  final source = (user?.name?.trim().isNotEmpty ?? false)
      ? user!.name!.trim()
      : (user?.email ?? '?');
  final parts = source
      .split(RegExp(r'\s+'))
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '?';
  final first = parts.first[0];
  final second = parts.length > 1 ? parts[1][0] : '';
  return (first + second).toUpperCase();
}

/// The user's picture, falling back to initials. [radius] in logical px.
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.user, this.radius = 24});

  final User? user;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final url = user?.avatarUrl;
    final fallback = InitialsAvatar(
      initials: userInitials(user),
      radius: radius,
    );
    if (url == null || url.isEmpty) return fallback;
    return ClipOval(
      // Short-lived signed S3 link that changes on every /me fetch, so the
      // cache naturally stays fresh.
      child: CachedNetworkImage(
        imageUrl: url,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorWidget: (_, _, _) => fallback,
      ),
    );
  }
}

/// WhatsApp-style "You" tab: identity card, then account / workspace
/// actions. Always usable after a degraded bootstrap (no tenant loaded) so
/// Switch workspace / Log out stay reachable.
class YouScreen extends ConsumerWidget {
  const YouScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authControllerProvider);
    final user = auth.user;
    final tenant = auth.activeTenant;
    final canSwitch = auth.tenants.length > 1;
    final name = (user?.name?.trim().isNotEmpty ?? false)
        ? user!.name!.trim()
        : (user?.profileName ?? user?.email ?? '');

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Insets.lg,
        Insets.sm,
        Insets.lg,
        Insets.xxl,
      ),
      children: [
        _GroupCard(
          children: [
            InkWell(
              onTap: () => context.push('/profile'),
              child: Padding(
                padding: const EdgeInsets.all(Insets.lg),
                child: Row(
                  children: [
                    UserAvatar(user: user, radius: 32),
                    const SizedBox(width: Insets.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.titleLarge?.copyWith(
                              fontSize: 20,
                            ),
                          ),
                          if (user?.email != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              user!.email!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.bodyMedium?.copyWith(
                                color: context.scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: context.scheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        _SectionLabel(l10n.youAccount),
        _GroupCard(
          children: [
            _Row(
              icon: Icons.person_outline_rounded,
              title: l10n.profileTitle,
              subtitle: l10n.youProfileSubtitle,
              onTap: () => context.push('/profile'),
            ),
            _Row(
              icon: Icons.people_alt_outlined,
              title: l10n.navClients,
              subtitle: l10n.youClientsSubtitle,
              onTap: () => context.push('/clients'),
            ),
          ],
        ),
        _SectionLabel(l10n.youWorkspace),
        _GroupCard(
          children: [
            _Row(
              icon: Icons.workspaces_rounded,
              iconColor: AppColors.signalDeep,
              title: tenant?.name ?? l10n.youWorkspace,
              subtitle: canSwitch ? l10n.switchTenant : null,
              trailing: canSwitch ? null : const SizedBox.shrink(),
              // Drive the picker through the auth state machine; the router
              // redirect bounces a direct `go('/select-tenant')` back to
              // `/chats` while the status is still `authenticated`.
              onTap: canSwitch
                  ? () =>
                        ref.read(authControllerProvider.notifier).switchTenant()
                  : null,
            ),
            _Row(
              icon: Icons.logout_rounded,
              iconColor: AppColors.ember,
              titleColor: AppColors.ember,
              title: l10n.logout,
              trailing: const SizedBox.shrink(),
              onTap: () async {
                // Unregister the device while the token is still valid, then
                // clear the session.
                await ref.read(pushServiceProvider).deregister();
                await ref.read(authControllerProvider.notifier).logout();
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Insets.xs,
        Insets.xl,
        Insets.xs,
        Insets.sm,
      ),
      child: Text(
        text,
        style: context.text.titleSmall?.copyWith(
          color: context.scheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.scheme.surfaceContainerLow,
      borderRadius: Radii.card,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                indent: Insets.lg + 36 + Insets.md,
                color: context.scheme.outlineVariant,
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.iconColor,
    this.titleColor,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? titleColor;

  /// Defaults to a chevron; pass `SizedBox.shrink()` to hide it.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final muted = context.scheme.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: Insets.md,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (iconColor ?? muted).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
              child: Icon(icon, size: 20, color: iconColor ?? muted),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleMedium?.copyWith(
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodySmall?.copyWith(color: muted),
                    ),
                  ],
                ],
              ),
            ),
            trailing ?? Icon(Icons.chevron_right_rounded, color: muted),
          ],
        ),
      ),
    );
  }
}
