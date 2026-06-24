import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_status_badge.dart';
import '../../../core/widgets/premium_glass_card.dart';
import '../models/my_proposal_item.dart';

class MyProposalCard extends StatelessWidget {
  final MyProposalItem proposal;

  const MyProposalCard({super.key, required this.proposal});

  @override
  Widget build(BuildContext context) {
    final createdAt = DateFormat('dd MMM yyyy', 'id_ID').format(proposal.createdAt);

    return PremiumGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  proposal.projectTitle,
                  style: AppTextStyles.subtitleLg,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppStatusBadge(status: proposal.status, type: 'proposal'),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            proposal.message,
            style: AppTextStyles.bodySm.copyWith(color: AppColors.slate, height: 1.45),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.base),
          _InfoRow(icon: Icons.payments_rounded, label: 'Harga', value: _formatCurrency(proposal.price)),
          _InfoRow(icon: Icons.schedule_rounded, label: 'Estimasi', value: proposal.estimatedTime),
          _InfoRow(icon: Icons.handyman_rounded, label: 'Metode', value: proposal.workMethod),
          _InfoRow(icon: Icons.calendar_today_rounded, label: 'Dikirim', value: createdAt),
          const Divider(height: AppSpacing.xl),
          Row(
            children: [
              Text('Status Project', style: AppTextStyles.caption.copyWith(color: AppColors.stone)),
              const Spacer(),
              AppStatusBadge(status: proposal.projectStatus, type: 'project'),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(value);
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: AppRadius.all(AppRadius.md),
            ),
            child: Icon(icon, size: 15, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(width: 74, child: Text(label, style: AppTextStyles.caption)),
          Expanded(child: Text(value, style: AppTextStyles.bodySmBold)),
        ],
      ),
    );
  }
}
