import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';

class UserReportService {
  SupabaseClient get _client => SupabaseService.client;

  String getCurrentUserId() {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login.');
    }

    return user.id;
  }

  Future<void> createUserReport({
    required String reportedUserId,
    required String reason,
    required String description,
  }) async {
    final reporterId = getCurrentUserId();

    await _client.from('reports').insert({
      'reporter_id': reporterId,
      'reported_user_id': reportedUserId,
      'project_id': null,
      'reason': reason,
      'description': description.trim(),
      'status': 'pending',
    });
  }
}
