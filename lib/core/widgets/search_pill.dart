import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class SearchPill extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  const SearchPill({
    super.key,
    required this.controller,
    required this.hint,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        style: AppTextStyles.bodySm.copyWith(color: AppColors.ink),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.surfaceSoft,
          hintText: hint,
          hintStyle: AppTextStyles.bodySm.copyWith(color: AppColors.steel),
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: AppColors.steel,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          border: OutlineInputBorder(
            borderRadius: AppRadius.all(AppRadius.full),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.all(AppRadius.full),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.all(AppRadius.full),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
