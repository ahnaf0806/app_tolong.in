import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/admin_user_item_model.dart';
import 'admin_status_chip.dart';

class AdminUserCard extends StatelessWidget {
  final AdminUserItemModel user;
  final ValueChanged<String> onChangeAccountStatus;
  final ValueChanged<String> onChangeVerification;
  final VoidCallback? onTap;

  const AdminUserCard({
    super.key,
    required this.user,
    required this.onChangeAccountStatus,
    required this.onChangeVerification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.10),
                child: Text(
                  user.name.trim().isEmpty
                      ? '?'
                      : user.name.trim()[0].toUpperCase(),
                  style: AppTextStyles.bodyMdBold.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: AppTextStyles.bodyMdBold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user.email,
                      style: AppTextStyles.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.open_in_new_rounded,
                size: 18,
                color: AppColors.stone,
              ),
              PopupMenuButton<String>(
                onSelected: onChangeAccountStatus,
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'active', child: Text('Aktifkan')),
                  PopupMenuItem(
                    value: 'warned',
                    child: Text('Beri Peringatan'),
                  ),
                  PopupMenuItem(value: 'blocked', child: Text('Blokir')),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              AdminStatusChip(
                label: user.roleLabel,
                tone: _roleTone(user.role),
              ),
              AdminStatusChip(
                label: user.statusLabel,
                tone: user.accountStatus == 'blocked' ? 'danger' : 'success',
              ),
              if (user.role == 'freelancer')
                AdminStatusChip(
                  label: user.verificationLabel,
                  tone: user.verificationStatus == 'verified'
                      ? 'success'
                      : 'warning',
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            [
              user.studyProgram,
              user.university,
            ].whereType<String>().where((e) => e.trim().isNotEmpty).join(' • '),
            style: AppTextStyles.bodySm,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (user.role == 'freelancer') ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.warning,
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  user.ratingAverage.toStringAsFixed(1),
                  style: AppTextStyles.bodySmBold,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${user.totalProjects} project selesai',
                  style: AppTextStyles.caption,
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  onSelected: onChangeVerification,
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'pending', child: Text('Set Pending')),
                    PopupMenuItem(value: 'verified', child: Text('Verifikasi')),
                    PopupMenuItem(
                      value: 'rejected',
                      child: Text('Tolak Verifikasi'),
                    ),
                  ],
                  child: Text('Verifikasi', style: AppTextStyles.linkMd),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _roleTone(String role) {
    if (role == 'admin') return 'purple';
    if (role == 'project_owner') return 'primary';
    return 'success';
  }
}
