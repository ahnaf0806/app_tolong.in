import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class AppBrandLogo extends StatelessWidget {
  final double size;
  final bool showLabel;
  final bool compact;
  final Color? labelColor;

  const AppBrandLogo({
    super.key,
    this.size = 52,
    this.showLabel = false,
    this.compact = false,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: AppRadius.all(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.all(size * 0.28),
        child: Image.asset(
          AppAssets.logo,
          fit: BoxFit.cover,
        ),
      ),
    );

    if (!showLabel) {
      return mark;
    }

    return Row(
      mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
      children: [
        mark,
        const SizedBox(width: AppSpacing.md),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tolong.in',
                style: AppTextStyles.subtitleLg.copyWith(
                  color: labelColor ?? AppColors.inkDeep,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Smart student project marketplace',
                style: AppTextStyles.caption.copyWith(
                  color: (labelColor ?? AppColors.stone).withValues(alpha: 0.82),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
