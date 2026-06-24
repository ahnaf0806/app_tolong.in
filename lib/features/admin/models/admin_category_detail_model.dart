import 'admin_project_item_model.dart';

class AdminCategoryDetailModel {
  final String id;
  final String name;
  final String? description;
  final bool isActive;
  final int displayOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<AdminProjectItemModel> projects;

  const AdminCategoryDetailModel({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
    required this.displayOrder,
    this.createdAt,
    this.updatedAt,
    required this.projects,
  });

  int get totalProjects => projects.length;
  int get openProjects => projects.where((e) => e.status == 'open').length;
  int get inProgressProjects =>
      projects.where((e) => e.status == 'in_progress').length;
  int get completedProjects =>
      projects.where((e) => e.status == 'completed').length;
  int get reportedProjects => projects.where((e) => e.reportCount > 0).length;
  String get statusLabel => isActive ? 'Aktif' : 'Nonaktif';
}
