import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/report_model.dart';

class ReportService {
  SupabaseClient get _client => SupabaseService.client;

  String getCurrentUserId() {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login.');
    }

    return user.id;
  }

  Future<void> createReport(ReportModel report) async {
    await _client.from('reports').insert(report.toCreateJson());
  }

  Future<void> reportProject({
    required String projectId,
    required String projectOwnerId,
    required String reason,
    required String description,
  }) async {
    final reporterId = getCurrentUserId();

    final report = ReportModel(
      reporterId: reporterId,
      reportedUserId: projectOwnerId,
      projectId: projectId,
      reason: reason,
      description: description,
    );

    await createReport(report);
  }
}
