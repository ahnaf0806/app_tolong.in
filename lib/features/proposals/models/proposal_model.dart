class ProposalModel {
  final String? id;
  final String projectId;
  final String freelancerId;
  final String message;
  final double price;
  final String estimatedTime;
  final String workMethod;
  final String status;
  final DateTime? createdAt;
  final String? freelancerName;

  const ProposalModel({
    this.id,
    required this.projectId,
    required this.freelancerId,
    required this.message,
    required this.price,
    required this.estimatedTime,
    required this.workMethod,
    this.status = 'pending',
    this.createdAt,
    this.freelancerName,
  });

  factory ProposalModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profiles'];

    String? name;

    if (profile is Map<String, dynamic>) {
      name = profile['name'] as String?;
    }

    return ProposalModel(
      id: json['id'] as String?,
      projectId: json['project_id'] as String,
      freelancerId: json['freelancer_id'] as String,
      message: json['message'] as String,
      price: (json['price'] as num).toDouble(),
      estimatedTime: json['estimated_time'] as String,
      workMethod: json['work_method'] as String,
      status: (json['status'] as String?) ?? 'pending',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      freelancerName: json['freelancer_name'] as String? ?? name,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'project_id': projectId,
      'freelancer_id': freelancerId,
      'message': message,
      'price': price,
      'estimated_time': estimatedTime,
      'work_method': workMethod,
      'status': status,
    };
  }
}
