import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/premium_gradient_card.dart';
import '../controllers/admin_moderation_controller.dart';
import '../widgets/admin_moderation_card.dart';

class AdminModerationTab extends StatefulWidget {
  const AdminModerationTab({super.key});

  @override
  State<AdminModerationTab> createState() => _AdminModerationTabState();
}

class _AdminModerationTabState extends State<AdminModerationTab> {
  final AdminModerationController _controller = AdminModerationController();

  @override
  void initState() {
    super.initState();
    _controller.loadQueue();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _controller.loadQueue,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              _buildHeader(),
              const SizedBox(height: AppSpacing.lg),
              if (_controller.isLoading && _controller.items.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (_controller.errorMessage != null)
                AppErrorState(
                  message: _controller.errorMessage!,
                  onRetry: _controller.loadQueue,
                )
              else if (_controller.items.isEmpty)
                const AppEmptyState(
                  icon: Icons.verified_user_rounded,
                  title: 'Tidak ada antrean moderasi',
                  message:
                      'Laporan, verifikasi, dan user bermasalah akan muncul di sini.',
                )
              else
                ..._controller.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: AdminModerationCard(item: item),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return PremiumGradientCard(
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.canvas.withValues(alpha: 0.14),
              borderRadius: AppRadius.all(AppRadius.xxl),
            ),
            child: const Icon(
              Icons.fact_check_rounded,
              color: AppColors.canvas,
              size: 30,
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Moderation Queue',
                  style: AppTextStyles.headingSm.copyWith(
                    color: AppColors.canvas,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Antrean laporan, verifikasi, dan akun yang perlu ditinjau admin.',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.canvas.withValues(alpha: 0.82),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
