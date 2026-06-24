import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/profile_model.dart';

class ProfileHeaderCard extends StatelessWidget {
  final ProfileModel profile;
  final bool isUploadingPhoto;
  final VoidCallback onChangePhoto;

  const ProfileHeaderCard({
    super.key,
    required this.profile,
    required this.isUploadingPhoto,
    required this.onChangePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: Colors.white.withValues(alpha: 0.18),
                backgroundImage:
                    profile.photoUrl == null || profile.photoUrl!.isEmpty
                    ? null
                    : NetworkImage(profile.photoUrl!),
                child: profile.photoUrl == null || profile.photoUrl!.isEmpty
                    ? const Icon(
                        Icons.person_rounded,
                        size: 56,
                        color: Colors.white,
                      )
                    : null,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: InkWell(
                  onTap: isUploadingPhoto ? null : onChangePhoto,
                  borderRadius: BorderRadius.circular(99),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: isUploadingPhoto
                        ? const Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(
                            Icons.camera_alt_rounded,
                            size: 20,
                            color: AppColors.primary,
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            profile.name,
            style: AppTextStyles.headingLg.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            profile.email,
            style: AppTextStyles.bodySm.copyWith(
              color: Colors.white.withValues(alpha: 0.86),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.base),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              profile.roleLabel,
              style: AppTextStyles.bodySm.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (profile.isFreelancer) ...[
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Rating',
                    value: profile.ratingAverage.toStringAsFixed(1),
                    icon: Icons.star_rounded,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Project',
                    value: profile.totalProjects.toString(),
                    icon: Icons.work_rounded,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Status',
                    value: profile.verificationLabel,
                    icon: Icons.verified_rounded,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTextStyles.bodyMdBold.copyWith(color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }
}
