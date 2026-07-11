import 'package:flutter/widgets.dart';
// intl ships its own TextDirection; hide it so Flutter's is the one in scope.
import 'package:intl/intl.dart' hide TextDirection;

import 'i18n/arb/app_localizations.dart';

/// Date / time helpers shared across chat & notification lists.
class Fmt {
  const Fmt._();

  /// Relative timestamp for list rows: time today, "Yesterday", weekday this
  /// week, otherwise a short date. Locale-aware via [intl].
  static String listTimestamp(BuildContext context, DateTime when) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(when.year, when.month, when.day);
    final diffDays = today.difference(that).inDays;

    if (diffDays == 0) return DateFormat.jm(locale).format(when);
    if (diffDays == 1) return l10n.yesterday;
    if (diffDays < 7) return DateFormat.E(locale).format(when);
    return DateFormat.yMd(locale).format(when);
  }

  /// Header label for a day separator in the chat thread.
  static String dayHeader(BuildContext context, DateTime day) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(day.year, day.month, day.day);
    final diff = today.difference(that).inDays;
    if (diff == 0) return l10n.today;
    if (diff == 1) return l10n.yesterday;
    return DateFormat.yMMMMd(locale).format(day);
  }

  static String timeOfDay(BuildContext context, DateTime when) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.jm(locale).format(when);
  }

  /// Paint direction for message text, resolved from the content itself
  /// rather than the app locale: an Arabic body lays out RTL inside its
  /// bubble even in an English UI, and vice versa.
  static TextDirection textDirectionFor(String text) =>
      Bidi.detectRtlDirectionality(text)
      ? TextDirection.rtl
      : TextDirection.ltr;
}
