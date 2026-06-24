import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/admin_user_item_model.dart';
import '../widgets/admin_info_row.dart';
import '../widgets/admin_status_chip.dart';

class AdminUserDetailPage extends StatelessWidget {
  final AdminUserItemModel user;
  final Future<void> Function(String userId, String status) onChangeUserStatus;
  final Future<void> Function(String userId, String status)
  onChangeVerification;

  const AdminUserDetailPage({
    super.key,
    required this.user,
    required this.onChangeUserStatus,
    required this.onChangeVerification,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: const Text('Detail User')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          _buildHeader(),
          const SizedBox(height: AppSpacing.lg),
          _buildAccountInfo(),
          const SizedBox(height: AppSpacing.lg),
          if (user.role == 'freelancer') ...[
            _buildFreelancerInfo(),
            const SizedBox(height: AppSpacing.lg),
          ],
          _buildAccountActions(context),
          if (user.role == 'freelancer') ...[
            const SizedBox(height: AppSpacing.lg),
            _buildVerificationActions(context),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final initial = user.name.trim().isEmpty
        ? '?'
        : user.name.trim()[0].toUpperCase();

    return AppCard(
      backgroundColor: AppColors.inkDeep,
      hasBorder: false,
      radius: AppRadius.xxxl,
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.canvas.withValues(alpha: 0.14),
            child: Text(
              initial,
              style: AppTextStyles.headingSm.copyWith(color: AppColors.canvas),
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: AppTextStyles.headingSm.copyWith(
                    color: AppColors.canvas,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  user.email,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.canvas.withValues(alpha: 0.78),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
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
                      tone: _accountTone(user.accountStatus),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo() {
    final createdAt = user.createdAt == null
        ? '-'
        : DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(user.createdAt!);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Informasi Akun'),
          const SizedBox(height: AppSpacing.md),
          AdminInfoRow(
            label: 'User ID',
            value: user.id,
            icon: Icons.tag_rounded,
          ),
          AdminInfoRow(
            label: 'Nama',
            value: user.name,
            icon: Icons.person_rounded,
          ),
          AdminInfoRow(
            label: 'Email',
            value: user.email,
            icon: Icons.email_rounded,
          ),
          AdminInfoRow(
            label: 'Role',
            value: user.roleLabel,
            icon: Icons.verified_user_rounded,
          ),
          AdminInfoRow(
            label: 'Status akun',
            value: user.statusLabel,
            icon: Icons.health_and_safety_rounded,
          ),
          AdminInfoRow(
            label: 'Tanggal daftar',
            value: createdAt,
            icon: Icons.schedule_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildFreelancerInfo() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Informasi Freelancer'),
          const SizedBox(height: AppSpacing.md),
          AdminInfoRow(
            label: 'Universitas',
            value: user.university ?? '-',
            icon: Icons.account_balance_rounded,
          ),
          AdminInfoRow(
            label: 'Program studi',
            value: user.studyProgram ?? '-',
            icon: Icons.school_rounded,
          ),
          AdminInfoRow(
            label: 'Verifikasi',
            value: user.verificationLabel,
            icon: Icons.fact_check_rounded,
          ),
          AdminInfoRow(
            label: 'Rating rata-rata',
            value: user.ratingAverage.toStringAsFixed(1),
            icon: Icons.star_rounded,
          ),
          AdminInfoRow(
            label: 'Project selesai',
            value: user.totalProjects.toString(),
            icon: Icons.work_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountActions(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Aksi Akun'),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Gunakan tindakan ini untuk menjaga keamanan dan kualitas ekosistem Tolong.in.',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.charcoal),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ActionButton(
            icon: Icons.check_circle_rounded,
            label: 'Aktifkan Akun',
            color: AppColors.success,
            onTap: () => _confirmAction(
              context: context,
              title: 'Aktifkan akun?',
              message: 'User akan dapat menggunakan aplikasi secara normal.',
              action: () => onChangeUserStatus(user.id, 'active'),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ActionButton(
            icon: Icons.warning_amber_rounded,
            label: 'Beri Peringatan',
            color: AppColors.warning,
            onTap: () => _confirmAction(
              context: context,
              title: 'Beri peringatan?',
              message: 'Status akun user akan berubah menjadi Peringatan.',
              action: () => onChangeUserStatus(user.id, 'warned'),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ActionButton(
            icon: Icons.block_rounded,
            label: 'Blokir Akun',
            color: AppColors.critical,
            onTap: user.role == 'admin'
                ? null
                : () => _confirmAction(
                    context: context,
                    title: 'Blokir akun?',
                    message:
                        'User tidak seharusnya dapat memakai aplikasi jika akun diblokir.',
                    action: () => onChangeUserStatus(user.id, 'blocked'),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationActions(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Aksi Verifikasi Freelancer'),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Verifikasi membantu project owner menilai kredibilitas freelancer.',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.charcoal),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ActionButton(
            icon: Icons.verified_rounded,
            label: 'Verifikasi Freelancer',
            color: AppColors.success,
            onTap: () => _confirmAction(
              context: context,
              title: 'Verifikasi freelancer?',
              message:
                  'Status verifikasi freelancer akan menjadi Terverifikasi.',
              action: () => onChangeVerification(user.id, 'verified'),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ActionButton(
            icon: Icons.hourglass_top_rounded,
            label: 'Set Menunggu Verifikasi',
            color: AppColors.primary,
            onTap: () => _confirmAction(
              context: context,
              title: 'Set pending?',
              message: 'Status verifikasi akan dikembalikan ke Menunggu.',
              action: () => onChangeVerification(user.id, 'pending'),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ActionButton(
            icon: Icons.cancel_rounded,
            label: 'Tolak Verifikasi',
            color: AppColors.critical,
            onTap: () => _confirmAction(
              context: context,
              title: 'Tolak verifikasi?',
              message: 'Status verifikasi freelancer akan menjadi Ditolak.',
              action: () => onChangeVerification(user.id, 'rejected'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: AppTextStyles.subtitleLg);
  }

  Future<void> _confirmAction({
    required BuildContext context,
    required String title,
    required String message,
    required Future<void> Function() action,
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

    await action();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aksi admin berhasil diproses.'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.of(context).pop();
    }
  }

  String _roleTone(String role) {
    if (role == 'admin') return 'purple';
    if (role == 'project_owner') return 'primary';
    return 'success';
  }

  String _accountTone(String status) {
    if (status == 'blocked') return 'danger';
    if (status == 'warned') return 'warning';
    return 'success';
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
