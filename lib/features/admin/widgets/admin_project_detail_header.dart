import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/admin_project_detail_model.dart';
import 'admin_status_chip.dart';

class AdminProjectDetailHeader extends StatelessWidget {
  final AdminProjectDetailModel project;

  const AdminProjectDetailHeader({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.inkDeep,
      hasBorder: false,
      radius: AppRadius.xxxl,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.folder_rounded, color: AppColors.canvas, size: 42),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: AppTextStyles.headingSm.copyWith(
                    color: AppColors.canvas,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Owner: ${project.ownerName}',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.canvas.withValues(alpha: 0.78),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    AdminStatusChip(
                      label: project.statusLabel,
                      tone: _statusTone(project.status),
                    ),
                    if (project.hasPendingReports)
                      AdminStatusChip(
                        label: '${project.pendingReportCount} laporan baru',
                        tone: 'danger',
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

  String _statusTone(String status) {
    if (status == 'completed') return 'success';
    if (status == 'cancelled') return 'danger';
    if (status == 'in_progress') return 'warning';
    return 'primary';
  }
}
