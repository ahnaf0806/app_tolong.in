import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';
import '../services/user_report_service.dart';

class ReportUserSheet extends StatefulWidget {
  final String reportedUserId;
  final String reportedUserName;
  final String reportedUserRoleLabel;

  const ReportUserSheet({
    super.key,
    required this.reportedUserId,
    required this.reportedUserName,
    this.reportedUserRoleLabel = 'User',
  });

  @override
  State<ReportUserSheet> createState() => _ReportUserSheetState();
}

class _ReportUserSheetState extends State<ReportUserSheet> {
  final UserReportService _service = UserReportService();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedReason = _reasons.first.value;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final description = _descriptionController.text.trim();

    if (description.length < 10) {
      _showMessage('Deskripsi laporan minimal 10 karakter.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await _service.createUserReport(
        reportedUserId: widget.reportedUserId,
        reason: _selectedReason,
        description: description,
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Laporan profil berhasil dikirim.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      _showMessage(error.toString().replaceAll('Exception:', '').trim());
    }

    if (mounted) {
      setState(() => _isSubmitting = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
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
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.hairline,
                    borderRadius: AppRadius.all(AppRadius.full),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Laporkan ${widget.reportedUserRoleLabel}',
                  style: AppTextStyles.headingSm),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Laporkan profil ${widget.reportedUserName} jika terindikasi melanggar aturan Tolong.in.',
                style: AppTextStyles.bodySm.copyWith(color: AppColors.stone),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Alasan laporan', style: AppTextStyles.bodyMdBold),
              const SizedBox(height: AppSpacing.sm),
              ..._reasons.map(_buildReasonTile),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _descriptionController,
                minLines: 4,
                maxLines: 6,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  labelText: 'Deskripsi laporan',
                  hintText: 'Jelaskan alasan laporan secara singkat dan jelas...',
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: AppColors.surfaceSoft,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.all(AppRadius.xl),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                text: 'Kirim Laporan',
                icon: Icons.report_rounded,
                isLoading: _isSubmitting,
                variant: PrimaryButtonVariant.cobalt,
                onPressed: _submit,
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                text: 'Batal',
                onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReasonTile(_ReportReason reason) {
    final isSelected = _selectedReason == reason.value;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: InkWell(
        borderRadius: AppRadius.all(AppRadius.xl),
        onTap: _isSubmitting
            ? null
            : () => setState(() => _selectedReason = reason.value),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.08)
                : AppColors.surfaceSoft,
            borderRadius: AppRadius.all(AppRadius.xl),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.hairlineSoft,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: isSelected ? AppColors.primary : AppColors.stone,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reason.label, style: AppTextStyles.bodySmBold),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(reason.description, style: AppTextStyles.caption),
                  ],
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

const _reasons = [
  _ReportReason(
    value: 'profil_palsu',
    label: 'Profil Palsu',
    description: 'Identitas, kampus, atau data profil terlihat tidak valid.',
  ),
  _ReportReason(
    value: 'penipuan',
    label: 'Penipuan',
    description: 'User terindikasi melakukan penipuan atau penyalahgunaan.',
  ),
  _ReportReason(
    value: 'perilaku_tidak_sopan',
    label: 'Perilaku Tidak Sopan',
    description: 'User menggunakan bahasa kasar, mengancam, atau melecehkan.',
  ),
  _ReportReason(
    value: 'skill_tidak_sesuai',
    label: 'Skill Tidak Sesuai',
    description: 'Informasi skill atau portofolio diduga tidak sesuai.',
  ),
  _ReportReason(
    value: 'spam',
    label: 'Spam',
    description: 'User melakukan promosi atau pesan berulang yang mengganggu.',
  ),
  _ReportReason(
    value: 'lainnya',
    label: 'Lainnya',
    description: 'Pelanggaran lain yang perlu ditinjau admin.',
  ),
];
