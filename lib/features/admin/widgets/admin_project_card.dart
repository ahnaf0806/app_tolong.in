import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/admin_project_item_model.dart';
import 'admin_status_chip.dart';

class AdminProjectCard extends StatelessWidget {
  final AdminProjectItemModel project;
  final ValueChanged<String> onChangeStatus;
  final VoidCallback? onTap;

  const AdminProjectCard({
    super.key,
    required this.project,
    required this.onChangeStatus,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final deadline = project.deadline == null
        ? '-'
        : DateFormat('dd MMM yyyy', 'id_ID').format(project.deadline!);

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AdminStatusChip(
                label: project.statusLabel,
                tone: _statusTone(project.status),
              ),
              const Spacer(),
              if (project.reportCount > 0)
                AdminStatusChip(
                  label: '${project.reportCount} laporan',
                  tone: 'danger',
                ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(
                Icons.open_in_new_rounded,
                size: 18,
                color: AppColors.stone,
              ),
              PopupMenuButton<String>(
                onSelected: onChangeStatus,
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'open', child: Text('Set Terbuka')),
                  PopupMenuItem(
                    value: 'in_progress',
                    child: Text('Set Berjalan'),
                  ),
                  PopupMenuItem(value: 'completed', child: Text('Set Selesai')),
                  PopupMenuItem(value: 'cancelled', child: Text('Batalkan')),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            project.title,
            style: AppTextStyles.subtitleLg,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text('Owner: ${project.ownerName}', style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _InfoTile(label: 'Bidang', value: project.projectField),
              ),
              Expanded(
                child: _InfoTile(label: 'Deadline', value: deadline),
              ),
              Expanded(
                child: _InfoTile(
                  label: 'Proposal',
                  value: project.proposalCount.toString(),
                ),
              ),
            ],
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

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.bodySmBold.copyWith(color: AppColors.ink),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
