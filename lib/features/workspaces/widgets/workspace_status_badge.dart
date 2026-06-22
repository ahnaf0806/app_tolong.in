import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';

class WorkspaceStatusBadge extends StatelessWidget {
  final String status;

  const WorkspaceStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: AppRadius.all(AppRadius.full),
      ),
      child: Text(
        _displayText,
        style: AppTextStyles.captionBold.copyWith(color: _textColor),
      ),
    );
  }

  String get _displayText {
    switch (status) {
      case 'active':
        return 'Aktif';
      case 'submitted':
        return 'Menunggu Review';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  Color get _backgroundColor {
    switch (status) {
      case 'active':
        return AppColors.primary;
      case 'submitted':
        return AppColors.attention;
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.critical;
      default:
        return AppColors.stone;
    }
  }

  Color get _textColor {
    switch (status) {
      case 'active':
      case 'submitted':
      case 'completed':
      case 'cancelled':
        return AppColors.canvas;
      default:
        return AppColors.inkDeep;
    }
  }
}
