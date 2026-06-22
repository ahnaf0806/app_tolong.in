import 'package:flutter/material.dart';

import '../models/message_model.dart';
import '../services/chat_service.dart';

class ChatController extends ChangeNotifier {
  final ChatService _chatService;

  ChatController({ChatService? chatService})
    : _chatService = chatService ?? ChatService();

  bool isLoading = false;
  bool isSending = false;
  String? errorMessage;

  String? currentUserId;
  List<MessageModel> messages = [];

  Future<void> loadMessages({
    required String workspaceId,
    bool silent = false,
  }) async {
    if (!silent) {
      _setLoading(true);
    }

    errorMessage = null;

    try {
      currentUserId = _chatService.getCurrentUserId();
      messages = await _chatService.getMessages(workspaceId);
    } catch (error) {
      errorMessage = _cleanError(error);
    }

    if (!silent) {
      _setLoading(false);
    } else {
      notifyListeners();
    }
  }

  Future<bool> sendMessage({
    required String workspaceId,
    required String receiverId,
    required String message,
  }) async {
    errorMessage = null;

    final cleanMessage = message.trim();

    if (cleanMessage.isEmpty) {
      return false;
    }

    _setSending(true);

    try {
      await _chatService.sendMessage(
        workspaceId: workspaceId,
        receiverId: receiverId,
        message: cleanMessage,
      );

      await loadMessages(workspaceId: workspaceId, silent: true);

      _setSending(false);
      return true;
    } catch (error) {
      errorMessage = _cleanError(error);
      _setSending(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setSending(bool value) {
    isSending = value;
    notifyListeners();
  }

  String _cleanError(Object error) {
    final message = error.toString();

    if (message.contains('violates row-level security') ||
        message.contains('permission denied')) {
      return 'Akses chat ditolak oleh Supabase RLS.';
    }

    if (message.contains('User belum login')) {
      return 'User belum login. Silakan login ulang.';
    }

    return message.replaceAll('Exception:', '').trim();
  }
}
