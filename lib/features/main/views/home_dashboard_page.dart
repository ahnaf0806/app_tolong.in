import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';
import '../../projects/models/project_model.dart';
import '../../projects/services/project_service.dart';
import '../../projects/views/create_project_page.dart';
import '../../projects/views/manage_project_page.dart';
import '../../projects/views/project_detail_page.dart';
import '../../projects/views/project_list_page.dart';
import '../../projects/widgets/project_card.dart';
import '../../workspaces/models/workspace_model.dart';
import '../../workspaces/services/workspace_service.dart';
import '../../workspaces/views/workspace_detail_page.dart';
import '../../workspaces/widgets/workspace_card.dart';

class HomeDashboardPage extends StatefulWidget {
  final String role;

  const HomeDashboardPage({super.key, required this.role});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  final ProjectService _projectService = ProjectService();
  final WorkspaceService _workspaceService = WorkspaceService();

  bool _isLoading = true;
  String? _errorMessage;
  String? _currentUserId;

  List<ProjectModel> _projects = [];
  List<WorkspaceModel> _workspaces = [];

  bool get _isOwner => widget.role == 'project_owner';

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final currentUserId = _projectService.getCurrentUserId();

      final projects = _isOwner
          ? await _projectService.getProjectsByOwner(currentUserId)
          : await _projectService.getOpenProjects();

      final workspaces = await _workspaceService.getMyWorkspaces();

      if (!mounted) return;

