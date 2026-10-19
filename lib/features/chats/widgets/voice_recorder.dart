import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record/record.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';

/// Where the hold-to-record gesture is.
enum RecordPhase {
  /// Nothing recording; the composer shows the mic button.
  idle,

  /// Finger down on the mic: recording, "Slide to cancel", lock hint above.
  holding,

  /// Slid up past the lock: hands-free recording with pause / delete / send.
  locked,
}

/// State machine + audio backend for WhatsApp-style voice notes.
///
/// The composer owns the pointer gesture and feeds it in through [start],
/// [updateDrag], [release]; everything else (timer, amplitude samples for the
/// waveform, lock / cancel thresholds, pause) lives here so it can be driven
/// headlessly in tests and previews. Recordings are mono AAC in an `.m4a`
/// temp file (`audio/mp4`, in the API's allow-list); the API re-encodes voice
/// notes to OGG/Opus for WhatsApp.
class VoiceRecorderController extends ChangeNotifier {
  VoiceRecorderController({
    AudioRecorder? recorder,
    this.amplitudeInterval = const Duration(milliseconds: 90),
    this.minDuration = const Duration(seconds: 1),
  }) : _recorder = recorder ?? AudioRecorder();

  /// Drag distance (logical px) that cancels / locks a held recording.
  static const double cancelDistance = 110;
  static const double lockDistance = 70;

  /// How many amplitude samples the waveform keeps.
  static const int maxSamples = 48;

  final AudioRecorder _recorder;
  final Duration amplitudeInterval;
  final Duration minDuration;

  RecordPhase _phase = RecordPhase.idle;
  bool _paused = false;
  bool _permissionDenied = false;
  Object? _error;
  String? _path;
  final Stopwatch _clock = Stopwatch();
  Timer? _ticker;
  StreamSubscription<Amplitude>? _ampSub;
  final List<double> _samples = [];
  double _dragDx = 0;
  double _dragDy = 0;
  bool _disposed = false;

  RecordPhase get phase => _phase;
  bool get isActive => _phase != RecordPhase.idle;
  bool get isLocked => _phase == RecordPhase.locked;
  bool get paused => _paused;
  bool get permissionDenied => _permissionDenied;
  Object? get error => _error;
  Duration get elapsed => _clock.elapsed;

  /// 0..1 amplitude samples, oldest first.
  List<double> get samples => List.unmodifiable(_samples);

  /// Horizontal drag toward the start edge, as 0..1 of [cancelDistance].
  double get cancelProgress =>
      (-_dragDx / cancelDistance).clamp(0.0, 1.0).toDouble();

  /// Upward drag, as 0..1 of [lockDistance].
  double get lockProgress =>
      (-_dragDy / lockDistance).clamp(0.0, 1.0).toDouble();

