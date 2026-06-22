import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/workspace_model.dart';
import 'workspace_status_badge.dart';

class WorkspaceCard extends StatelessWidget {
  final WorkspaceModel workspace;
  final bool isOwner;
  final VoidCallback onTap;

  const WorkspaceCard({
    super.key,
    required this.workspace,
    required this.isOwner,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final partnerName = isOwner
        ? workspace.freelancerName
        : workspace.ownerName;
    final startedAt = workspace.startedAt != null
        ? DateFormat('dd MMM yyyy', 'id_ID').format(workspace.startedAt!)
        : '-';

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workspace.projectTitle,
                      style: AppTextStyles.headingSm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 14,
                          color: AppColors.stone,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          partnerName,
                          style: AppTextStyles.bodySm.copyWith(
                            color: AppColors.stone,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              WorkspaceStatusBadge(status: workspace.status),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            workspace.projectDescription,
            style: AppTextStyles.bodySm.copyWith(color: AppColors.charcoal),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 14,
                color: AppColors.stone,
              ),
              const SizedBox(width: 4),
              Text(
                'Mulai: $startedAt',
                style: AppTextStyles.caption.copyWith(color: AppColors.stone),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.all(AppRadius.lg),
                ),
              ),
              child: Text('Buka Workspace', style: AppTextStyles.captionBold),
            ),
          ),
        ],
      ),
    );
  }
}
