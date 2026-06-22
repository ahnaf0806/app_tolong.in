import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/message_model.dart';

class ChatService {
  SupabaseClient get _client => SupabaseService.client;

  String getCurrentUserId() {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login.');
    }

    return user.id;
  }

  Future<List<MessageModel>> getMessages(String workspaceId) async {
    final response = await _client
        .from('messages')
        .select(
          'id, workspace_id, sender_id, receiver_id, message, attachment_url, is_read, created_at',
        )
        .eq('workspace_id', workspaceId)
        .order('created_at', ascending: true);

    final rows = response as List;

    return rows
        .map((item) => MessageModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> sendMessage({
    required String workspaceId,
    required String receiverId,
    required String message,
  }) async {
    final senderId = getCurrentUserId();

    final chatMessage = MessageModel(
      workspaceId: workspaceId,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
    );

    await _client.from('messages').insert(chatMessage.toCreateJson());
  }
}
