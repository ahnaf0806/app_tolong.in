import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/admin_category_detail_model.dart';
import '../models/admin_project_item_model.dart';
import 'admin_dashboard_service.dart';

class AdminCategoryDetailService {
  final AdminDashboardService _guard = AdminDashboardService();
  SupabaseClient get _client => SupabaseService.client;

  Future<AdminCategoryDetailModel> getCategoryDetail(String categoryId) async {
    await _guard.assertAdminAccess();

    final category = await _client
        .from('project_categories')
        .select('id, name, description, is_active, display_order, created_at, updated_at')
        .eq('id', categoryId)
        .maybeSingle();
    if (category == null) throw Exception('Kategori tidak ditemukan.');

    final projects = await _client
        .from('projects')
        .select('id, owner_id, title, project_field, status, budget, deadline, created_at')
        .eq('category_id', categoryId)
        .order('created_at', ascending: false);

    final projectRows = (projects as List).map((e) => e as Map<String, dynamic>).toList();
    final ownerIds = projectRows.map((e) => e['owner_id'] as String?).whereType<String>().toSet().toList();
    final owners = await _loadOwners(ownerIds);
    final reportCounts = await _loadReportCounts(projectRows.map((e) => e['id'] as String).toList());

    return AdminCategoryDetailModel(
      id: category['id'] as String,
      name: category['name'] as String? ?? '-',
      description: category['description'] as String?,
      isActive: category['is_active'] as bool? ?? true,
      displayOrder: (category['display_order'] as num?)?.toInt() ?? 0,
      createdAt: _parseDate(category['created_at']),
      updatedAt: _parseDate(category['updated_at']),
      projects: projectRows.map((row) {
        final owner = owners[row['owner_id']];
        return AdminProjectItemModel(
          id: row['id'] as String,
          ownerId: row['owner_id'] as String,
          ownerName: owner ?? 'Owner',
          title: row['title'] as String? ?? '-',
          projectField: row['project_field'] as String? ?? '-',
          status: row['status'] as String? ?? 'open',
          budget: (row['budget'] as num?)?.toDouble() ?? 0,
          deadline: _parseDate(row['deadline']),
          createdAt: _parseDate(row['created_at']),
          reportCount: reportCounts[row['id']] ?? 0,
        );
      }).toList(),
    );
  }

  Future<Map<String, String>> _loadOwners(List<String> ids) async {
    if (ids.isEmpty) return {};
    final rows = await _client.from('profiles').select('id, name').inFilter('id', ids);
    return {
      for (final item in rows as List)
        (item as Map<String, dynamic>)['id'] as String: item['name'] as String? ?? 'Owner',
    };
  }

  Future<Map<String, int>> _loadReportCounts(List<String> projectIds) async {
    if (projectIds.isEmpty) return {};
    final rows = await _client.from('reports').select('project_id').inFilter('project_id', projectIds);
    final result = <String, int>{};
    for (final item in rows as List) {
      final id = (item as Map<String, dynamic>)['project_id'] as String?;
      if (id == null) continue;
      result[id] = (result[id] ?? 0) + 1;
    }
    return result;
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
