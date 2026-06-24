import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class WorkspaceStatusBadge extends StatelessWidget {
  final String status;

  const WorkspaceStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: AppRadius.all(AppRadius.full),
        border: Border.all(color: _color.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 14, color: _color),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            _displayText,
            style: AppTextStyles.captionBold.copyWith(color: _color),
          ),
        ],
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

  IconData get _icon {
    switch (status) {
      case 'active':
        return Icons.sync_rounded;
      case 'submitted':
        return Icons.outbox_rounded;
      case 'completed':
        return Icons.verified_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  Color get _color {
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
}
