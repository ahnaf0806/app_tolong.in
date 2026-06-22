import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/proposal_model.dart';

class ProposalListCard extends StatelessWidget {
  final ProposalModel proposal;
  final bool isActionLoading;
  final bool canAct;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const ProposalListCard({
    super.key,
    required this.proposal,
    required this.isActionLoading,
    required this.canAct,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.canvas,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: AppSpacing.base),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.all(AppRadius.xl),
        side: const BorderSide(color: AppColors.hairlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    proposal.freelancerName ?? 'Freelancer',
                    style: AppTextStyles.bodyMdBold,
                  ),
                ),
                _ProposalStatusBadge(status: proposal.status),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              proposal.message,
              style: AppTextStyles.bodyMd,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.base),
            _InfoRow(label: 'Harga', value: _formatCurrency(proposal.price)),
            _InfoRow(label: 'Estimasi', value: proposal.estimatedTime),
            _InfoRow(label: 'Metode', value: proposal.workMethod),
            if (canAct) ...[
              const SizedBox(height: AppSpacing.base),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isActionLoading ? null : onReject,
                      child: const Text('Tolak'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isActionLoading ? null : onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                      ),
                      child: isActionLoading
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

  String _formatCurrency(double value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(value);
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          SizedBox(width: 82, child: Text(label, style: AppTextStyles.caption)),
          Expanded(child: Text(value, style: AppTextStyles.bodySm)),
        ],
      ),
    );
  }
}

class _ProposalStatusBadge extends StatelessWidget {
  final String status;

  const _ProposalStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status.toLowerCase()) {
      case 'accepted':
        label = 'Diterima';
        backgroundColor = const Color(0xFFE8F5EC);
        textColor = AppColors.success;
        break;
      case 'rejected':
        label = 'Ditolak';
        backgroundColor = const Color(0xFFFFECEF);
        textColor = AppColors.critical;
        break;
      default:
        label = 'Menunggu';
        backgroundColor = const Color(0xFFFFF4E0);
        textColor = AppColors.attention;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.all(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
