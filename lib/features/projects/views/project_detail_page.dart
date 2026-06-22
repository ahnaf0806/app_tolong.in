import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../proposals/views/create_proposal_page.dart';
import '../models/project_model.dart';

/// Halaman detail project untuk freelancer.
/// Menampilkan seluruh informasi project dan tombol Ajukan Proposal.
class ProjectDetailPage extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Detail Project'),
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.inkDeep,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          // Kategori + difficulty
          Row(
            children: [
              _Pill(
                label: project.categoryName ?? project.projectField,
                color: AppColors.primary,
                bgColor: AppColors.primary.withValues(alpha: 0.08),
              ),
              const SizedBox(width: AppSpacing.xs),
              _DifficultyPill(difficulty: project.difficulty),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Judul
          Text(project.title, style: AppTextStyles.headingSm),
          const SizedBox(height: AppSpacing.xs),

          // Owner
          if (project.ownerName != null)
            Row(
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  size: 14,
                  color: AppColors.stone,
                ),
                const SizedBox(width: 4),
                Text(
                  'Oleh ${project.ownerName}',
                  style: AppTextStyles.bodySm,
                ),
              ],
            ),
          const SizedBox(height: AppSpacing.xl),

          // Info cards (budget, deadline, status)
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  icon: Icons.payments_outlined,
                  label: 'Budget',
                  value: _formatBudget(project.budget),
                  iconColor: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _InfoCard(
                  icon: Icons.calendar_month_outlined,
                  label: 'Deadline',
                  value: _formatDeadline(project.deadline),
                  iconColor: AppColors.attention,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _InfoCard(
                  icon: Icons.circle,
                  label: 'Status',
                  value: _formatStatus(project.status),
                  iconColor: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Garis pemisah
          const Divider(color: AppColors.hairlineSoft),
          const SizedBox(height: AppSpacing.base),

          // Deskripsi
          Text('Deskripsi Project', style: AppTextStyles.subtitleLg),
          const SizedBox(height: AppSpacing.sm),
          Text(
            project.description,
            style: AppTextStyles.bodyMd.copyWith(height: 1.7),
          ),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateProposalPage(project: project),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.all(AppRadius.xl),
                ),
              ),
              icon: const Icon(Icons.send_rounded, size: 18),
              label: Text('Ajukan Proposal', style: AppTextStyles.buttonMd),
            ),
          ),
        ),
      ),
    );
  }

  String _formatBudget(double budget) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(budget);
  }

  String _formatDeadline(DateTime deadline) {
    return DateFormat('d MMM yyyy', 'id_ID').format(deadline);
  }

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return 'Terbuka';
      case 'closed':
        return 'Ditutup';
      case 'in_progress':
        return 'Berjalan';
      default:
        return status;
    }
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;

  const _Pill({
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.all(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DifficultyPill extends StatelessWidget {
  final String difficulty;
  const _DifficultyPill({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bgColor;
    String label;

    switch (difficulty.toLowerCase()) {
      case 'easy':
        label = 'Mudah';
        color = AppColors.success;
        bgColor = const Color(0xFFE8F5EC);
        break;
      case 'hard':
        label = 'Sulit';
        color = AppColors.critical;
        bgColor = const Color(0xFFFFECEF);
        break;
      default:
        label = 'Menengah';
        color = AppColors.attention;
        bgColor = const Color(0xFFFFF4E0);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.all(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: AppRadius.all(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(height: AppSpacing.xxs),
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.captionBold,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
