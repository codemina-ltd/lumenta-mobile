// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sender.freezed.dart';
part 'sender.g.dart';

enum SenderStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('active')
  active,
  @JsonValue('inactive')
  inactive,
  @JsonValue('error')
  error,
}

/// A tenant WhatsApp sender (WABA phone number) from `GET /v1/senders`.
/// Only the fields the per-sender chat threads need; the endpoint returns
/// more (profile, tier, provider) which are ignored here.
@freezed
abstract class Sender with _$Sender {
  const factory Sender({
    required String id,
    @Default('') String displayName,
    String? phoneNumber,
    String? displayPhoneNumber,
    @JsonKey(unknownEnumValue: SenderStatus.pending)
    @Default(SenderStatus.pending)
    SenderStatus status,
    @Default(false) bool isDefault,
  }) = _Sender;

  const Sender._();

  factory Sender.fromJson(Map<String, dynamic> json) => _$SenderFromJson(json);

  bool get isActive => status == SenderStatus.active;

  /// Tab/caption label: display name, falling back to the phone number.
  String get label =>
      displayName.trim().isNotEmpty ? displayName : (number ?? id);

  String? get number => displayPhoneNumber ?? phoneNumber;
}
