class ReportModel {
  final String? id;
  final String reporterId;
  final String? reportedUserId;
  final String? projectId;
  final String reason;
  final String description;
  final String status;
  final DateTime? createdAt;

  const ReportModel({
    this.id,
    required this.reporterId,
    this.reportedUserId,
    this.projectId,
    required this.reason,
    required this.description,
    this.status = 'pending',
    this.createdAt,
  });

  Map<String, dynamic> toCreateJson() {
    return {
      'reporter_id': reporterId,
      'reported_user_id': reportedUserId,
      'project_id': projectId,
      'reason': reason,
      'description': description,
      'status': status,
    };
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String?,
      reporterId: json['reporter_id'] as String? ?? '',
      reportedUserId: json['reported_user_id'] as String?,
      projectId: json['project_id'] as String?,
      reason: json['reason'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );
  }
}
