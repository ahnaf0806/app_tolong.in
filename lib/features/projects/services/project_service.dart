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
        .order('name', ascending: true);

    return (response as List)
        .map((item) => ProjectCategoryModel.fromJson(item))
        .toList();
  }

  Future<void> createProject(ProjectModel project) async {
    await _client.from('projects').insert(project.toCreateJson());
  }

  String getCurrentUserId() {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login.');
    }

    return user.id;
  }
}
