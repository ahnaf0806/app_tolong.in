import 'package:app_tolongin/core/widgets/app_empety_state.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_error_state.dart';
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

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _acceptProposal(OwnerProposalItem proposal) async {
    final success = await _controller.acceptProposal(proposal);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Proposal diterima dan workspace dibuat.'
              : _controller.errorMessage ?? 'Gagal menerima proposal.',
        ),
      ),
    );

    if (success) {
      await _loadProposals();
    }
  }

  Future<void> _rejectProposal(String proposalId) async {
    final success = await _controller.rejectProposal(proposalId);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Proposal ditolak.'
              : _controller.errorMessage ?? 'Gagal menolak proposal.',
        ),
      ),
    );

    if (success) {
      await _loadProposals();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return RefreshIndicator(
          onRefresh: _loadProposals,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              Text('Proposal Masuk', style: AppTextStyles.headingLg),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Kelola proposal yang dikirim freelancer untuk project kamu.',
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.stone),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (_controller.isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xl),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_controller.errorMessage != null &&
                  _controller.proposals.isEmpty)
                AppErrorState(
                  message: _controller.errorMessage!,
                  onRetry: _loadProposals,
                )
              else if (_controller.proposals.isEmpty)
                const AppEmptyState(
                  icon: Icons.assignment_outlined,
                  title: 'Belum Ada Proposal',
                  message:
                      'Proposal dari freelancer akan muncul setelah mereka mengajukan penawaran.',
                )
              else
                ..._buildProposalItems(),
            ],
          ),
        );
      },
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

      if (index != _controller.proposals.length - 1) {
        items.add(const SizedBox(height: AppSpacing.md));
      }
    }

    return items;
  }
}
