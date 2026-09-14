import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// Voice-note player for a chat bubble: gradient play/pause button, a
/// seekable progress track with elapsed / total clock, and a playback-speed
/// chip (1× → 1.5× → 2×). Mirrors the portal's VoiceNotePlayer.
///
/// The media proxy requires the Bearer header, which `audioplayers` can't add
/// to a streamed URL, so we download the bytes via [loadBytes] (authenticated
/// Dio) on first play and play them from memory.
///
/// The track is always laid out LTR (time flows left → right in every
/// locale, as on WhatsApp); the bubble handles RTL for any transcript.
class AudioBubble extends StatefulWidget {
  const AudioBubble({
    super.key,
    required this.loadBytes,
    required this.color,
    this.outbound = false,
    this.mimeType,
    this.width = 220,
  });

  final Future<Uint8List?> Function() loadBytes;

  /// Bubble text colour — drives the clock, chip ink and track tint.
  final Color color;

  /// Bubble side; picks the accent ramp for the button and progress fill.
  final bool outbound;
  final String? mimeType;
  final double width;

  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

const _speeds = [1.0, 1.5, 2.0];

class _AudioBubbleState extends State<AudioBubble> {
  final _player = AudioPlayer();
  PlayerState _state = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _preparing = false;
  bool _dragging = false;
  int _speedIdx = 0;
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _player.onPlayerStateChanged.listen((s) {
      if (mounted) setState(() => _state = s);
    });
    _player.onPositionChanged.listen((p) {
      if (mounted && !_dragging) setState(() => _position = p);
    });
    _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _position = Duration.zero);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_state == PlayerState.playing) {
      await _player.pause();
      return;
    }
    if (_bytes == null) {
      setState(() => _preparing = true);
      _bytes = await widget.loadBytes();
      if (mounted) setState(() => _preparing = false);
      if (_bytes == null) return;
    }
    if (_state == PlayerState.paused) {
      await _player.resume();
      return;
    }
    await _player.setPlaybackRate(_speeds[_speedIdx]);
    await _player.play(BytesSource(_bytes!, mimeType: widget.mimeType));
  }

  Future<void> _cycleSpeed() async {
    setState(() => _speedIdx = (_speedIdx + 1) % _speeds.length);
    await _player.setPlaybackRate(_speeds[_speedIdx]);
  }

  Future<void> _seekToFraction(double fraction) async {
    if (_duration == Duration.zero) return;
    final target = _duration * fraction.clamp(0.0, 1.0);
    setState(() => _position = target);
    await _player.seek(target);
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.toString();
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final playing = _state == PlayerState.playing;
    final hasDuration = _duration > Duration.zero;
    final progress = hasDuration
        ? (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;
    // Idle: total length once known. Playing / scrubbed: elapsed time.
    final showElapsed = playing || _position > Duration.zero;
    final clock = _fmt(showElapsed ? _position : _duration);
    final speedLabel =
        '${_speeds[_speedIdx] == 1.0 ? '1' : _speeds[_speedIdx]}×';

    // Outbound bubbles are already green, so the button steps darker (light)
    // or drops to forest ink (dark) to keep contrast against the bubble.
    final accent = widget.outbound
        ? (isDark
              ? const [AppColors.forest3, AppColors.deepForest]
              : const [AppColors.signalDeep, Color(0xFF00805C)])
        : context.brand.accentGradient;
    final fill = widget.outbound ? AppColors.signalDeep : AppColors.signal;
    final fillOnDark = isDark
        ? (widget.outbound ? AppColors.onDarkHigh : AppColors.signal)
        : fill;
    final glow = widget.outbound && isDark ? AppColors.deepForest : fill;
    final track = widget.color.withValues(alpha: isDark ? 0.22 : 0.14);
    final thumbBorder = isDark ? AppColors.forest2 : Colors.white;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        width: widget.width,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              button: true,
              label: playing ? l10n.pauseVoiceNote : l10n.playVoiceNote,
              child: GestureDetector(
                onTap: _preparing ? null : _toggle,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: accent,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: glow.withValues(alpha: 0.32),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: _preparing
                      ? const Padding(
                          padding: EdgeInsets.all(11),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          playing
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;
                      void seekAt(double dx) =>
                          _seekToFraction(w <= 0 ? 0 : dx / w);
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapDown: hasDuration
                            ? (d) => seekAt(d.localPosition.dx)
                            : null,
                        onHorizontalDragStart: hasDuration
                            ? (d) {
                                _dragging = true;
                                seekAt(d.localPosition.dx);
                              }
                            : null,
                        onHorizontalDragUpdate: hasDuration
                            ? (d) => seekAt(d.localPosition.dx)
                            : null,
                        onHorizontalDragEnd: (_) => _dragging = false,
                        onHorizontalDragCancel: () => _dragging = false,
                        child: SizedBox(
                          height: 18,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: track,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: progress,
                                child: Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: fillOnDark,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: (progress * w) - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: fillOnDark,
                                    border: Border.all(
                                      color: thumbBorder,
                                      width: 2,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x2E101828),
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        clock,
                        style: TextStyle(
                          fontSize: 11,
                          height: 14 / 11,
                          color: widget.color.withValues(alpha: 0.7),
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      Semantics(
                        button: true,
                        label: l10n.playbackSpeed(speedLabel),
                        child: GestureDetector(
                          onTap: _cycleSpeed,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: widget.color.withValues(
                                alpha: isDark ? 0.16 : 0.08,
                              ),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Text(
                              speedLabel,
                              style: TextStyle(
                                fontSize: 10.5,
                                height: 14 / 10.5,
                                fontWeight: FontWeight.w600,
                                color: widget.color.withValues(alpha: 0.85),
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
