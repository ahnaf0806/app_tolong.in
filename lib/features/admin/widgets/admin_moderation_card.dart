import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/admin_moderation_item_model.dart';
import 'admin_status_chip.dart';

class AdminModerationCard extends StatelessWidget {
  final AdminModerationItemModel item;

  const AdminModerationCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final date = item.createdAt == null
        ? null
        : DateFormat('dd MMM yyyy', 'id_ID').format(item.createdAt!);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              AdminStatusChip(label: item.typeLabel, tone: _typeTone(item.type)),
              AdminStatusChip(label: item.priorityLabel, tone: _priorityTone(item.priority)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(item.title, style: AppTextStyles.subtitleLg),
          const SizedBox(height: AppSpacing.xs),
          Text(
            item.subtitle,
            style: AppTextStyles.bodySm.copyWith(color: AppColors.charcoal),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (date != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(date, style: AppTextStyles.caption),
          ],
        ],
      ),
    );
  }

  String _typeTone(String type) {
    if (type == 'report') return 'danger';
    if (type == 'verification') return 'primary';
    return 'warning';
  }

  String _priorityTone(String priority) {
    if (priority == 'high') return 'danger';
    if (priority == 'medium') return 'warning';
    return 'success';
  }
}
