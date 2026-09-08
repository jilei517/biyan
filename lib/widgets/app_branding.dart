import 'package:flutter/material.dart';
import 'package:biyan/theme/app_colors.dart';

class AppBrandingConstants {
  AppBrandingConstants._();

  static const String appName = '彼颜';
  static const String tagline = '分享生活，记录每一刻';
  static const String logoAsset = 'assets/images/logo.jpg';
}

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 96,
    this.showShadow = true,
  });

  final double size;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: showShadow
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(size * 0.28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.purple.withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            )
          : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.28),
        child: Image.asset(
          AppBrandingConstants.logoAsset,
          width: size,
          height: size,
          fit: BoxFit.cover,
          cacheWidth: (size * 3).round(),
          filterQuality: FilterQuality.low,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.purple, AppColors.pink],
                ),
                borderRadius: BorderRadius.circular(size * 0.28),
              ),
              alignment: Alignment.center,
              child: Text(
                '彼',
                style: TextStyle(
                  fontSize: size * 0.42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AppNameText extends StatelessWidget {
  const AppNameText({
    super.key,
    this.fontSize = 36,
  });

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      AppBrandingConstants.appName,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.normal,
        color: Colors.black,
        letterSpacing: 2,
      ),
    );
  }
}

class AppTaglineText extends StatelessWidget {
  const AppTaglineText({
    super.key,
    this.fontSize = 15,
    this.color,
  });

  final double fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      AppBrandingConstants.tagline,
      style: TextStyle(
        fontSize: fontSize,
        height: 1.5,
        color: color ?? AppColors.textSecondary,
        letterSpacing: 0.5,
      ),
      textAlign: TextAlign.center,
    );
  }
}
