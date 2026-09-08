import 'package:flutter/material.dart';
import 'package:biyan/theme/app_colors.dart';
import 'package:biyan/widgets/app_image.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.avatar,
    this.size = 64,
    this.showBorder = true,
  });

  final String avatar;
  final double size;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final image = ClipOval(
      child: AppImage(
        url: avatar,
        width: size,
        height: size,
        assetFallback: 'assets/images/avatar.png',
      ),
    );

    if (!showBorder) return image;

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFC084FC), Color(0xFFF472B6)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: image,
    );
  }
}

class UserProfileChip extends StatelessWidget {
  const UserProfileChip({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.purpleLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.purpleDark,
        ),
      ),
    );
  }
}
