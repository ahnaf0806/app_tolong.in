import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class RoleSelector extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String> onChanged;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _RoleItem(
            label: 'Project Owner',
            subtitle: 'Buat project',
            value: 'project_owner',
            selectedRole: selectedRole,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _RoleItem(
            label: 'Freelancer',
            subtitle: 'Cari project',
            value: 'freelancer',
            selectedRole: selectedRole,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _RoleItem extends StatelessWidget {
  final String label;
  final String subtitle;
  final String value;
  final String selectedRole;
  final ValueChanged<String> onChanged;

  const _RoleItem({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.selectedRole,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedRole == value;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: AppRadius.all(AppRadius.xl),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.inkDeep : AppColors.canvas,
          borderRadius: AppRadius.all(AppRadius.xl),
          border: Border.all(
            color: isSelected ? AppColors.inkDeep : AppColors.hairline,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmBold.copyWith(
                color: isSelected ? AppColors.canvas : AppColors.ink,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? AppColors.canvas : AppColors.steel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
