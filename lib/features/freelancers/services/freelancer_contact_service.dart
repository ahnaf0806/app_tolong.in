import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';

class FreelancerContactWorkspace {
  final String workspaceId;

  const FreelancerContactWorkspace({required this.workspaceId});
}

class FreelancerContactService {
  SupabaseClient get _client => SupabaseService.client;

  String getCurrentUserId() {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login.');
    }

    return user.id;
  }

  Future<FreelancerContactWorkspace?> findWorkspaceForChat({
    required String freelancerId,
  }) async {
    final ownerId = getCurrentUserId();

    final response = await _client
        .from('project_workspaces')
        .select('id, owner_id, freelancer_id, status, created_at')
        .eq('owner_id', ownerId)
        .eq('freelancer_id', freelancerId)
        .neq('status', 'cancelled')
        .order('created_at', ascending: false)
        .limit(1);

    final rows = response as List;

    if (rows.isEmpty) {
      return null;
    }

    final row = rows.first as Map<String, dynamic>;

    return FreelancerContactWorkspace(workspaceId: row['id'] as String);
  }
}
