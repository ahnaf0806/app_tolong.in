import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/freelancer_summary_model.dart';

class FreelancerCard extends StatelessWidget {
  final FreelancerSummaryModel freelancer;

  const FreelancerCard({super.key, required this.freelancer});

  @override
  Widget build(BuildContext context) {
    final studyInfo = [
      freelancer.studyProgram,
      freelancer.university,
    ].whereType<String>().where((item) => item.trim().isNotEmpty).join(' • ');

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Avatar(photoUrl: freelancer.photoUrl, name: freelancer.name),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      freelancer.name,
                      style: AppTextStyles.subtitleLg,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      studyInfo.isEmpty
                          ? 'Data kampus belum dilengkapi'
                          : studyInfo,
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.charcoal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _VerificationChip(
                label: freelancer.verificationLabel,
                status: freelancer.verificationStatus,
              ),
            ],
          ),
          if ((freelancer.bio ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.base),
            Text(
              freelancer.bio!,
              style: AppTextStyles.bodySm.copyWith(color: AppColors.charcoal),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppSpacing.base),
          _SkillWrap(skills: freelancer.skills),
          const SizedBox(height: AppSpacing.base),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 18,
                color: AppColors.warning,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                freelancer.ratingAverage.toStringAsFixed(1),
                style: AppTextStyles.bodySmBold,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  '${freelancer.totalProjects} project selesai',
                  style: AppTextStyles.caption.copyWith(color: AppColors.stone),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if ((freelancer.portfolioUrl ?? '').trim().isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: AppRadius.all(AppRadius.full),
                  ),
                  child: Text(
                    'Portofolio',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? photoUrl;
  final String name;

  const _Avatar({required this.photoUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    final cleanName = name.trim();
    final initials = cleanName.isEmpty
        ? 'F'
        : cleanName
              .split(RegExp(r'\s+'))
              .take(2)
              .map((part) => part[0].toUpperCase())
              .join();

    return CircleAvatar(
      radius: 28,
      backgroundColor: AppColors.surfaceSoft,
      backgroundImage: photoUrl == null || photoUrl!.trim().isEmpty
          ? null
          : NetworkImage(photoUrl!),
      child: photoUrl == null || photoUrl!.trim().isEmpty
          ? Text(
              initials,
              style: AppTextStyles.bodyMdBold.copyWith(
                color: AppColors.primary,
              ),
            )
          : null,
    );
  }
}

class _VerificationChip extends StatelessWidget {
  final String label;
  final String status;

  const _VerificationChip({required this.label, required this.status});

  @override
  Widget build(BuildContext context) {
    final isVerified = status == 'verified';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isVerified
            ? AppColors.success.withValues(alpha: 0.12)
            : AppColors.surfaceSoft,
        borderRadius: AppRadius.all(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: isVerified ? AppColors.success : AppColors.stone,
          fontWeight: FontWeight.w700,
        ),
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
      return Text(
        'Belum ada keahlian',
        style: AppTextStyles.bodySm.copyWith(color: AppColors.stone),
      );
    }

    final visibleSkills = skills.take(5).toList();
    final hiddenCount = skills.length - visibleSkills.length;

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        ...visibleSkills.map(
          (skill) => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: AppRadius.all(AppRadius.full),
            ),
            child: Text(
              skill,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        if (hiddenCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: AppRadius.all(AppRadius.full),
            ),
            child: Text(
              '+$hiddenCount',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.stone,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}
