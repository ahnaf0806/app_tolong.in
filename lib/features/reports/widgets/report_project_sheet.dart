import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';
import '../../projects/models/project_model.dart';
import '../services/report_service.dart';

class ReportProjectSheet extends StatefulWidget {
  final ProjectModel project;

  const ReportProjectSheet({super.key, required this.project});

  @override
  State<ReportProjectSheet> createState() => _ReportProjectSheetState();
}

class _ReportProjectSheetState extends State<ReportProjectSheet> {
  final ReportService _reportService = ReportService();
  final TextEditingController _descriptionController = TextEditingController();

  final List<_ReportReason> _reasons = const [
    _ReportReason(
      value: 'permintaan_joki_tugas',
      label: 'Permintaan joki tugas',
      description:
          'Project meminta tugas kuliah, ujian, kuis, skripsi, atau pelanggaran akademik.',
    ),
    _ReportReason(
      value: 'penipuan',
      label: 'Penipuan',
      description:
          'Project terindikasi palsu, menyesatkan, atau merugikan pengguna.',
    ),
    _ReportReason(
      value: 'project_palsu',
      label: 'Project palsu',
      description:
          'Project tidak memiliki kebutuhan nyata atau dibuat untuk tujuan tidak jelas.',
    ),
    _ReportReason(
      value: 'bahasa_tidak_sopan',
      label: 'Bahasa tidak sopan',
      description:
          'Deskripsi project mengandung kata kasar, hinaan, atau pelecehan.',
    ),
    _ReportReason(
      value: 'penyalahgunaan_file',
      label: 'Penyalahgunaan file',
      description:
          'Project meminta atau membagikan file yang tidak seharusnya.',
    ),
    _ReportReason(
      value: 'lainnya',
      label: 'Lainnya',
      description: 'Masalah lain yang perlu ditinjau admin.',
    ),
  ];

  String _selectedReason = 'permintaan_joki_tugas';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    final projectId = widget.project.id;
    final description = _descriptionController.text.trim();

    if (projectId == null || projectId.isEmpty) {
      _showSnackBar('Project tidak valid.', isError: true);
      return;
    }

    if (description.length < 10) {
      _showSnackBar(
        'Tuliskan detail laporan minimal 10 karakter.',
        isError: true,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _reportService.reportProject(
        projectId: projectId,
        projectOwnerId: widget.project.ownerId,
        reason: _selectedReason,
        description: description,
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Laporan berhasil dikirim dan akan ditinjau admin.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      _showSnackBar(
        error.toString().replaceAll('Exception:', '').trim(),
        isError: true,
      );
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? AppColors.critical : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.hairline,
                    borderRadius: AppRadius.all(AppRadius.full),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Laporkan Project', style: AppTextStyles.headingSm),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Pilih alasan laporan agar admin bisa meninjau project ini dengan tepat.',
                style: AppTextStyles.bodySm,
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildProjectPreview(),
              const SizedBox(height: AppSpacing.lg),
              Text('Alasan Laporan', style: AppTextStyles.bodyMdBold),
              const SizedBox(height: AppSpacing.sm),
              ..._reasons.map(_buildReasonTile),
              const SizedBox(height: AppSpacing.lg),
              CustomTextField(
                controller: _descriptionController,
                label: 'Detail laporan',
                hint: 'Jelaskan bagian yang bermasalah pada project ini...',
                maxLines: 4,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                text: 'Kirim Laporan',
                icon: Icons.report_rounded,
                variant: PrimaryButtonVariant.cobalt,
                isLoading: _isSubmitting,
                onPressed: _submitReport,
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                text: 'Batal',
                onPressed: _isSubmitting
                    ? null
                    : () => Navigator.of(context).pop(false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: AppRadius.all(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.project.title,
            style: AppTextStyles.bodyMdBold,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.project.categoryName ?? widget.project.projectField,
            style: AppTextStyles.caption.copyWith(color: AppColors.stone),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonTile(_ReportReason reason) {
    final isSelected = reason.value == _selectedReason;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: AppRadius.all(AppRadius.xl),
        onTap: _isSubmitting
            ? null
            : () {
                setState(() {
                  _selectedReason = reason.value;
                });
              },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.08)
                : AppColors.canvas,
            borderRadius: AppRadius.all(AppRadius.xl),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.hairlineSoft,
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: isSelected ? AppColors.primary : AppColors.stone,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reason.label, style: AppTextStyles.bodySmBold),
                      const SizedBox(height: 2),
                      Text(
                        reason.description,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.stone,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportReason {
  final String value;
  final String label;
  final String description;

  const _ReportReason({
    required this.value,
    required this.label,
    required this.description,
  });
}
