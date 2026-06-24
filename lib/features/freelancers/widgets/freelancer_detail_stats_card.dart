import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/freelancer_summary_model.dart';

class FreelancerDetailStatsCard extends StatelessWidget {
  final FreelancerSummaryModel freelancer;

  const FreelancerDetailStatsCard({super.key, required this.freelancer});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.star_rounded,
            label: 'Rating',
            value: freelancer.ratingAverage.toStringAsFixed(1),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatCard(
            icon: Icons.work_rounded,
            label: 'Project Selesai',
            value: freelancer.totalProjects.toString(),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: AppSpacing.md),
          Text(value, style: AppTextStyles.headingSm),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
