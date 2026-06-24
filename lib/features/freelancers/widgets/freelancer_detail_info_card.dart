import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/freelancer_summary_model.dart';

class FreelancerDetailInfoCard extends StatelessWidget {
  final FreelancerSummaryModel freelancer;

  const FreelancerDetailInfoCard({super.key, required this.freelancer});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Profil', style: AppTextStyles.subtitleLg),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(
            icon: Icons.account_balance_rounded,
            label: 'Universitas',
            value: freelancer.university ?? '-',
          ),
          _InfoRow(
            icon: Icons.school_rounded,
            label: 'Program Studi',
            value: freelancer.studyProgram ?? '-',
          ),
          _InfoRow(
            icon: Icons.calendar_month_rounded,
            label: 'Semester',
            value: freelancer.semester?.toString() ?? '-',
          ),
          if ((freelancer.portfolioUrl ?? '').trim().isNotEmpty)
            _InfoRow(
              icon: Icons.link_rounded,
              label: 'Portofolio',
              value: freelancer.portfolioUrl!,
            ),
          const Divider(height: AppSpacing.xl),
          Text('Bio', style: AppTextStyles.bodyMdBold),
          const SizedBox(height: AppSpacing.sm),
          Text(
            (freelancer.bio ?? '').trim().isEmpty
                ? 'Freelancer belum menulis bio.'
                : freelancer.bio!,
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.charcoal,
              height: 1.45,
            ),
          ),
          const Divider(height: AppSpacing.xl),
          Text('Keahlian', style: AppTextStyles.bodyMdBold),
          const SizedBox(height: AppSpacing.sm),
          _SkillWrap(skills: freelancer.skills),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.stone),
          const SizedBox(width: AppSpacing.sm),
          Expanded(flex: 4, child: Text(label, style: AppTextStyles.bodySm)),
          Expanded(
            flex: 6,
            child: Text(
              value.trim().isEmpty ? '-' : value,
              style: AppTextStyles.bodySmBold,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillWrap extends StatelessWidget {
  final List<String> skills;

  const _SkillWrap({required this.skills});

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) {
      return Text('Belum ada keahlian.', style: AppTextStyles.bodySm);
    }

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: skills.map((skill) {
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
            skill,
            style: AppTextStyles.captionBold.copyWith(color: AppColors.primary),
          ),
        );
      }).toList(),
    );
  }
}
