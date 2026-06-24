import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/admin_project_detail_model.dart';
import 'admin_info_row.dart';

class AdminProjectDetailInfoCard extends StatelessWidget {
  final AdminProjectDetailModel project;

  const AdminProjectDetailInfoCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final deadline = _formatDate(project.deadline);
    final createdAt = _formatDate(project.createdAt);
    final budget = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(project.budget);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Project', style: AppTextStyles.subtitleLg),
          const SizedBox(height: AppSpacing.md),
          AdminInfoRow(
            label: 'Project ID',
            value: project.id,
            icon: Icons.tag_rounded,
          ),
          AdminInfoRow(
            label: 'Kategori',
            value: project.categoryName ?? '-',
            icon: Icons.category_rounded,
          ),
          AdminInfoRow(
            label: 'Bidang',
            value: project.projectField,
            icon: Icons.workspaces_rounded,
          ),
          AdminInfoRow(
            label: 'Tingkat kesulitan',
            value: project.difficultyLabel,
            icon: Icons.speed_rounded,
          ),
          AdminInfoRow(
            label: 'Budget',
            value: budget,
            icon: Icons.payments_rounded,
          ),
          AdminInfoRow(
            label: 'Deadline',
            value: deadline,
            icon: Icons.event_rounded,
          ),
          AdminInfoRow(
            label: 'Dibuat pada',
            value: createdAt,
            icon: Icons.schedule_rounded,
          ),
          const Divider(height: AppSpacing.xl),
          Text('Deskripsi', style: AppTextStyles.bodyMdBold),
          const SizedBox(height: AppSpacing.sm),
          Text(
            project.description,
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.charcoal,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }
}
