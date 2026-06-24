import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/admin_dashboard_data.dart';
import '../models/admin_project_item_model.dart';
import '../models/admin_report_item_model.dart';
import '../models/admin_stats_model.dart';
import '../models/admin_user_item_model.dart';
import 'admin_audit_log_service.dart';

class AdminDashboardService {
  final AdminAuditLogService _logService = AdminAuditLogService();
  SupabaseClient get _client => SupabaseService.client;

  Future<void> assertAdminAccess() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User belum login.');

    final profile = await _client
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .maybeSingle();

    if (profile == null || profile['role'] != 'admin') {
      throw Exception('Akses ditolak. Akun ini bukan admin.');
    }
  }

  Future<AdminDashboardData> getDashboardData() async {
    await assertAdminAccess();

    final profiles = _asList(await _client.from('profiles').select(
          'id, name, email, role, university, study_program, account_status, created_at',
        ));
    final freelancerProfiles = _asList(await _client.from('freelancer_profiles').select(
          'user_id, verification_status, rating_average, total_projects',
        ));
    final projects = _asList(await _client.from('projects').select(
          'id, owner_id, title, project_field, status, budget, deadline, created_at',
        ));
    final proposals = _asList(await _client.from('proposals').select('id, project_id'));
    final workspaces = _asList(await _client.from('project_workspaces').select('id, status'));
    final reports = _asList(await _client.from('reports').select(
          'id, reporter_id, reported_user_id, project_id, reason, description, status, created_at',
        ));
    final reviews = _asList(await _client.from('reviews').select('rating'));

    final profileMap = {for (final item in profiles) item['id'] as String: item};
    final freelancerMap = {for (final item in freelancerProfiles) item['user_id'] as String: item};
    final projectMap = {for (final item in projects) item['id'] as String: item};
    final proposalCounts = _countByKey(proposals, 'project_id');
    final reportCounts = _countByKey(reports, 'project_id');

    return AdminDashboardData(
      stats: _buildStats(
        profiles: profiles,
        projects: projects,
        workspaces: workspaces,
        reports: reports,
        reviews: reviews,
      ),
      users: _buildUsers(profiles, freelancerMap),
      reports: _buildReports(reports, profileMap, projectMap),
      projects: _buildProjects(projects, profileMap, proposalCounts, reportCounts),
    );
  }

  Future<void> updateReportStatus({
    required String reportId,
    required String status,
  }) async {
    await assertAdminAccess();
    await _client.from('reports').update({'status': status}).eq('id', reportId);
    await _logService.createLog(
      action: 'moderate',
      targetTable: 'reports',
      targetId: reportId,
      description: 'Mengubah status laporan menjadi $status',
    );
  }

  Future<void> updateUserStatus({
    required String userId,
    required String accountStatus,
  }) async {
    await assertAdminAccess();
    await _client.from('profiles').update({'account_status': accountStatus}).eq('id', userId);
    await _logService.createLog(
      action: 'moderate',
      targetTable: 'profiles',
      targetId: userId,
      description: 'Mengubah status akun menjadi $accountStatus',
    );
  }

  Future<void> updateFreelancerVerification({
    required String userId,
    required String verificationStatus,
  }) async {
    await assertAdminAccess();
    await _client.from('freelancer_profiles').update({
      'verification_status': verificationStatus,
    }).eq('user_id', userId);
    await _logService.createLog(
      action: 'moderate',
      targetTable: 'freelancer_profiles',
      targetId: userId,
      description: 'Mengubah verifikasi freelancer menjadi $verificationStatus',
    );
  }

  Future<void> updateProjectStatus({
    required String projectId,
    required String status,
  }) async {
    await assertAdminAccess();
    await _client.from('projects').update({'status': status}).eq('id', projectId);
    await _logService.createLog(
      action: 'moderate',
      targetTable: 'projects',
      targetId: projectId,
      description: 'Mengubah status project menjadi $status',
    );
  }

  List<Map<String, dynamic>> _asList(dynamic response) =>
      (response as List).map((item) => item as Map<String, dynamic>).toList();

  Map<String, int> _countByKey(List<Map<String, dynamic>> rows, String key) {
    final result = <String, int>{};
    for (final row in rows) {
      final id = row[key] as String?;
      if (id == null) continue;
      result[id] = (result[id] ?? 0) + 1;
    }
    return result;
  }

  List<AdminUserItemModel> _buildUsers(
    List<Map<String, dynamic>> profiles,
    Map<String, Map<String, dynamic>> freelancerMap,
  ) {
    return profiles.map((item) {
      final freelancer = freelancerMap[item['id']];
      return AdminUserItemModel(
        id: item['id'] as String,
        name: item['name'] as String? ?? 'Pengguna',
        email: item['email'] as String? ?? '-',
        role: item['role'] as String? ?? 'freelancer',
        accountStatus: item['account_status'] as String? ?? 'active',
        university: item['university'] as String?,
        studyProgram: item['study_program'] as String?,
        createdAt: _parseDate(item['created_at']),
        verificationStatus: freelancer?['verification_status'] as String?,
        ratingAverage: (freelancer?['rating_average'] as num?)?.toDouble() ?? 0,
        totalProjects: (freelancer?['total_projects'] as num?)?.toInt() ?? 0,
      );
    }).toList();
  }

  List<AdminReportItemModel> _buildReports(
    List<Map<String, dynamic>> reports,
    Map<String, Map<String, dynamic>> profiles,
    Map<String, Map<String, dynamic>> projects,
  ) {
    final items = reports.map((item) {
      final reporter = profiles[item['reporter_id']];
      final reported = profiles[item['reported_user_id']];
      final project = projects[item['project_id']];
      return AdminReportItemModel(
        id: item['id'] as String,
        reporterId: item['reporter_id'] as String,
        reportedUserId: item['reported_user_id'] as String?,
        projectId: item['project_id'] as String?,
        reason: item['reason'] as String? ?? 'lainnya',
        description: item['description'] as String? ?? '-',
        status: item['status'] as String? ?? 'pending',
        createdAt: _parseDate(item['created_at']),
        reporterName: reporter?['name'] as String? ?? 'Pelapor',
        reporterEmail: reporter?['email'] as String? ?? '-',
        reportedUserName: reported?['name'] as String? ?? '-',
        reportedUserEmail: reported?['email'] as String? ?? '-',
        projectTitle: project?['title'] as String? ?? '-',
      );
    }).toList();
    items.sort((a, b) => (b.createdAt ?? DateTime(2000)).compareTo(a.createdAt ?? DateTime(2000)));
    return items;
  }

  List<AdminProjectItemModel> _buildProjects(
    List<Map<String, dynamic>> projects,
    Map<String, Map<String, dynamic>> profiles,
    Map<String, int> proposalCounts,
    Map<String, int> reportCounts,
  ) {
    return projects.map((item) {
      final owner = profiles[item['owner_id']];
      return AdminProjectItemModel(
        id: item['id'] as String,
        ownerId: item['owner_id'] as String,
        ownerName: owner?['name'] as String? ?? 'Owner',
        title: item['title'] as String? ?? '-',
        projectField: item['project_field'] as String? ?? '-',
        status: item['status'] as String? ?? 'open',
        budget: (item['budget'] as num?)?.toDouble() ?? 0,
        deadline: _parseDate(item['deadline']),
        createdAt: _parseDate(item['created_at']),
        proposalCount: proposalCounts[item['id']] ?? 0,
        reportCount: reportCounts[item['id']] ?? 0,
      );
    }).toList();
  }

  AdminStatsModel _buildStats({
    required List<Map<String, dynamic>> profiles,
    required List<Map<String, dynamic>> projects,
    required List<Map<String, dynamic>> workspaces,
    required List<Map<String, dynamic>> reports,
    required List<Map<String, dynamic>> reviews,
  }) {
    final totalRating = reviews.fold<double>(
      0,
      (sum, item) => sum + ((item['rating'] as num?)?.toDouble() ?? 0),
    );
    return AdminStatsModel(
      totalUsers: profiles.length,
      totalOwners: profiles.where((e) => e['role'] == 'project_owner').length,
      totalFreelancers: profiles.where((e) => e['role'] == 'freelancer').length,
      totalAdmins: profiles.where((e) => e['role'] == 'admin').length,
      blockedUsers: profiles.where((e) => e['account_status'] == 'blocked').length,
      totalProjects: projects.length,
      openProjects: projects.where((e) => e['status'] == 'open').length,
      inProgressProjects: projects.where((e) => e['status'] == 'in_progress').length,
      completedProjects: projects.where((e) => e['status'] == 'completed').length,
      cancelledProjects: projects.where((e) => e['status'] == 'cancelled').length,
      totalWorkspaces: workspaces.length,
      activeWorkspaces: workspaces.where((e) => e['status'] == 'active').length,
      completedWorkspaces: workspaces.where((e) => e['status'] == 'completed').length,
      totalReports: reports.length,
      pendingReports: reports.where((e) => e['status'] == 'pending').length,
      reviewedReports: reports.where((e) => e['status'] == 'reviewed').length,
      resolvedReports: reports.where((e) => e['status'] == 'resolved').length,
      totalReviews: reviews.length,
      averageRating: reviews.isEmpty ? 0 : totalRating / reviews.length,
    );
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
