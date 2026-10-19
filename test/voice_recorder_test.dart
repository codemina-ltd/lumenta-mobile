import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/chats/widgets/voice_recorder.dart';
import 'package:record/record.dart';

/// In-memory recorder backend: no platform channels, writes a tiny file on
/// stop so [VoiceRecorderController.finish] sees a non-empty recording.
class _FakeRecordPlatform extends RecordPlatform {
  final calls = <String>[];
  String? path;
  bool permission = true;

  /// Level returned by [getAmplitude]; the recorder polls it on an interval.
  double level = -30;

  @override
  Future<void> create(String recorderId) async {}
  @override
  Future<bool> hasPermission(String recorderId, {bool request = true}) async =>
      permission;
  @override
  Future<void> start(
    String recorderId,
    RecordConfig config, {
    required String path,
  }) async {
    calls.add('start');
    this.path = path;
  }

  @override
  Future<Stream<Uint8List>> startStream(
    String recorderId,
    RecordConfig config,
  ) async => const Stream.empty();
  @override
  Future<String?> stop(String recorderId) async {
    calls.add('stop');
    final p = path;
    if (p != null) File(p).writeAsBytesSync(List.filled(64, 1));
    return p;
  }

  @override
  Future<void> cancel(String recorderId) async => calls.add('cancel');
  @override
  Future<void> pause(String recorderId) async => calls.add('pause');
  @override
  Future<void> resume(String recorderId) async => calls.add('resume');
  @override
  Future<bool> isPaused(String recorderId) async => false;
  @override
  Future<bool> isRecording(String recorderId) async => path != null;
  @override
  Future<List<InputDevice>> listInputDevices(String recorderId) async =>
      const [];
  @override
  Future<Amplitude> getAmplitude(String recorderId) async =>
      Amplitude(current: level, max: 0);
  @override
  Future<bool> isEncoderSupported(
    String recorderId,
    AudioEncoder encoder,
  ) async => true;
  @override
  Future<void> dispose(String recorderId) async {}
  @override
  Stream<RecordState> onStateChanged(String recorderId) => const Stream.empty();
  @override
  void setOnConfigChanged(
    String recorderId,
    void Function(RecordConfig config)? handler,
  ) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _FakeRecordPlatform platform;
  late VoiceRecorderController c;

  setUp(() {
    platform = _FakeRecordPlatform();
    RecordPlatform.instance = platform;
    c = VoiceRecorderController(
      recorder: AudioRecorder(),
      minDuration: Duration.zero,
      amplitudeInterval: const Duration(milliseconds: 5),
    );
  });

  tearDown(() => c.dispose());

  test('start → holding; release sends the file path', () async {
    expect(await c.start(), isTrue);
    expect(c.phase, RecordPhase.holding);
    final r = await c.release();
    expect(r.tooShort, isFalse);
    expect(r.path, endsWith('.m4a'));
    expect(c.phase, RecordPhase.idle);
    expect(platform.calls, ['start', 'stop']);
  });

  test('a tap (shorter than minDuration) is discarded with tooShort', () async {
    final short = VoiceRecorderController(
      recorder: AudioRecorder(),
      minDuration: const Duration(seconds: 5),
    );
    await short.start();
    final r = await short.release();
    expect(r.tooShort, isTrue);
    expect(r.path, isNull);
    expect(platform.calls.last, 'cancel');
    short.dispose();
  });

  test('sliding toward the start edge past the threshold cancels', () async {
    await c.start();
    c.updateDrag(const Offset(-50, 0), textDirection: TextDirection.ltr);
    expect(c.phase, RecordPhase.holding);
    expect(
      c.cancelProgress,
      closeTo(50 / VoiceRecorderController.cancelDistance, 1e-6),
    );
    c.updateDrag(const Offset(-70, 0), textDirection: TextDirection.ltr);
    await Future<void>.delayed(Duration.zero);
    expect(c.phase, RecordPhase.idle);
    expect(platform.calls.last, 'cancel');
  });

  test('in RTL the cancel slide goes the other way', () async {
    await c.start();
    c.updateDrag(const Offset(120, 0), textDirection: TextDirection.rtl);
    await Future<void>.delayed(Duration.zero);
    expect(c.phase, RecordPhase.idle);
    expect(platform.calls.last, 'cancel');
  });

  test('sliding up locks; pause/resume and finish work hands-free', () async {
    await c.start();
    c.updateDrag(const Offset(0, -80), textDirection: TextDirection.ltr);
    expect(c.phase, RecordPhase.locked);
    // Release after lock is a no-op: still recording.
    final r = await c.release();
    expect(r.path, isNull);
    expect(c.isLocked, isTrue);
    await c.pause();
    expect(c.paused, isTrue);
    await c.resume();
    expect(c.paused, isFalse);
    final path = await c.finish();
    expect(path, isNotNull);
    expect(platform.calls, ['start', 'pause', 'resume', 'stop']);
  });

  test('amplitude samples are normalised and capped', () async {
    await c.start();
    // The recorder polls getAmplitude every 5 ms; let it fill the buffer.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    platform.level = 0;
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(c.samples.length, VoiceRecorderController.maxSamples);
    expect(c.samples.last, 1.0);
    expect(c.samples.first, closeTo(0.5, 1e-6));
    await c.cancel();
  });

  test('permission denied → start returns false and flags it', () async {
    platform.permission = false;
    expect(await c.start(), isFalse);
    expect(c.permissionDenied, isTrue);
    expect(c.phase, RecordPhase.idle);
  });

  test('formatRecordClock pads seconds', () {
    expect(formatRecordClock(const Duration(seconds: 7)), '0:07');
    expect(formatRecordClock(const Duration(minutes: 1, seconds: 30)), '1:30');
  });
}
