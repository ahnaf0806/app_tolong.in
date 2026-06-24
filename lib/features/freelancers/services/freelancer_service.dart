import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/freelancer_summary_model.dart';

class FreelancerService {
  SupabaseClient get _client => SupabaseService.client;

  Future<List<FreelancerSummaryModel>> getFreelancers() async {
    final profileRows = await _client
        .from('profiles')
        .select(
          'id, name, email, university, study_program, semester, photo_url, role',
        )
        .eq('role', 'freelancer')
        .order('name', ascending: true);

    final profiles = profileRows as List;

    if (profiles.isEmpty) {
      return [];
    }

    final userIds = profiles
        .map((item) => item['id'] as String)
        .where((id) => id.trim().isNotEmpty)
        .toList();

    final freelancerRows = await _client
        .from('freelancer_profiles')
        .select(
          'user_id, skills, bio, portfolio_url, rating_average, total_projects, verification_status',
        )
        .inFilter('user_id', userIds);

    final freelancerProfiles = freelancerRows as List;

    final freelancerProfileMap = <String, Map<String, dynamic>>{
      for (final item in freelancerProfiles)
        item['user_id'] as String: item as Map<String, dynamic>,
    };

    return profiles.map((item) {
      final profile = item as Map<String, dynamic>;
      final userId = profile['id'] as String;

      return FreelancerSummaryModel.fromMaps(
        profile: profile,
        freelancerProfile: freelancerProfileMap[userId],
      );
    }).toList();
  }
}
