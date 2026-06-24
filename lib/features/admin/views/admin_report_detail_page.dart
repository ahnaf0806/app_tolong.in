import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/admin_report_item_model.dart';
import '../widgets/admin_action_button.dart';
import '../widgets/admin_confirm_dialog.dart';
import '../widgets/admin_info_row.dart';
import '../widgets/admin_status_chip.dart';

class AdminReportDetailPage extends StatelessWidget {
  final AdminReportItemModel report;
  final Future<void> Function(String reportId, String status) onChangeReportStatus;
  final Future<void> Function(String userId, String status) onChangeUserStatus;
  final Future<void> Function(String projectId, String status) onChangeProjectStatus;

  const AdminReportDetailPage({
    super.key,
    required this.report,
    required this.onChangeReportStatus,
    required this.onChangeUserStatus,
    required this.onChangeProjectStatus,
  });

  @override
  Widget build(BuildContext context) {
    final date = report.createdAt == null
        ? '-'
        : DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(report.createdAt!);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: const Text('Detail Laporan')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          _buildHeader(),
          const SizedBox(height: AppSpacing.lg),
          _buildReportSummary(date),
          const SizedBox(height: AppSpacing.lg),
          _buildProjectInfo(),
          const SizedBox(height: AppSpacing.lg),
          _buildUserInfo(),
          const SizedBox(height: AppSpacing.lg),
          _buildModerationActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return AppCard(
      backgroundColor: AppColors.inkDeep,
      hasBorder: false,
      radius: 32,
      child: Row(
        children: [
          const Icon(Icons.gavel_rounded, color: AppColors.canvas, size: 40),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report.reasonLabel, style: AppTextStyles.headingSm.copyWith(color: AppColors.canvas)),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Tinjau laporan sebelum mengambil tindakan moderasi.',
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.canvas.withValues(alpha: 0.78)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportSummary(String date) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Ringkasan Laporan'),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              AdminStatusChip(label: report.reasonLabel, tone: report.reason == 'permintaan_joki_tugas' ? 'danger' : 'warning'),
              AdminStatusChip(label: report.statusLabel, tone: _reportStatusTone(report.status)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AdminInfoRow(label: 'Tanggal laporan', value: date, icon: Icons.schedule_rounded),
          const Divider(height: AppSpacing.xl),
          Text('Deskripsi Laporan', style: AppTextStyles.bodyMdBold),
          const SizedBox(height: AppSpacing.sm),
          Text(report.description, style: AppTextStyles.bodySm.copyWith(color: AppColors.charcoal, height: 1.45)),
        ],
      ),
    );
  }

  Widget _buildProjectInfo() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Project Dilaporkan'),
          const SizedBox(height: AppSpacing.md),
          AdminInfoRow(label: 'Judul project', value: report.projectTitle, icon: Icons.folder_copy_rounded),
          AdminInfoRow(label: 'Project ID', value: report.projectId ?? '-', icon: Icons.tag_rounded),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('User Terkait'),
          const SizedBox(height: AppSpacing.md),
          Text('Pelapor', style: AppTextStyles.bodyMdBold),
          AdminInfoRow(label: 'Nama', value: report.reporterName, icon: Icons.person_rounded),
          AdminInfoRow(label: 'Email', value: report.reporterEmail, icon: Icons.email_rounded),
          const Divider(height: AppSpacing.xl),
          Text('Terlapor', style: AppTextStyles.bodyMdBold),
          AdminInfoRow(label: 'Nama', value: report.reportedUserName, icon: Icons.person_off_rounded),
          AdminInfoRow(label: 'Email', value: report.reportedUserEmail, icon: Icons.email_rounded),
        ],
      ),
    );
  }

  Widget _buildModerationActions(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Aksi Moderasi'),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Gunakan tindakan ini hanya setelah laporan ditinjau. Tindakan admin akan langsung mengubah data di Supabase.',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.charcoal),
          ),
          const SizedBox(height: AppSpacing.lg),
          AdminActionButton(
            icon: Icons.visibility_rounded,
            label: 'Tandai Laporan Ditinjau',
            color: AppColors.primary,
            onTap: () => _runAction(context, 'Tandai laporan ditinjau?', 'Status laporan akan berubah menjadi Ditinjau.', () => onChangeReportStatus(report.id, 'reviewed')),
          ),
          const SizedBox(height: AppSpacing.sm),
          AdminActionButton(
            icon: Icons.check_circle_rounded,
            label: 'Tandai Laporan Selesai',
            color: AppColors.success,
            onTap: () => _runAction(context, 'Selesaikan laporan?', 'Status laporan akan berubah menjadi Selesai.', () => onChangeReportStatus(report.id, 'resolved')),
          ),
          const SizedBox(height: AppSpacing.sm),
          AdminActionButton(
            icon: Icons.warning_amber_rounded,
            label: 'Beri Peringatan ke User Terlapor',
            color: AppColors.warning,
            onTap: report.reportedUserId == null ? null : () => _runAction(context, 'Beri peringatan?', 'Status akun user terlapor akan menjadi Peringatan.', () => onChangeUserStatus(report.reportedUserId!, 'warned')),
          ),
          const SizedBox(height: AppSpacing.sm),
          AdminActionButton(
            icon: Icons.block_rounded,
            label: 'Blokir User Terlapor',
            color: AppColors.critical,
            onTap: report.reportedUserId == null ? null : () => _runAction(context, 'Blokir user?', 'Pastikan laporan valid sebelum memblokir akun.', () => onChangeUserStatus(report.reportedUserId!, 'blocked')),
          ),
          const SizedBox(height: AppSpacing.sm),
          AdminActionButton(
            icon: Icons.cancel_rounded,
            label: 'Batalkan Project Bermasalah',
            color: AppColors.criticalStrong,
            onTap: report.projectId == null ? null : () => _runAction(context, 'Batalkan project?', 'Project akan diubah menjadi dibatalkan.', () => onChangeProjectStatus(report.projectId!, 'cancelled')),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(title, style: AppTextStyles.subtitleLg);

  String _reportStatusTone(String status) {
    if (status == 'resolved') return 'success';
    if (status == 'reviewed') return 'primary';
    return 'warning';
  }

  Future<void> _runAction(
    BuildContext context,
    String title,
    String message,
    Future<void> Function() action,
  ) async {
    final confirmed = await AdminConfirmDialog.show(context: context, title: title, message: message);
    if (!confirmed) return;
    await action();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aksi moderasi berhasil diproses.'), behavior: SnackBarBehavior.floating),
      );
      Navigator.of(context).pop();
    }
  }
}
