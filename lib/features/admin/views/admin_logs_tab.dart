import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/premium_gradient_card.dart';
import '../controllers/admin_logs_controller.dart';
import '../widgets/admin_log_card.dart';

class AdminLogsTab extends StatefulWidget {
  const AdminLogsTab({super.key});

  @override
  State<AdminLogsTab> createState() => _AdminLogsTabState();
}

class _AdminLogsTabState extends State<AdminLogsTab> {
  final AdminLogsController _controller = AdminLogsController();

  @override
  void initState() {
    super.initState();
    _controller.loadLogs();
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
          onRefresh: _controller.loadLogs,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              _buildHeader(),
              const SizedBox(height: AppSpacing.lg),
              if (_controller.isLoading && _controller.logs.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (_controller.errorMessage != null)
                AppErrorState(
                  message: _controller.errorMessage!,
                  onRetry: _controller.loadLogs,
                )
              else if (_controller.logs.isEmpty)
                const AppEmptyState(
                  icon: Icons.history_rounded,
                  title: 'Belum ada aktivitas admin',
                  message:
                      'Aksi moderasi dan perubahan data akan tercatat di sini.',
                )
              else
                ..._controller.logs.map(
                  (log) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: AdminLogCard(log: log),
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
              Icons.history_rounded,
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
                  'Admin Audit Log',
                  style: AppTextStyles.headingSm.copyWith(
                    color: AppColors.canvas,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Riwayat tindakan admin untuk transparansi moderasi.',
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
