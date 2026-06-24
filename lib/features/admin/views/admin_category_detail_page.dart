import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_error_state.dart';
import '../controllers/admin_category_detail_controller.dart';
import '../widgets/admin_category_detail_header.dart';
import '../widgets/admin_metric_card.dart';
import '../widgets/admin_project_card.dart';

class AdminCategoryDetailPage extends StatefulWidget {
  final String categoryId;
  final String initialName;

  const AdminCategoryDetailPage({
    super.key,
    required this.categoryId,
    required this.initialName,
  });

  @override
  State<AdminCategoryDetailPage> createState() => _AdminCategoryDetailPageState();
}

class _AdminCategoryDetailPageState extends State<AdminCategoryDetailPage> {
  final AdminCategoryDetailController _controller = AdminCategoryDetailController();

  @override
  void initState() {
    super.initState();
    _controller.loadCategory(widget.categoryId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: Text(widget.initialName)),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.isLoading && _controller.category == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_controller.errorMessage != null) {
            return AppErrorState(
              message: _controller.errorMessage!,
              onRetry: () => _controller.loadCategory(widget.categoryId),
            );
          }
          final category = _controller.category;
          if (category == null) return const SizedBox.shrink();

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => _controller.loadCategory(widget.categoryId),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              children: [
                AdminCategoryDetailHeader(category: category),
                const SizedBox(height: AppSpacing.lg),
                _buildMetrics(),
                const SizedBox(height: AppSpacing.lg),
                _buildProjectList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetrics() {
    final c = _controller.category!;
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.25,
      children: [
        AdminMetricCard(title: 'Total Project', value: c.totalProjects.toString(), icon: Icons.folder_rounded, color: AppColors.primary),
        AdminMetricCard(title: 'Terbuka', value: c.openProjects.toString(), icon: Icons.lock_open_rounded, color: AppColors.primary),
        AdminMetricCard(title: 'Selesai', value: c.completedProjects.toString(), icon: Icons.verified_rounded, color: AppColors.success),
        AdminMetricCard(title: 'Dilaporkan', value: c.reportedProjects.toString(), icon: Icons.report_rounded, color: AppColors.critical),
      ],
    );
  }

  Widget _buildProjectList() {
    final projects = _controller.category!.projects;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Project dalam Kategori', style: AppTextStyles.subtitleLg),
          const SizedBox(height: AppSpacing.md),
          if (projects.isEmpty)
            Text('Belum ada project pada kategori ini.', style: AppTextStyles.bodySm)
          else
            ...projects.map(
              (project) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: AdminProjectCard(
                  project: project,
                  onChangeStatus: (_) {},
                ),
              ),
            ),
        ],
      ),
    );
  }
}
