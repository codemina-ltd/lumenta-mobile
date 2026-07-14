import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/client_search.dart';
import '../shared/skeletons.dart';
import '../shared/widgets.dart';
import 'search_controller.dart';

/// Global client search, opened from the home app bar. Finds clients by
/// name, phone, custom field values, message bodies, internal notes and
/// CTWA ad headlines; tapping a result opens the client's chat thread.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {}); // keep the clear button in sync
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchControllerProvider.notifier).setQuery(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(searchControllerProvider);
    final controller = ref.read(searchControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _searchCtrl,
          autofocus: true,
          onChanged: _onChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: l10n.searchGlobalHint,
            border: InputBorder.none,
            suffixIcon: _searchCtrl.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () {
                      _searchCtrl.clear();
                      _onChanged('');
                    },
                  ),
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (state.query.length < kSearchMinQueryLength) {
            return EmptyState(
              title: l10n.searchGlobalTitle,
              message: l10n.searchMinChars,
              icon: Icons.search_rounded,
            );
          }
          if (state.loading) {
            return const SkeletonList(count: 6, lines: 2);
          }
          if (state.error != null) {
            return ErrorRetry(onRetry: controller.retry);
          }
          if (state.results.isEmpty) {
            return EmptyState(
              message: l10n.searchNoResults(state.query),
              icon: Icons.search_off_rounded,
            );
          }
          return ListView.separated(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.only(bottom: Insets.lg),
            itemCount: state.results.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              indent: 76,
              endIndent: Insets.lg,
              color: context.scheme.outlineVariant,
            ),
            itemBuilder: (context, i) {
              final result = state.results[i];
              return _ResultRow(
                result: result,
                query: state.query,
                onTap: () => context.push('/chats/${result.client.id}'),
              );
            },
          );
        },
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.result,
    required this.query,
    required this.onTap,
  });

  final ClientSearchResult result;
  final String query;
  final VoidCallback onTap;

  /// The first non-identity match (message, note, field…) — the name/phone
  /// already appear on the title line, so this is the interesting context.
  ClientSearchMatch? get _context {
    for (final m in result.matches) {
      if (m.source != 'name' && m.source != 'phone') return m;
    }
    return null;
  }

  String _sourceLabel(AppLocalizations l10n, ClientSearchMatch match) {
    switch (match.source) {
      case 'customField':
        return match.fieldLabel ?? l10n.searchSourceCustomField;
      case 'message':
        return l10n.searchSourceMessage;
      case 'note':
        return l10n.searchSourceNote;
      case 'headline':
        return l10n.searchSourceHeadline;
      default:
        return l10n.searchSourceCustomField;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final client = result.client;
    final contextMatch = _context;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: Insets.md,
        ),
        child: Row(
          children: [
            InitialsAvatar(initials: client.initials),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    highlightMatches(
                      client.displayName,
                      query,
                      context.text.titleMedium,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '+${client.phoneNumber}',
                    style: context.text.bodySmall?.copyWith(
                      color: context.scheme.onSurfaceVariant,
                      letterSpacing: 0.2,
                    ),
                  ),
                  if (contextMatch != null) ...[
                    const SizedBox(height: Insets.xs),
                    Row(
                      children: [
                        StatusPill(
                          label: _sourceLabel(l10n, contextMatch),
                          color: context.scheme.primary,
                        ),
                        const SizedBox(width: Insets.sm),
                        Expanded(
                          child: Text.rich(
                            highlightMatches(
                              contextMatch.snippet,
                              query,
                              context.text.bodySmall?.copyWith(
                                color: context.scheme.onSurfaceVariant,
                              ),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: Insets.sm),
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 20,
              color: context.scheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

/// Builds a [TextSpan] with every query-token occurrence bolded.
/// Case-insensitive; tokens are matched independently, mirroring the
/// server's per-token prefix search.
@visibleForTesting
TextSpan highlightMatches(String text, String query, TextStyle? style) {
  final tokens = query
      .trim()
      .split(RegExp(r'\s+'))
      .where((t) => t.isNotEmpty)
      .map(RegExp.escape)
      .toList();
  if (tokens.isEmpty || text.isEmpty) {
    return TextSpan(text: text, style: style);
  }
  final pattern = RegExp(tokens.join('|'), caseSensitive: false);
  final bold = (style ?? const TextStyle()).copyWith(
    fontWeight: FontWeight.w700,
  );
  final children = <TextSpan>[];
  var cursor = 0;
  for (final m in pattern.allMatches(text)) {
    if (m.start > cursor) {
      children.add(TextSpan(text: text.substring(cursor, m.start)));
    }
    children.add(TextSpan(text: text.substring(m.start, m.end), style: bold));
    cursor = m.end;
  }
  if (children.isEmpty) return TextSpan(text: text, style: style);
  if (cursor < text.length) {
    children.add(TextSpan(text: text.substring(cursor)));
  }
  return TextSpan(style: style, children: children);
}
