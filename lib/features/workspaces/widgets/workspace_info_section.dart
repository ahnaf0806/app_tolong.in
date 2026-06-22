import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/workspace_model.dart';

class WorkspaceInfoSection extends StatelessWidget {
  final WorkspaceModel workspace;

  const WorkspaceInfoSection({super.key, required this.workspace});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Project', style: AppTextStyles.headingSm),
          const SizedBox(height: AppSpacing.lg),
          _InfoRow(label: 'Project Owner', value: workspace.ownerName),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(label: 'Freelancer', value: workspace.freelancerName),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(
            label: 'Tanggal Mulai',
            value: workspace.startedAt != null
                ? DateFormat(
                    'dd MMMM yyyy',
                    'id_ID',
                  ).format(workspace.startedAt!)
                : '-',
          ),
          if (workspace.completedAt != null) ...[
            const SizedBox(height: AppSpacing.md),
            _InfoRow(
              label: 'Tanggal Selesai',
              value: DateFormat(
                'dd MMMM yyyy',
                'id_ID',
              ).format(workspace.completedAt!),
            ),
          ],
          if (workspace.resultFileUrl != null &&
              workspace.resultFileUrl!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _InfoRow(
              label: 'File Hasil Kerja',
              value: workspace.resultFileUrl!,
              isLink: true,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLink;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.stone),
        ),
        const SizedBox(height: 2),
        isLink
            ? Text(
                value,
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.metaLink,
                  decoration: TextDecoration.underline,
                ),
              )
            : Text(value, style: AppTextStyles.bodyMd),
      ],
    );
  }
}
