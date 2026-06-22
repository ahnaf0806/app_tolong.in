class OwnerProposalItem {
  final String id;
  final String projectId;
  final String freelancerId;
  final String projectTitle;
  final String freelancerName;
  final String message;
  final double price;
  final String estimatedTime;
  final String workMethod;
  final String status;
  final DateTime createdAt;

  const OwnerProposalItem({
    required this.id,
    required this.projectId,
    required this.freelancerId,
    required this.projectTitle,
    required this.freelancerName,
    required this.message,
    required this.price,
    required this.estimatedTime,
    required this.workMethod,
    required this.status,
    required this.createdAt,
  });

  factory OwnerProposalItem.fromMaps({
    required Map<String, dynamic> proposal,
    required String projectTitle,
    required String freelancerName,
  }) {
    return OwnerProposalItem(
      id: proposal['id'] as String,
      projectId: proposal['project_id'] as String,
      freelancerId: proposal['freelancer_id'] as String,
      projectTitle: projectTitle,
      freelancerName: freelancerName,
      message: proposal['message'] as String,
      price: (proposal['price'] as num).toDouble(),
      estimatedTime: proposal['estimated_time'] as String,
      workMethod: proposal['work_method'] as String,
      status: proposal['status'] as String,
      createdAt: DateTime.parse(proposal['created_at'] as String),
    );
  }

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';
}
