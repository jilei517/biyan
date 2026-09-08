import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:biyan/data/app_data.dart';
import 'package:biyan/models/diary_entry.dart';
import 'package:biyan/services/image_storage_service.dart';
import 'package:biyan/services/voice_storage_service.dart';
import 'package:biyan/theme/app_colors.dart';
import 'package:biyan/widgets/screen_header.dart';
import 'package:biyan/widgets/voice_player_bar.dart';

class AddDiaryScreen extends StatefulWidget {
  const AddDiaryScreen({
    super.key,
    required this.onBack,
    required this.onPublish,
  });

  final VoidCallback onBack;
  final ValueChanged<DiaryEntry> onPublish;

  @override
  State<AddDiaryScreen> createState() => _AddDiaryScreenState();
}

class _AddDiaryScreenState extends State<AddDiaryScreen> {
  final _textController = TextEditingController();
  late DateTime _selectedDate;
  String _emotionIcon = '📝';
  String _emotionText = '记录';
  final List<String> _selectedImages = [];
  bool _isPickingImages = false;

  bool _isRecording = false;
  int _recordingSeconds = 0;
  Timer? _recordTimer;
  String? _voicePath;
  int? _voiceDurationSeconds;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    _textController.dispose();
    if (_isRecording) {
      VoiceStorageService.cancelRecording();
    }
    super.dispose();
  }

  void _showEmotionPicker() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: AppData.emotionOptions.map((option) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _emotionIcon = option['icon']!;
                      _emotionText = option['text']!;
                    });
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: [
                      Text(option['icon']!, style: const TextStyle(fontSize: 32)),
                      const SizedBox(height: 4),
                      Text(
                        option['text']!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImages() async {
    if (_isPickingImages) return;
    if (_selectedImages.length >= ImageStorageService.maxDiaryImages) {
      _showSnackBar('最多只能添加 ${ImageStorageService.maxDiaryImages} 张照片');
      return;
    }

    setState(() => _isPickingImages = true);
    try {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;

      final paths = await ImageStorageService.pickFromGallery(
        currentCount: _selectedImages.length,
      );
      if (!mounted || paths.isEmpty) return;
      setState(() {
        _selectedImages.addAll(paths);
        if (_selectedImages.length > ImageStorageService.maxDiaryImages) {
          _selectedImages.removeRange(
            ImageStorageService.maxDiaryImages,
            _selectedImages.length,
          );
        }
      });
    } on Exception catch (e) {
      if (mounted) {
        final message = e.toString().contains('photo_access_denied') ||
                e.toString().contains('permission')
            ? '无法打开相册，请在系统设置中允许访问照片'
            : '添加照片失败，请重试';
        _showSnackBar(message);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('添加照片失败，请重试');
      }
    } finally {
      if (mounted) {
        setState(() => _isPickingImages = false);
      }
    }
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
      return;
    }
    await _startRecording();
  }

  Future<void> _startRecording() async {
    if (_voicePath != null) {
      _showSnackBar('请先删除已有语音后再录制');
      return;
    }

    final hasPermission = await VoiceStorageService.hasPermission();
    if (!hasPermission) {
      if (mounted) {
        _showSnackBar('请在系统设置中允许麦克风权限');
      }
      return;
    }

    try {
      final path = await VoiceStorageService.createTempPath();
      await VoiceStorageService.startRecording(path);
      _recordTimer?.cancel();
      setState(() {
        _isRecording = true;
        _recordingSeconds = 0;
      });
      _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (!mounted) {
          timer.cancel();
          return;
        }
        final next = _recordingSeconds + 1;
        setState(() => _recordingSeconds = next);
        if (next >= VoiceStorageService.maxDurationSeconds) {
          await _stopRecording();
        }
      });
    } catch (_) {
      if (mounted) {
        _showSnackBar('无法开始录音，请重试');
      }
    }
  }

  Future<void> _stopRecording() async {
    _recordTimer?.cancel();
    _recordTimer = null;

    try {
      final path = await VoiceStorageService.stopRecording();
      final duration = _recordingSeconds;
      if (!mounted) return;

      if (path == null || duration < 1) {
        setState(() {
          _isRecording = false;
          _recordingSeconds = 0;
        });
        _showSnackBar('录音时间太短');
        return;
      }

      final savedPath = await VoiceStorageService.persistVoice(path);
      if (!mounted) return;
      setState(() {
        _isRecording = false;
        _voicePath = savedPath;
        _voiceDurationSeconds = duration;
        _recordingSeconds = 0;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _isRecording = false;
          _recordingSeconds = 0;
        });
        _showSnackBar('保存语音失败，请重试');
      }
    }
  }

  Future<void> _removeVoice() async {
    await VoiceStorageService.deleteVoice(_voicePath);
    if (!mounted) return;
    setState(() {
      _voicePath = null;
      _voiceDurationSeconds = null;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _handlePublish() async {
    if (_isRecording) {
      _showSnackBar('请先结束录音');
      return;
    }

    final text = _textController.text.trim();
    final hasVoice = _voicePath != null && (_voiceDurationSeconds ?? 0) > 0;
    if (text.isEmpty && !hasVoice) {
      _showSnackBar('请输入文字或录制语音后再发布');
      return;
    }

    final weekDays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    final weekDay = weekDays[_selectedDate.weekday % 7];
    final monthWeek = '${_selectedDate.month}月/$weekDay';
    final now = DateTime.now();
    final time = DateFormat('HH:mm').format(now);
    final fullDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

    final entry = DiaryEntry(
      id: now.millisecondsSinceEpoch,
      day: '${_selectedDate.day}',
      monthWeek: monthWeek,
      emotionIcon: _emotionIcon,
      text: text.isEmpty ? '语音日记' : text,
      images: List<String>.from(_selectedImages),
      emotionText: _emotionText,
      time: time,
      year: _selectedDate.year,
      month: _selectedDate.month,
      fullDate: fullDate,
      voicePath: _voicePath,
      voiceDurationSeconds: _voiceDurationSeconds,
    );

    widget.onPublish(entry);
    widget.onBack();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('MM/dd').format(_selectedDate);
    final canAddMore = _selectedImages.length < ImageStorageService.maxDiaryImages;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ScreenHeader(
            title: '写日记',
            onBack: widget.onBack,
            rightWidget: GestureDetector(
              onTap: _handlePublish,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.purpleLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '发布',
                  style: TextStyle(
                    color: AppColors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: _pickDate,
                          child: _ToolChip(
                            icon: Icons.calendar_month,
                            label: dateLabel,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _showEmotionPicker,
                          child: _ToolChip(
                            icon: Icons.emoji_emotions_outlined,
                            label: '心情 $_emotionIcon',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      expands: true,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        hintText: '今天发生了什么难忘的事情 ...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (_isRecording) ...[
                    const SizedBox(height: 8),
                    _RecordingBanner(
                      durationLabel: _formatDuration(_recordingSeconds),
                      onStop: _stopRecording,
                    ),
                  ] else if (_voicePath != null &&
                      _voiceDurationSeconds != null) ...[
                    const SizedBox(height: 8),
                    VoicePlayerBar(
                      path: _voicePath!,
                      durationSeconds: _voiceDurationSeconds!,
                      onDelete: _removeVoice,
                    ),
                  ],
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ..._selectedImages.asMap().entries.map((entry) {
                          final index = entry.key;
                          final path = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: _SelectedImageTile(
                              path: path,
                              onRemove: () => _removeImage(index),
                            ),
                          );
                        }),
                        if (canAddMore)
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: _isPickingImages ? null : _pickImages,
                              child: _MediaActionTile(
                                icon: Icons.image_outlined,
                                label: '添加照片',
                                loading: _isPickingImages,
                              ),
                            ),
                          ),
                        GestureDetector(
                          onTap: _toggleRecording,
                          child: _MediaActionTile(
                            icon: _isRecording
                                ? Icons.stop_circle_outlined
                                : Icons.mic_none_rounded,
                            label: _isRecording ? '结束录音' : '录制语音',
                            active: _isRecording || _voicePath != null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_selectedImages.isNotEmpty || _voicePath != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        [
                          if (_selectedImages.isNotEmpty)
                            '${_selectedImages.length}/${ImageStorageService.maxDiaryImages} 照片',
                          if (_voicePath != null) '已添加语音',
                        ].join(' · '),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordingBanner extends StatelessWidget {
  const _RecordingBanner({
    required this.durationLabel,
    required this.onStop,
  });

  final String durationLabel;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: AppColors.pink,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '正在录音 $durationLabel',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.pinkAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: onStop,
            child: const Text(
              '完成',
              style: TextStyle(
                color: AppColors.pinkAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaActionTile extends StatelessWidget {
  const _MediaActionTile({
    required this.icon,
    required this.label,
    this.loading = false,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final bool loading;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: active ? AppColors.purpleLight : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: active ? AppColors.purple : Colors.grey.shade300,
        ),
      ),
      child: loading
          ? const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: active ? AppColors.purple : Colors.grey.shade400,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: active ? AppColors.purple : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
    );
  }
}

class _SelectedImageTile extends StatelessWidget {
  const _SelectedImageTile({
    required this.path,
    required this.onRemove,
  });

  final String path;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            File(path),
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _ToolChip extends StatelessWidget {
  const _ToolChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
