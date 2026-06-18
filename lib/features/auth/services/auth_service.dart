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
    required String university,
    required String studyProgram,
    required int semester,
    required String role,
  }) async {
    return _client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        'name': name.trim(),
        'role': role,
        'university': university.trim(),
        'study_program': studyProgram.trim(),
        'semester': semester.toString(),
      },
    );
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
