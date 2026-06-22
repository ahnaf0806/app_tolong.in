class ProjectModel {
  final String? id;
  final String ownerId;
  final String categoryId;
  final String title;
  final String projectField;
  final String description;
  final DateTime deadline;
  final double budget;
  final String difficulty;
  final String? attachmentUrl;
  final String status;

  // Relasi: nama kategori dan nama owner (dari join Supabase)
  final String? categoryName;
  final String? ownerName;

  const ProjectModel({
    this.id,
    required this.ownerId,
    required this.categoryId,
    required this.title,
    required this.projectField,
    required this.description,
    required this.deadline,
    required this.budget,
    required this.difficulty,
    this.attachmentUrl,
    this.status = 'open',
    this.categoryName,
    this.ownerName,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    // Ambil nama kategori dari relasi project_categories
    final categoryMap = json['project_categories'] as Map<String, dynamic>?;
    final categoryName = categoryMap?['name'] as String?;

    // Ambil nama owner dari relasi profiles
    final ownerMap = json['profiles'] as Map<String, dynamic>?;
    final ownerName = ownerMap?['full_name'] as String?;

    return ProjectModel(
      id: json['id'] as String?,
      ownerId: json['owner_id'] as String? ?? '',
      categoryId: json['category_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      projectField: json['project_field'] as String? ?? '',
      description: json['description'] as String? ?? '',
      deadline: DateTime.parse(json['deadline'] as String),
      budget: (json['budget'] as num).toDouble(),
      difficulty: json['difficulty'] as String? ?? 'medium',
      attachmentUrl: json['attachment_url'] as String?,
      status: json['status'] as String? ?? 'open',
      categoryName: categoryName,
      ownerName: ownerName,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'owner_id': ownerId,
      'category_id': categoryId,
      'title': title,
      'project_field': projectField,
      'description': description,
      'deadline': deadline.toIso8601String().split('T').first,
      'budget': budget,
      'difficulty': difficulty,
      'attachment_url': attachmentUrl,
      'status': status,
    };
  }
}
