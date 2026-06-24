import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/admin_moderation_item_model.dart';
import 'admin_dashboard_service.dart';

class AdminModerationService {
  final AdminDashboardService _guard = AdminDashboardService();
  SupabaseClient get _client => SupabaseService.client;

  Future<List<AdminModerationItemModel>> getQueue() async {
    await _guard.assertAdminAccess();

    final reports = await _client
        .from('reports')
        .select('id, reason, description, status, created_at')
        .eq('status', 'pending')
        .order('created_at', ascending: false);

    final freelancers = await _client
        .from('freelancer_profiles')
        .select('user_id, verification_status')
        .eq('verification_status', 'pending');

    final blockedUsers = await _client
        .from('profiles')
        .select('id, name, email, account_status, created_at')
        .eq('account_status', 'warned');

    return [
      ..._reportItems(reports as List),
      ..._freelancerItems(freelancers as List),
      ..._warnedUserItems(blockedUsers as List),
    ];
  }

  List<AdminModerationItemModel> _reportItems(List rows) {
    return rows.map((item) {
      final row = item as Map<String, dynamic>;
      return AdminModerationItemModel(
        id: row['id'] as String,
        type: 'report',
        priority: row['reason'] == 'permintaan_joki_tugas' ? 'high' : 'medium',
        status: row['status'] as String? ?? 'pending',
        title: 'Laporan ${row['reason'] ?? 'pelanggaran'}',
        subtitle: row['description'] as String? ?? '-',
        createdAt: _parseDate(row['created_at']),
      );
    }).toList();
  }

  List<AdminModerationItemModel> _freelancerItems(List rows) {
    return rows.map((item) {
      final row = item as Map<String, dynamic>;
      return AdminModerationItemModel(
        id: row['user_id'] as String,
        type: 'verification',
        priority: 'medium',
        status: row['verification_status'] as String? ?? 'pending',
        title: 'Verifikasi freelancer',
        subtitle: 'Freelancer menunggu peninjauan admin.',
      );
    }).toList();
  }

  List<AdminModerationItemModel> _warnedUserItems(List rows) {
    return rows.map((item) {
      final row = item as Map<String, dynamic>;
      return AdminModerationItemModel(
        id: row['id'] as String,
        type: 'blocked_user',
        priority: 'low',
        status: row['account_status'] as String? ?? 'warned',
        title: row['name'] as String? ?? 'User diperingatkan',
        subtitle: row['email'] as String? ?? '-',
        createdAt: _parseDate(row['created_at']),
      );
    }).toList();
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
