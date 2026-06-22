import 'package:app_tolongin/features/workspaces/views/workspace_detail_page.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../controllers/workspace_controller.dart';
import '../models/workspace_model.dart';
import '../widgets/workspace_card.dart';

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
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _onRefresh() async {
    await _loadWorkspaces();
  }

  void _navigateToDetail(WorkspaceModel workspace, bool isOwner) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            WorkspaceDetailPage(workspaceId: workspace.id!, isOwner: isOwner),
      ),
    ).then((_) => _loadWorkspaces());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              Text('Workspace', style: AppTextStyles.headingLg),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Pantau project yang sedang dikerjakan.',
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.stone),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (_controller.isLoading)
                const Center(child: LoadingIndicator())
              else if (_controller.errorMessage != null)
                _buildErrorState()
              else if (_controller.workspaces.isEmpty)
                _buildEmptyState()
              else
                _buildWorkspaceList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: AppColors.critical,
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Gagal memuat workspace', style: AppTextStyles.headingSm),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _controller.errorMessage!,
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.stone),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: _loadWorkspaces,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_outline_rounded, size: 64, color: AppColors.stone),
          const SizedBox(height: AppSpacing.md),
          Text('Belum ada workspace', style: AppTextStyles.headingSm),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Workspace akan muncul setelah proposal diterima.',
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.stone),
            textAlign: TextAlign.center,
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
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.md),
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
