import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/freelancer_summary_model.dart';

class FreelancerDetailHeader extends StatelessWidget {
  final FreelancerSummaryModel freelancer;

  const FreelancerDetailHeader({super.key, required this.freelancer});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.inkDeep,
      hasBorder: false,
      radius: AppRadius.xxxl,
      child: Row(
        children: [
          _Avatar(photoUrl: freelancer.photoUrl, name: freelancer.name),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  freelancer.name,
                  style: AppTextStyles.headingSm.copyWith(
                    color: AppColors.canvas,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  freelancer.email,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.canvas.withValues(alpha: 0.78),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                _VerificationChip(label: freelancer.verificationLabel),
              ],
            ),
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
      radius: 34,
      backgroundColor: AppColors.canvas.withValues(alpha: 0.14),
      backgroundImage: photoUrl == null || photoUrl!.isEmpty
          ? null
          : NetworkImage(photoUrl!),
      child: photoUrl == null || photoUrl!.isEmpty
          ? Text(
              initials,
              style: AppTextStyles.bodyMdBold.copyWith(
                color: AppColors.canvas,
              ),
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
        color: isVerified
            ? AppColors.success.withValues(alpha: 0.16)
            : AppColors.canvas.withValues(alpha: 0.14),
        borderRadius: AppRadius.all(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTextStyles.captionBold.copyWith(color: AppColors.canvas),
      ),
    );
  }
}
