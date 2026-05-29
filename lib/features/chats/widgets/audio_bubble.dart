import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// Compact voice-note / audio player for a chat bubble.
///
/// The media proxy requires the Bearer header, which `audioplayers` can't add
/// to a streamed URL, so we download the bytes via [loadBytes] (authenticated
/// Dio) and play them from memory.
class AudioBubble extends StatefulWidget {
  const AudioBubble({
    super.key,
    required this.loadBytes,
    required this.color,
    this.mimeType,
  });

  final Future<Uint8List?> Function() loadBytes;
  final Color color;
  final String? mimeType;

  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble> {
  final _player = AudioPlayer();
  PlayerState _state = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _preparing = false;
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _player.onPlayerStateChanged.listen((s) {
      if (mounted) setState(() => _state = s);
    });
    _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
    _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
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
    await _player.play(BytesSource(_bytes!, mimeType: widget.mimeType));
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final playing = _state == PlayerState.playing;
    final total = _duration.inMilliseconds == 0 ? 1 : _duration.inMilliseconds;
    final progress = (_position.inMilliseconds / total).clamp(0.0, 1.0);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _preparing
            ? Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: widget.color,
                  ),
                ),
              )
            : IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(playing ? Icons.pause_circle : Icons.play_circle),
                color: widget.color,
                onPressed: _toggle,
              ),
        SizedBox(
          width: 130,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: progress,
                color: widget.color,
                backgroundColor: widget.color.withValues(alpha: 0.2),
              ),
              const SizedBox(height: 4),
              Text(
                _duration == Duration.zero
                    ? _fmt(_position)
                    : _fmt(_duration - _position),
                style: TextStyle(fontSize: 11, color: widget.color),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
