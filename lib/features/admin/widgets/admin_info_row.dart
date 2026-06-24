import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class AdminInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const AdminInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: AppColors.stone),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: AppTextStyles.bodySm.copyWith(color: AppColors.stone),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            flex: 6,
            child: Text(
              value.trim().isEmpty ? '-' : value,
              style: AppTextStyles.bodySmBold.copyWith(color: AppColors.ink),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
