import 'package:app_tolongin/core/widgets/app_empety_state.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/loading_indicator.dart';
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
            physics: const AlwaysScrollableScrollPhysics(),
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
                const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xl),
                  child: Center(child: LoadingIndicator()),
                )
              else if (_controller.errorMessage != null)
                AppErrorState(
                  message: _controller.errorMessage!,
                  onRetry: _loadWorkspaces,
                )
              else if (_controller.workspaces.isEmpty)
                const AppEmptyState(
                  icon: Icons.work_outline_rounded,
                  title: 'Belum Ada Workspace',
                  message:
                      'Workspace akan dibuat otomatis setelah proposal diterima.',
                )
              else
                _buildWorkspaceList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWorkspaceList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _controller.workspaces.length,
      separatorBuilder: (context, index) {
        return const SizedBox(height: AppSpacing.md);
      },
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
