import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';

class ProfileService {
  SupabaseClient get _client => SupabaseService.client;

  Future<String?> getCurrentUserRole() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      return null;
    }

    final response = await _client
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return response['role'] as String?;
  }
}
