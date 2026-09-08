import 'package:flutter/material.dart';
import 'package:biyan/theme/app_colors.dart';

class CompanionStatsCard extends StatelessWidget {
  const CompanionStatsCard({
    super.key,
    required this.companionDays,
    required this.moviesWatched,
    this.onCompanionTap,
    this.onMoviesTap,
  });

  final int companionDays;
  final int moviesWatched;
  final VoidCallback? onCompanionTap;
  final VoidCallback? onMoviesTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFDF2F8), Color(0xFFF3E8FF)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.purpleLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.favorite,
              iconColor: AppColors.pink,
              value: '$companionDays',
              label: '陪伴天数',
              onTap: onCompanionTap,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.purple.shade100,
          ),
          Expanded(
            child: _StatItem(
              icon: Icons.movie_outlined,
              iconColor: AppColors.purple,
              value: '$moviesWatched',
              label: '看过的电影',
              onTap: onMoviesTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
