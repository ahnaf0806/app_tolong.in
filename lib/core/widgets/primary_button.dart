import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

enum PrimaryButtonVariant { black, cobalt }

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final PrimaryButtonVariant variant;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = PrimaryButtonVariant.black,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = _backgroundColor;

    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: AppColors.canvas,
          disabledBackgroundColor: AppColors.disabledText,
          disabledForegroundColor: AppColors.canvas,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
          textStyle: AppTextStyles.buttonMd,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.all(AppRadius.full),
          ),
        ),
        child: _buildChild(),
      ),
    );
  }

  Color get _backgroundColor {
    switch (variant) {
      case PrimaryButtonVariant.black:
        return AppColors.inkButton;
      case PrimaryButtonVariant.cobalt:
        return AppColors.primary;
    }
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.canvas,
        ),
      );
    }

    if (icon == null) {
      return Text(
        text,
        style: AppTextStyles.buttonMd.copyWith(color: AppColors.canvas),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyles.buttonMd.copyWith(color: AppColors.canvas),
        ),
      ],
    );
  }
}
