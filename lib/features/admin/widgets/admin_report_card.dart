import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/admin_report_item_model.dart';
import 'admin_status_chip.dart';

class AdminReportCard extends StatelessWidget {
  final AdminReportItemModel report;
  final ValueChanged<String> onChangeStatus;
  final VoidCallback? onTap;

  const AdminReportCard({
    super.key,
    required this.report,
    required this.onChangeStatus,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final date = report.createdAt == null
        ? '-'
        : DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(report.createdAt!);

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AdminStatusChip(
                label: report.reasonLabel,
                tone: report.reason == 'permintaan_joki_tugas'
                    ? 'danger'
                    : 'warning',
              ),
              const Spacer(),
              AdminStatusChip(
                label: report.statusLabel,
                tone: _statusTone(report.status),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            report.projectTitle,
            style: AppTextStyles.subtitleLg,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.description,
            style: AppTextStyles.bodySm.copyWith(color: AppColors.charcoal),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Pelapor: ${report.reporterName} • ${report.reporterEmail}',
            style: AppTextStyles.caption,
          ),
          Text(
            'Terlapor: ${report.reportedUserName} • ${report.reportedUserEmail}',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(child: Text(date, style: AppTextStyles.caption)),
              const Icon(
                Icons.open_in_new_rounded,
                size: 18,
                color: AppColors.stone,
              ),
              const SizedBox(width: AppSpacing.xs),
              PopupMenuButton<String>(
                onSelected: onChangeStatus,
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'pending', child: Text('Set Menunggu')),
                  PopupMenuItem(value: 'reviewed', child: Text('Set Ditinjau')),
                  PopupMenuItem(value: 'resolved', child: Text('Set Selesai')),
                ],
                child: const Icon(Icons.more_horiz_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusTone(String status) {
    if (status == 'resolved') return 'success';
    if (status == 'reviewed') return 'primary';
    return 'warning';
  }
}
