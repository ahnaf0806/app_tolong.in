class MyProposalItem {
  final String id;
  final String projectId;
  final String projectTitle;
  final String projectStatus;
  final String message;
  final double price;
  final String estimatedTime;
  final String workMethod;
  final String status;
  final DateTime createdAt;

  const MyProposalItem({
    required this.id,
    required this.projectId,
    required this.projectTitle,
    required this.projectStatus,
    required this.message,
    required this.price,
    required this.estimatedTime,
    required this.workMethod,
    required this.status,
    required this.createdAt,
  });

  factory MyProposalItem.fromMaps({
    required Map<String, dynamic> proposal,
    required String projectTitle,
    required String projectStatus,
  }) {
    return MyProposalItem(
      id: proposal['id'] as String,
      projectId: proposal['project_id'] as String,
      projectTitle: projectTitle,
      projectStatus: projectStatus,
      message: proposal['message'] as String? ?? '',
      price: (proposal['price'] as num).toDouble(),
      estimatedTime: proposal['estimated_time'] as String? ?? '-',
      workMethod: proposal['work_method'] as String? ?? '-',
      status: proposal['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(proposal['created_at'] as String),
    );
  }

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';
}
