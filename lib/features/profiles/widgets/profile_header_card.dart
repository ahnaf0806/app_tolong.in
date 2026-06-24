import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/premium_gradient_card.dart';
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
    return PremiumGradientCard(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.canvas.withValues(alpha: 0.16),
                backgroundImage: profile.photoUrl == null || profile.photoUrl!.isEmpty
                    ? null
                    : NetworkImage(profile.photoUrl!),
                child: profile.photoUrl == null || profile.photoUrl!.isEmpty
                    ? const Icon(Icons.person_rounded, size: 58, color: AppColors.canvas)
                    : null,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: InkWell(
                  onTap: isUploadingPhoto ? null : onChangePhoto,
                  borderRadius: AppRadius.all(AppRadius.full),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.canvas,
                      borderRadius: AppRadius.all(AppRadius.full),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.inkDeep.withValues(alpha: 0.12),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: isUploadingPhoto
                        ? const Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.camera_alt_rounded, size: 20, color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            profile.name,
            style: AppTextStyles.headingLg.copyWith(color: AppColors.canvas),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            profile.email,
            style: AppTextStyles.bodySm.copyWith(color: AppColors.canvas.withValues(alpha: 0.86)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.base),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.canvas.withValues(alpha: 0.16),
              borderRadius: AppRadius.all(AppRadius.full),
            ),
            child: Text(
              profile.roleLabel,
              style: AppTextStyles.captionBold.copyWith(color: AppColors.canvas),
            ),
          ),
          if (profile.isFreelancer) ...[
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(child: _StatItem(label: 'Rating', value: profile.ratingAverage.toStringAsFixed(1), icon: Icons.star_rounded)),
                Expanded(child: _StatItem(label: 'Project', value: profile.totalProjects.toString(), icon: Icons.work_rounded)),
                Expanded(child: _StatItem(label: 'Status', value: profile.verificationLabel, icon: Icons.verified_rounded)),
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

  const _StatItem({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.canvas, size: 24),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: AppTextStyles.bodySmBold.copyWith(color: AppColors.canvas), textAlign: TextAlign.center),
        Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.canvas.withValues(alpha: 0.76)), textAlign: TextAlign.center),
      ],
    );
  }
}
