import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_gradient_background.dart';
import '../../chat/views/chat_page.dart';
import '../../reports/widgets/report_user_sheet.dart';
import '../models/freelancer_summary_model.dart';
import '../services/freelancer_contact_service.dart';
import '../widgets/freelancer_detail_actions_card.dart';
import '../widgets/freelancer_detail_header.dart';
import '../widgets/freelancer_detail_info_card.dart';
import '../widgets/freelancer_detail_stats_card.dart';

class FreelancerDetailPage extends StatefulWidget {
  final FreelancerSummaryModel freelancer;

  const FreelancerDetailPage({
    super.key,
    required this.freelancer,
  });

  @override
  State<FreelancerDetailPage> createState() => _FreelancerDetailPageState();
}

class _FreelancerDetailPageState extends State<FreelancerDetailPage> {
  final FreelancerContactService _contactService = FreelancerContactService();
  bool _isOpeningChat = false;

  Future<void> _openChat() async {
    setState(() => _isOpeningChat = true);

    try {
      final contact = await _contactService.findWorkspaceForChat(
        freelancerId: widget.freelancer.id,
      );

      if (!mounted) return;

      if (contact == null) {
        await showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Chat Belum Tersedia'),
            content: const Text(
              'Chat dengan freelancer akan aktif setelah Anda menerima proposal freelancer dan workspace project dibuat.',
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Mengerti'),
              ),
            ],
          ),
        );
        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatPage(
            workspaceId: contact.workspaceId,
            receiverId: widget.freelancer.id,
            partnerName: widget.freelancer.name,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceAll('Exception:', '').trim()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (mounted) {
      setState(() => _isOpeningChat = false);
    }
  }

  void _openReportSheet() {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.canvas,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxxl),
        ),
      ),
      builder: (_) => ReportUserSheet(
        reportedUserId: widget.freelancer.id,
        reportedUserName: widget.freelancer.name,
        reportedUserRoleLabel: 'Freelancer',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final freelancer = widget.freelancer;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: const Text('Detail Freelancer')),
      body: AppGradientBackground(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
          FreelancerDetailHeader(freelancer: freelancer),
          const SizedBox(height: AppSpacing.lg),
          FreelancerDetailStatsCard(freelancer: freelancer),
          const SizedBox(height: AppSpacing.lg),
          FreelancerDetailInfoCard(freelancer: freelancer),
          const SizedBox(height: AppSpacing.lg),
            FreelancerDetailActionsCard(
              isOpeningChat: _isOpeningChat,
              onOpenChat: _openChat,
              onOpenReport: _openReportSheet,
            ),
          ],
        ),
      ),
    );
  }
}
