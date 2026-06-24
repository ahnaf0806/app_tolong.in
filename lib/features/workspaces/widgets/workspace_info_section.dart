import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/premium_glass_card.dart';
import '../models/workspace_model.dart';

class WorkspaceInfoSection extends StatelessWidget {
  final WorkspaceModel workspace;

  const WorkspaceInfoSection({super.key, required this.workspace});

  @override
  Widget build(BuildContext context) {
    return PremiumGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Project', style: AppTextStyles.subtitleLg),
          const SizedBox(height: AppSpacing.base),
          _InfoRow(
            icon: Icons.person_rounded,
            label: 'Project Owner',
            value: workspace.ownerName,
          ),
          _InfoRow(
            icon: Icons.school_rounded,
            label: 'Freelancer',
            value: workspace.freelancerName,
          ),
          _InfoRow(
            icon: Icons.event_rounded,
            label: 'Tanggal Mulai',
            value: workspace.startedAt != null
                ? DateFormat('dd MMMM yyyy', 'id_ID').format(workspace.startedAt!)
                : '-',
          ),
          if (workspace.completedAt != null)
            _InfoRow(
              icon: Icons.verified_rounded,
              label: 'Tanggal Selesai',
              value: DateFormat('dd MMMM yyyy', 'id_ID').format(workspace.completedAt!),
            ),
          if ((workspace.resultFileUrl ?? '').trim().isNotEmpty)
            _InfoRow(
              icon: Icons.link_rounded,
              label: 'File Hasil Kerja',
              value: workspace.resultFileUrl!,
              isLink: true,
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLink;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: AppRadius.all(AppRadius.xl),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(color: AppColors.stone),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  value.trim().isEmpty ? '-' : value,
                  style: AppTextStyles.bodySmBold.copyWith(
                    color: isLink ? AppColors.metaLink : AppColors.ink,
                    decoration: isLink ? TextDecoration.underline : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
