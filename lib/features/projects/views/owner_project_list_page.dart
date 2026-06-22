import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/owner_project_list_controller.dart';
import '../widgets/project_card.dart';
import 'manage_project_page.dart';

class OwnerProjectListPage extends StatefulWidget {
  const OwnerProjectListPage({super.key});

  @override
  State<OwnerProjectListPage> createState() => _OwnerProjectListPageState();
}

class _OwnerProjectListPageState extends State<OwnerProjectListPage> {
  final OwnerProjectListController _controller = OwnerProjectListController();

  @override
  void initState() {
    super.initState();
    _controller.loadProjects();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openManage(int index) {
    final project = _controller.projects[index];
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ManageProjectPage(project: project),
      ),
    ).then((_) {
      // Reload in case project status changed
      _controller.loadProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.canvas,
          body: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _controller.refresh,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              children: [
                Text('Project Saya', style: AppTextStyles.headingLg),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Kelola project yang kamu buat dan lihat proposal yang masuk.',
                  style: AppTextStyles.bodyMd,
                ),
                const SizedBox(height: AppSpacing.xl),

                if (_controller.isLoading && _controller.projects.isEmpty)
                  const Center(child: CircularProgressIndicator()),

                if (!_controller.isLoading && _controller.errorMessage != null)
                  Center(
                    child: Text(
                      _controller.errorMessage!,
                      style: AppTextStyles.bodySm.copyWith(color: AppColors.critical),
                    ),
                  ),

                if (!_controller.isLoading &&
                    _controller.errorMessage == null &&
                    _controller.projects.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
                    child: Center(
                      child: Text(
                        'Kamu belum membuat project apapun.',
                        style: AppTextStyles.bodyMd,
                      ),
                    ),
                  ),

                if (_controller.projects.isNotEmpty)
                  ...List.generate(
                    _controller.projects.length,
                    (i) => ProjectCard(
                      project: _controller.projects[i],
                      onTap: () => _openManage(i),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
