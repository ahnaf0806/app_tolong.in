import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_gradient_background.dart';
import '../../../core/widgets/premium_glass_card.dart';
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

    if (!mounted) return;

    if (success) {
      _messageController.clear();
      _scrollToBottom();
      return;
    }

    if (_controller.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.errorMessage!),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        titleSpacing: 0,
        title: _ChatTitle(partnerName: widget.partnerName),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loadMessages,
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: AppGradientBackground(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final currentUserId = _controller.currentUserId;

            if (_controller.isLoading && _controller.messages.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_controller.errorMessage != null &&
                _controller.messages.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: AppErrorState(
                  message: _controller.errorMessage!,
                  onRetry: _loadMessages,
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: _loadMessages,
                    child: _controller.messages.isEmpty
                        ? ListView(
                            padding: const EdgeInsets.all(AppSpacing.xl),
                            children: const [
                              AppEmptyState(
                                icon: Icons.chat_bubble_outline_rounded,
                                title: 'Belum ada pesan',
                                message:
                                    'Mulai percakapan project dengan pesan pertama yang jelas dan sopan.',
                              ),
                            ],
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.base,
                              AppSpacing.base,
                              AppSpacing.base,
                              AppSpacing.xs,
                            ),
                            itemCount: _controller.messages.length,
                            itemBuilder: (context, index) {
                              final message = _controller.messages[index];
                              return MessageBubble(
                                message: message,
                                isMine: currentUserId != null &&
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
      ),
    );
  }
}

class _ChatTitle extends StatelessWidget {
  final String partnerName;

  const _ChatTitle({required this.partnerName});

  @override
  Widget build(BuildContext context) {
    final initial = partnerName.trim().isEmpty
        ? 'C'
        : partnerName.trim()[0].toUpperCase();

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primary.withValues(alpha: 0.10),
          child: Text(
            initial,
            style: AppTextStyles.bodyMdBold.copyWith(color: AppColors.primary),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                partnerName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Percakapan project',
                style: AppTextStyles.caption.copyWith(color: AppColors.stone),
              ),
            ],
          ),
        ),
      ],
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.base,
          AppSpacing.xs,
          AppSpacing.base,
          AppSpacing.base,
        ),
        child: PremiumGlassCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          radius: AppRadius.xxl,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: 'Tulis pesan...',
                    filled: true,
                    fillColor: AppColors.surfaceSoft,
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.all(AppRadius.xl),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.base,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: 48,
                height: 48,
                child: FilledButton(
                  onPressed: isSending ? null : onSend,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.canvas,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.all(AppRadius.xl),
                    ),
                  ),
                  child: isSending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.canvas,
                          ),
                        )
                      : const Icon(Icons.send_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
