import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/review_model.dart';

class ReviewService {
  SupabaseClient get _client => SupabaseService.client;

  String getCurrentUserId() {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login.');
    }

    return user.id;
  }

  Future<bool> hasReviewedWorkspace(String workspaceId) async {
    final reviewerId = getCurrentUserId();

    final response = await _client
        .from('reviews')
        .select('id')
        .eq('workspace_id', workspaceId)
        .eq('reviewer_id', reviewerId)
        .maybeSingle();

    return response != null;
  }

  Future<void> createReview(ReviewModel review) async {
    await _client.from('reviews').insert(review.toCreateJson());

    try {
      await _client.rpc(
        'refresh_freelancer_rating',
        params: {'target_freelancer_id': review.freelancerId},
      );
    } catch (_) {
      // Review tetap berhasil meskipun refresh rating gagal.
    }
  }
}
