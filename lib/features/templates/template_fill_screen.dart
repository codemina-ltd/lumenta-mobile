import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/template.dart';
import '../chats/chat_providers.dart';
import '../chats/thread_controller.dart';
import '../chats/widgets/template_bubble.dart';
import 'template_vars.dart';

/// Full-screen form for filling a template's body + button variables, with a
/// live preview. Sends via [ThreadController.sendTemplate] and pops `true` on
/// success so the caller can scroll the thread to the new bubble. The send is
/// bound to [threadKey]'s sender (per-sender thread tabs).
class TemplateFillScreen extends ConsumerStatefulWidget {
  const TemplateFillScreen({
    super.key,
    required this.template,
    required this.threadKey,
    required this.to,
  });

  final Template template;
  final ThreadKey threadKey;
  final String to;

  @override
  ConsumerState<TemplateFillScreen> createState() => _TemplateFillScreenState();
}

class _TemplateFillScreenState extends ConsumerState<TemplateFillScreen> {
  late final List<TemplateVarField> _varFields;
  late final List<TemplateButtonField> _buttonFields;
  final Map<String, TextEditingController> _controllers = {};
  bool _sending = false;

  Template get _t => widget.template;

  @override
  void initState() {
    super.initState();
    _varFields = templateVarFields(_t);
    _buttonFields = templateButtonFields(_t);
    for (final f in _varFields) {
      _controllers['v:${f.key}'] = TextEditingController()
        ..addListener(_onChanged);
    }
    for (final f in _buttonFields) {
      _controllers['b:${f.key}'] = TextEditingController()
        ..addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _onChanged() => setState(() {});

  Map<String, String> get _variables => {
        for (final f in _varFields)
          f.key: _controllers['v:${f.key}']!.text.trim(),
      };

  Map<String, String> get _buttonVariables => {
        for (final f in _buttonFields)
          f.key: _controllers['b:${f.key}']!.text.trim(),
      };

  List<String> get _missing => [
        ...missingVarLabels(_t, _variables),
        ...missingButtonLabels(_t, _buttonVariables),
      ];

  Future<void> _send() async {
    if (_missing.isNotEmpty || _sending) return;
    setState(() => _sending = true);
    final btn = _buttonVariables;
    final error = await ref
        .read(threadControllerProvider(widget.threadKey).notifier)
        .sendTemplate(
          to: widget.to,
          template: _t,
          variables: _variables,
          buttonVariables: btn.isEmpty ? null : btn,
        );
    if (!mounted) return;
    if (error == null) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _sending = false);
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorText(error, l10n))),
      );
    }
  }

  /// Surface the provider error detail (e.g. Meta code 131049) when present.
  String _errorText(Object error, AppLocalizations l10n) {
    final detail = _extractDetail(error);
    return detail ?? l10n.templateSendFailed;
  }

  String? _extractDetail(Object error) {
    // DioException carries the API error body; pull a human message out of it.
    final dynamic e = error;
    try {
      final data = e.response?.data;
      if (data is Map) {
        final msg = data['message'] ?? data['error'];
        if (msg is String && msg.trim().isNotEmpty) return msg;
        if (msg is List && msg.isNotEmpty) return msg.join('\n');
      }
    } catch (_) {
      // Not a Dio error — fall through to the generic copy.
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isMarketingUs =
        _t.category == 'marketing' && widget.to.startsWith('1');
    final canSend = _missing.isEmpty && !_sending;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.templateFillTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Insets.lg,
          Insets.lg,
          Insets.lg,
          Insets.xxxl,
        ),
        children: [
          _PreviewCard(template: _t, variables: _variables),
          if (isMarketingUs) ...[
            const SizedBox(height: Insets.md),
            _WarningBanner(message: l10n.templateMarketingUsWarning),
          ],
          const SizedBox(height: Insets.xl),
          for (final f in _varFields) ...[
            _Field(
              controller: _controllers['v:${f.key}']!,
              label: f.label,
              hint: f.example,
            ),
            const SizedBox(height: Insets.lg),
          ],
          for (final f in _buttonFields) ...[
            _Field(
              controller: _controllers['b:${f.key}']!,
              label: f.label,
              hint: null,
            ),
            const SizedBox(height: Insets.lg),
          ],
          const SizedBox(height: Insets.sm),
          FilledButton.icon(
            onPressed: canSend ? _send : null,
            icon: _sending
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_rounded, size: 20),
            label: Text(l10n.sendTemplate),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: AppColors.signal,
              foregroundColor: AppColors.deepForest,
            ),
          ),
          if (_missing.isNotEmpty) ...[
            const SizedBox(height: Insets.sm),
            Text(
              l10n.templateVarRequired(_missing.join(', ')),
              style: context.text.bodySmall?.copyWith(
                color: context.scheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.controller, required this.label, this.hint});

  final TextEditingController controller;
  final String label;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.text.labelLarge),
        const SizedBox(height: Insets.sm),
        TextField(
          controller: controller,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            border: const OutlineInputBorder(borderRadius: Radii.field),
          ),
        ),
      ],
    );
  }
}

/// Live preview styled like an outbound chat bubble. Renders the full template
/// — header (text or media), formatted body with live-filled variables, footer,
/// buttons, and carousel — through [TemplateContentView] so it matches the sent
/// bubble (and the portal) exactly. The template handed in comes from the list
/// endpoint, which omits presigned media URLs; [chatTemplateProvider] fetches
/// the detail so header/carousel images can render. The preview shows
/// immediately with the list template and upgrades in place once detail loads.
class _PreviewCard extends ConsumerWidget {
  const _PreviewCard({required this.template, required this.variables});

  final Template template;
  final Map<String, String> variables;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final chat = context.chat;
    final detail = ref.watch(chatTemplateProvider(template.id)).asData?.value;
    // Body is rendered from the list template (whose fields the form was built
    // from); the detail template only enriches media/structure.
    final structural = detail ?? template;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.templatePreview,
          style: context.text.labelMedium?.copyWith(
            color: context.scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Insets.sm),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.82,
            ),
            // Narrow padding so a media header sits close to the bubble's top
            // and sides (its Radii.sm corners then nest concentrically in the
            // bubble's Radii.md corners); TemplateContentView adds the
            // difference back to the body so text keeps its Insets.md sides and
            // Insets.sm top.
            padding: const EdgeInsets.fromLTRB(
              Insets.xs,
              Insets.xs,
              Insets.xs,
              Insets.sm,
            ),
            decoration: BoxDecoration(
              color: chat.outboundBubble,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Radii.md),
                topRight: Radius.circular(Radii.md),
                bottomLeft: Radius.circular(Radii.md),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: TemplateContentView(
              template: structural,
              body: renderPreview(template, variables),
              textColor: chat.outboundText,
              sidePadding: Insets.md - Insets.xs,
              topPadding: Insets.sm - Insets.xs,
            ),
          ),
        ),
      ],
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.amber.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              size: 20, color: AppColors.amber),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Text(message, style: context.text.bodySmall),
          ),
        ],
      ),
    );
  }
}
