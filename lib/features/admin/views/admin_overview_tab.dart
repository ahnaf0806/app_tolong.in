import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/admin_stats_model.dart';
import '../widgets/admin_metric_card.dart';

class AdminOverviewTab extends StatelessWidget {
  final AdminStatsModel stats;

  const AdminOverviewTab({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final metrics = [
      AdminMetricCard(
        title: 'Total User',
        value: stats.totalUsers.toString(),
        subtitle: '${stats.totalFreelancers} freelancer',
        icon: Icons.people_alt_rounded,
        color: AppColors.primary,
      ),
      AdminMetricCard(
        title: 'Project',
        value: stats.totalProjects.toString(),
        subtitle: '${stats.openProjects} terbuka',
        icon: Icons.folder_copy_rounded,
        color: AppColors.oculusPurple,
      ),
      AdminMetricCard(
        title: 'Workspace',
        value: stats.totalWorkspaces.toString(),
        subtitle: '${stats.activeWorkspaces} aktif',
        icon: Icons.work_rounded,
        color: AppColors.attention,
      ),
      AdminMetricCard(
        title: 'Laporan',
        value: stats.totalReports.toString(),
        subtitle: '${stats.pendingReports} menunggu',
        icon: Icons.report_rounded,
        color: AppColors.critical,
      ),
      AdminMetricCard(
        title: 'User Diblokir',
        value: stats.blockedUsers.toString(),
        subtitle: 'akun bermasalah',
        icon: Icons.block_rounded,
        color: AppColors.criticalStrong,
      ),
      AdminMetricCard(
        title: 'Rating Rata-rata',
        value: stats.averageRating.toStringAsFixed(1),
        subtitle: '${stats.totalReviews} ulasan',
        icon: Icons.star_rounded,
        color: AppColors.warning,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        _buildHero(),
        const SizedBox(height: AppSpacing.xl),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: metrics.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.25,
          ),
          itemBuilder: (_, index) => metrics[index],
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildBreakdown(),
      ],
    );
  }

  Widget _buildHero() {
    return AppCard(
      backgroundColor: AppColors.inkDeep,
      hasBorder: false,
      radius: 32,
      child: Row(
        children: [
          const Icon(
            Icons.admin_panel_settings_rounded,
            color: AppColors.canvas,
            size: 42,
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin Control Center',
                  style: AppTextStyles.headingSm.copyWith(
                    color: AppColors.canvas,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Pantau ekosistem Tolong.in dari user, project, laporan, sampai kualitas freelancer.',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.canvas.withValues(alpha: 0.78),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdown() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ringkasan Operasional', style: AppTextStyles.subtitleLg),
          const SizedBox(height: AppSpacing.md),
          _RowInfo(label: 'Project Owner', value: stats.totalOwners.toString()),
          _RowInfo(
            label: 'Student Freelancer',
            value: stats.totalFreelancers.toString(),
          ),
          _RowInfo(label: 'Admin', value: stats.totalAdmins.toString()),
          _RowInfo(
            label: 'Project Berjalan',
            value: stats.inProgressProjects.toString(),
          ),
          _RowInfo(
            label: 'Project Selesai',
            value: stats.completedProjects.toString(),
          ),
          _RowInfo(
            label: 'Project Dibatalkan',
            value: stats.cancelledProjects.toString(),
          ),
          _RowInfo(
            label: 'Laporan Ditinjau',
            value: stats.reviewedReports.toString(),
          ),
          _RowInfo(
            label: 'Laporan Selesai',
            value: stats.resolvedReports.toString(),
          ),
        ],
      ),
    );
  }
}

class _RowInfo extends StatelessWidget {
  final String label;
  final String value;

  const _RowInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.bodySm)),
          Text(value, style: AppTextStyles.bodySmBold),
        ],
      ),
    );
  }
}
