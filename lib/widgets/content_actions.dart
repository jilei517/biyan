import 'package:flutter/material.dart';
import 'package:biyan/theme/app_colors.dart';

class ContentAuthorRow extends StatelessWidget {
  const ContentAuthorRow({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    final initial = name.isEmpty ? '?' : name.substring(0, 1);
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.purpleLight,
          child: Text(
            initial,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.purpleDark,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              '穿搭创作者',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ContentMoreSheet {
  ContentMoreSheet._();

  static Future<void> show({
    required BuildContext context,
    required String authorName,
    required VoidCallback onShield,
    required VoidCallback onBlock,
    required VoidCallback onComplaint,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              _ActionTile(
                icon: Icons.visibility_off_outlined,
                title: '屏蔽',
                subtitle: '不再看到该内容',
                onTap: () async {
                  Navigator.pop(sheetContext);
                  if (!context.mounted) return;
                  final confirmed = await _confirm(
                    context,
                    title: '屏蔽该内容？',
                    content: '屏蔽后，首页将不再展示这条内容。',
                    confirmText: '确定屏蔽',
                  );
                  if (confirmed) onShield();
                },
              ),
              _ActionTile(
                icon: Icons.person_off_outlined,
                title: '拉黑',
                subtitle: '不再看到「$authorName」的全部内容',
                destructive: true,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  if (!context.mounted) return;
                  final confirmed = await _confirm(
                    context,
                    title: '拉黑 $authorName？',
                    content: '拉黑后，将不再看到「$authorName」发布的专题和穿搭内容。',
                    confirmText: '确定拉黑',
                    destructive: true,
                  );
                  if (confirmed) onBlock();
                },
              ),
              _ActionTile(
                icon: Icons.report_outlined,
                title: '我要投诉',
                subtitle: '举报不当或违规内容',
                onTap: () {
                  Navigator.pop(sheetContext);
                  onComplaint();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  static Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String content,
    required String confirmText,
    bool destructive = false,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: TextButton.styleFrom(
                foregroundColor: destructive ? Colors.red : AppColors.purpleDark,
              ),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
    return confirmed == true;
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? const Color(0xFFDC2626) : AppColors.textPrimary;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
      ),
      onTap: onTap,
    );
  }
}
