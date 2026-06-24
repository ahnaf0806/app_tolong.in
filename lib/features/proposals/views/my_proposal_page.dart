import 'package:app_tolongin/core/widgets/app_empety_state.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_error_state.dart';
import '../controllers/my_proposal_controller.dart';
import '../widgets/my_proposal_card.dart';

class MyProposalsPage extends StatefulWidget {
  const MyProposalsPage({super.key});

  @override
  State<MyProposalsPage> createState() => _MyProposalsPageState();
}

class _MyProposalsPageState extends State<MyProposalsPage> {
  final MyProposalController _controller = MyProposalController();

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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _loadProposals,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              Text('Proposal Saya', style: AppTextStyles.headingLg),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Pantau status proposal yang sudah kamu kirim.',
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.stone),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (_controller.isLoading && _controller.proposals.isEmpty)
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
                      'Proposal yang kamu kirim ke project akan tampil di halaman ini.',
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

      items.add(MyProposalCard(proposal: proposal));

      if (index != _controller.proposals.length - 1) {
        items.add(const SizedBox(height: AppSpacing.md));
      }
    }

    return items;
  }
}
