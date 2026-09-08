import 'package:flutter/material.dart';
import 'package:biyan/theme/app_colors.dart';
import 'package:biyan/widgets/screen_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.onBack,
    required this.onHelpFeedback,
    required this.onComplaint,
    required this.onUserNotice,
    required this.onPrivacy,
    required this.onAbout,
    required this.onDeleteAccount,
    required this.onLogout,
  });

  final VoidCallback onBack;
  final VoidCallback onHelpFeedback;
  final VoidCallback onComplaint;
  final VoidCallback onUserNotice;
  final VoidCallback onPrivacy;
  final VoidCallback onAbout;
  final VoidCallback onDeleteAccount;
  final VoidCallback onLogout;

  Future<void> _confirmAction(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: isDestructive
                  ? TextButton.styleFrom(foregroundColor: Colors.red)
                  : null,
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
    if (confirmed == true) onConfirm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        children: [
          ScreenHeader(title: '设置', onBack: onBack),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _SettingsGroup(
                  items: [
                    _SettingsItem(
                      icon: Icons.help_outline,
                      title: '帮助与反馈',
                      onTap: onHelpFeedback,
                    ),
                    _SettingsItem(
                      icon: Icons.report_outlined,
                      title: '我要投诉',
                      onTap: onComplaint,
                    ),
                    _SettingsItem(
                      icon: Icons.description_outlined,
                      title: '用户须知',
                      onTap: onUserNotice,
                    ),
                    _SettingsItem(
                      icon: Icons.privacy_tip_outlined,
                      title: '隐私协议',
                      onTap: onPrivacy,
                    ),
                    _SettingsItem(
                      icon: Icons.info_outline,
                      title: '关于我们',
                      onTap: onAbout,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SettingsGroup(
                  items: [
                    _SettingsItem(
                      icon: Icons.person_off_outlined,
                      title: '注销账号',
                      titleColor: Colors.red,
                      onTap: onDeleteAccount,
                    ),
                    _SettingsItem(
                      icon: Icons.logout,
                      title: '退出账号',
                      titleColor: AppColors.textPrimary,
                      showArrow: false,
                      onTap: () => _confirmAction(
                        context,
                        title: '退出账号',
                        message: '退出后将返回登录页，确定退出吗？',
                        confirmText: '确认退出',
                        onConfirm: onLogout,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.items});

  final List<_SettingsItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Column(
            children: [
              item,
              if (index < items.length - 1)
                Divider(
                  height: 1,
                  indent: 56,
                  color: Colors.grey.shade100,
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.titleColor = AppColors.textPrimary,
    this.showArrow = true,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color titleColor;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
            ),
            if (showArrow)
              Icon(
                Icons.chevron_right,
                size: 20,
                color: Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );
  }
}
