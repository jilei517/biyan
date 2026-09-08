import 'package:flutter/material.dart';
import 'package:biyan/models/diary_entry.dart';
import 'package:biyan/theme/app_colors.dart';
import 'package:biyan/widgets/app_image.dart';
import 'package:biyan/widgets/screen_header.dart';
import 'package:biyan/widgets/voice_player_bar.dart';

class DiaryDetailScreen extends StatefulWidget {
  const DiaryDetailScreen({
    super.key,
    required this.diary,
    required this.onBack,
    required this.onDelete,
  });

  final DiaryEntry diary;
  final VoidCallback onBack;
  final VoidCallback onDelete;

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  bool _showImages = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _showImages = true);
    });
  }

  void _showDeleteConfirm() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('删除日记'),
          content: const Text('确定要删除这篇日记吗？删除后无法恢复。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                widget.onDelete();
              },
              child: const Text(
                '删除',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showMoreMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  '删除日记',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showDeleteConfirm();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final diary = widget.diary;

    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        children: [
          ScreenHeader(
            title: '日记详情',
            onBack: widget.onBack,
            rightWidget: IconButton(
              onPressed: _showMoreMenu,
              icon: const Icon(Icons.more_horiz, size: 20),
              color: AppColors.textPrimary,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            diary.emotionIcon,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${diary.year}年${diary.month}月${diary.day}日',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${diary.monthWeek} · ${diary.time} · ${diary.emotionText}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      diary.text,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.8,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (diary.hasVoice) ...[
                      const SizedBox(height: 20),
                      VoicePlayerBar(
                        path: diary.voicePath!,
                        durationSeconds: diary.voiceDurationSeconds!,
                      ),
                    ],
                    if (diary.images.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _DiaryImageGrid(
                        images: diary.images,
                        showImages: _showImages,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiaryImageGrid extends StatelessWidget {
  const _DiaryImageGrid({
    required this.images,
    required this.showImages,
  });

  final List<String> images;
  final bool showImages;

  Widget _imageSlot({
    required String url,
    required double? width,
    required double? height,
    required BorderRadius borderRadius,
  }) {
    if (!showImages) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: ColoredBox(
          color: Colors.grey.shade200,
          child: SizedBox(width: width, height: height),
        ),
      );
    }

    return AppImage(
      url: url,
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (images.length == 3) {
      final gridWidth = MediaQuery.sizeOf(context).width - 88;
      final bottomSize = (gridWidth - 12) / 2;

      return Column(
        children: [
          AspectRatio(
            aspectRatio: 2,
            child: _imageSlot(
              url: images[0],
              width: gridWidth,
              height: gridWidth / 2,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _imageSlot(
                    url: images[1],
                    width: bottomSize,
                    height: bottomSize,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _imageSlot(
                    url: images[2],
                    width: bottomSize,
                    height: bottomSize,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    final itemSize = (MediaQuery.sizeOf(context).width - 88 - 12) / 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return _imageSlot(
          url: images[index],
          width: itemSize,
          height: itemSize,
          borderRadius: BorderRadius.circular(16),
        );
      },
    );
  }
}
