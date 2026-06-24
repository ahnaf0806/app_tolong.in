import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_gradient_background.dart';
import '../../../core/widgets/premium_glass_card.dart';
import '../../../core/widgets/premium_gradient_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/project_controller.dart';
import '../widgets/anti_joki_checkbox.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/difficulty_selector.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key});

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final ProjectController _controller = ProjectController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.loadCategories();
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (selectedDate != null) _controller.selectDeadline(selectedDate);
  }

  Future<void> _submit() async {
    final success = await _controller.createProject(
      title: _titleController.text,
      description: _descriptionController.text,
      budgetText: _budgetController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project berhasil dibuat.')),
      );
      _titleController.clear();
      _descriptionController.clear();
      _budgetController.clear();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_controller.errorMessage ?? 'Project gagal dibuat.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppGradientBackground(
      child: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            if (_controller.isLoading && _controller.categories.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              children: [
                _buildHero(),
                const SizedBox(height: AppSpacing.xl),
                PremiumGlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Informasi Project', style: AppTextStyles.subtitleLg),
                      const SizedBox(height: AppSpacing.md),
                      _input(
                        controller: _titleController,
                        label: 'Judul Project',
                        hint: 'Contoh: Desain Poster Event Kampus',
                        icon: Icons.title_rounded,
                      ),
                      const SizedBox(height: AppSpacing.base),
                      CategoryDropdown(
                        categories: _controller.categories,
                        selectedCategoryId: _controller.selectedCategoryId,
                        onChanged: _controller.selectCategory,
                      ),
                      const SizedBox(height: AppSpacing.base),
                      DifficultySelector(
                        selectedDifficulty: _controller.selectedDifficulty,
                        onChanged: _controller.selectDifficulty,
                      ),
                      const SizedBox(height: AppSpacing.base),
                      _input(
                        controller: _descriptionController,
                        label: 'Deskripsi Project',
                        hint: 'Jelaskan output, referensi, aturan kerja, dan batasan project.',
                        icon: Icons.notes_rounded,
                        maxLines: 5,
                      ),
                      const SizedBox(height: AppSpacing.base),
                      _input(
                        controller: _budgetController,
                        label: 'Budget',
                        hint: 'Contoh: 150000',
                        icon: Icons.payments_rounded,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: AppSpacing.base),
                      OutlinedButton.icon(
                        onPressed: _pickDeadline,
                        icon: const Icon(Icons.calendar_month_rounded),
                        label: Text(
                          _controller.selectedDeadline == null
                              ? 'Pilih Deadline'
                              : 'Deadline: ${_controller.selectedDeadline!.toIso8601String().split('T').first}',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.base),
                      AntiJokiCheckbox(
                        value: _controller.antiJokiAccepted,
                        onChanged: _controller.setAntiJokiAccepted,
                      ),
                      if (_controller.errorMessage != null) ...[
                        const SizedBox(height: AppSpacing.base),
                        Text(
                          _controller.errorMessage!,
                          style: AppTextStyles.bodySmBold.copyWith(color: AppColors.critical),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      PrimaryButton(
                        text: 'Publikasikan Project',
                        icon: Icons.rocket_launch_rounded,
                        isLoading: _controller.isLoading,
                        variant: PrimaryButtonVariant.cobalt,
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHero() {
    return PremiumGradientCard(
      child: Row(
        children: [
          const Icon(Icons.folder_special_rounded, color: AppColors.canvas, size: 42),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Buat Project', style: AppTextStyles.headingSm.copyWith(color: AppColors.canvas)),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Tulis kebutuhan dengan jelas agar freelancer memahami scope, deadline, dan budget.',
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