      setState(() {
        _currentUserId = currentUserId;
        _projects = projects;
        _workspaces = workspaces;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  void _goToCreateProject() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const CreateProjectPage()))
        .then((_) => _loadDashboard());
  }

  void _goToProjectList() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const ProjectListPage()))
        .then((_) => _loadDashboard());
  }

  void _openProject(ProjectModel project) {
    if (_isOwner) {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (_) => ManageProjectPage(project: project),
            ),
          )
          .then((_) => _loadDashboard());
      return;
    }

    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => ProjectDetailPage(project: project),
          ),
        )
        .then((_) => _loadDashboard());
  }

  void _openWorkspace(WorkspaceModel workspace) {
    final isOwner = workspace.ownerId == _currentUserId;

    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => WorkspaceDetailPage(
              workspaceId: workspace.id!,
              isOwner: isOwner,
            ),
          ),
        )
        .then((_) => _loadDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _loadDashboard,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            _buildHeroCard(),
            const SizedBox(height: AppSpacing.xl),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_errorMessage != null)
              _buildErrorState()
            else ...[
              _buildStatsGrid(),
              const SizedBox(height: AppSpacing.xl),
              _buildQuickActions(),
              const SizedBox(height: AppSpacing.xl),
              _buildProjectSection(),
              const SizedBox(height: AppSpacing.xl),
              _buildWorkspaceSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.inkDeep,
        borderRadius: AppRadius.all(AppRadius.xxxl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _isOwner ? Icons.add_business_rounded : Icons.school_rounded,
            color: AppColors.canvas,
            size: 36,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            _isOwner
                ? 'Kelola project dengan lebih rapi'
                : 'Bangun portofolio dari project nyata',
            style: AppTextStyles.headingSm.copyWith(color: AppColors.canvas),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _isOwner
                ? 'Buat project, terima proposal mahasiswa, diskusi, dan pantau progress pekerjaan dalam satu alur.'
                : 'Cari project sesuai skill, ajukan proposal, kerjakan secara profesional, lalu kumpulkan rating.',
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.canvas.withValues(alpha: 0.82),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return AppCard(
      backgroundColor: AppColors.critical.withValues(alpha: 0.06),
      hasBorder: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard belum bisa dimuat',
            style: AppTextStyles.bodyMdBold.copyWith(color: AppColors.critical),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _errorMessage ?? 'Terjadi kesalahan.',
            style: AppTextStyles.bodySm,
          ),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            text: 'Coba Lagi',
            icon: Icons.refresh_rounded,
            onPressed: _loadDashboard,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final activeWorkspaces = _workspaces
        .where(
          (item) => item.status != 'completed' && item.status != 'cancelled',
        )
        .length;

    final completedWorkspaces = _workspaces
        .where((item) => item.status == 'completed')
        .length;

    final openProjects = _projects
        .where((item) => item.status == 'open')
        .length;
    final progressProjects = _projects
        .where((item) => item.status == 'in_progress')
        .length;
    final completedProjects = _projects
        .where((item) => item.status == 'completed')
        .length;

    final items = _isOwner
        ? [
            _StatItem(
              title: 'Project Saya',
              value: _projects.length.toString(),
              icon: Icons.folder_copy_outlined,
              color: AppColors.primary,
            ),
            _StatItem(
              title: 'Terbuka',
              value: openProjects.toString(),
              icon: Icons.lock_open_rounded,
              color: AppColors.success,
            ),
            _StatItem(
              title: 'Berjalan',
              value: progressProjects.toString(),
              icon: Icons.sync_rounded,
              color: AppColors.attention,
            ),
            _StatItem(
              title: 'Selesai',
              value: completedProjects.toString(),
              icon: Icons.verified_rounded,
              color: AppColors.success,
            ),
          ]
        : [
            _StatItem(
              title: 'Project Terbuka',
              value: _projects.length.toString(),
              icon: Icons.search_rounded,
              color: AppColors.primary,
            ),
            _StatItem(
              title: 'Workspace Aktif',
              value: activeWorkspaces.toString(),
              icon: Icons.work_outline_rounded,
              color: AppColors.attention,
            ),
            _StatItem(
              title: 'Selesai',
              value: completedWorkspaces.toString(),
              icon: Icons.verified_rounded,
              color: AppColors.success,
            ),
            _StatItem(
              title: 'Portofolio',
              value: completedWorkspaces.toString(),
              icon: Icons.badge_outlined,
              color: AppColors.oculusPurple,
            ),
          ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 640 ? 4 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, index) {
            return _StatCard(item: items[index]);
          },
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Aksi Cepat', style: AppTextStyles.subtitleLg),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _isOwner
                ? 'Mulai project baru atau lanjutkan memantau proposal dan workspace.'
                : 'Temukan project yang sesuai dengan skill dan minatmu.',
            style: AppTextStyles.bodySm,
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            text: _isOwner ? 'Buat Project Baru' : 'Cari Project',
            icon: _isOwner ? Icons.add_circle_rounded : Icons.search_rounded,
            variant: PrimaryButtonVariant.cobalt,
            onPressed: _isOwner ? _goToCreateProject : _goToProjectList,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectSection() {
    final latestProjects = _projects.take(3).toList();

    return _SectionBlock(
      title: _isOwner ? 'Project Terbaru Saya' : 'Project Terbaru',
      subtitle: _isOwner
          ? 'Pantau project yang sudah kamu buat.'
          : 'Project terbuka yang bisa kamu ajukan proposal.',
      emptyText: _isOwner
          ? 'Kamu belum membuat project.'
          : 'Belum ada project terbuka saat ini.',
      isEmpty: latestProjects.isEmpty,
      child: Column(
        children: latestProjects
            .map(
              (project) => ProjectCard(
                project: project,
                onTap: () => _openProject(project),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildWorkspaceSection() {
    final latestWorkspaces = _workspaces.take(2).toList();

    return _SectionBlock(
      title: 'Workspace Terbaru',
      subtitle: 'Project yang sudah masuk tahap pengerjaan.',
      emptyText: 'Belum ada workspace aktif.',
      isEmpty: latestWorkspaces.isEmpty,
      child: Column(
        children: latestWorkspaces
            .map(
              (workspace) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: WorkspaceCard(
                  workspace: workspace,
                  isOwner: workspace.ownerId == _currentUserId,
                  onTap: () => _openWorkspace(workspace),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emptyText;
  final bool isEmpty;
  final Widget child;

  const _SectionBlock({
    required this.title,
    required this.subtitle,
    required this.emptyText,
    required this.isEmpty,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.subtitleLg),
          const SizedBox(height: AppSpacing.xs),
          Text(subtitle, style: AppTextStyles.bodySm),
          const SizedBox(height: AppSpacing.lg),
          if (isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: AppRadius.all(AppRadius.xl),
              ),
              child: Text(
                emptyText,
                style: AppTextStyles.bodySm,
                textAlign: TextAlign.center,
              ),
            )
          else
            child,
        ],
      ),
    );
  }
}

class _StatItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _StatCard extends StatelessWidget {
  final _StatItem item;

  const _StatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.base),
      backgroundColor: item.color.withValues(alpha: 0.08),
      hasBorder: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, color: item.color, size: 24),
          const Spacer(),
          Text(
            item.value,
            style: AppTextStyles.headingSm.copyWith(color: item.color),
          ),
          const SizedBox(height: 2),
          Text(
            item.title,
            style: AppTextStyles.caption.copyWith(color: AppColors.charcoal),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