  /// Begin a held recording. Returns false (and sets [permissionDenied] or
  /// [error]) when the mic isn't available; the composer shows a hint.
  Future<bool> start() async {
    if (isActive) return true;
    _permissionDenied = false;
    _error = null;
    try {
      if (!await _recorder.hasPermission()) {
        _permissionDenied = true;
        _notify();
        return false;
      }
      final dir = Directory.systemTemp;
      _path = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 64000,
          sampleRate: 44100,
          numChannels: 1,
          autoGain: true,
          noiseSuppress: true,
        ),
        path: _path!,
      );
    } catch (e) {
      _error = e;
      _path = null;
      _notify();
      return false;
    }
    _phase = RecordPhase.holding;
    _paused = false;
    _dragDx = 0;
    _dragDy = 0;
    _samples.clear();
    _clock
      ..reset()
      ..start();
    _ticker = Timer.periodic(
      const Duration(milliseconds: 200),
      (_) => _notify(),
    );
    _ampSub = _recorder.onAmplitudeChanged(amplitudeInterval).listen(_onAmp);
    HapticFeedback.mediumImpact();
    _notify();
    return true;
  }

  void _onAmp(Amplitude amp) {
    if (_paused || !isActive) return;
    // dBFS → 0..1 over a -60 dB window; most speech lands in 0.3–0.9.
    final level = ((amp.current + 60) / 60).clamp(0.0, 1.0).toDouble();
    _samples.add(level);
    if (_samples.length > maxSamples) _samples.removeAt(0);
    _notify();
  }

  /// Accumulate the finger's travel while holding. Crossing the cancel
  /// distance cancels; crossing the lock distance locks.
  void updateDrag(Offset delta, {required TextDirection textDirection}) {
    if (_phase != RecordPhase.holding) return;
    // "Slide to cancel" always moves toward the start edge.
    final toward = textDirection == TextDirection.rtl ? -delta.dx : delta.dx;
    _dragDx += toward;
    _dragDy += delta.dy;
    if (_dragDx > 0) _dragDx = 0;
    if (_dragDy > 0) _dragDy = 0;
    if (-_dragDx >= cancelDistance) {
      unawaited(cancel());
      return;
    }
    if (-_dragDy >= lockDistance) {
      lock();
      return;
    }
    _notify();
  }

  /// Hands-free mode (slid up, or called directly).
  void lock() {
    if (_phase != RecordPhase.holding) return;
    _phase = RecordPhase.locked;
    _dragDx = 0;
    _dragDy = 0;
    HapticFeedback.selectionClick();
    _notify();
  }

  Future<void> pause() async {
    if (!isLocked || _paused) return;
    try {
      await _recorder.pause();
    } catch (e) {
      _error = e;
    }
    _paused = true;
    _clock.stop();
    _notify();
  }

  Future<void> resume() async {
    if (!isLocked || !_paused) return;
    try {
      await _recorder.resume();
    } catch (e) {
      _error = e;
    }
    _paused = false;
    _clock.start();
    _notify();
  }

  /// Finger lifted while holding: send unless the clip is too short (a tap),
  /// in which case the recording is discarded and [tooShort] is true.
  Future<({String? path, bool tooShort})> release() async {
    if (_phase != RecordPhase.holding) return (path: null, tooShort: false);
    if (_clock.elapsed < minDuration) {
      await cancel();
      return (path: null, tooShort: true);
    }
    final path = await finish();
    return (path: path, tooShort: false);
  }

  /// Stop and return the recorded file path (null if nothing usable).
  Future<String?> finish() async {
    if (!isActive) return null;
    String? path;
    try {
      path = await _recorder.stop();
    } catch (e) {
      _error = e;
    }
    path ??= _path;
    _reset();
    _notify();
    final file = path == null ? null : File(path);
    return (file != null && file.existsSync() && file.lengthSync() > 0)
        ? path
        : null;
  }

  /// Discard the recording (slide-to-cancel, trash button).
  Future<void> cancel() async {
    if (!isActive) return;
    try {
      await _recorder.cancel();
    } catch (_) {}
    final p = _path;
    if (p != null) {
      unawaited(File(p).delete().catchError((_) => File(p)));
    }
    _reset();
    HapticFeedback.lightImpact();
    _notify();
  }

  void _reset() {
    _phase = RecordPhase.idle;
    _paused = false;
    _path = null;
    _clock
      ..stop()
      ..reset();
    _ticker?.cancel();
    _ticker = null;
    _ampSub?.cancel();
    _ampSub = null;
    _dragDx = 0;
    _dragDy = 0;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _ticker?.cancel();
    _ampSub?.cancel();
    if (isActive) unawaited(_recorder.cancel().catchError((_) {}));
    unawaited(_recorder.dispose());
    super.dispose();
  }
}

String formatRecordClock(Duration d) {
  final m = d.inMinutes;
  final s = d.inSeconds % 60;
  return '$m:${s.toString().padLeft(2, '0')}';
}

/// Held-recording strip (WhatsApp's "Slide to cancel"): blinking red mic,
/// running clock, the cancel hint that trails the finger. The mic button and
/// lock hint are drawn by the composer so they stay under the pointer.
class HoldRecordingBar extends StatelessWidget {
  const HoldRecordingBar({super.key, required this.controller});

  final VoiceRecorderController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final muted = context.scheme.onSurfaceVariant;
    final progress = controller.cancelProgress;
    return Row(
      children: [
        const SizedBox(width: Insets.sm),
        _BlinkingMic(color: AppColors.ember),
        const SizedBox(width: Insets.md),
        Text(
          formatRecordClock(controller.elapsed),
          style: context.text.titleMedium?.copyWith(
            fontSize: 18,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        Expanded(
          child: Opacity(
            opacity: (1 - progress * 1.2).clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(-progress * 40, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.composerSlideToCancel,
                    style: context.text.bodyLarge?.copyWith(color: muted),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.chevron_left_rounded, color: muted, size: 22),
                ],
              ),
            ),
          ),
        ),
        // Room for the mic button the composer overlays here.
        const SizedBox(width: 56),
      ],
    );
  }
}

