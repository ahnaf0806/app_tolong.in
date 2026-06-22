class MessageModel {
  final String? id;
  final String workspaceId;
  final String senderId;
  final String receiverId;
  final String message;
  final String? attachmentUrl;
  final bool isRead;
  final DateTime? createdAt;

  const MessageModel({
    this.id,
    required this.workspaceId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.attachmentUrl,
    this.isRead = false,
    this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String?,
      workspaceId: json['workspace_id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      message: json['message'] as String,
      attachmentUrl: json['attachment_url'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'workspace_id': workspaceId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'attachment_url': attachmentUrl,
      'is_read': isRead,
    };
  }

  bool isMine(String currentUserId) {
    return senderId == currentUserId;
  }
}
