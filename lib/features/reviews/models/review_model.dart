class ReviewModel {
  final String? id;
  final String workspaceId;
  final String reviewerId;
  final String freelancerId;
  final int rating;
  final String comment;
  final DateTime? createdAt;

  const ReviewModel({
    this.id,
    required this.workspaceId,
    required this.reviewerId,
    required this.freelancerId,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String?,
      workspaceId: json['workspace_id'] as String,
      reviewerId: json['reviewer_id'] as String,
      freelancerId: json['freelancer_id'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String? ?? '',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'workspace_id': workspaceId,
      'reviewer_id': reviewerId,
      'freelancer_id': freelancerId,
      'rating': rating,
      'comment': comment,
    };
  }
}
