class ProjectWorkspaceModel {
  final String? id;
  final String projectId;
  final String freelancerId;
  final String ownerId;
  final String status;
  final DateTime? createdAt;

  const ProjectWorkspaceModel({
    this.id,
    required this.projectId,
    required this.freelancerId,
    required this.ownerId,
    this.status = 'active',
    this.createdAt,
  });

  Map<String, dynamic> toCreateJson() {
    return {
      'project_id': projectId,
      'freelancer_id': freelancerId,
      'owner_id': ownerId,
      'status': status,
    };
  }
}
