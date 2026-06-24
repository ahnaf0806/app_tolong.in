import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_gradient_background.dart';
import '../../../core/widgets/premium_gradient_card.dart';
import '../../../core/widgets/premium_glass_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../projects/models/project_model.dart';
import '../controllers/proposal_controller.dart';
import '../widgets/proposal_form_info_card.dart';

class CreateProposalPage extends StatefulWidget {
  final ProjectModel project;

  const CreateProposalPage({super.key, required this.project});

  @override
  State<CreateProposalPage> createState() => _CreateProposalPageState();
}

class _CreateProposalPageState extends State<CreateProposalPage> {
  final ProposalController _controller = ProposalController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _estimatedTimeController = TextEditingController();
  final TextEditingController _workMethodController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _messageController.dispose();
    _priceController.dispose();
    _estimatedTimeController.dispose();
    _workMethodController.dispose();
    super.dispose();
  }

  Future<void> _submitProposal() async {
    final success = await _controller.createProposal(
      projectId: widget.project.id ?? '',
      projectStatus: widget.project.status,
      message: _messageController.text,
      priceText: _priceController.text,
      estimatedTime: _estimatedTimeController.text,
      workMethod: _workMethodController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proposal berhasil dikirim.')),
      );
      Navigator.pop(context);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_controller.errorMessage ?? 'Proposal gagal dikirim.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: AppGradientBackground(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return ListView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                children: [
                  _buildHero(context),
                  const SizedBox(height: AppSpacing.xl),
                  ProposalFormInfoCard(project: widget.project),
                  const SizedBox(height: AppSpacing.xl),
                  PremiumGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Detail Proposal', style: AppTextStyles.subtitleLg),
                        const SizedBox(height: AppSpacing.md),
                        _input(
                          controller: _messageController,
                          label: 'Pesan Proposal',
                          hint: 'Jelaskan kemampuan, pengalaman, dan cara menyelesaikan project ini.',
                          icon: Icons.chat_bubble_outline_rounded,
                          maxLines: 5,
                        ),
                        const SizedBox(height: AppSpacing.base),
                        _input(
                          controller: _priceController,
                          label: 'Harga Penawaran',
                          hint: 'Contoh: 150000',
                          icon: Icons.payments_rounded,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: AppSpacing.base),
                        _input(
                          controller: _estimatedTimeController,
                          label: 'Estimasi Waktu',
                          hint: 'Contoh: 3 hari',
                          icon: Icons.schedule_rounded,
                        ),
                        const SizedBox(height: AppSpacing.base),
                        _input(
                          controller: _workMethodController,
                          label: 'Metode Kerja',
                          hint: 'Contoh: draft awal, revisi, lalu finalisasi.',
                          icon: Icons.handyman_rounded,
                          maxLines: 3,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        PrimaryButton(
                          text: 'Kirim Proposal',
                          icon: Icons.send_rounded,
                          isLoading: _controller.isLoading,
                          variant: PrimaryButtonVariant.cobalt,
                          onPressed: _submitProposal,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return PremiumGradientCard(
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.canvas),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ajukan Proposal', style: AppTextStyles.headingSm.copyWith(color: AppColors.canvas)),
                Text(
                  'Tawarkan skill terbaikmu secara profesional.',
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.canvas.withValues(alpha: 0.86)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: AppColors.surfaceSoft,
        border: OutlineInputBorder(
          borderRadius: AppRadius.all(AppRadius.xl),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
