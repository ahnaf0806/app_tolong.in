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
  });

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
