import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

class GhostButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const GhostButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.inkDeep,
          side: const BorderSide(color: AppColors.ghostBorder, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          textStyle: AppTextStyles.buttonMd,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.all(AppRadius.full),
          ),
        ),
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild() {
    if (icon == null) {
      return Text(
        text,
        style: AppTextStyles.buttonMd.copyWith(color: AppColors.inkDeep),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyles.buttonMd.copyWith(color: AppColors.inkDeep),
        ),
      ],
    );
  }
}
