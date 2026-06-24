import 'package:app_tolongin/features/proposals/views/my_proposal_page.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../workspaces/views/workspace_list_page.dart';

class FreelancerActivityPage extends StatelessWidget {
  const FreelancerActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: AppColors.canvas,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
            child: const TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(icon: Icon(Icons.assignment_outlined), text: 'Proposal'),
                Tab(icon: Icon(Icons.work_outline_rounded), text: 'Workspace'),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [MyProposalsPage(), WorkspaceListPage()],
            ),
          ),
        ],
      ),
    );
  }
}
