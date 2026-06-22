class WorkspaceModel {
  final String? id;
  final String projectId;
  final String ownerId;
  final String freelancerId;
  final String? proposalId;
  final String projectTitle;
  final String projectDescription;
  final String ownerName;
  final String freelancerName;
  final String status;
  final String? resultFileUrl;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? createdAt;

  const WorkspaceModel({
    this.id,
    required this.projectId,
    required this.ownerId,
    required this.freelancerId,
    this.proposalId,
    required this.projectTitle,
    required this.projectDescription,
    required this.ownerName,
    required this.freelancerName,
    this.status = 'active',
    this.resultFileUrl,
    this.startedAt,
    this.completedAt,
    this.createdAt,
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    final project = json['projects'] as Map<String, dynamic>?;
    final owner = json['owner'] as Map<String, dynamic>?;
    final freelancer = json['freelancer'] as Map<String, dynamic>?;

    return WorkspaceModel(
      id: json['id'] as String?,
      projectId: json['project_id'] as String,
      ownerId: json['owner_id'] as String,
      freelancerId: json['freelancer_id'] as String,
      proposalId: json['proposal_id'] as String?,
      projectTitle: project?['title'] as String? ?? 'Project',
      projectDescription: project?['description'] as String? ?? '',
      ownerName: owner?['name'] as String? ?? 'Project Owner',
      freelancerName: freelancer?['name'] as String? ?? 'Freelancer',
      status: json['status'] as String? ?? 'active',
      resultFileUrl: json['result_file_url'] as String?,
      startedAt: json['started_at'] == null
          ? null
          : DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );
  }

  bool get isActive => status == 'active';
  bool get isSubmitted => status == 'submitted';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
}
