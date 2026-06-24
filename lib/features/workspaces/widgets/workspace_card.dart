import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/premium_glass_card.dart';
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
    final partnerName = isOwner ? workspace.freelancerName : workspace.ownerName;
    final partnerLabel = isOwner ? 'Freelancer' : 'Project Owner';
    final startedAt = workspace.startedAt != null
        ? DateFormat('dd MMM yyyy', 'id_ID').format(workspace.startedAt!)
        : '-';

    return PremiumGlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primarySoft,
                    ],
                  ),
                  borderRadius: AppRadius.all(AppRadius.xxl),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.20),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.workspaces_rounded,
                  color: AppColors.canvas,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workspace.projectTitle,
                      style: AppTextStyles.subtitleLg,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    WorkspaceStatusBadge(status: workspace.status),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            workspace.projectDescription,
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.charcoal,
              height: 1.45,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.base),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: AppRadius.all(AppRadius.xl),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.person_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    '$partnerLabel: $partnerName',
                    style: AppTextStyles.bodySmBold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 15, color: AppColors.stone),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                'Mulai: $startedAt',
                style: AppTextStyles.caption.copyWith(color: AppColors.stone),
              ),
              const Spacer(),
              Text(
                'Buka Detail',
                style: AppTextStyles.captionBold.copyWith(color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.xxs),
              const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }
}
