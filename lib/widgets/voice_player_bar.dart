import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:biyan/theme/app_colors.dart';

class VoicePlayerBar extends StatefulWidget {
  const VoicePlayerBar({
    super.key,
    required this.path,
    required this.durationSeconds,
    this.compact = false,
    this.onDelete,
  });

  final String path;
  final int durationSeconds;
  final bool compact;
  final VoidCallback? onDelete;

  @override
  State<VoicePlayerBar> createState() => _VoicePlayerBarState();
}

class _VoicePlayerBarState extends State<VoicePlayerBar> {
  late final AudioPlayer _player;
  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<Duration>? _positionSub;
  bool _playing = false;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _stateSub = _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _playing = state == PlayerState.playing);
    });
    _positionSub = _player.onPositionChanged.listen((position) {
      if (!mounted) return;
      setState(() => _position = position);
    });
    _player.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _playing = false;
        _position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _positionSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_playing) {
      await _player.pause();
      return;
    }

    if (_position == Duration.zero ||
        _position.inMilliseconds >= widget.durationSeconds * 1000) {
      await _player.play(DeviceFileSource(widget.path));
    } else {
      await _player.resume();
    }
  }

  String _formatSeconds(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.durationSeconds.clamp(1, 3600);
    final current = _playing || _position > Duration.zero
        ? _position.inSeconds.clamp(0, total)
        : 0;
    final progress = current / total;
    final height = widget.compact ? 44.0 : 52.0;

    return Container(
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: widget.compact ? 10 : 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.purpleLight,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _togglePlay,
            child: Container(
              width: widget.compact ? 30 : 34,
              height: widget.compact ? 30 : 34,
              decoration: const BoxDecoration(
                color: AppColors.purple,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: widget.compact ? 18 : 20,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 4,
                    backgroundColor: Colors.white.withValues(alpha: 0.7),
                    valueColor: const AlwaysStoppedAnimation(AppColors.purple),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatSeconds(current)} / ${_formatSeconds(total)}',
                  style: TextStyle(
                    fontSize: widget.compact ? 10 : 11,
                    color: AppColors.purpleDark,
                  ),
                ),
              ],
            ),
          ),
          if (widget.onDelete != null) ...[
            const SizedBox(width: 4),
            IconButton(
              onPressed: widget.onDelete,
              icon: const Icon(Icons.delete_outline, size: 18),
              color: AppColors.textSecondary,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ] else ...[
            const SizedBox(width: 8),
            Icon(
              Icons.mic_none_rounded,
              size: widget.compact ? 16 : 18,
              color: AppColors.purple,
            ),
          ],
        ],
      ),
    );
  }
}
