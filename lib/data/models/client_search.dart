import 'package:freezed_annotation/freezed_annotation.dart';

import 'client.dart';

part 'client_search.freezed.dart';
part 'client_search.g.dart';

/// One reason a client matched in `GET /v1/search/clients` — which source
/// the hit came from plus a short excerpt around the matched text.
///
/// `source` is one of: name, phone, customField, message, note, headline.
@freezed
abstract class ClientSearchMatch with _$ClientSearchMatch {
  const factory ClientSearchMatch({
    required String source,
    required String snippet,
    /// Custom field label — present only when [source] == 'customField'.
    String? fieldLabel,
  }) = _ClientSearchMatch;

  factory ClientSearchMatch.fromJson(Map<String, dynamic> json) =>
      _$ClientSearchMatchFromJson(json);
}

/// A ranked client hit from the global search endpoint.
@freezed
abstract class ClientSearchResult with _$ClientSearchResult {
  const factory ClientSearchResult({
    required Client client,
    required int score,
    required List<ClientSearchMatch> matches,
  }) = _ClientSearchResult;

  factory ClientSearchResult.fromJson(Map<String, dynamic> json) =>
      _$ClientSearchResultFromJson(json);
}
