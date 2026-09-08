import 'package:flutter/material.dart';
import 'package:biyan/theme/app_colors.dart';

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    required this.onBack,
    this.rightWidget,
    this.transparent = false,
  });

  final String title;
  final VoidCallback onBack;
  final Widget? rightWidget;
  final bool transparent;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: transparent ? Colors.transparent : Colors.white.withValues(alpha: 0.92),
          border: transparent
              ? null
              : const Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: onBack,
                icon: Icon(
                  Icons.chevron_left,
                  color: transparent ? Colors.white : AppColors.textPrimary,
                  size: 28,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 88),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: transparent ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: rightWidget ?? const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
