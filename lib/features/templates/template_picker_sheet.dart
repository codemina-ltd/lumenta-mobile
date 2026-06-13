import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/template.dart';
import '../chats/thread_controller.dart';
import '../shared/skeletons.dart';
import '../shared/widgets.dart';
import 'template_fill_screen.dart';
import 'template_vars.dart';
import 'templates_controller.dart';

/// Run the full pick → fill → send flow: a modal picker, then the fill screen.
/// Returns `true` once a template has been sent so the caller can scroll the
/// thread to the new bubble. The picker lists only templates sendable by the
/// thread's sender (`threadKey.senderId`); a merged thread shows them all.
Future<bool?> showTemplatePicker({
  required BuildContext context,
  required ThreadKey threadKey,
  required String to,
}) async {
  final template = await showModalBottomSheet<Template>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(borderRadius: Radii.sheet),
    builder: (_) => _TemplatePickerSheet(forSenderId: threadKey.senderId),
  );
  if (template == null || !context.mounted) return null;
  return Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (_) => TemplateFillScreen(
        template: template,
        threadKey: threadKey,
        to: to,
      ),
    ),
  );
}

class _TemplatePickerSheet extends ConsumerStatefulWidget {
  const _TemplatePickerSheet({this.forSenderId});

  final String? forSenderId;

  @override
  ConsumerState<_TemplatePickerSheet> createState() =>
      _TemplatePickerSheetState();
}

class _TemplatePickerSheetState extends ConsumerState<_TemplatePickerSheet> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref
          .read(templatesControllerProvider(widget.forSenderId).notifier)
          .setSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(templatesControllerProvider(widget.forSenderId));
    final controller =
        ref.read(templatesControllerProvider(widget.forSenderId).notifier);

    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: [
            const SizedBox(height: Insets.sm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.scheme.outlineVariant,
                borderRadius: BorderRadius.circular(Radii.pill),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Insets.lg,
                Insets.md,
                Insets.lg,
                Insets.sm,
              ),
              child: Row(
                children: [
                  Text(l10n.templatePickerTitle, style: context.text.titleLarge),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Insets.lg,
                0,
                Insets.lg,
                Insets.sm,
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: _onSearchChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: l10n.templateSearchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  isDense: true,
                  border:
                      const OutlineInputBorder(borderRadius: Radii.field),
                ),
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (state.loading) {
                    return const SkeletonList(count: 7, lines: 2);
                  }
                  if (state.error != null && state.items.isEmpty) {
                    return ErrorRetry(onRetry: controller.refresh);
                  }
                  if (state.items.isEmpty) {
                    return EmptyState(
                      title: l10n.noApprovedTemplates,
                      message: l10n.noApprovedTemplatesHint,
                      icon: Icons.description_outlined,
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: Insets.lg),
                    itemCount: state.items.length,
                    separatorBuilder: (_, _) => Divider(
                      height: 1,
                      indent: Insets.lg,
                      endIndent: Insets.lg,
                      color: context.scheme.outlineVariant,
                    ),
                    itemBuilder: (context, i) => _TemplateRow(
                      template: state.items[i],
                      onTap: () =>
                          Navigator.of(context).pop(state.items[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplateRow extends StatelessWidget {
  const _TemplateRow({required this.template, required this.onTap});

  final Template template;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: Insets.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    template.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleMedium,
                  ),
                ),
                if (template.category.isNotEmpty) ...[
                  const SizedBox(width: Insets.sm),
                  _CategoryPill(category: template.category),
                ],
                if (template.hasMediaHeader) ...[
                  const SizedBox(width: Insets.xs),
                  _MediaChip(template: template),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              renderPreview(template, const {}),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.bodySmall?.copyWith(
                color: context.scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Insets.sm, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.lilac.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Text(
        category,
        style: context.text.labelSmall?.copyWith(
          color: context.scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MediaChip extends StatelessWidget {
  const _MediaChip({required this.template});

  final Template template;

  @override
  Widget build(BuildContext context) {
    final icon = switch (template.headerFormat) {
      'IMAGE' => Icons.image_rounded,
      'VIDEO' => Icons.videocam_rounded,
      _ => Icons.insert_drive_file_rounded,
    };
    return Icon(icon, size: 18, color: context.scheme.onSurfaceVariant);
  }
}
