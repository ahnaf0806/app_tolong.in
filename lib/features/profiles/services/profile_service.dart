import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/profile_model.dart';

class ProfileService {
  SupabaseClient get _client => SupabaseService.client;

  String getCurrentUserId() {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login.');
    }

    return user.id;
  }

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

  Future<ProfileModel?> getCurrentProfile() async {
    final userId = getCurrentUserId();

    final profile = await _client
        .from('profiles')
        .select(
          'id, name, email, role, university, study_program, semester, photo_url',
        )
        .eq('id', userId)
        .maybeSingle();

    if (profile == null) {
      return null;
    }

    Map<String, dynamic>? freelancerProfile;

    if (profile['role'] == 'freelancer') {
      freelancerProfile = await _client
          .from('freelancer_profiles')
          .select(
            'skills, bio, portfolio_url, rating_average, total_projects, verification_status',
          )
          .eq('user_id', userId)
          .maybeSingle();
    }

    return ProfileModel.fromMaps(
      profile: profile,
      freelancerProfile: freelancerProfile,
    );
  }

  Future<void> updateProfile({
    required String name,
    String? university,
    String? studyProgram,
    int? semester,
    String? bio,
    List<String>? skills,
    String? portfolioUrl,
    required bool isFreelancer,
  }) async {
    final userId = getCurrentUserId();

    await _client
        .from('profiles')
        .update({
          'name': name.trim(),
          'university': university?.trim(),
          'study_program': studyProgram?.trim(),
          'semester': semester,
        })
        .eq('id', userId);

    if (isFreelancer) {
      await _client
          .from('freelancer_profiles')
          .update({
            'bio': bio?.trim(),
            'skills': skills ?? [],
            'portfolio_url': portfolioUrl?.trim(),
          })
          .eq('user_id', userId);
    }
  }

  Future<String> uploadProfilePhoto(String filePath) async {
    final userId = getCurrentUserId();

    final file = File(filePath);
    final extension = filePath.split('.').last;
    final storagePath =
        '$userId/profile_${DateTime.now().millisecondsSinceEpoch}.$extension';

    await _client.storage
        .from('profile-photos')
        .upload(
          storagePath,
          file,
          fileOptions: const FileOptions(upsert: true),
        );

    final publicUrl = _client.storage
        .from('profile-photos')
        .getPublicUrl(storagePath);

    await _client
        .from('profiles')
        .update({'photo_url': publicUrl})
        .eq('id', userId);

    return publicUrl;
  }
}
