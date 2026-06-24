import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_gradient_background.dart';
import '../../../core/widgets/premium_glass_card.dart';
import '../../../core/widgets/premium_gradient_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';
import '../../chat/views/chat_page.dart';
import '../../reviews/views/create_review_page.dart';
import '../controllers/workspace_controller.dart';
import '../models/workspace_model.dart';
import '../widgets/workspace_info_section.dart';
import '../widgets/workspace_status_badge.dart';

class WorkspaceDetailPage extends StatefulWidget {
  final String workspaceId;
  final bool isOwner;

  const WorkspaceDetailPage({
    super.key,
    required this.workspaceId,
    required this.isOwner,
  });

  @override
  State<WorkspaceDetailPage> createState() => _WorkspaceDetailPageState();
}

class _WorkspaceDetailPageState extends State<WorkspaceDetailPage> {
  final WorkspaceController _controller = WorkspaceController();
  final TextEditingController _resultUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWorkspace();
  }

  @override
  void dispose() {
    _controller.dispose();
    _resultUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadWorkspace() async {
    await _controller.loadWorkspaceDetail(widget.workspaceId);
  }

  Future<void> _submitResult(WorkspaceModel workspace) async {
    _resultUrlController.text = workspace.resultFileUrl ?? '';

    final resultUrl = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Kirim Hasil Kerja'),
          content: TextField(
            controller: _resultUrlController,
            decoration: InputDecoration(
              labelText: 'Link hasil kerja',
              hintText: 'Contoh: https://drive.google.com/...',
              filled: true,
              fillColor: AppColors.surfaceSoft,
              border: OutlineInputBorder(
                borderRadius: AppRadius.all(AppRadius.xl),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, _resultUrlController.text.trim()),
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );

    if (resultUrl == null || resultUrl.isEmpty) return;

    final success = await _controller.submitWorkspace(
      workspaceId: workspace.id!,
      resultFileUrl: resultUrl,
    );

    if (!mounted) return;

    _showMessage(
      success
          ? 'Hasil kerja berhasil dikirim.'
          : _controller.errorMessage ?? 'Gagal mengirim hasil kerja.',
    );

    if (success) await _loadWorkspace();
  }

  Future<void> _completeWorkspace(WorkspaceModel workspace) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Selesaikan Project?'),
          content: const Text(
            'Project akan ditandai selesai. Pastikan hasil kerja sudah sesuai.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Ya, Selesaikan'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final success = await _controller.completeWorkspace(workspace.id!);

    if (!mounted) return;

    _showMessage(
      success
          ? 'Project berhasil diselesaikan.'
          : _controller.errorMessage ?? 'Gagal menyelesaikan project.',
    );

    if (success) await _loadWorkspace();
  }

  void _openChat(WorkspaceModel workspace) {
    final receiverId = widget.isOwner ? workspace.freelancerId : workspace.ownerId;
    final partnerName = widget.isOwner ? workspace.freelancerName : workspace.ownerName;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(
          workspaceId: workspace.id!,
          receiverId: receiverId,
          partnerName: partnerName,
        ),
      ),
    );
  }

  Future<void> _openReview(WorkspaceModel workspace) async {
    final reviewed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CreateReviewPage(workspace: workspace)),
    );

    if (reviewed == true) await _loadWorkspace();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Workspace')),
      body: AppGradientBackground(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            if (_controller.isLoading && _controller.selectedWorkspace == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_controller.errorMessage != null) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: AppErrorState(
                  message: _controller.errorMessage!,
                  onRetry: _loadWorkspace,
                ),
              );
            }

            final workspace = _controller.selectedWorkspace;
            if (workspace == null) {
              return const Center(child: Text('Workspace tidak ditemukan.'));
            }

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _loadWorkspace,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                children: [
                  _buildHero(workspace),
                  const SizedBox(height: AppSpacing.lg),
                  _buildProgressCard(workspace),
                  const SizedBox(height: AppSpacing.lg),
                  WorkspaceInfoSection(workspace: workspace),
                  const SizedBox(height: AppSpacing.lg),
                  _buildActions(workspace),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHero(WorkspaceModel workspace) {
    final partnerName = widget.isOwner ? workspace.freelancerName : workspace.ownerName;
    final partnerLabel = widget.isOwner ? 'Freelancer' : 'Project Owner';

    return PremiumGradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.canvas.withValues(alpha: 0.14),
                  borderRadius: AppRadius.all(AppRadius.xxl),
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded,
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
                      workspace.projectTitle,
                      style: AppTextStyles.headingSm.copyWith(
                        color: AppColors.canvas,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '$partnerLabel: $partnerName',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.canvas.withValues(alpha: 0.84),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    WorkspaceStatusBadge(status: workspace.status),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            workspace.projectDescription,
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.canvas.withValues(alpha: 0.86),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(WorkspaceModel workspace) {
    final progress = switch (workspace.status) {
      'active' => 0.45,
      'submitted' => 0.78,
      'completed' => 1.0,
      'cancelled' => 0.0,
      _ => 0.25,
    };

    return PremiumGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Progress Project', style: AppTextStyles.subtitleLg),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _progressMessage(workspace.status),
            style: AppTextStyles.bodySm.copyWith(color: AppColors.charcoal),
          ),
          const SizedBox(height: AppSpacing.base),
          ClipRRect(
            borderRadius: AppRadius.all(AppRadius.full),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: progress,
              backgroundColor: AppColors.surfaceSoft,
              color: workspace.status == 'cancelled'
                  ? AppColors.critical
                  : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _progressMessage(String status) {
    switch (status) {
      case 'active':
        return 'Project sedang dikerjakan. Gunakan chat untuk koordinasi.';
      case 'submitted':
        return 'Freelancer sudah mengirim hasil. Menunggu konfirmasi owner.';
      case 'completed':
        return 'Project selesai. Rating dan review dapat diberikan.';
      case 'cancelled':
        return 'Project dibatalkan.';
      default:
        return 'Workspace sudah dibuat dan siap digunakan.';
    }
  }

  Widget _buildActions(WorkspaceModel workspace) {
    return PremiumGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Aksi Workspace', style: AppTextStyles.subtitleLg),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Kelola komunikasi, hasil kerja, dan penyelesaian project di sini.',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.charcoal),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            text: 'Buka Chat',
            icon: Icons.chat_bubble_rounded,
            variant: PrimaryButtonVariant.cobalt,
            onPressed: () => _openChat(workspace),
          ),
          if (!widget.isOwner && workspace.isActive) ...[
            const SizedBox(height: AppSpacing.sm),
            SecondaryButton(
              text: 'Kirim Hasil Kerja',
              icon: Icons.upload_file_rounded,
              onPressed: _controller.isLoading ? null : () => _submitResult(workspace),
            ),
          ],
          if (widget.isOwner && (workspace.isActive || workspace.isSubmitted)) ...[
            const SizedBox(height: AppSpacing.sm),
            SecondaryButton(
              text: 'Selesaikan Project',
              icon: Icons.check_circle_rounded,
              onPressed: _controller.isLoading ? null : () => _completeWorkspace(workspace),
            ),
          ],
          if (widget.isOwner && workspace.isCompleted) ...[
            const SizedBox(height: AppSpacing.sm),
            SecondaryButton(
              text: 'Beri Review & Rating',
              icon: Icons.star_rounded,
              onPressed: () => _openReview(workspace),
            ),
          ],
        ],
      ),
    );
  }
}
