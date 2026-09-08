import 'package:flutter/material.dart';
import 'package:biyan/models/banner_item.dart';
import 'package:biyan/theme/app_colors.dart';
import 'package:biyan/widgets/app_image.dart';
import 'package:biyan/widgets/content_actions.dart';
import 'package:biyan/widgets/screen_header.dart';

class BannerDetailScreen extends StatelessWidget {
  const BannerDetailScreen({
    super.key,
    required this.banner,
    required this.onBack,
    required this.onShield,
    required this.onBlock,
    required this.onComplaint,
  });

  final BannerItem banner;
  final VoidCallback onBack;
  final VoidCallback onShield;
  final VoidCallback onBlock;
  final VoidCallback onComplaint;

  void _showMoreMenu(BuildContext context) {
    ContentMoreSheet.show(
      context: context,
      authorName: banner.authorName,
      onShield: onShield,
      onBlock: onBlock,
      onComplaint: onComplaint,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ListView(
                  children: [
                    SizedBox(
                      height: 280,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AppImage(url: banner.image),
                          Container(
                            color: Colors.black.withValues(alpha: 0.3),
                          ),
                          Positioned(
                            left: 20,
                            bottom: 16,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Transform(
                                  transform: Matrix4.skewX(-0.2),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    color: AppColors.yellow,
                                    child: Text(
                                      banner.tag,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  banner.title,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(blurRadius: 6, color: Colors.black45),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  banner.subtitle,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade200,
                                    shadows: const [
                                      Shadow(blurRadius: 4, color: Colors.black45),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ContentAuthorRow(name: banner.authorName),
                          const SizedBox(height: 20),
                          Text(
                            banner.content,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.8,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (banner.tips.isNotEmpty) ...[
                            const SizedBox(height: 28),
                            const Text(
                              '穿搭要点',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...banner.tips.map((tip) => _TipCard(tip: tip)),
                          ],
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ScreenHeader(
                    title: '穿搭专题',
                    onBack: onBack,
                    transparent: true,
                    rightWidget: IconButton(
                      onPressed: () => _showMoreMenu(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      icon: const Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                        size: 24,
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

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final BannerTip tip;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.purple,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip.desc,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.6,
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
