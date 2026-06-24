import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_error_state.dart';
import '../controllers/admin_project_detail_controller.dart';
import '../widgets/admin_project_detail_header.dart';
import '../widgets/admin_project_detail_info_card.dart';
import '../widgets/admin_project_detail_stats_card.dart';
import '../widgets/admin_project_moderation_card.dart';

class AdminProjectDetailPage extends StatefulWidget {
  final String projectId;
  final String? initialTitle;

  const AdminProjectDetailPage({
    super.key,
    required this.projectId,
    this.initialTitle,
  });

  @override
  State<AdminProjectDetailPage> createState() => _AdminProjectDetailPageState();
}

class _AdminProjectDetailPageState extends State<AdminProjectDetailPage> {
  final AdminProjectDetailController _controller =
      AdminProjectDetailController();

  @override
  void initState() {
    super.initState();
    _controller.loadProject(widget.projectId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await _controller.loadProject(widget.projectId);
  }

  Future<void> _changeStatus(String status) async {
    await _controller.updateProjectStatus(widget.projectId, status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: Text(widget.initialTitle ?? 'Detail Project')),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.isLoading && _controller.project == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.errorMessage != null && _controller.project == null) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: AppErrorState(
                message: _controller.errorMessage!,
                onRetry: _refresh,
              ),
            );
          }

          final project = _controller.project;

          if (project == null) {
            return const SizedBox.shrink();
          }

          return Stack(
            children: [
              RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _refresh,
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  children: [
                    AdminProjectDetailHeader(project: project),
                    const SizedBox(height: AppSpacing.lg),
                    AdminProjectDetailStatsCard(project: project),
                    const SizedBox(height: AppSpacing.lg),
                    AdminProjectDetailInfoCard(project: project),
                    const SizedBox(height: AppSpacing.lg),
                    AdminProjectModerationCard(
                      project: project,
                      onChangeStatus: _changeStatus,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
              if (_controller.isActionLoading)
                const LinearProgressIndicator(minHeight: 2),
            ],
          );
        },
      ),
    );
  }
}
