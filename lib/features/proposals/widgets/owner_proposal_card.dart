import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_status_badge.dart';
import '../models/owner_proposal_item.dart';

class OwnerProposalCard extends StatelessWidget {
  final OwnerProposalItem proposal;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final bool isLoading;

  const OwnerProposalCard({
    super.key,
    required this.proposal,
    required this.onAccept,
    required this.onReject,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
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
            _buildFreelancerInfo(),
            const SizedBox(height: AppSpacing.base),
            Text(
              proposal.message,
              style: AppTextStyles.bodySm.copyWith(color: AppColors.charcoal),
              maxLines: 4,
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
            if (proposal.isPending) ...[
              const SizedBox(height: AppSpacing.base),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isLoading ? null : onReject,
                      child: const Text('Tolak'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Terima'),
                    ),
                  ),
                ],
              ),
            ],
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

  Widget _buildFreelancerInfo() {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.surfaceSoft,
            borderRadius: AppRadius.all(AppRadius.md),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            size: 18,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Freelancer', style: AppTextStyles.caption),
              Text(
                proposal.freelancerName,
                style: AppTextStyles.bodySm.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
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