/// Lock affordance floating above the mic while holding: padlock + chevron
/// in a pill, rising/brightening as the finger slides up.
class RecordLockHint extends StatelessWidget {
  const RecordLockHint({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return Transform.translate(
      offset: Offset(0, -progress * 10),
      child: Container(
        width: 44,
        padding: const EdgeInsets.symmetric(vertical: Insets.md),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(Radii.pill),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              progress >= 1 ? Icons.lock_rounded : Icons.lock_open_rounded,
              size: 20,
              color: Color.lerp(
                scheme.onSurfaceVariant,
                AppColors.signalDeep,
                progress,
              ),
            ),
            const SizedBox(height: Insets.lg),
            Icon(
              Icons.keyboard_arrow_up_rounded,
              size: 20,
              color: scheme.onSurfaceVariant.withValues(
                alpha: 1 - progress * 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Locked (hands-free) panel: clock + live waveform on top, then
/// delete · pause/resume · send.
class LockedRecordingPanel extends StatelessWidget {
  const LockedRecordingPanel({
    super.key,
    required this.controller,
    required this.onDelete,
    required this.onSend,
  });

  final VoiceRecorderController controller;
  final VoidCallback onDelete;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = context.scheme;
    final paused = controller.paused;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Insets.md,
            Insets.xs,
            Insets.md,
            0,
          ),
          child: Row(
            children: [
              if (paused)
                const Padding(
                  padding: EdgeInsets.only(right: Insets.sm),
                  child: Icon(
                    Icons.pause_rounded,
                    size: 18,
                    color: AppColors.ember,
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(right: Insets.sm),
                  child: _BlinkingMic(color: AppColors.ember, size: 18),
                ),
              Text(
                formatRecordClock(controller.elapsed),
                style: context.text.titleMedium?.copyWith(
                  fontSize: 18,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: Insets.lg),
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: CustomPaint(
                    painter: _WavePainter(
                      samples: controller.samples,
                      color: paused
                          ? scheme.onSurfaceVariant
                          : AppColors.signalDeep,
                      trackColor: scheme.outlineVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Insets.sm),
        Row(
          children: [
            IconButton(
              tooltip: l10n.composerDeleteRecording,
              iconSize: 26,
              icon: const Icon(Icons.delete_outline_rounded),
              color: scheme.onSurface,
              onPressed: onDelete,
            ),
            const Spacer(),
            _RoundOutlineButton(
              tooltip: paused
                  ? l10n.composerResumeRecording
                  : l10n.composerPauseRecording,
              icon: paused ? Icons.mic_rounded : Icons.pause_rounded,
              color: AppColors.ember,
              onTap: paused ? controller.resume : controller.pause,
            ),
            const Spacer(),
            Tooltip(
              message: l10n.composerSendRecording,
              child: Material(
                color: AppColors.signal,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onSend,
                  child: const SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(
                      Icons.send_rounded,
                      color: AppColors.deepForest,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: Insets.xs),
          ],
        ),
      ],
    );
  }
}

class _RoundOutlineButton extends StatelessWidget {
  const _RoundOutlineButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: CircleBorder(side: BorderSide(color: color, width: 2)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, color: color, size: 24),
          ),
        ),
      ),
    );
  }
}

/// Soft 1 Hz pulse on the recording mic glyph.
class _BlinkingMic extends StatefulWidget {
  const _BlinkingMic({required this.color, this.size = 22});

  final Color color;
  final double size;

  @override
  State<_BlinkingMic> createState() => _BlinkingMicState();
}

class _BlinkingMicState extends State<_BlinkingMic>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    return FadeTransition(
      opacity: reduce
          ? const AlwaysStoppedAnimation(1)
          : Tween(begin: 0.35, end: 1.0).animate(_ctrl),
      child: Icon(Icons.mic_rounded, color: widget.color, size: widget.size),
    );
  }
}

/// Live waveform: newest samples on the end side, bars grow with level; the
/// unfilled remainder is a dotted track like WhatsApp's.
class _WavePainter extends CustomPainter {
  const _WavePainter({
    required this.samples,
    required this.color,
    required this.trackColor,
  });

  final List<double> samples;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    const barW = 3.0;
    const gap = 3.0;
    final slots = math.max(1, (size.width / (barW + gap)).floor());
    final mid = size.height / 2;
    final bar = Paint()
      ..color = color
      ..strokeWidth = barW
      ..strokeCap = StrokeCap.round;
    final dot = Paint()..color = trackColor;
    // Right-align the samples: the last sample sits in the last slot.
    final start = slots - samples.length;
    for (var i = 0; i < slots; i++) {
      final x = i * (barW + gap) + barW / 2;
      final si = i - start;
      if (si < 0 || si >= samples.length) {
        canvas.drawCircle(Offset(x, mid), 1.2, dot);
        continue;
      }
      final h = math.max(3.0, samples[si] * size.height);
      canvas.drawLine(Offset(x, mid - h / 2), Offset(x, mid + h / 2), bar);
    }
  }

  @override
  bool shouldRepaint(covariant _WavePainter old) =>
      !listEquals(old.samples, samples) || old.color != color;
}
