import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/premium_gradient_card.dart';
import '../controllers/workspace_controller.dart';
import '../models/workspace_model.dart';
import '../widgets/workspace_card.dart';
import 'workspace_detail_page.dart';

class WorkspaceListPage extends StatefulWidget {
  const WorkspaceListPage({super.key});

  @override
  State<WorkspaceListPage> createState() => _WorkspaceListPageState();
}

class _WorkspaceListPageState extends State<WorkspaceListPage> {
  final WorkspaceController _controller = WorkspaceController();

  @override
  void initState() {
    super.initState();
    _loadWorkspaces();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadWorkspaces() async {
    await _controller.loadWorkspaces();
    if (mounted) setState(() {});
  }

  void _navigateToDetail(WorkspaceModel workspace, bool isOwner) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkspaceDetailPage(
          workspaceId: workspace.id!,
          isOwner: isOwner,
        ),
      ),
    ).then((_) => _loadWorkspaces());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _loadWorkspaces,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              _buildHeader(),
              const SizedBox(height: AppSpacing.xl),
              if (_controller.isLoading && _controller.workspaces.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (_controller.errorMessage != null)
                AppErrorState(
                  message: _controller.errorMessage!,
                  onRetry: _loadWorkspaces,
                )
              else if (_controller.workspaces.isEmpty)
                const AppEmptyState(
                  icon: Icons.work_outline_rounded,
                  title: 'Belum ada workspace',
                  message:
                      'Workspace akan dibuat otomatis setelah proposal diterima.',
                )
              else
                _buildWorkspaceList(),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    final activeCount = _controller.workspaces
        .where((workspace) => workspace.status == 'active')
        .length;
    final completedCount = _controller.workspaces
        .where((workspace) => workspace.status == 'completed')
        .length;

    return PremiumGradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.canvas.withValues(alpha: 0.14),
                  borderRadius: AppRadius.all(AppRadius.xxl),
                ),
                child: const Icon(
                  Icons.workspaces_rounded,
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
                      'Workspace',
                      style: AppTextStyles.headingSm.copyWith(
                        color: AppColors.canvas,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Pantau project, hasil kerja, chat, dan penyelesaian.',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.canvas.withValues(alpha: 0.84),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _MiniStat(label: 'Total', value: '${_controller.workspaces.length}'),
              const SizedBox(width: AppSpacing.sm),
              _MiniStat(label: 'Aktif', value: '$activeCount'),
              const SizedBox(width: AppSpacing.sm),
              _MiniStat(label: 'Selesai', value: '$completedCount'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspaceList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _controller.workspaces.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final workspace = _controller.workspaces[index];
        final userId = _controller.getCurrentUserId();
        final isOwner = workspace.ownerId == userId;

        return WorkspaceCard(
          workspace: workspace,
          isOwner: isOwner,
          onTap: () => _navigateToDetail(workspace, isOwner),
        );
      },
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.canvas.withValues(alpha: 0.14),
          borderRadius: AppRadius.all(AppRadius.xl),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTextStyles.subtitleLg.copyWith(color: AppColors.canvas),
            ),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.canvas.withValues(alpha: 0.80),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
