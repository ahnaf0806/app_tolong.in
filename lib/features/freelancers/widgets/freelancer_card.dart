import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/freelancer_summary_model.dart';

class FreelancerCard extends StatelessWidget {
  final FreelancerSummaryModel freelancer;
  final VoidCallback? onTap;

  const FreelancerCard({
    super.key,
    required this.freelancer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      [
                        freelancer.studyProgram,
                        freelancer.university,
                      ].whereType<String>().where((item) => item.isNotEmpty).join(' • '),
                      style: AppTextStyles.bodySm,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _VerificationChip(label: freelancer.verificationLabel),
              if (onTap != null) ...[
                const SizedBox(width: AppSpacing.xs),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.stone,
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          if ((freelancer.bio ?? '').trim().isNotEmpty) ...[
            Text(
              freelancer.bio!,
              style: AppTextStyles.bodySm.copyWith(color: AppColors.charcoal),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.base),
          ],
          _SkillWrap(skills: freelancer.skills),
          const SizedBox(height: AppSpacing.base),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 18, color: AppColors.warning),
              const SizedBox(width: 4),
              Text(
                freelancer.ratingAverage.toStringAsFixed(1),
                style: AppTextStyles.bodySmBold,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${freelancer.totalProjects} project selesai',
                style: AppTextStyles.caption.copyWith(color: AppColors.stone),
              ),
              const Spacer(),
              if ((freelancer.portfolioUrl ?? '').trim().isNotEmpty)
                Text(
                  'Portofolio tersedia',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
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
    final initials = name.trim().isEmpty
        ? 'F'
        : name
              .trim()
              .split(RegExp(r'\s+'))
              .take(2)
              .map((part) => part[0].toUpperCase())
              .join();

    return CircleAvatar(
      radius: 28,
      backgroundColor: AppColors.surfaceSoft,
      backgroundImage: photoUrl == null || photoUrl!.isEmpty
          ? null
          : NetworkImage(photoUrl!),
      child: photoUrl == null || photoUrl!.isEmpty
          ? Text(
              initials,
              style: AppTextStyles.bodyMdBold.copyWith(color: AppColors.primary),
            )
          : null,
    );
  }
}

class _VerificationChip extends StatelessWidget {
  final String label;

  const _VerificationChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final isVerified = label == 'Terverifikasi';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isVerified ? AppColors.success.withValues(alpha: 0.12) : AppColors.surfaceSoft,
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
      return Text('Belum ada keahlian', style: AppTextStyles.bodySm);
    }

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: skills.take(5).map((skill) {
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
            skill,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }).toList(),
    );
  }
}
