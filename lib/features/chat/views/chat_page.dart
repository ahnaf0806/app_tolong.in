import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../controllers/chat_controller.dart';
import '../widgets/message_bubble.dart';

class ChatPage extends StatefulWidget {
  final String workspaceId;
  final String receiverId;
  final String partnerName;

  const ChatPage({
    super.key,
    required this.workspaceId,
    required this.receiverId,
    required this.partnerName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController _controller = ChatController();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadMessages();

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      _controller.loadMessages(workspaceId: widget.workspaceId, silent: true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    await _controller.loadMessages(workspaceId: widget.workspaceId);
    _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text;

    final success = await _controller.sendMessage(
      workspaceId: widget.workspaceId,
      receiverId: widget.receiverId,
      message: text,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      _messageController.clear();
      _scrollToBottom();
      return;
    }

    if (_controller.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_controller.errorMessage!)));
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: Text(widget.partnerName),
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.inkDeep,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final currentUserId = _controller.currentUserId;

          if (_controller.isLoading && _controller.messages.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.errorMessage != null &&
              _controller.messages.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  _controller.errorMessage!,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadMessages,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppSpacing.base),
                    itemCount: _controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = _controller.messages[index];

                      return MessageBubble(
                        message: message,
                        isMine:
                            currentUserId != null &&
                            message.isMine(currentUserId),
                      );
                    },
                  ),
                ),
              ),
              _ChatInputBar(
                controller: _messageController,
                isSending: _controller.isSending,
                onSend: _sendMessage,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  const _ChatInputBar({
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.canvas,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Tulis pesan...',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              height: 48,
              width: 48,
              child: ElevatedButton(
                onPressed: isSending ? null : onSend,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: isSending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
