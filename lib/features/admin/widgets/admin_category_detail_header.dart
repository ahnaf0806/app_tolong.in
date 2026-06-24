import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/admin_category_detail_model.dart';
import 'admin_status_chip.dart';

class AdminCategoryDetailHeader extends StatelessWidget {
  final AdminCategoryDetailModel category;

  const AdminCategoryDetailHeader({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.inkDeep,
      hasBorder: false,
      radius: AppRadius.xxxl,
      child: Row(
        children: [
          const Icon(Icons.category_rounded, color: AppColors.canvas, size: 40),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: AppTextStyles.headingSm.copyWith(color: AppColors.canvas),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  category.description ?? 'Kategori project Tolong.in',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.canvas.withValues(alpha: 0.78),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  children: [
                    AdminStatusChip(
                      label: category.statusLabel,
                      tone: category.isActive ? 'success' : 'danger',
                    ),
                    AdminStatusChip(
                      label: 'Urutan ${category.displayOrder}',
                      tone: 'primary',
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
}
