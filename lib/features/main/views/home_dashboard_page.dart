import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_brand_logo.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_gradient_background.dart';
import '../../../core/widgets/premium_glass_card.dart';
import '../../../core/widgets/premium_gradient_card.dart';
import '../../../core/widgets/premium_metric_tile.dart';
import '../../../core/widgets/premium_section_header.dart';
import '../../chat/views/chat_inbox_page.dart';
import '../../freelancers/views/freelancer_directory_page.dart';
import '../../projects/models/project_model.dart';
import '../../projects/services/project_service.dart';
import '../../projects/views/create_project_page.dart';
import '../../projects/views/manage_project_page.dart';
import '../../projects/views/project_detail_page.dart';
import '../../projects/views/project_list_page.dart';
import '../../workspaces/models/workspace_model.dart';
import '../../workspaces/services/workspace_service.dart';
import '../../workspaces/views/workspace_detail_page.dart';

class HomeDashboardPage extends StatefulWidget {
  final String role;

  const HomeDashboardPage({
    super.key,
    required this.role,
  });

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  final ProjectService _projectService = ProjectService();
  final WorkspaceService _workspaceService = WorkspaceService();

  bool _isLoading = true;
  String? _errorMessage;
  List<ProjectModel> _projects = [];
  List<WorkspaceModel> _workspaces = [];

  bool get _isOwner => widget.role == 'project_owner';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = _projectService.getCurrentUserId();
      final results = await Future.wait([
        _isOwner
            ? _projectService.getProjectsByOwner(userId)
            : _projectService.getOpenProjects(),
        _workspaceService.getMyWorkspaces(),
      ]);

      if (!mounted) return;

