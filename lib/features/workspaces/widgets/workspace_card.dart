import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_status_badge.dart';
import '../models/workspace_model.dart';

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

    final partnerLabel = isOwner ? 'Freelancer' : 'Project Owner';

    final startedAt = workspace.startedAt != null
        ? DateFormat('dd MMM yyyy', 'id_ID').format(workspace.startedAt!)
        : '-';

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppSpacing.sm),
          _buildPartnerInfo(label: partnerLabel, name: partnerName),
          const SizedBox(height: AppSpacing.sm),
          Text(
            workspace.projectDescription,
            style: AppTextStyles.bodySm.copyWith(color: AppColors.charcoal),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.base),
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
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.stone,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            workspace.projectTitle,
            style: AppTextStyles.headingSm,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        AppStatusBadge(status: workspace.status, type: 'workspace'),
      ],
    );
  }

  Widget _buildPartnerInfo({required String label, required String name}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: AppRadius.all(AppRadius.lg),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.person_outline_rounded,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$label: ',
            style: AppTextStyles.caption.copyWith(color: AppColors.stone),
          ),
          Expanded(
            child: Text(
              name,
              style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
