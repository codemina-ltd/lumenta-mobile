// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'channel_thread.freezed.dart';
part 'channel_thread.g.dart';

/// One of a client's non-WhatsApp (Instagram DM / Messenger) inbox threads,
/// from `GET /v1/inbox/clients/:id/channel-threads` — one per connected
/// channel account, most recently active first. Hydrated with the channel
/// account's display name/status so the composer can render (and disable
/// itself) without a second round trip.
@freezed
abstract class ChannelThread with _$ChannelThread {
  const factory ChannelThread({
    required String id,
    required String channelType,
    required String channelAccountId,
    String? serviceWindowExpiresAt,
    String? lastInboundAt,
    String? lastOutboundAt,
    String? accountDisplayName,
    @Default('inactive') String accountStatus,
  }) = _ChannelThread;

  const ChannelThread._();

  factory ChannelThread.fromJson(Map<String, dynamic> json) =>
      _$ChannelThreadFromJson(json);

  /// Whether the 24-hour customer-service window is currently open
  /// (free-form sends allowed).
  bool get windowOpen {
    final raw = serviceWindowExpiresAt;
    final expires = raw == null ? null : DateTime.tryParse(raw);
    return expires != null && expires.isAfter(DateTime.now());
  }

  /// Whether the HUMAN_AGENT tag can still extend the reply window — allowed
  /// up to 7 days after the customer's last message (mirrors the portal's
  /// ChannelComposer and the server-side enforcement).
  bool get humanAgentAvailable {
    final raw = lastInboundAt;
    final last = raw == null ? null : DateTime.tryParse(raw);
    return last != null &&
        DateTime.now().difference(last) <= const Duration(days: 7);
  }
}
