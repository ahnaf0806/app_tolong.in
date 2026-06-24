import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/admin_project_detail_model.dart';
import 'admin_dashboard_service.dart';

class AdminProjectDetailService {
  final AdminDashboardService _adminGuard = AdminDashboardService();

  SupabaseClient get _client => SupabaseService.client;

  Future<AdminProjectDetailModel> getProjectDetail(String projectId) async {
    await _adminGuard.assertAdminAccess();

    final project = await _client
        .from('projects')
        .select(
          'id, owner_id, category_id, title, project_field, description, difficulty, budget, deadline, attachment_url, status, created_at',
        )
        .eq('id', projectId)
        .maybeSingle();

    if (project == null) {
      throw Exception('Project tidak ditemukan.');
    }

    final ownerId = project['owner_id'] as String;

    final owner = await _client
        .from('profiles')
        .select('id, name, email')
        .eq('id', ownerId)
        .maybeSingle();

    final categoryId = project['category_id'] as String?;
    Map<String, dynamic>? category;

    if (categoryId != null) {
      category = await _client
          .from('project_categories')
          .select('id, name')
          .eq('id', categoryId)
          .maybeSingle();
    }

    final proposals = await _client
        .from('proposals')
        .select('id, status')
        .eq('project_id', projectId);

    final reports = await _client
        .from('reports')
        .select('id, status')
        .eq('project_id', projectId);

    final workspace = await _client
        .from('project_workspaces')
        .select('id, status')
        .eq('project_id', projectId)
        .maybeSingle();

    final proposalList = _asList(proposals);
    final reportList = _asList(reports);

    return AdminProjectDetailModel(
      id: project['id'] as String,
      ownerId: ownerId,
      ownerName: owner?['name'] as String? ?? 'Project Owner',
      ownerEmail: owner?['email'] as String? ?? '-',
      title: project['title'] as String? ?? '-',
      categoryName: category?['name'] as String?,
      projectField: project['project_field'] as String? ?? '-',
      description: project['description'] as String? ?? '-',
      difficulty: project['difficulty'] as String? ?? '-',
      budget: (project['budget'] as num?)?.toDouble() ?? 0,
      deadline: _parseDate(project['deadline']),
      status: project['status'] as String? ?? 'open',
      attachmentUrl: project['attachment_url'] as String?,
      createdAt: _parseDate(project['created_at']),
      proposalCount: proposalList.length,
      pendingProposalCount: proposalList
          .where((item) => item['status'] == 'pending')
          .length,
      acceptedProposalCount: proposalList
          .where((item) => item['status'] == 'accepted')
          .length,
      reportCount: reportList.length,
      pendingReportCount: reportList
          .where((item) => item['status'] == 'pending')
          .length,
      workspaceStatus: workspace?['status'] as String?,
    );
  }

  Future<void> updateProjectStatus({
    required String projectId,
    required String status,
  }) async {
    await _adminGuard.assertAdminAccess();

    await _client
        .from('projects')
        .update({'status': status})
        .eq('id', projectId);
  }

  List<Map<String, dynamic>> _asList(dynamic response) {
    return (response as List)
        .map((item) => item as Map<String, dynamic>)
        .toList();
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
