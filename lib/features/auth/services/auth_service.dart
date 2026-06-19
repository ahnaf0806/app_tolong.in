import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';

class AuthService {
  SupabaseClient get _client => SupabaseService.client;

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    String? university,
    String? studyProgram,
    int? semester,
    required String role,
  }) async {
    final metadata = <String, dynamic>{'name': name.trim(), 'role': role};

    if (role == 'freelancer') {
      metadata.addAll({
        'university': university?.trim(),
        'study_program': studyProgram?.trim(),
        'semester': semester?.toString(),
      });
    }

    return _client.auth.signUp(
      email: email.trim(),
      password: password,
      data: metadata,
    );
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
