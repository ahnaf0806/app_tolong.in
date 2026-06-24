import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/admin_user_item_model.dart';
import '../widgets/admin_action_button.dart';
import '../widgets/admin_confirm_dialog.dart';
import '../widgets/admin_info_row.dart';
import '../widgets/admin_status_chip.dart';

class AdminUserDetailPage extends StatelessWidget {
  final AdminUserItemModel user;
  final Future<void> Function(String userId, String status) onChangeUserStatus;
  final Future<void> Function(String userId, String status) onChangeVerification;

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
    final initial = user.name.trim().isEmpty ? '?' : user.name.trim()[0].toUpperCase();
    return AppCard(
      backgroundColor: AppColors.inkDeep,
      hasBorder: false,
      radius: AppRadius.xxxl,
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.canvas.withValues(alpha: 0.14),
            child: Text(initial, style: AppTextStyles.headingSm.copyWith(color: AppColors.canvas)),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: AppTextStyles.headingSm.copyWith(color: AppColors.canvas), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: AppSpacing.xs),
                Text(user.email, style: AppTextStyles.bodySm.copyWith(color: AppColors.canvas.withValues(alpha: 0.78)), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    AdminStatusChip(label: user.roleLabel, tone: _roleTone(user.role)),
                    AdminStatusChip(label: user.statusLabel, tone: _accountTone(user.accountStatus)),
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
          AdminInfoRow(label: 'User ID', value: user.id, icon: Icons.tag_rounded),
          AdminInfoRow(label: 'Nama', value: user.name, icon: Icons.person_rounded),
          AdminInfoRow(label: 'Email', value: user.email, icon: Icons.email_rounded),
          AdminInfoRow(label: 'Role', value: user.roleLabel, icon: Icons.verified_user_rounded),
          AdminInfoRow(label: 'Status akun', value: user.statusLabel, icon: Icons.health_and_safety_rounded),
          AdminInfoRow(label: 'Tanggal daftar', value: createdAt, icon: Icons.schedule_rounded),
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
          AdminInfoRow(label: 'Universitas', value: user.university ?? '-', icon: Icons.account_balance_rounded),
          AdminInfoRow(label: 'Program studi', value: user.studyProgram ?? '-', icon: Icons.school_rounded),
          AdminInfoRow(label: 'Verifikasi', value: user.verificationLabel, icon: Icons.fact_check_rounded),
          AdminInfoRow(label: 'Rating rata-rata', value: user.ratingAverage.toStringAsFixed(1), icon: Icons.star_rounded),
          AdminInfoRow(label: 'Project selesai', value: user.totalProjects.toString(), icon: Icons.work_rounded),
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
          Text('Gunakan tindakan ini untuk menjaga keamanan Tolong.in.', style: AppTextStyles.bodySm.copyWith(color: AppColors.charcoal)),
          const SizedBox(height: AppSpacing.lg),
          AdminActionButton(icon: Icons.check_circle_rounded, label: 'Aktifkan Akun', color: AppColors.success, onTap: () => _run(context, 'Aktifkan akun?', 'User akan dapat menggunakan aplikasi secara normal.', () => onChangeUserStatus(user.id, 'active'))),
          const SizedBox(height: AppSpacing.sm),
          AdminActionButton(icon: Icons.warning_amber_rounded, label: 'Beri Peringatan', color: AppColors.warning, onTap: () => _run(context, 'Beri peringatan?', 'Status akun akan berubah menjadi Peringatan.', () => onChangeUserStatus(user.id, 'warned'))),
          const SizedBox(height: AppSpacing.sm),
          AdminActionButton(icon: Icons.block_rounded, label: 'Blokir Akun', color: AppColors.critical, onTap: user.role == 'admin' ? null : () => _run(context, 'Blokir akun?', 'Akun user akan diblokir.', () => onChangeUserStatus(user.id, 'blocked'))),
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
          Text('Verifikasi membantu project owner menilai kredibilitas freelancer.', style: AppTextStyles.bodySm.copyWith(color: AppColors.charcoal)),
          const SizedBox(height: AppSpacing.lg),
          AdminActionButton(icon: Icons.verified_rounded, label: 'Verifikasi Freelancer', color: AppColors.success, onTap: () => _run(context, 'Verifikasi freelancer?', 'Status akan menjadi Terverifikasi.', () => onChangeVerification(user.id, 'verified'))),
          const SizedBox(height: AppSpacing.sm),
          AdminActionButton(icon: Icons.hourglass_top_rounded, label: 'Set Menunggu Verifikasi', color: AppColors.primary, onTap: () => _run(context, 'Set pending?', 'Status dikembalikan ke Menunggu.', () => onChangeVerification(user.id, 'pending'))),
          const SizedBox(height: AppSpacing.sm),
          AdminActionButton(icon: Icons.cancel_rounded, label: 'Tolak Verifikasi', color: AppColors.critical, onTap: () => _run(context, 'Tolak verifikasi?', 'Status akan menjadi Ditolak.', () => onChangeVerification(user.id, 'rejected'))),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(title, style: AppTextStyles.subtitleLg);

  Future<void> _run(BuildContext context, String title, String message, Future<void> Function() action) async {
    final confirmed = await AdminConfirmDialog.show(context: context, title: title, message: message);
    if (!confirmed) return;
    await action();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aksi admin berhasil diproses.'), behavior: SnackBarBehavior.floating));
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
