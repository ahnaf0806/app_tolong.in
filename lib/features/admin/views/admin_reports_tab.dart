import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/premium_glass_card.dart';
import '../models/admin_report_item_model.dart';
import '../widgets/admin_report_card.dart';

class AdminReportsTab extends StatefulWidget {
  final List<AdminReportItemModel> reports;
  final Future<void> Function(String reportId, String status) onChangeStatus;
  final void Function(AdminReportItemModel report) onOpenReport;

  const AdminReportsTab({
    super.key,
    required this.reports,
    required this.onChangeStatus,
    required this.onOpenReport,
  });

  @override
  State<AdminReportsTab> createState() => _AdminReportsTabState();
}

class _AdminReportsTabState extends State<AdminReportsTab> {
  String _status = 'all';

  List<AdminReportItemModel> get _filteredReports {
    if (_status == 'all') return widget.reports;
    return widget.reports.where((report) => report.status == _status).toList();
  }

  @override
  Widget build(BuildContext context) {
    final reports = _filteredReports;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        _buildFilter(),
        const SizedBox(height: AppSpacing.lg),
        if (reports.isEmpty)
          const AppEmptyState(
            icon: Icons.report_outlined,
            title: 'Belum ada laporan',
            message: 'Laporan akan muncul sesuai filter status yang dipilih.',
          )
        else
          ...reports.map(
            (report) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AdminReportCard(
                report: report,
                onTap: () => widget.onOpenReport(report),
                onChangeStatus: (status) => widget.onChangeStatus(report.id, status),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFilter() {
    return PremiumGlassCard(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: DropdownButtonFormField<String>(
        initialValue: _status,
        decoration: const InputDecoration(
          labelText: 'Filter Status Laporan',
          prefixIcon: Icon(Icons.filter_alt_rounded),
        ),
        items: const [
          DropdownMenuItem(value: 'all', child: Text('Semua')),
          DropdownMenuItem(value: 'pending', child: Text('Menunggu')),
          DropdownMenuItem(value: 'reviewed', child: Text('Ditinjau')),
          DropdownMenuItem(value: 'resolved', child: Text('Selesai')),
        ],
        dropdownColor: AppColors.canvas,
        onChanged: (value) {
          if (value == null) return;
          setState(() => _status = value);
        },
      ),
    );
  }
}
