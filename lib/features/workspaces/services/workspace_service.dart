import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/workspace_model.dart';

class WorkspaceService {
  SupabaseClient get _client => SupabaseService.client;

  String getCurrentUserId() {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login.');
    }

    return user.id;
  }

  Future<List<WorkspaceModel>> getMyWorkspaces() async {
    final userId = getCurrentUserId();

    final response = await _client
        .from('project_workspaces')
        .select(
          'id, project_id, owner_id, freelancer_id, proposal_id, status, result_file_url, started_at, completed_at, created_at, projects!inner(title, description), owner:profiles!owner_id(name), freelancer:profiles!freelancer_id(name)',
        )
        .or('owner_id.eq.$userId,freelancer_id.eq.$userId')
        .order('started_at', ascending: false);

    final workspaces = response as List;

    return workspaces.map((workspace) {
      return WorkspaceModel.fromJson(workspace as Map<String, dynamic>);
    }).toList();
  }

  Future<WorkspaceModel?> getWorkspaceDetail(String workspaceId) async {
    final userId = getCurrentUserId();

    final response = await _client
        .from('project_workspaces')
        .select(
          'id, project_id, owner_id, freelancer_id, proposal_id, status, result_file_url, started_at, completed_at, created_at, projects!inner(title, description), owner:profiles!owner_id(name), freelancer:profiles!freelancer_id(name)',
        )
        .eq('id', workspaceId)
        .or('owner_id.eq.$userId,freelancer_id.eq.$userId')
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return WorkspaceModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> markWorkspaceSubmitted({
    required String workspaceId,
    required String resultFileUrl,
  }) async {
    final userId = getCurrentUserId();

    await _client
        .from('project_workspaces')
        .update({'status': 'submitted', 'result_file_url': resultFileUrl})
        .eq('id', workspaceId)
        .eq('freelancer_id', userId)
        .eq('status', 'active');
  }

  Future<void> markWorkspaceCompleted(String workspaceId) async {
    final userId = getCurrentUserId();

    await _client
        .from('project_workspaces')
        .update({
          'status': 'completed',
          'completed_at': DateTime.now().toIso8601String(),
        })
        .eq('id', workspaceId)
        .eq('owner_id', userId)
        .inFilter('status', ['active', 'submitted']);
  }
}
