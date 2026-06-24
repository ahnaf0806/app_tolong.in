import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_status_badge.dart';
import '../models/my_proposal_item.dart';

class MyProposalCard extends StatelessWidget {
  final MyProposalItem proposal;

  const MyProposalCard({super.key, required this.proposal});

  @override
  Widget build(BuildContext context) {
    final createdAt = DateFormat(
      'dd MMM yyyy',
      'id_ID',
    ).format(proposal.createdAt);

    return Card(
      elevation: 0,
      color: AppColors.canvas,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.all(AppRadius.xl),
        side: const BorderSide(color: AppColors.hairlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: AppSpacing.sm),
            Text(
              proposal.message,
              style: AppTextStyles.bodySm.copyWith(color: AppColors.charcoal),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.base),
            _InfoRow(
              icon: Icons.payments_outlined,
              label: 'Harga',
              value: _formatCurrency(proposal.price),
            ),
            _InfoRow(
              icon: Icons.schedule_rounded,
              label: 'Estimasi',
              value: proposal.estimatedTime,
            ),
            _InfoRow(
              icon: Icons.handyman_outlined,
              label: 'Metode',
              value: proposal.workMethod,
            ),
            _InfoRow(
              icon: Icons.calendar_today_rounded,
              label: 'Dikirim',
              value: createdAt,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Text(
                  'Status Project',
                  style: AppTextStyles.caption.copyWith(color: AppColors.stone),
                ),
                const Spacer(),
                AppStatusBadge(status: proposal.projectStatus, type: 'project'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            proposal.projectTitle,
            style: AppTextStyles.bodyMdBold,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        AppStatusBadge(status: proposal.status, type: 'proposal'),
      ],
    );
  }

  String _formatCurrency(double value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(value);
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.stone),
          const SizedBox(width: AppSpacing.xs),
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.stone),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
