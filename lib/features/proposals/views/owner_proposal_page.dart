import 'package:flutter/material.dart';

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
    _controller.loadProposals();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return RefreshIndicator(
          onRefresh: _controller.loadProposals,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Proposal Masuk',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Kelola proposal yang dikirim freelancer untuk project kamu.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              if (_controller.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_controller.proposals.isEmpty)
                const Text('Belum ada proposal yang masuk.')
              else
                ..._controller.proposals.map(
                  (proposal) => OwnerProposalCard(
                    proposal: proposal,
                    isLoading: _controller.isLoading,
                    onAccept: () => _acceptProposal(proposal),
                    onReject: () => _rejectProposal(proposal.id),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
