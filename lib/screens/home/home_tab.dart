import 'package:flutter/material.dart';
import 'package:biyan/data/app_data.dart';
import 'package:biyan/models/banner_item.dart';
import 'package:biyan/models/outfit_item.dart';
import 'package:biyan/models/user_profile.dart';
import 'package:biyan/theme/app_colors.dart';
import 'package:biyan/widgets/banner_carousel.dart';
import 'package:biyan/widgets/outfit_card.dart';
import 'package:biyan/widgets/user_avatar.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({
    super.key,
    required this.profile,
    required this.loggedIn,
    required this.onBannerTap,
    required this.onOutfitTap,
    this.blockedOutfitIds = const {},
    this.blockedBannerIds = const {},
    this.blockedAuthorIds = const {},
  });

  final UserProfile profile;
  final bool loggedIn;
  final ValueChanged<BannerItem> onBannerTap;
  final ValueChanged<OutfitItem> onOutfitTap;
  final Set<int> blockedOutfitIds;
  final Set<int> blockedBannerIds;
  final Set<String> blockedAuthorIds;

  @override
  Widget build(BuildContext context) {
    final banners = AppData.visibleBanners(
      blockedBannerIds: blockedBannerIds,
      blockedAuthorIds: blockedAuthorIds,
    );
    final outfits = AppData.visibleOutfits(
      blockedOutfitIds: blockedOutfitIds,
      blockedAuthorIds: blockedAuthorIds,
    );

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (loggedIn)
                  UserAvatar(
                    avatar: profile.avatar,
                    size: 44,
                    showBorder: false,
                  )
                else
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.purpleLight,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.person_outline,
                      size: 24,
                      color: AppColors.purple,
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loggedIn ? 'Hi, ${profile.nickname}' : 'Hi，欢迎来到彼颜',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textPrimary,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        loggedIn
                            ? (profile.signature.isEmpty
                                ? '今天也想记点什么'
                                : profile.signature)
                            : '登录后即可记录爱好、日记和陪伴',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        if (banners.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BannerCarousel(
                key: ValueKey(banners.map((banner) => banner.id).join('-')),
                banners: banners,
                onBannerTap: onBannerTap,
              ),
            ),
          ),
        if (banners.isNotEmpty)
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              '穿搭灵感',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        if (outfits.isEmpty)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 124),
              child: Text(
                '暂无更多穿搭灵感',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 124),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final outfit = outfits[index];
                  return OutfitCard(
                    outfit: outfit,
                    onTap: () => onOutfitTap(outfit),
                  );
                },
                childCount: outfits.length,
              ),
            ),
          ),
      ],
    );
  }
}
