import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_brand_logo.dart';
import '../../../core/widgets/premium_glass_card.dart';
import '../../../core/widgets/premium_gradient_card.dart';
import '../../../core/widgets/premium_metric_tile.dart';
import '../models/admin_stats_model.dart';

class AdminOverviewTab extends StatelessWidget {
  final AdminStatsModel stats;

  const AdminOverviewTab({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final metrics = [
      PremiumMetricTile(
        value: stats.totalUsers.toString(),
        label: 'Total User',
        caption: '${stats.totalFreelancers} freelancer',
        icon: Icons.people_alt_rounded,
        color: AppColors.primary,
      ),
      PremiumMetricTile(
        value: stats.totalProjects.toString(),
        label: 'Project',
        caption: '${stats.openProjects} terbuka',
        icon: Icons.folder_copy_rounded,
        color: AppColors.oculusPurple,
      ),
      PremiumMetricTile(
        value: stats.totalWorkspaces.toString(),
        label: 'Workspace',
        caption: '${stats.activeWorkspaces} aktif',
        icon: Icons.work_rounded,
        color: AppColors.attention,
      ),
      PremiumMetricTile(
        value: stats.totalReports.toString(),
        label: 'Laporan',
        caption: '${stats.pendingReports} menunggu',
        icon: Icons.report_rounded,
        color: AppColors.critical,
      ),
      PremiumMetricTile(
        value: stats.blockedUsers.toString(),
        label: 'User Diblokir',
        caption: 'akun bermasalah',
        icon: Icons.block_rounded,
        color: AppColors.criticalStrong,
      ),
      PremiumMetricTile(
        value: stats.averageRating.toStringAsFixed(1),
        label: 'Rating Rata-rata',
        caption: '${stats.totalReviews} ulasan',
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
            childAspectRatio: 1.05,
          ),
          itemBuilder: (_, index) => metrics[index],
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildOperationsPanel(),
      ],
    );
  }

  Widget _buildHero() {
    return PremiumGradientCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBrandLogo(size: 58),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin Control Center',
                  style: AppTextStyles.headingSm.copyWith(
                    color: AppColors.canvas,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Pantau user, project, laporan, kategori, dan kualitas ekosistem Tolong.in dari satu dashboard modern.',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.canvas.withValues(alpha: 0.86),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: const [
                    _AdminBadge(icon: Icons.security_rounded, label: 'Aman'),
                    _AdminBadge(icon: Icons.analytics_rounded, label: 'Terukur'),
                    _AdminBadge(icon: Icons.gavel_rounded, label: 'Moderasi'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationsPanel() {
    return PremiumGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.09),
                  borderRadius: AppRadius.all(AppRadius.xl),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ringkasan Operasional', style: AppTextStyles.subtitleLg),
                    Text(
                      'Kondisi platform saat ini',
                      style: AppTextStyles.caption.copyWith(color: AppColors.stone),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _RowInfo(label: 'Project Owner', value: stats.totalOwners.toString()),
          _RowInfo(label: 'Student Freelancer', value: stats.totalFreelancers.toString()),
          _RowInfo(label: 'Admin', value: stats.totalAdmins.toString()),
          _RowInfo(label: 'Project Berjalan', value: stats.inProgressProjects.toString()),
          _RowInfo(label: 'Project Selesai', value: stats.completedProjects.toString()),
          _RowInfo(label: 'Project Dibatalkan', value: stats.cancelledProjects.toString()),
          _RowInfo(label: 'Laporan Ditinjau', value: stats.reviewedReports.toString()),
          _RowInfo(label: 'Laporan Selesai', value: stats.resolvedReports.toString()),
        ],
      ),
    );
  }
}

class _AdminBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AdminBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.canvas.withValues(alpha: 0.15),
        borderRadius: AppRadius.all(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.canvas),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.captionBold.copyWith(color: AppColors.canvas),
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
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: AppRadius.all(AppRadius.xl),
        border: Border.all(color: AppColors.hairlineSoft),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.bodySm)),
          Text(value, style: AppTextStyles.bodySmBold),
        ],
      ),
    );
  }
}
