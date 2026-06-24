import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_gradient_background.dart';
import '../../../core/widgets/premium_gradient_card.dart';
import '../controllers/owner_proposal_controller.dart';
import '../models/owner_proposal_item.dart';
import '../widgets/owner_proposal_card.dart';

class OwnerProposalPage extends StatefulWidget {
  const OwnerProposalPage({super.key});

  @override
  State<OwnerProposalPage> createState() => _OwnerProposalPageState();
}

class _OwnerProposalPageState extends State<OwnerProposalPage> {
  final OwnerProposalController _controller = OwnerProposalController();

  @override
  void initState() {
    super.initState();
    _loadProposals();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadProposals() async {
    await _controller.loadProposals();
    if (mounted) setState(() {});
  }

  Future<void> _acceptProposal(OwnerProposalItem proposal) async {
    final success = await _controller.acceptProposal(proposal);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? 'Proposal diterima dan workspace dibuat.' : _controller.errorMessage ?? 'Gagal menerima proposal.')),
    );
    if (success) await _loadProposals();
  }

  Future<void> _rejectProposal(String proposalId) async {
    final success = await _controller.rejectProposal(proposalId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? 'Proposal ditolak.' : _controller.errorMessage ?? 'Gagal menolak proposal.')),
    );
    if (success) await _loadProposals();
  }

  @override
  Widget build(BuildContext context) {
    return AppGradientBackground(
      child: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _loadProposals,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.xl),
                children: [
                  _hero(),
                  const SizedBox(height: AppSpacing.xl),
                  if (_controller.isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: AppSpacing.xl),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_controller.errorMessage != null && _controller.proposals.isEmpty)
                    AppErrorState(message: _controller.errorMessage!, onRetry: _loadProposals)
                  else if (_controller.proposals.isEmpty)
                    const AppEmptyState(
                      icon: Icons.assignment_outlined,
                      title: 'Belum Ada Proposal',
                      message: 'Proposal dari freelancer akan muncul setelah mereka mengajukan penawaran.',
                    )
                  else
                    ..._buildProposalItems(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _hero() {
    return PremiumGradientCard(
      child: Row(
        children: [
          const Icon(Icons.mark_email_read_rounded, color: AppColors.canvas, size: 42),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Proposal Masuk', style: AppTextStyles.headingSm.copyWith(color: AppColors.canvas)),
                Text(
                  'Kelola proposal freelancer dengan cepat dan terstruktur.',
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.canvas.withValues(alpha: 0.86)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildProposalItems() {
    final items = <Widget>[];
    for (var index = 0; index < _controller.proposals.length; index++) {
      final proposal = _controller.proposals[index];
      items.add(
        OwnerProposalCard(
          proposal: proposal,
          isLoading: _controller.isLoading,
          onAccept: () => _acceptProposal(proposal),
          onReject: () => _rejectProposal(proposal.id),
        ),
      );
      if (index != _controller.proposals.length - 1) items.add(const SizedBox(height: AppSpacing.md));
    }
    return items;
  }
}
