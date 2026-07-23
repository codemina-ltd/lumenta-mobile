import 'package:flutter/material.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/scheduled_message.dart';
import '../../../data/models/smp_call.dart';

/// Localised label + colour maps for the enum-ish string statuses shown across
/// the client-detail cards (message delivery, order status, thread status,
/// suppression scope/reason). Falls back to the raw server value when an
/// unexpected key arrives, so a new backend enum degrades gracefully.

String messageStatusLabel(AppLocalizations l10n, String status) =>
    switch (status) {
      'sent' => l10n.statusSent,
      'delivered' => l10n.statusDelivered,
      'read' => l10n.statusRead,
      'failed' => l10n.statusFailed,
      'received' => l10n.statusReceived,
      _ => status,
    };

Color messageStatusColor(String status) => switch (status) {
  'read' => AppColors.lilac,
  'delivered' => AppColors.signal,
  'received' => AppColors.signalDeep,
  'failed' => AppColors.ember,
  _ => AppColors.slate,
};

String orderStatusLabel(AppLocalizations l10n, String status) =>
    switch (status) {
      'pending' => l10n.orderStatusPending,
      'confirmed' => l10n.orderStatusConfirmed,
      'paid' => l10n.orderStatusPaid,
      'shipped' => l10n.orderStatusShipped,
      'completed' => l10n.orderStatusCompleted,
      'cancelled' => l10n.orderStatusCancelled,
      _ => status,
    };

Color orderStatusColor(String status) => switch (status) {
  'completed' || 'paid' => AppColors.signal,
  'shipped' || 'confirmed' => AppColors.signalDeep,
  'cancelled' => AppColors.ember,
  _ => AppColors.amber,
};

String callDirectionLabel(AppLocalizations l10n, CallDirection direction) =>
    switch (direction) {
      CallDirection.incoming => l10n.callDirectionIncoming,
      CallDirection.outgoing => l10n.callDirectionOutgoing,
      CallDirection.missed => l10n.callDirectionMissed,
      CallDirection.rejected => l10n.callDirectionRejected,
      CallDirection.unknown => '—',
    };

Color callDirectionColor(CallDirection direction) => switch (direction) {
  CallDirection.outgoing => AppColors.signal,
  CallDirection.incoming => AppColors.lilac,
  CallDirection.missed => AppColors.amber,
  CallDirection.rejected => AppColors.ember,
  CallDirection.unknown => AppColors.slate,
};

String threadStatusLabel(AppLocalizations l10n, String status) =>
    switch (status) {
      'open' => l10n.threadStatusOpen,
      'pending' => l10n.threadStatusPending,
      'resolved' => l10n.threadStatusResolved,
      'snoozed' => l10n.threadStatusSnoozed,
      _ => status,
    };

String suppressionScopeLabel(AppLocalizations l10n, String scope) =>
    switch (scope) {
      'marketing' => l10n.suppressionScopeMarketing,
      'all' => l10n.suppressionScopeAll,
      _ => scope,
    };

String scheduledMessageStatusLabel(
  AppLocalizations l10n,
  ScheduledMessageStatus status,
) => switch (status) {
  ScheduledMessageStatus.pending => l10n.scheduledMessageStatusPending,
  ScheduledMessageStatus.sent => l10n.scheduledMessageStatusSent,
  ScheduledMessageStatus.cancelled => l10n.scheduledMessageStatusCancelled,
  ScheduledMessageStatus.failed => l10n.scheduledMessageStatusFailed,
};

Color scheduledMessageStatusColor(ScheduledMessageStatus status) =>
    switch (status) {
      ScheduledMessageStatus.sent => AppColors.signal,
      ScheduledMessageStatus.pending => AppColors.amber,
      ScheduledMessageStatus.cancelled => AppColors.slate,
      ScheduledMessageStatus.failed => AppColors.ember,
    };

String suppressionReasonLabel(AppLocalizations l10n, String reason) =>
    switch (reason) {
      'user_optout' => l10n.suppressionReasonUserOptout,
      'manual' => l10n.suppressionReasonManual,
      'hard_bounce' => l10n.suppressionReasonHardBounce,
      'blocked_by_user' => l10n.suppressionReasonBlockedByUser,
      'compliance' => l10n.suppressionReasonCompliance,
      _ => reason,
    };
