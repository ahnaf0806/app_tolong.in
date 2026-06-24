import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class AdminActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const AdminActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return InkWell(
      borderRadius: AppRadius.all(AppRadius.xl),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: disabled
              ? AppColors.surfaceSoft
              : color.withValues(alpha: 0.08),
          borderRadius: AppRadius.all(AppRadius.xl),
          border: Border.all(
            color: disabled
                ? AppColors.hairlineSoft
                : color.withValues(alpha: 0.26),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: disabled ? AppColors.stone : color),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodySmBold.copyWith(
                  color: disabled ? AppColors.stone : color,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: disabled ? AppColors.stone : color,
            ),
          ],
        ),
      ),
    );
  }
}
