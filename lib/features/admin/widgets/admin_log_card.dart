import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/admin_audit_log_model.dart';
import 'admin_status_chip.dart';

class AdminLogCard extends StatelessWidget {
  final AdminAuditLogModel log;

  const AdminLogCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final date = log.createdAt == null
        ? '-'
        : DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(log.createdAt!);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AdminStatusChip(label: log.actionLabel, tone: _tone(log.action)),
              const Spacer(),
              Text(date, style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(log.description, style: AppTextStyles.bodyMdBold),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${log.targetTable} • ${log.targetId ?? '-'}',
            style: AppTextStyles.caption.copyWith(color: AppColors.stone),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text('Admin: ${log.adminName}', style: AppTextStyles.caption),
        ],
      ),
    );
  }

  String _tone(String action) {
    if (action == 'delete') return 'danger';
    if (action == 'moderate') return 'warning';
    if (action == 'create') return 'success';
    return 'primary';
  }
}
