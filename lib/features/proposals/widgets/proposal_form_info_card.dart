import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/premium_glass_card.dart';
import '../../projects/models/project_model.dart';

class ProposalFormInfoCard extends StatelessWidget {
  final ProjectModel project;

  const ProposalFormInfoCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return PremiumGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(project.title, style: AppTextStyles.subtitleLg),
          const SizedBox(height: AppSpacing.xs),
          Text(
            project.projectField,
            style: AppTextStyles.bodySm.copyWith(color: AppColors.slate),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  icon: Icons.payments_rounded,
                  label: 'Budget',
                  value: _formatBudget(project.budget),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _InfoItem(
                  icon: Icons.event_rounded,
                  label: 'Deadline',
                  value: _formatDeadline(project.deadline),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatBudget(double budget) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(budget);
  }

  String _formatDeadline(DateTime deadline) {
    return DateFormat('d MMM yyyy', 'id_ID').format(deadline);
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: AppRadius.all(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: AppTextStyles.caption),
          Text(value, style: AppTextStyles.bodySmBold),
        ],
      ),
    );
  }
}
