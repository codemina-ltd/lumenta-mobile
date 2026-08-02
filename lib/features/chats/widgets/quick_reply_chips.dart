import 'package:flutter/material.dart';

import '../../../core/format.dart';
import '../../../core/theme/app_dimens.dart';

/// The native quick replies a chatbot MENU step offered on an outbound
/// IG/Messenger message, rendered as small display-only pill chips under the
/// prompt body — mirrors the portal's ChatBubble quick-reply chips. The
/// options ride as real buttons on the customer's side; here they only show
/// the agent what was offered, so the chips are never tappable.
class QuickReplyChips extends StatelessWidget {
  const QuickReplyChips({
    super.key,
    required this.titles,
    required this.textColor,
  });

  final List<String> titles;

  /// The bubble's text color — the chips derive their border/fill from it so
  /// they read correctly on both inbound and outbound bubbles.
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final title in titles)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: textColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(Radii.pill),
              border: Border.all(color: textColor.withValues(alpha: 0.25)),
            ),
            child: Text(
              title,
              textDirection: Fmt.textDirectionFor(title),
              style: TextStyle(
                color: textColor.withValues(alpha: 0.9),
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ),
      ],
    );
  }
}
