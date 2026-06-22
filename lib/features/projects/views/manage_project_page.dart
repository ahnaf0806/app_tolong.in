import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../proposals/controllers/manage_proposal_controller.dart';
import '../../proposals/widgets/proposal_list_card.dart';
import '../models/project_model.dart';

class ManageProjectPage extends StatefulWidget {
  final ProjectModel project;

  const ManageProjectPage({super.key, required this.project});

  @override
  State<ManageProjectPage> createState() => _ManageProjectPageState();
}

class _ManageProjectPageState extends State<ManageProjectPage> {
  final ManageProposalController _controller = ManageProposalController();

  @override
  void initState() {
    super.initState();
    _controller.loadProposals(widget.project.id!);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAccept(String proposalId, String freelancerId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Terima Proposal?'),
        content: const Text(
          'Apakah kamu yakin ingin menerima proposal ini? Proposal lain akan otomatis ditolak dan workspace akan dibuat.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Terima'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _controller.acceptProposal(
        proposalId: proposalId,
        projectId: widget.project.id!,
        freelancerId: freelancerId,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proposal diterima! Workspace telah dibuat.'),
          ),
        );
        _controller.loadProposals(widget.project.id!);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _controller.errorMessage ?? 'Gagal menerima proposal',
            ),
          ),
        );
      }
    }
  }

  void _handleReject(String proposalId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tolak Proposal?'),
        content: const Text('Apakah kamu yakin ingin menolak proposal ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.critical,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Tolak'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _controller.rejectProposal(proposalId);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Proposal ditolak.')));
        _controller.loadProposals(widget.project.id!);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_controller.errorMessage ?? 'Gagal menolak proposal'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Flag to see if the project is no longer open
    final bool projectIsActive = widget.project.status.toLowerCase() == 'open';

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Kelola Project'),
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.inkDeep,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => _controller.loadProposals(widget.project.id!),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              children: [
                // Project Summary
                Text(widget.project.title, style: AppTextStyles.headingSm),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Status: ${widget.project.status}',
                  style: AppTextStyles.bodySm,
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Proposals Section
                Text('Daftar Proposal Masuk', style: AppTextStyles.subtitleLg),
                const SizedBox(height: AppSpacing.md),

                if (_controller.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.xxl),
                      child: CircularProgressIndicator(),
                    ),
                  ),

                if (!_controller.isLoading && _controller.errorMessage != null)
                  Center(
                    child: Text(
                      _controller.errorMessage!,
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.critical,
                      ),
                    ),
                  ),

                if (!_controller.isLoading &&
                    _controller.errorMessage == null &&
                    _controller.proposals.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.xxxl),
                      child: Text('Belum ada proposal masuk.'),
                    ),
                  ),

                if (!_controller.isLoading && _controller.proposals.isNotEmpty)
                  ..._controller.proposals.map(
                    (proposal) => ProposalListCard(
                      proposal: proposal,
                      isActionLoading: _controller.isActionLoading,
                      canAct: projectIsActive && proposal.status == 'pending',
                      onAccept: () =>
                          _handleAccept(proposal.id!, proposal.freelancerId),
                      onReject: () => _handleReject(proposal.id!),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
