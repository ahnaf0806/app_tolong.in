import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class AdminStatusChip extends StatelessWidget {
  final String label;
  final String tone;

  const AdminStatusChip({super.key, required this.label, required this.tone});

  @override
  Widget build(BuildContext context) {
    final color = _color;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: AppRadius.all(AppRadius.full),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Color get _color {
    switch (tone) {
      case 'success':
        return AppColors.success;
      case 'warning':
        return AppColors.warning;
      case 'danger':
        return AppColors.critical;
      case 'purple':
        return AppColors.oculusPurple;
      default:
        return AppColors.primary;
    }
  }
}
