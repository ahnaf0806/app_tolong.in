import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/admin_project_detail_model.dart';
import 'admin_audit_log_service.dart';
import 'admin_dashboard_service.dart';

class AdminProjectDetailService {
  final AdminDashboardService _adminGuard = AdminDashboardService();
  final AdminAuditLogService _logService = AdminAuditLogService();
  SupabaseClient get _client => SupabaseService.client;

  Future<AdminProjectDetailModel> getProjectDetail(String projectId) async {
    await _adminGuard.assertAdminAccess();

    final project = await _client
        .from('projects')
        .select('id, owner_id, category_id, title, project_field, description, difficulty, budget, deadline, attachment_url, status, created_at')
        .eq('id', projectId)
        .maybeSingle();

    if (project == null) throw Exception('Project tidak ditemukan.');

    final ownerId = project['owner_id'] as String;
    final owner = await _client
        .from('profiles')
        .select('id, name, email')
        .eq('id', ownerId)
        .maybeSingle();

    final category = await _loadCategory(project['category_id'] as String?);
    final proposals = _asList(await _client.from('proposals').select('id, status').eq('project_id', projectId));
    final reports = _asList(await _client.from('reports').select('id, status').eq('project_id', projectId));
    final workspace = await _client
        .from('project_workspaces')
        .select('id, status')
        .eq('project_id', projectId)
        .maybeSingle();

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
      proposalCount: proposals.length,
      pendingProposalCount: proposals.where((item) => item['status'] == 'pending').length,
      acceptedProposalCount: proposals.where((item) => item['status'] == 'accepted').length,
      reportCount: reports.length,
      pendingReportCount: reports.where((item) => item['status'] == 'pending').length,
      workspaceStatus: workspace?['status'] as String?,
    );
  }

  Future<void> updateProjectStatus({required String projectId, required String status}) async {
    await _adminGuard.assertAdminAccess();
    await _client.from('projects').update({'status': status}).eq('id', projectId);
    await _logService.createLog(
      action: 'moderate',
      targetTable: 'projects',
      targetId: projectId,
      description: 'Mengubah status project menjadi $status dari halaman detail',
    );
  }

  Future<Map<String, dynamic>?> _loadCategory(String? categoryId) async {
    if (categoryId == null) return null;
    return _client.from('project_categories').select('id, name').eq('id', categoryId).maybeSingle();
  }

  List<Map<String, dynamic>> _asList(dynamic response) =>
      (response as List).map((item) => item as Map<String, dynamic>).toList();

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
