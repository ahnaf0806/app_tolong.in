import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final Color backgroundColor;
  final bool hasBorder;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.radius = AppRadius.xl,
    this.backgroundColor = AppColors.canvas,
    this.hasBorder = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.all(radius),
        border: hasBorder ? Border.all(color: AppColors.hairlineSoft) : null,
      ),
      child: child,
    );

    if (onTap == null) {
      return card;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.all(radius),
        child: card,
      ),
    );
  }
}
