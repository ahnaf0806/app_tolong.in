class ProjectCategoryModel {
  final String id;
  final String name;
  final String? description;

  const ProjectCategoryModel({
    required this.id,
    required this.name,
    this.description,
  });

  factory ProjectCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProjectCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }
}
