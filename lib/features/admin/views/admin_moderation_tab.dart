import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_error_state.dart';
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
                AppCard(
                  child: Text(
                    'Tidak ada antrean moderasi saat ini.',
                    style: AppTextStyles.bodySm,
                    textAlign: TextAlign.center,
                  ),
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
    return AppCard(
      backgroundColor: AppColors.inkDeep,
      hasBorder: false,
      radius: 32,
      child: Row(
        children: [
          const Icon(Icons.fact_check_rounded, color: AppColors.canvas, size: 38),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Moderation Queue',
                  style: AppTextStyles.headingSm.copyWith(color: AppColors.canvas),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Antrean laporan, verifikasi, dan akun yang perlu ditinjau admin.',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.canvas.withValues(alpha: 0.78),
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