      setState(() {
        _projects = results[0] as List<ProjectModel>;
        _workspaces = results[1] as List<WorkspaceModel>;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString().replaceAll('Exception:', '').trim();
      });
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: AppGradientBackground(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: AppGradientBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: AppErrorState(
                message: _errorMessage!,
                onRetry: _loadData,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: AppGradientBackground(
        child: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _loadData,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              children: [
                _buildHero(),
                const SizedBox(height: AppSpacing.xl),
                _buildMetrics(),
                const SizedBox(height: AppSpacing.xl),
                _buildQuickActions(),
                const SizedBox(height: AppSpacing.xl),
                _buildProjectSection(),
                const SizedBox(height: AppSpacing.xl),
                _buildWorkspaceSection(),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return PremiumGradientCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBrandLogo(size: 62),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isOwner ? 'Beranda Project Owner' : 'Beranda Freelancer',
                  style: AppTextStyles.headingSm.copyWith(
                    color: AppColors.canvas,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _isOwner
                      ? 'Kelola project, proposal, freelancer, dan chat dari satu tempat.'
                      : 'Temukan project aktif dan pantau workspace yang sedang berjalan.',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.canvas.withValues(alpha: 0.86),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    _HeroBadge(
                      icon: _isOwner ? Icons.folder_copy_rounded : Icons.search_rounded,
                      label: _isOwner ? '${_projects.length} Project' : '${_projects.length} Tersedia',
                    ),
                    _HeroBadge(
                      icon: Icons.workspaces_rounded,
                      label: '${_workspaces.length} Workspace',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetrics() {
    final activeProjects = _projects.where((p) => p.status == 'in_progress').length;
    final completedProjects = _projects.where((p) => p.status == 'completed').length;
    final activeWorkspaces = _workspaces.where((w) => w.status == 'active').length;
    final completedWorkspaces = _workspaces.where((w) => w.status == 'completed').length;

    final items = _isOwner
        ? [
            PremiumMetricTile(
              value: _projects.length.toString(),
              label: 'Total Project',
              caption: 'Owner',
              icon: Icons.folder_copy_rounded,
              color: AppColors.primary,
            ),
            PremiumMetricTile(
              value: activeProjects.toString(),
              label: 'Berjalan',
              caption: 'Aktif',
              icon: Icons.sync_rounded,
              color: AppColors.attention,
            ),
            PremiumMetricTile(
              value: completedProjects.toString(),
              label: 'Selesai',
              caption: 'Done',
              icon: Icons.verified_rounded,
              color: AppColors.success,
            ),
            PremiumMetricTile(
              value: _workspaces.length.toString(),
              label: 'Workspace',
              caption: '$activeWorkspaces aktif',
              icon: Icons.work_rounded,
              color: AppColors.oculusPurple,
            ),
          ]
        : [
            PremiumMetricTile(
              value: _projects.length.toString(),
              label: 'Project Open',
              caption: 'Tersedia',
              icon: Icons.travel_explore_rounded,
              color: AppColors.primary,
            ),
            PremiumMetricTile(
              value: _workspaces.length.toString(),
              label: 'Workspace',
              caption: '$activeWorkspaces aktif',
              icon: Icons.workspaces_rounded,
              color: AppColors.attention,
            ),
            PremiumMetricTile(
              value: completedWorkspaces.toString(),
              label: 'Selesai',
              caption: 'Riwayat',
              icon: Icons.task_alt_rounded,
              color: AppColors.success,
            ),
            PremiumMetricTile(
              value: '4.8',
              label: 'Target Rating',
              caption: 'Kualitas',
              icon: Icons.star_rounded,
              color: AppColors.warning,
            ),
          ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.18,
      ),
      itemBuilder: (_, index) => items[index],
    );
  }

  Widget _buildQuickActions() {
    return PremiumGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PremiumSectionHeader(title: 'Pintasan Cepat'),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _QuickTile(
                  icon: _isOwner ? Icons.add_circle_rounded : Icons.search_rounded,
                  title: _isOwner ? 'Buat Project' : 'Cari Project',
                  subtitle: _isOwner ? 'Mulai kebutuhan baru' : 'Temukan peluang',
                  onTap: () => _openPage(_isOwner ? const CreateProjectPage() : const ProjectListPage()),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _QuickTile(
                  icon: _isOwner ? Icons.groups_rounded : Icons.chat_bubble_rounded,
                  title: _isOwner ? 'Freelancer' : 'Chat',
                  subtitle: _isOwner ? 'Lihat talent' : 'Komunikasi',
                  onTap: () => _openPage(_isOwner ? const FreelancerDirectoryPage() : const ChatInboxPage()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectSection() {
    final visibleProjects = _projects.take(3).toList();

    return PremiumGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PremiumSectionHeader(
            title: _isOwner ? 'Project Terbaru' : 'Project Direkomendasikan',
            actionLabel: 'Lihat semua',
            onAction: () => _openPage(_isOwner ? const CreateProjectPage() : const ProjectListPage()),
          ),
          const SizedBox(height: AppSpacing.md),
          if (visibleProjects.isEmpty)
            AppEmptyState(
              icon: Icons.folder_open_rounded,
              title: _isOwner ? 'Belum ada project' : 'Belum ada project terbuka',
              message: _isOwner
                  ? 'Buat project pertama untuk mulai mencari freelancer.'
                  : 'Coba refresh atau cek kembali nanti.',
            )
          else
            ...visibleProjects.map(_projectMiniTile),
        ],
      ),
    );
  }

  Widget _buildWorkspaceSection() {
    final visibleWorkspaces = _workspaces.take(3).toList();

    return PremiumGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PremiumSectionHeader(title: 'Workspace Aktif'),
          const SizedBox(height: AppSpacing.md),
          if (visibleWorkspaces.isEmpty)
            const AppEmptyState(
              icon: Icons.workspaces_rounded,
              title: 'Belum ada workspace',
              message: 'Workspace akan muncul setelah proposal diterima.',
            )
          else
            ...visibleWorkspaces.map(_workspaceMiniTile),
        ],
      ),
    );
  }

  Widget _projectMiniTile(ProjectModel project) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: _MiniTile(
        icon: Icons.folder_copy_rounded,
        title: project.title,
        subtitle: '${project.categoryName ?? project.projectField} • ${_statusLabel(project.status)}',
        trailing: 'Rp ${project.budget.toStringAsFixed(0)}',
        onTap: project.id == null
            ? null
            : () => _openPage(
                  _isOwner
                      ? ManageProjectPage(project: project)
                      : ProjectDetailPage(project: project),
                ),
      ),
    );
  }

  Widget _workspaceMiniTile(WorkspaceModel workspace) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: _MiniTile(
        icon: Icons.workspaces_rounded,
        title: workspace.projectTitle,
        subtitle: '${_isOwner ? workspace.freelancerName : workspace.ownerName} • ${_statusLabel(workspace.status)}',
        trailing: 'Buka',
        onTap: workspace.id == null
            ? null
            : () => _openPage(WorkspaceDetailPage(workspaceId: workspace.id!, isOwner: _isOwner)),
      ),
    );
  }

  void _openPage(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'open':
        return 'Terbuka';
      case 'in_progress':
      case 'active':
        return 'Aktif';
      case 'submitted':
        return 'Menunggu konfirmasi';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }
}

class _HeroBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.canvas.withValues(alpha: 0.15),
        borderRadius: AppRadius.all(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.canvas),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.captionBold.copyWith(color: AppColors.canvas),
          ),
        ],
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.all(AppRadius.xxl),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.07),
          borderRadius: AppRadius.all(AppRadius.xxl),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(title, style: AppTextStyles.bodySmBold),
            Text(subtitle, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _MiniTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;
  final VoidCallback? onTap;

  const _MiniTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.all(AppRadius.xxl),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.surfaceRaised,
          borderRadius: AppRadius.all(AppRadius.xxl),
          border: Border.all(color: AppColors.hairlineSoft),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.09),
                borderRadius: AppRadius.all(AppRadius.xl),
              ),
              child: Icon(icon, color: AppColors.primary, size: 21),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodySmBold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              trailing,
              style: AppTextStyles.captionBold.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
