import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

enum BadgeType { success, attention, warning, critical }

class StatusBadge extends StatelessWidget {
  final String text;
  final BadgeType type;

  const StatusBadge({super.key, required this.text, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: AppRadius.all(AppRadius.full),
      ),
      child: Text(
        text,
        style: AppTextStyles.captionBold.copyWith(color: _textColor),
      ),
    );
  }

  Color get _backgroundColor {
    switch (type) {
      case BadgeType.success:
        return AppColors.success;
      case BadgeType.attention:
        return AppColors.attention;
      case BadgeType.warning:
        return AppColors.warning;
      case BadgeType.critical:
        return AppColors.critical;
    }
  }

  Color get _textColor {
    switch (type) {
      case BadgeType.warning:
        return AppColors.inkDeep;
      case BadgeType.success:
      case BadgeType.attention:
      case BadgeType.critical:
        return AppColors.canvas;
    }
  }
}
