import 'package:dio/dio.dart';

/// Campaigns API client. The mobile client-detail screen reads the campaigns
/// that targeted a contact together with that contact's own delivery outcome;
/// campaign authoring stays in the portal.
class CampaignsRepo {
  CampaignsRepo(this._dio);
  final Dio _dio;

  /// `GET /campaigns/by-client/:clientId` → `ClientCampaign[]` (plain array).
  Future<List<ClientCampaign>> forClient(String clientId) async {
    final res = await _dio.get<List<dynamic>>('/campaigns/by-client/$clientId');
    return (res.data ?? const [])
        .map((e) => ClientCampaign.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

/// Lightweight read model for a campaign row on the contact (no codegen).
/// `messageStatus` is this contact's delivery outcome; `campaignStatus` is the
/// campaign's overall state.
class ClientCampaign {
  const ClientCampaign({
    required this.campaignId,
    required this.type,
    required this.campaignStatus,
    required this.messageStatus,
    this.title,
    this.sentAt,
  });

  final String campaignId;
  final String type; // text | template | flow
  final String campaignStatus;
  final String messageStatus; // sent | delivered | read | failed | received
  final String? title;
  final String? sentAt;

  factory ClientCampaign.fromJson(Map<String, dynamic> m) => ClientCampaign(
    campaignId: (m['campaignId'] as String?) ?? (m['id'] as String? ?? ''),
    type: (m['type'] as String?) ?? 'text',
    campaignStatus: (m['campaignStatus'] as String?) ?? '',
    messageStatus: (m['messageStatus'] as String?) ?? '',
    title: m['title'] as String?,
    sentAt: m['sentAt'] as String?,
  );
}
