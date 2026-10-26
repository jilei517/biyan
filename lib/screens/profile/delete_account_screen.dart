import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:biyan/theme/app_colors.dart';
import 'package:biyan/widgets/screen_header.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({
    super.key,
    required this.onBack,
    required this.onOpenNotice,
    required this.onConfirm,
  });

  final VoidCallback onBack;
  final VoidCallback onOpenNotice;
  final Future<void> Function() onConfirm;

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool _agreed = false;
  bool _submitting = false;
  late final TapGestureRecognizer _noticeRecognizer;

  static const _clearItems = <_ClearItem>[
    _ClearItem(
      icon: Icons.badge_outlined,
      title: '账号与登录信息',
      subtitle: '本地注册账号、登录状态将被彻底移除',
    ),
    _ClearItem(
      icon: Icons.person_outline,
      title: '个人资料',
      subtitle: '昵称、头像、个性签名等资料恢复并清空',
    ),
    _ClearItem(
      icon: Icons.auto_stories_outlined,
      title: '时间轴日记',
      subtitle: '文字、配图与语音日记将全部删除',
    ),
    _ClearItem(
      icon: Icons.note_alt_outlined,
      title: '备忘与爱好',
      subtitle: '备忘录、爱好标签与自定义标签一并清除',
    ),
    _ClearItem(
      icon: Icons.favorite_border,
      title: '陪伴与观影记录',
      subtitle: '陪伴天数、起始日期与一起看过的电影',
    ),
    _ClearItem(
      icon: Icons.tune,
      title: '偏好与反馈记录',
      subtitle: '穿搭屏蔽、拉黑偏好、帮助反馈与投诉相关内容',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _noticeRecognizer = TapGestureRecognizer()..onTap = widget.onOpenNotice;
  }

  @override
  void dispose() {
    _noticeRecognizer.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    if (!_agreed || _submitting) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('最后确认'),
          content: const Text(
            '注销后，彼颜中的本地数据将立即清空且无法找回。确定注销吗？',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('再想想'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('确定注销'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => _submitting = true);
    try {
      await widget.onConfirm();
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        children: [
          ScreenHeader(title: '注销账号', onBack: widget.onBack),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFF8F5FF),
                          Color(0xFFFFF8F3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFEDE4FF)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.purple.withValues(alpha: 0.12),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.warning_amber_rounded,
                            color: Color(0xFFE8A317),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '注销后以下内容将被清空',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                  height: 1.35,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                '操作立即生效，且不可恢复。请确认你已备份需要保留的回忆。',
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.5,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < _clearItems.length; i++) ...[
                          _ClearItemTile(item: _clearItems[i]),
                          if (i < _clearItems.length - 1)
                            Divider(
                              height: 1,
                              indent: 68,
                              color: Colors.grey.shade100,
                            ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: Color(0xFFB45309),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '注销仅清除本机彼颜数据。若你曾把内容备份到其他位置，不受影响。',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: Color(0xFF92400E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              16 + MediaQuery.paddingOf(context).bottom,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: Checkbox(
                        value: _agreed,
                        activeColor: AppColors.purple,
                        side: const BorderSide(color: AppColors.textMuted),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        onChanged: _submitting
                            ? null
                            : (value) {
                                setState(() => _agreed = value ?? false);
                              },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            const TextSpan(text: '我已阅读'),
                            TextSpan(
                              text: '《账号注销须知》',
                              style: const TextStyle(
                                color: AppColors.purple,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: _noticeRecognizer,
                            ),
                            const TextSpan(
                              text: '，知晓注销立即生效且不可恢复，并自愿注销账号。',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _agreed && !_submitting ? _handleConfirm : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F2A3A),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      disabledForegroundColor: Colors.grey.shade500,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            '确定注销',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClearItem {
  const _ClearItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}

class _ClearItemTile extends StatelessWidget {
  const _ClearItemTile({required this.item});

  final _ClearItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.purpleLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, size: 20, color: AppColors.purpleDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
