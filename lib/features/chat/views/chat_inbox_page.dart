import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/premium_glass_card.dart';
import '../../../core/widgets/premium_gradient_card.dart';
import '../../workspaces/controllers/workspace_controller.dart';
import '../../workspaces/models/workspace_model.dart';
import 'chat_page.dart';

class ChatInboxPage extends StatefulWidget {
  const ChatInboxPage({super.key});

  @override
  State<ChatInboxPage> createState() => _ChatInboxPageState();
}

class _ChatInboxPageState extends State<ChatInboxPage> {
  final WorkspaceController _controller = WorkspaceController();

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadChats() async {
    await _controller.loadWorkspaces();
    if (mounted) setState(() {});
  }

  void _openChat(WorkspaceModel workspace) {
    final userId = _controller.getCurrentUserId();
    final isOwner = workspace.ownerId == userId;
    final receiverId = isOwner ? workspace.freelancerId : workspace.ownerId;
    final partnerName = isOwner ? workspace.freelancerName : workspace.ownerName;

    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => ChatPage(
              workspaceId: workspace.id!,
              receiverId: receiverId,
              partnerName: partnerName,
            ),
          ),
        )
        .then((_) => _loadChats());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _loadChats,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              _buildHeader(),
              const SizedBox(height: AppSpacing.xl),
              if (_controller.isLoading && _controller.workspaces.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (_controller.errorMessage != null &&
                  _controller.workspaces.isEmpty)
                AppErrorState(
                  message: _controller.errorMessage!,
                  onRetry: _loadChats,
                )
              else if (_controller.workspaces.isEmpty)
                const AppEmptyState(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Belum ada chat',
                  message:
                      'Chat akan aktif otomatis setelah proposal diterima dan workspace dibuat.',
                )
              else
                ..._buildChatItems(),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return PremiumGradientCard(
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.canvas.withValues(alpha: 0.14),
              borderRadius: AppRadius.all(AppRadius.xxl),
            ),
            child: const Icon(
              Icons.mark_chat_unread_rounded,
              color: AppColors.canvas,
              size: 30,
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chat Project',
                  style: AppTextStyles.headingSm.copyWith(
                    color: AppColors.canvas,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Komunikasi langsung dengan partner project Anda.',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.canvas.withValues(alpha: 0.84),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildChatItems() {
    final items = <Widget>[];

    for (var index = 0; index < _controller.workspaces.length; index++) {
      final workspace = _controller.workspaces[index];
      final userId = _controller.getCurrentUserId();
      final isOwner = workspace.ownerId == userId;

      items.add(
        _ChatWorkspaceCard(
          workspace: workspace,
          isOwner: isOwner,
          onTap: () => _openChat(workspace),
        ),
      );

      if (index != _controller.workspaces.length - 1) {
        items.add(const SizedBox(height: AppSpacing.md));
      }
    }

    return items;
  }
}

class _ChatWorkspaceCard extends StatelessWidget {
  final WorkspaceModel workspace;
  final bool isOwner;
  final VoidCallback onTap;

  const _ChatWorkspaceCard({
    required this.workspace,
    required this.isOwner,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final partnerName = isOwner ? workspace.freelancerName : workspace.ownerName;
    final partnerLabel = isOwner ? 'Freelancer' : 'Project Owner';
    final initial = partnerName.trim().isEmpty
        ? 'C'
        : partnerName.trim()[0].toUpperCase();

    return PremiumGlassCard(
      onTap: onTap,
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 29,
                backgroundColor: AppColors.primary.withValues(alpha: 0.10),
                child: Text(
                  initial,
                  style: AppTextStyles.subtitleLg.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    border: Border.all(color: AppColors.canvas, width: 2),
                    borderRadius: AppRadius.all(AppRadius.full),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workspace.projectTitle,
                  style: AppTextStyles.bodyMdBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '$partnerLabel: $partnerName',
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.stone),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                _StatusPill(status: workspace.status),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(Icons.chevron_right_rounded, color: AppColors.stone),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      'active' => 'Dikerjakan',
      'submitted' => 'Menunggu konfirmasi',
      'completed' => 'Selesai',
      'cancelled' => 'Dibatalkan',
      _ => status,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.all(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTextStyles.captionBold.copyWith(color: AppColors.primary),
      ),
    );
  }
}
