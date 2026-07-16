// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'smp_call.freezed.dart';
part 'smp_call.g.dart';

enum CallDirection {
  @JsonValue('incoming')
  incoming,
  @JsonValue('outgoing')
  outgoing,
  @JsonValue('missed')
  missed,
  @JsonValue('rejected')
  rejected,
  @JsonValue('unknown')
  unknown,
}

/// One SMP call-log entry for a contact, from `GET /smp/calls?clientId=…`.
@freezed
abstract class SmpCall with _$SmpCall {
  const factory SmpCall({
    required String id,
    required String startedAt,
    @JsonKey(unknownEnumValue: CallDirection.unknown)
    required CallDirection direction,
    @Default(0) int durationSeconds,
    String? deviceIdentifier,
    required String clientNumber,

    /// Employee name as reported by the SMP device (legacy attribution).
    String? smpEmployeeName,

    /// Portal user the call is attributed to, when the device is linked.
    String? agentUserId,
    String? agentName,
  }) = _SmpCall;

  const SmpCall._();

  factory SmpCall.fromJson(Map<String, dynamic> json) =>
      _$SmpCallFromJson(json);

  DateTime? get startedAtDate => DateTime.tryParse(startedAt)?.toLocal();

  /// Who handled the call: the linked portal user, falling back to the
  /// device-reported employee name. Null when neither is known.
  String? get handlerName => agentName ?? smpEmployeeName;
}
