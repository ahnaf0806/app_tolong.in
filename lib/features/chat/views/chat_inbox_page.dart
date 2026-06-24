import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../workspaces/models/workspace_model.dart';
import '../../workspaces/services/workspace_service.dart';
import 'chat_page.dart';

class ChatInboxPage extends StatefulWidget {
  const ChatInboxPage({super.key});

  @override
  State<ChatInboxPage> createState() => _ChatInboxPageState();
}

class _ChatInboxPageState extends State<ChatInboxPage> {
  final WorkspaceService _workspaceService = WorkspaceService();

  bool _isLoading = true;
  String? _errorMessage;
  String? _currentUserId;
  List<WorkspaceModel> _workspaces = [];

  @override
  void initState() {
    super.initState();
    _loadInbox();
  }

  Future<void> _loadInbox() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final currentUserId = _workspaceService.getCurrentUserId();
      final workspaces = await _workspaceService.getMyWorkspaces();

      if (!mounted) return;

      setState(() {
        _currentUserId = currentUserId;
        _workspaces = workspaces
            .where((workspace) => workspace.id != null)
            .where((workspace) => workspace.status != 'cancelled')
            .toList();
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  void _openChat(WorkspaceModel workspace) {
    final currentUserId = _currentUserId;

    if (currentUserId == null || workspace.id == null) {
      return;
    }

    final isOwner = workspace.ownerId == currentUserId;
    final partnerId = isOwner ? workspace.freelancerId : workspace.ownerId;
    final partnerName = isOwner
        ? workspace.freelancerName
        : workspace.ownerName;

    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => ChatPage(
              workspaceId: workspace.id!,
              receiverId: partnerId,
              partnerName: partnerName,
            ),
          ),
        )
        .then((_) => _loadInbox());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _loadInbox,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            _buildHeader(),
            const SizedBox(height: AppSpacing.xl),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_errorMessage != null)
              _buildErrorState()
            else if (_workspaces.isEmpty)
              _buildEmptyState()
            else
              ..._workspaces.map(_buildChatItem),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AppCard(
      backgroundColor: AppColors.inkDeep,
      hasBorder: false,
      radius: AppRadius.xxxl,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.canvas.withValues(alpha: 0.12),
              borderRadius: AppRadius.all(AppRadius.full),
            ),
            child: const Icon(
              Icons.chat_bubble_rounded,
              color: AppColors.canvas,
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
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Diskusi project yang sudah memiliki workspace aktif.',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.canvas.withValues(alpha: 0.78),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return AppCard(
      backgroundColor: AppColors.critical.withValues(alpha: 0.06),
      hasBorder: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chat belum bisa dimuat',
            style: AppTextStyles.bodyMdBold.copyWith(color: AppColors.critical),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _errorMessage ?? 'Terjadi kesalahan.',
            style: AppTextStyles.bodySm,
          ),
          const SizedBox(height: AppSpacing.base),
          OutlinedButton.icon(
            onPressed: _loadInbox,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return AppCard(
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: AppRadius.all(AppRadius.circle),
            ),
            child: const Icon(
              Icons.forum_outlined,
              color: AppColors.primary,
              size: 34,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Belum ada percakapan',
            style: AppTextStyles.subtitleLg,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Chat akan muncul setelah proposal diterima dan workspace project dibuat.',
            style: AppTextStyles.bodySm,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(WorkspaceModel workspace) {
    final currentUserId = _currentUserId;
    final isOwner = workspace.ownerId == currentUserId;
    final partnerName = isOwner
        ? workspace.freelancerName
        : workspace.ownerName;
    final partnerLabel = isOwner ? 'Freelancer' : 'Project Owner';

    final date = workspace.startedAt ?? workspace.createdAt;
    final formattedDate = date == null
        ? '-'
        : DateFormat('dd MMM yyyy', 'id_ID').format(date);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        onTap: () => _openChat(workspace),
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Row(
          children: [
            _AvatarInitial(name: partnerName),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    partnerName,
                    style: AppTextStyles.bodyMdBold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    partnerLabel,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.stone,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    workspace.projectTitle,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.charcoal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formattedDate, style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.md),
                const Icon(Icons.chevron_right_rounded, color: AppColors.stone),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarInitial extends StatelessWidget {
  final String name;

  const _AvatarInitial({required this.name});

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: AppRadius.all(AppRadius.circle),
      ),
      child: Center(
        child: Text(
          initial,
          style: AppTextStyles.subtitleLg.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}
