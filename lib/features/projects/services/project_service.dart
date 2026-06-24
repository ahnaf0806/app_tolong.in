import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/project_category_model.dart';
import '../models/project_model.dart';

class ProjectService {
  SupabaseClient get _client => SupabaseService.client;

  Future<List<ProjectCategoryModel>> getCategories() async {
    final response = await _client
        .from('project_categories')
        .select('id, name, description')
        .eq('is_active', true)
        .order('display_order', ascending: true)
        .order('name', ascending: true);

    return (response as List)
        .map((item) => ProjectCategoryModel.fromJson(item))
        .toList();
  }

  Future<void> createProject(ProjectModel project) async {
    await _client.from('projects').insert(project.toCreateJson());
  }

  /// Mengambil semua project dengan status 'open', diurutkan dari terbaru.
  /// Join ke project_categories untuk nama kategori.
  /// Join profiles dihilangkan karena FK mungkin tidak terdaftar di Supabase schema.
  Future<List<ProjectModel>> getOpenProjects() async {
    final response = await _client
        .from('projects')
        .select(
          'id, owner_id, category_id, title, project_field, description, deadline, budget, difficulty, attachment_url, status, created_at, project_categories(name)',
        )
        .eq('status', 'open')
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => ProjectModel.fromJson(item))
        .toList();
  }

  /// Mengambil daftar project milik owner yang sedang login.
  Future<List<ProjectModel>> getProjectsByOwner(String ownerId) async {
    final response = await _client
        .from('projects')
        .select(
          'id, owner_id, category_id, title, project_field, description, deadline, budget, difficulty, attachment_url, status, created_at, project_categories(name)',
        )
        .eq('owner_id', ownerId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => ProjectModel.fromJson(item))
        .toList();
  }

  String getCurrentUserId() {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login.');
    }

    return user.id;
  }
}
