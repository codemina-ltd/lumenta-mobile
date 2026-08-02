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

  /// Bubble timestamp — always 12-hour ("7:09 PM"), matching the portal.
  /// Not `jm`: that pattern goes 24-hour in fr/ar locales, and chat bubbles
  /// should read 12-hour everywhere. The day-period marker still localizes
  /// (PM / م / PM).
  static String timeOfDay(BuildContext context, DateTime when) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat('h:mm a', locale).format(when);
  }

  /// Compact duration from a second count — "45s", "21m 9s", "1h 2m 3s".
  static String duration(int seconds) {
    final total = seconds < 0 ? 0 : seconds;
    final h = total ~/ 3600;
    final m = (total % 3600) ~/ 60;
    final s = total % 60;
    if (h > 0) return '${h}h ${m}m ${s}s';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  /// Paint direction for message text, resolved from the content itself
  /// rather than the app locale: an Arabic body lays out RTL inside its
  /// bubble even in an English UI, and vice versa.
  static TextDirection textDirectionFor(String text) =>
      Bidi.detectRtlDirectionality(text)
      ? TextDirection.rtl
      : TextDirection.ltr;

  /// `EGP 1,300.00` — matches the portal's product-card price formatting
  /// (currency code first, thousands-grouped, 2 decimals).
  static String money(int priceMinor, String currency) {
    final amount = NumberFormat('#,##0.00').format(priceMinor / 100);
    return '$currency $amount';
  }
}
