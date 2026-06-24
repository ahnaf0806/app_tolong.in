import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/admin_project_detail_model.dart';

class AdminProjectModerationCard extends StatelessWidget {
  final AdminProjectDetailModel project;
  final Future<void> Function(String status) onChangeStatus;

  const AdminProjectModerationCard({
    super.key,
    required this.project,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Aksi Moderasi Project', style: AppTextStyles.subtitleLg),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Admin dapat mengubah status project jika project bermasalah, selesai, atau perlu dikembalikan ke status terbuka.',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.charcoal),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ActionButton(
            icon: Icons.lock_open_rounded,
            label: 'Set Project Terbuka',
            color: AppColors.primary,
            onTap: project.status == 'open'
                ? null
                : () => _confirm(
                    context,
                    title: 'Set project terbuka?',
                    message: 'Project akan tampil sebagai project terbuka.',
                    status: 'open',
                  ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ActionButton(
            icon: Icons.sync_rounded,
            label: 'Set Project Berjalan',
            color: AppColors.attention,
            onTap: project.status == 'in_progress'
                ? null
                : () => _confirm(
                    context,
                    title: 'Set project berjalan?',
                    message: 'Status project akan berubah menjadi berjalan.',
                    status: 'in_progress',
                  ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ActionButton(
            icon: Icons.verified_rounded,
            label: 'Set Project Selesai',
            color: AppColors.success,
            onTap: project.status == 'completed'
                ? null
                : () => _confirm(
                    context,
                    title: 'Set project selesai?',
                    message: 'Status project akan berubah menjadi selesai.',
                    status: 'completed',
                  ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ActionButton(
            icon: Icons.cancel_rounded,
            label: 'Batalkan Project',
            color: AppColors.critical,
            onTap: project.status == 'cancelled'
                ? null
                : () => _confirm(
                    context,
                    title: 'Batalkan project?',
                    message:
                        'Project akan dibatalkan. Gunakan tindakan ini untuk project palsu, joki, atau pelanggaran serius.',
                    status: 'cancelled',
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String status,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Lanjutkan'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await onChangeStatus(status);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Status project berhasil diperbarui.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return InkWell(
      borderRadius: AppRadius.all(AppRadius.xl),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: disabled
              ? AppColors.surfaceSoft
              : color.withValues(alpha: 0.08),
          borderRadius: AppRadius.all(AppRadius.xl),
          border: Border.all(
            color: disabled
                ? AppColors.hairlineSoft
                : color.withValues(alpha: 0.26),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: disabled ? AppColors.stone : color),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodySmBold.copyWith(
                  color: disabled ? AppColors.stone : color,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: disabled ? AppColors.stone : color,
            ),
          ],
        ),
      ),
    );
  }
}
