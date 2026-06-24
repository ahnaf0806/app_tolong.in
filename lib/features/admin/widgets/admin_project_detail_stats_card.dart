import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/admin_project_detail_model.dart';

class AdminProjectDetailStatsCard extends StatelessWidget {
  final AdminProjectDetailModel project;

  const AdminProjectDetailStatsCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatItem(
        title: 'Proposal',
        value: project.proposalCount.toString(),
        icon: Icons.description_rounded,
        color: AppColors.primary,
      ),
      _StatItem(
        title: 'Diterima',
        value: project.acceptedProposalCount.toString(),
        icon: Icons.check_circle_rounded,
        color: AppColors.success,
      ),
      _StatItem(
        title: 'Laporan',
        value: project.reportCount.toString(),
        icon: Icons.report_rounded,
        color: AppColors.critical,
      ),
      _StatItem(
        title: 'Workspace',
        value: project.workspaceStatusLabel,
        icon: Icons.work_rounded,
        color: AppColors.attention,
      ),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Aktivitas Project', style: AppTextStyles.subtitleLg),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.55,
            ),
            itemBuilder: (_, index) => _StatTile(item: items[index]),
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _StatTile extends StatelessWidget {
  final _StatItem item;

  const _StatTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: item.color.withValues(alpha: 0.08),
        borderRadius: AppRadius.all(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, color: item.color, size: 22),
          const Spacer(),
          Text(
            item.value,
            style: AppTextStyles.bodyMdBold.copyWith(color: item.color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            item.title,
            style: AppTextStyles.caption.copyWith(color: AppColors.charcoal),
          ),
        ],
      ),
    );
  }
}
