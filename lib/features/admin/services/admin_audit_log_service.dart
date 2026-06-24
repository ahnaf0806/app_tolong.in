import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/admin_audit_log_model.dart';

class AdminAuditLogService {
  SupabaseClient get _client => SupabaseService.client;

  Future<void> createLog({
    required String action,
    required String targetTable,
    String? targetId,
    required String description,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client.from('admin_logs').insert({
      'admin_id': user.id,
      'action': action,
      'target_table': targetTable,
      'target_id': targetId,
      'description': description,
    });
  }

  Future<List<AdminAuditLogModel>> getLogs() async {
    final rows = await _client
        .from('admin_logs')
        .select('id, admin_id, action, target_table, target_id, description, created_at')
        .order('created_at', ascending: false)
        .limit(100);

    final list = (rows as List).map((item) {
      return item as Map<String, dynamic>;
    }).toList();

    final adminIds = list
        .map((item) => item['admin_id'] as String?)
        .whereType<String>()
        .toSet()
        .toList();

    final adminMap = <String, String>{};
    if (adminIds.isNotEmpty) {
      final admins = await _client
          .from('profiles')
          .select('id, name')
          .inFilter('id', adminIds);

      for (final item in admins as List) {
        final row = item as Map<String, dynamic>;
        adminMap[row['id'] as String] = row['name'] as String? ?? 'Admin';
      }
    }

    return list.map((item) {
      return AdminAuditLogModel.fromJson(
        item,
        adminName: adminMap[item['admin_id']] ?? 'Admin',
      );
    }).toList();
  }
}
