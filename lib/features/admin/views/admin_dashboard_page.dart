import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_error_state.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../models/admin_project_item_model.dart';
import '../models/admin_report_item_model.dart';
import '../models/admin_user_item_model.dart';
import 'admin_categories_tab.dart';
import 'admin_logs_tab.dart';
import 'admin_moderation_tab.dart';
import 'admin_overview_tab.dart';
import 'admin_project_detail_page.dart';
import 'admin_projects_tab.dart';
import 'admin_report_detail_page.dart';
import 'admin_reports_tab.dart';
import 'admin_user_detail_page.dart';
import 'admin_users_tab.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  final AdminDashboardController _controller = AdminDashboardController();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _controller.loadDashboard();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _changeReportStatus(String reportId, String status) async {
    await _controller.updateReportStatus(reportId, status);
    _showActionMessage('Status laporan diperbarui.');
  }

  Future<void> _changeUserStatus(String userId, String status) async {
    await _controller.updateUserStatus(userId, status);
    _showActionMessage('Status akun diperbarui.');
  }

  Future<void> _changeVerification(String userId, String status) async {
    await _controller.updateFreelancerVerification(userId, status);
    _showActionMessage('Status verifikasi freelancer diperbarui.');
  }

  Future<void> _changeProjectStatus(String projectId, String status) async {
    await _controller.updateProjectStatus(projectId, status);
    _showActionMessage('Status project diperbarui.');
  }

  void _openReportDetail(AdminReportItemModel report) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => AdminReportDetailPage(
              report: report,
              onChangeReportStatus: _changeReportStatus,
              onChangeUserStatus: _changeUserStatus,
              onChangeProjectStatus: _changeProjectStatus,
            ),
          ),
        )
        .then((_) => _controller.loadDashboard());
  }

  void _openUserDetail(AdminUserItemModel user) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => AdminUserDetailPage(
              user: user,
              onChangeUserStatus: _changeUserStatus,
              onChangeVerification: _changeVerification,
            ),
          ),
        )
        .then((_) => _controller.loadDashboard());
  }

  void _openProjectDetail(AdminProjectItemModel project) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => AdminProjectDetailPage(
              projectId: project.id,
              initialTitle: project.title,
            ),
          ),
        )
        .then((_) => _controller.loadDashboard());
  }

  void _showActionMessage(String message) {
    if (!mounted) return;
    final error = _controller.errorMessage;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: error == null ? null : AppColors.critical,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        if (_controller.isLoading && _controller.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.errorMessage != null && _controller.data == null) {
          return AppErrorState(
            message: _controller.errorMessage!,
            onRetry: _controller.loadDashboard,
          );
        }

        final stats = _controller.stats;
        if (stats == null) return const SizedBox.shrink();

        return Column(
          children: [
            _buildHeader(),
            if (_controller.isActionLoading) const LinearProgressIndicator(minHeight: 2),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.stone,
              indicatorColor: AppColors.primary,
              labelStyle: AppTextStyles.bodySmBold,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Moderation'),
                Tab(text: 'Reports'),
                Tab(text: 'Users'),
                Tab(text: 'Projects'),
                Tab(text: 'Categories'),
                Tab(text: 'Logs'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: _controller.refresh,
                    child: AdminOverviewTab(stats: stats),
                  ),
                  const AdminModerationTab(),
                  AdminReportsTab(
                    reports: _controller.reports,
                    onChangeStatus: _changeReportStatus,
                    onOpenReport: _openReportDetail,
                  ),
                  AdminUsersTab(
                    users: _controller.users,
                    onChangeUserStatus: _changeUserStatus,
                    onChangeVerification: _changeVerification,
                    onOpenUser: _openUserDetail,
                  ),
                  AdminProjectsTab(
                    projects: _controller.projects,
                    onChangeStatus: _changeProjectStatus,
                    onOpenProject: _openProjectDetail,
                  ),
                  const AdminCategoriesTab(),
                  const AdminLogsTab(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          const Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text('Admin Dashboard', style: AppTextStyles.subtitleLg)),
          IconButton(
            onPressed: _controller.loadDashboard,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
    );
  }
}
