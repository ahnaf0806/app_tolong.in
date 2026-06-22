import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/project_list_controller.dart';
import '../widgets/project_card.dart';
import 'project_detail_page.dart';

/// Halaman utama Cari Project untuk freelancer.
/// Menampilkan daftar project dengan status 'open'.
class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  final ProjectListController _controller = ProjectListController();

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

  void _openDetail(int index) {
    final project = _controller.projects[index];
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProjectDetailPage(project: project),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _controller.refresh,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.xl,
            ),
            children: [
              // Header
              Text('Cari Project', style: AppTextStyles.headingLg),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Temukan project yang sesuai dengan skill kamu.',
                style: AppTextStyles.bodyMd,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Loading state
              if (_controller.isLoading && _controller.projects.isEmpty)
                const _LoadingState(),

              // Error state
              if (!_controller.isLoading && _controller.errorMessage != null)
                _ErrorState(
                  message: _controller.errorMessage!,
                  onRetry: _controller.refresh,
                ),

              // Empty state
              if (!_controller.isLoading &&
                  _controller.errorMessage == null &&
                  _controller.projects.isEmpty)
                const _EmptyState(),

              // Daftar project
              if (_controller.projects.isNotEmpty) ...[
                // Label jumlah project
                Text(
                  '${_controller.projects.length} project tersedia',
                  style: AppTextStyles.bodySm,
                ),
                const SizedBox(height: AppSpacing.md),

                // Project cards
                ...List.generate(
                  _controller.projects.length,
                  (i) => ProjectCard(
                    project: _controller.projects[i],
                    onTap: () => _openDetail(i),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ───────────────────────────────── Sub-widgets ─────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sectionSm),
      child: Column(
        children: [
          Icon(
            Icons.work_outline_rounded,
            size: 64,
            color: AppColors.stone,
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            'Belum ada project tersedia',
            style: AppTextStyles.subtitleMd,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Coba lagi nanti atau tarik layar ke bawah untuk memperbarui.',
            style: AppTextStyles.bodySm,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sectionSm),
      child: Column(
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 64,
            color: AppColors.stone,
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            message,
            style: AppTextStyles.bodySm,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.base),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}
