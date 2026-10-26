import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:biyan/services/storage_service.dart';
import 'package:biyan/theme/app_colors.dart';
import 'package:biyan/widgets/screen_header.dart';

class CompanionDetailScreen extends StatefulWidget {
  const CompanionDetailScreen({
    super.key,
    required this.companionDays,
    required this.startDate,
    required this.nickname,
    required this.onBack,
    required this.onStartDateChanged,
  });

  final int companionDays;
  final DateTime startDate;
  final String nickname;
  final VoidCallback onBack;
  final ValueChanged<DateTime> onStartDateChanged;

  @override
  State<CompanionDetailScreen> createState() => _CompanionDetailScreenState();
}

class _CompanionDetailScreenState extends State<CompanionDetailScreen> {
  late DateTime _startDate;
  late int _companionDays;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _companionDays = widget.companionDays;
  }

  @override
  void didUpdateWidget(CompanionDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startDate != widget.startDate ||
        oldWidget.companionDays != widget.companionDays) {
      _startDate = widget.startDate;
      _companionDays = widget.companionDays;
    }
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: '选择相伴起点',
    );
    if (picked == null) return;

    setState(() {
      _startDate = picked;
      _companionDays = StorageService.companionDaysFromStart(picked);
    });
    widget.onStartDateChanged(picked);
  }

  List<({int days, String label, bool reached})> _milestones() {
    const targets = [100, 365, 500, 1000];
    return targets.map((days) {
      final label = days >= 1000 ? '${days ~/ 1000}千天' : '$days天';
      return (days: days, label: label, reached: _companionDays >= days);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final startLabel = DateFormat('yyyy年M月d日').format(_startDate);
    final milestones = _milestones();

    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        children: [
          ScreenHeader(
            title: '陪伴天数',
            onBack: widget.onBack,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFDF2F8), Color(0xFFF3E8FF)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.purpleLight),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.favorite, color: AppColors.pink, size: 28),
                      const SizedBox(height: 12),
                      Text(
                        '$_companionDays',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '天',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '与 ${widget.nickname} 从 $startLabel 开始相伴',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickStartDate,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.purpleLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.purple,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '修改相伴起点',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '调整起始日期，重新计算陪伴天数',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '纪念里程碑',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                ...milestones.map((milestone) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: milestone.reached
                                ? AppColors.purpleLight
                                : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            milestone.reached
                                ? Icons.check_rounded
                                : Icons.lock_outline,
                            size: 20,
                            color: milestone.reached
                                ? AppColors.purple
                                : AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '相伴 ${milestone.label}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                milestone.reached
                                    ? '已达成 🎉'
                                    : '还差 ${milestone.days - _companionDays} 天',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: milestone.reached
                                      ? AppColors.purple
                                      : AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
