import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../auth/auth_controller.dart';

/// Tenant feature switches (`GET /features`, audit item D6) — cached for the
/// session (NOT autoDispose) and re-fetched whenever the active tenant
/// changes, so it effectively loads once at tenant selection/app start.
/// [HomeShell] watches it eagerly so the flags are already resolved by the
/// time a chat screen needs them.
///
/// Consumers gate channel-specific affordances through
/// [channelFeatureEnabled]; existing data-gating (only render what the API
/// returned) stays as the fallback whenever the flags aren't available.
final tenantFeaturesProvider = FutureProvider<Map<String, bool>>((ref) async {
  ref.watch(authControllerProvider.select((s) => s.activeTenantId));
  return ref.read(featuresRepoProvider).getFlags();
});

/// The channel feature keys (plan-derived server-side since Phase 6.1).
/// WhatsApp is the product's core channel and has no flag — never gate it.
const channelFeatureKeys = [
  'channel_instagram',
  'channel_messenger',
  'channel_sms',
  'channel_email',
];

/// Whether [channelType] ('instagram' | 'messenger' | 'sms' | 'email' |
/// 'whatsapp') is enabled by the tenant's feature flags.
///
/// Fail-open by design: a null [flags] map (fetch pending or failed) and an
/// unknown key both yield true, leaving the existing data-gating in charge —
/// the flags only *refine* what the data already justifies showing. WhatsApp
/// is always enabled (no flag exists for it).
bool channelFeatureEnabled(Map<String, bool>? flags, String channelType) {
  if (flags == null || channelType == 'whatsapp') return true;
  return flags['channel_$channelType'] ?? true;
}

/// True when every channel flag is an explicit false — the one case where
/// fetching channel threads is pointless (mirrors the portal's `skip`).
bool allChannelFeaturesDisabled(Map<String, bool>? flags) {
  if (flags == null) return false;
  return channelFeatureKeys.every((k) => flags[k] == false);
}
