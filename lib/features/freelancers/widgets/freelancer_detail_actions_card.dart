import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';

class FreelancerDetailActionsCard extends StatelessWidget {
  final bool isOpeningChat;
  final VoidCallback onOpenChat;
  final VoidCallback onOpenReport;

  const FreelancerDetailActionsCard({
    super.key,
    required this.isOpeningChat,
    required this.onOpenChat,
    required this.onOpenReport,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Aksi', style: AppTextStyles.subtitleLg),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Gunakan chat untuk komunikasi project yang sudah memiliki workspace. Laporkan profil jika ada indikasi pelanggaran.',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.charcoal),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            text: 'Chat Freelancer',
            icon: Icons.chat_bubble_rounded,
            isLoading: isOpeningChat,
            variant: PrimaryButtonVariant.cobalt,
            onPressed: onOpenChat,
          ),
          const SizedBox(height: AppSpacing.sm),
          SecondaryButton(
            text: 'Laporkan Profil',
            icon: Icons.report_rounded,
            onPressed: onOpenReport,
          ),
        ],
      ),
    );
  }
}
