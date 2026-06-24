import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/admin_category_item_model.dart';
import 'admin_audit_log_service.dart';
import 'admin_dashboard_service.dart';

class AdminCategoryService {
  final AdminDashboardService _adminGuard = AdminDashboardService();
  final AdminAuditLogService _logService = AdminAuditLogService();
  SupabaseClient get _client => SupabaseService.client;

  Future<List<AdminCategoryItemModel>> getCategories() async {
    await _adminGuard.assertAdminAccess();

    final categoryRows = await _client
        .from('project_categories')
        .select('id, name, description, is_active, display_order, created_at, updated_at')
        .order('display_order', ascending: true)
        .order('name', ascending: true);

    final projectRows = await _client.from('projects').select('id, category_id');
    final countMap = <String, int>{};

    for (final item in projectRows as List) {
      final project = item as Map<String, dynamic>;
      final categoryId = project['category_id'] as String?;
      if (categoryId == null) continue;
      countMap[categoryId] = (countMap[categoryId] ?? 0) + 1;
    }

    return (categoryRows as List).map((item) {
      final category = item as Map<String, dynamic>;
      return AdminCategoryItemModel.fromJson(
        category,
        projectCount: countMap[category['id']] ?? 0,
      );
    }).toList();
  }

  Future<void> createCategory({
    required String name,
    required String description,
    required int displayOrder,
    required bool isActive,
  }) async {
    await _adminGuard.assertAdminAccess();
    final rows = await _client
        .from('project_categories')
        .insert({
          'name': name.trim(),
          'description': description.trim().isEmpty ? null : description.trim(),
          'display_order': displayOrder,
          'is_active': isActive,
        })
        .select('id')
        .single();
    await _logService.createLog(
      action: 'create',
      targetTable: 'project_categories',
      targetId: rows['id'] as String?,
      description: 'Menambah kategori project $name',
    );
  }

  Future<void> updateCategory({
    required String id,
    required String name,
    required String description,
    required int displayOrder,
    required bool isActive,
  }) async {
    await _adminGuard.assertAdminAccess();
    await _client.from('project_categories').update({
      'name': name.trim(),
      'description': description.trim().isEmpty ? null : description.trim(),
      'display_order': displayOrder,
      'is_active': isActive,
    }).eq('id', id);
    await _logService.createLog(
      action: 'update',
      targetTable: 'project_categories',
      targetId: id,
      description: 'Mengubah kategori project $name',
    );
  }

  Future<void> setCategoryActive({required String id, required bool isActive}) async {
    await _adminGuard.assertAdminAccess();
    await _client.from('project_categories').update({'is_active': isActive}).eq('id', id);
    await _logService.createLog(
      action: 'update',
      targetTable: 'project_categories',
      targetId: id,
      description: isActive ? 'Mengaktifkan kategori' : 'Menonaktifkan kategori',
    );
  }

  Future<void> deleteCategory({required AdminCategoryItemModel category}) async {
    await _adminGuard.assertAdminAccess();
    if (!category.canDelete) {
      throw Exception('Kategori tidak bisa dihapus karena sudah dipakai ${category.projectCount} project.');
    }
    await _client.from('project_categories').delete().eq('id', category.id);
    await _logService.createLog(
      action: 'delete',
      targetTable: 'project_categories',
      targetId: category.id,
      description: 'Menghapus kategori ${category.name}',
    );
  }
}
