import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/project_model.dart';

/// Widget card untuk menampilkan ringkasan project dalam daftar.
class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback? onTap;

  const ProjectCard({super.key, required this.project, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.all(AppRadius.xl),
        side: const BorderSide(color: AppColors.hairlineSoft),
      ),
      elevation: 0,
      color: AppColors.canvas,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.all(AppRadius.xl),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: kategori + badge kesulitan
              Row(
                children: [
                  Expanded(
                    child: _CategoryChip(
                      label: project.categoryName ?? project.projectField,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _DifficultyBadge(difficulty: project.difficulty),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Judul project
              Text(
                project.title,
                style: AppTextStyles.bodyMdBold,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),

              // Deskripsi singkat
              Text(
                project.description,
                style: AppTextStyles.bodySm,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.md),

              // Footer: budget + deadline
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.payments_outlined,
                    label: _formatBudget(project.budget),
                    color: AppColors.success,
                    bgColor: const Color(0xFFE8F5EC),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _InfoChip(
                    icon: Icons.calendar_today_outlined,
                    label: _formatDeadline(project.deadline),
                    color: AppColors.charcoal,
                    bgColor: AppColors.surfaceSoft,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppColors.stone,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatBudget(double budget) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(budget);
  }

  String _formatDeadline(DateTime deadline) {
    return DateFormat('d MMM yyyy', 'id_ID').format(deadline);
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.all(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
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
    final config = _getDifficultyConfig(difficulty);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: AppRadius.all(AppRadius.full),
      ),
      child: Text(
        config.label,
        style: AppTextStyles.caption.copyWith(
          color: config.color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _DifficultyConfig _getDifficultyConfig(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return _DifficultyConfig(
          label: 'Mudah',
          color: AppColors.success,
          bgColor: const Color(0xFFE8F5EC),
        );
      case 'hard':
        return _DifficultyConfig(
          label: 'Sulit',
          color: AppColors.critical,
          bgColor: const Color(0xFFFFECEF),
        );
      default:
        return _DifficultyConfig(
          label: 'Menengah',
          color: AppColors.attention,
          bgColor: const Color(0xFFFFF4E0),
        );
    }
  }
}

class _DifficultyConfig {
  final String label;
  final Color color;
  final Color bgColor;
  const _DifficultyConfig({
    required this.label,
    required this.color,
    required this.bgColor,
  });
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;

  const _InfoChip({
    required this.icon,
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
