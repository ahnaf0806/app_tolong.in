import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/premium_glass_card.dart';
import '../models/project_model.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback? onTap;

  const ProjectCard({super.key, required this.project, this.onTap});

  @override
  Widget build(BuildContext context) {
    return PremiumGlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _SoftChip(label: project.categoryName ?? project.projectField)),
              const SizedBox(width: AppSpacing.xs),
              _DifficultyBadge(difficulty: project.difficulty),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            project.title,
            style: AppTextStyles.subtitleLg.copyWith(color: AppColors.inkDeep),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            project.description,
            style: AppTextStyles.bodySm.copyWith(color: AppColors.slate, height: 1.45),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _InfoPill(
                  icon: Icons.payments_rounded,
                  label: _formatBudget(project.budget),
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              _InfoPill(
                icon: Icons.event_rounded,
                label: _formatDeadline(project.deadline),
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: AppRadius.all(AppRadius.full),
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatBudget(double budget) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(budget);
  }

  String _formatDeadline(DateTime deadline) {
    return DateFormat('d MMM yyyy', 'id_ID').format(deadline);
  }
}

class _SoftChip extends StatelessWidget {
  final String label;
  const _SoftChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.all(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTextStyles.captionBold.copyWith(color: AppColors.primary),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String difficulty;
  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final config = _difficultyConfig(difficulty);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: AppRadius.all(AppRadius.full),
      ),
      child: Text(
        config.label,
        style: AppTextStyles.captionBold.copyWith(color: config.color),
      ),
    );
  }

  _DiffConfig _difficultyConfig(String value) {
    switch (value.toLowerCase()) {
      case 'easy':
        return const _DiffConfig('Mudah', AppColors.success, AppColors.successBg);
      case 'hard':
        return const _DiffConfig('Sulit', AppColors.critical, Color(0xFFFFECEF));
      default:
        return const _DiffConfig('Sedang', AppColors.attention, AppColors.warningBg);
    }
  }
}

class _DiffConfig {
  final String label;
  final Color color;
  final Color bg;
  const _DiffConfig(this.label, this.color, this.bg);
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoPill({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.all(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.captionBold.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
