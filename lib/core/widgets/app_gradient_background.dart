import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppGradientBackground extends StatelessWidget {
  final Widget child;

  const AppGradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF3F7FF),
            Color(0xFFF8FAFD),
            AppColors.canvas,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -80,
            child: _GlowOrb(
              size: 240,
              color: AppColors.primary.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            top: 130,
            left: -60,
            child: _GlowOrb(
              size: 160,
              color: const Color(0xFF6FD3FF).withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            bottom: -70,
            right: -30,
            child: _GlowOrb(
              size: 180,
              color: AppColors.oculusPurple.withValues(alpha: 0.10),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 60,
              spreadRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}
