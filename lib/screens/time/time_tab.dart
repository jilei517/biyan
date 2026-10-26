import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:biyan/models/diary_entry.dart';
import 'package:biyan/theme/app_colors.dart';
import 'package:biyan/widgets/app_image.dart';
import 'package:biyan/widgets/companion_stats_card.dart';
import 'package:biyan/widgets/voice_player_bar.dart';

class TimeTab extends StatefulWidget {
  const TimeTab({
    super.key,
    required this.diaryEntries,
    required this.companionDays,
    required this.moviesWatched,
    required this.onDiaryTap,
    required this.onAddDiary,
    this.onCompanionTap,
    this.onMoviesTap,
  });

  final List<DiaryEntry> diaryEntries;
  final int companionDays;
  final int moviesWatched;
  final ValueChanged<DiaryEntry> onDiaryTap;
  final VoidCallback onAddDiary;
  final VoidCallback? onCompanionTap;
  final VoidCallback? onMoviesTap;

  @override
  State<TimeTab> createState() => _TimeTabState();
}

class _TimeTabState extends State<TimeTab> {
  late DateTime _displayMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _displayMonth = DateTime(now.year, now.month);
  }

  Future<void> _pickMonth() async {
    var selectedYear = _displayMonth.year;
    var selectedMonth = _displayMonth.month;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('取消'),
                        ),
                        const Text(
                          '选择月份',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _displayMonth = DateTime(selectedYear, selectedMonth);
                            });
                            Navigator.pop(context);
                          },
                          child: const Text(
                            '确定',
                            style: TextStyle(color: AppColors.purple),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: selectedYear > 2020
                              ? () => setModalState(() => selectedYear--)
                              : null,
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Text(
                          '$selectedYear年',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        IconButton(
                          onPressed: selectedYear < 2030
                              ? () => setModalState(() => selectedYear++)
                              : null,
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 2.2,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        final month = index + 1;
                        final isSelected = month == selectedMonth;
                        return GestureDetector(
                          onTap: () => setModalState(() => selectedMonth = month),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.purple
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.purple
                                    : AppColors.border,
                              ),
                            ),
                            child: Text(
                              '$month月',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<DiaryEntry> _entriesForMonth(int year, int month) {
    final entries = widget.diaryEntries.where((e) {
      if (e.fullDate != null) {
        final parts = e.fullDate!.split('-');
        return int.parse(parts[0]) == year && int.parse(parts[1]) == month;
      }
      return e.year == year && e.month == month;
    }).toList();
    entries.sort(
      (a, b) => int.parse(b.day).compareTo(int.parse(a.day)),
    );
    return entries;
  }

  Map<int, DiaryEntry> _entriesByDay(List<DiaryEntry> monthEntries) {
    final entriesByDay = <int, DiaryEntry>{};
    for (final entry in monthEntries) {
      final day = int.tryParse(entry.day);
      if (day != null) {
        entriesByDay[day] = entry;
      }
    }
    return entriesByDay;
  }

  @override
  Widget build(BuildContext context) {
    final monthEntries = _entriesForMonth(
      _displayMonth.year,
      _displayMonth.month,
    );
    final entriesByDay = _entriesByDay(monthEntries);
    final firstWeekday = DateTime(
      _displayMonth.year,
      _displayMonth.month,
      1,
    ).weekday % 7;
    final daysInMonth = DateTime(
      _displayMonth.year,
      _displayMonth.month + 1,
      0,
    ).day;

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
          children: [
            CompanionStatsCard(
              companionDays: widget.companionDays,
              moviesWatched: widget.moviesWatched,
              onCompanionTap: widget.onCompanionTap,
              onMoviesTap: widget.onMoviesTap,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _pickMonth,
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              DateFormat('yyyy年M月').format(_displayMonth),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: ['日', '一', '二', '三', '四', '五', '六']
                        .map(
                          (d) => Expanded(
                            child: Text(
                              d,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 9,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 4),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 2,
                      childAspectRatio: 1.45,
                    ),
                    itemCount: firstWeekday + daysInMonth,
                    itemBuilder: (context, index) {
                      if (index < firstWeekday) {
                        return const SizedBox();
                      }
                      final day = index - firstWeekday + 1;
                      final entry = entriesByDay[day];
                      Color? bgColor;
                      Color textColor = AppColors.textSecondary;

                      if (entry != null) {
                        bgColor = entry.calendarBgColor;
                        if (entry.calendarTextWhite) {
                          textColor = Colors.white;
                        } else if (entry.emotionText == '开心') {
                          textColor = AppColors.textPrimary;
                        }
                      }

                      return Center(
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: bgColor,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$day',
                            style: TextStyle(fontSize: 10, color: textColor),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (monthEntries.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    '这个月还没写日记，点右下角补一条',
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ),
              )
            else
              ...monthEntries.map(
                (entry) => _DiaryCard(
                  entry: entry,
                  onTap: () => widget.onDiaryTap(entry),
                ),
              ),
          ],
        ),
        Positioned(
          right: 20,
          bottom: 104,
          child: FloatingActionButton(
            onPressed: widget.onAddDiary,
            child: const Icon(Icons.add, size: 28),
          ),
        ),
      ],
    );
  }
}

class _DiaryCard extends StatelessWidget {
  const _DiaryCard({
    required this.entry,
    required this.onTap,
  });

  final DiaryEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final preview = entry.text.split('\n').first;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 48,
              child: Column(
                children: [
                  Text(
                    entry.day,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.monthWeek,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(entry.emotionIcon, style: const TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (entry.hasVoice) ...[
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {},
                        child: VoicePlayerBar(
                          path: entry.voicePath!,
                          durationSeconds: entry.voiceDurationSeconds!,
                          compact: true,
                        ),
                      ),
                    ],
                    if (entry.images.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: entry.images.take(3).map((url) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: AppImage(
                                  url: url,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.square,
                              size: 10,
                              color: entry.emotionColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${entry.emotionText} · ${entry.time}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          [
                            if (entry.imgCount > 0) '共${entry.imgCount}张',
                            if (entry.hasVoice)
                              '语音${entry.voiceDurationSeconds}s',
                          ].join(' · '),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
