import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../projects/models/project_model.dart';

class ProposalFormInfoCard extends StatelessWidget {
  final ProjectModel project;

  const ProposalFormInfoCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.title, style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(project.projectField, style: textTheme.bodyMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    label: 'Budget',
                    value: _formatBudget(project.budget),
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    label: 'Deadline',
                    value: _formatDeadline(project.deadline),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatBudget(double budget) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(budget);
  }

  String _formatDeadline(DateTime deadline) {
    return DateFormat('d MMM yyyy', 'id_ID').format(deadline);
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
