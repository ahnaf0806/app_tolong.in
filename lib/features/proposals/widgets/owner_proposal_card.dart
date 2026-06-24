import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_status_badge.dart';
import '../../../core/widgets/premium_glass_card.dart';
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
          const SizedBox(height: AppSpacing.md),
          _freelancerInfo(),
          const SizedBox(height: AppSpacing.base),
          Text(
            proposal.message,
            style: AppTextStyles.bodySm.copyWith(color: AppColors.slate, height: 1.45),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.base),
          _InfoRow(icon: Icons.payments_rounded, label: 'Harga', value: _formatCurrency(proposal.price)),
          _InfoRow(icon: Icons.schedule_rounded, label: 'Estimasi', value: proposal.estimatedTime),
          _InfoRow(icon: Icons.handyman_rounded, label: 'Metode', value: proposal.workMethod),
          if (proposal.isPending) ...[
            const SizedBox(height: AppSpacing.base),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isLoading ? null : onReject,
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Tolak'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: AppColors.canvas,
                    ),
                    icon: isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.check_rounded),
                    label: const Text('Terima'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _freelancerInfo() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: AppRadius.all(AppRadius.xl),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.canvas,
            child: Text(
              proposal.freelancerName.trim().isEmpty ? 'F' : proposal.freelancerName.trim()[0].toUpperCase(),
              style: AppTextStyles.bodySmBold.copyWith(color: AppColors.primary),
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
                  style: AppTextStyles.bodySmBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
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
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          SizedBox(width: 76, child: Text(label, style: AppTextStyles.caption)),
          Expanded(child: Text(value, style: AppTextStyles.bodySmBold)),
        ],
      ),
    );
  }
}
