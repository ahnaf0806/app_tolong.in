import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/admin_category_item_model.dart';
import 'admin_status_chip.dart';

class AdminCategoryCard extends StatelessWidget {
  final AdminCategoryItemModel category;
  final VoidCallback onEdit;
  final VoidCallback onToggleActive;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const AdminCategoryCard({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onToggleActive,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AdminStatusChip(
                label: category.statusLabel,
                tone: category.isActive ? 'success' : 'danger',
              ),
              const SizedBox(width: AppSpacing.xs),
              AdminStatusChip(label: 'Urutan ${category.displayOrder}', tone: 'primary'),
              const Spacer(),
              const Icon(Icons.open_in_new_rounded, size: 18, color: AppColors.stone),
              PopupMenuButton<String>(
                onSelected: _handleAction,
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit Kategori')),
                  PopupMenuItem(
                    value: 'toggle',
                    child: Text(category.isActive ? 'Nonaktifkan' : 'Aktifkan'),
                  ),
                  const PopupMenuItem(value: 'delete', child: Text('Hapus Kategori')),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            category.name,
            style: AppTextStyles.subtitleLg,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            category.description?.trim().isEmpty ?? true
                ? 'Belum ada deskripsi kategori.'
                : category.description!,
            style: AppTextStyles.bodySm.copyWith(color: AppColors.charcoal),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(Icons.folder_copy_outlined, size: 18, color: AppColors.stone),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  '${category.projectCount} project memakai kategori ini',
                  style: AppTextStyles.caption.copyWith(color: AppColors.stone),
                ),
              ),
              if (!category.canDelete)
                Text(
                  'Tidak bisa dihapus',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.critical,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleAction(String value) {
    if (value == 'edit') onEdit();
    if (value == 'toggle') onToggleActive();
    if (value == 'delete') onDelete();
  }
}
