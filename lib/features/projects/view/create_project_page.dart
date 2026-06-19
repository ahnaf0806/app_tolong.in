import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
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

    if (selectedDate != null) {
      _controller.selectDeadline(selectedDate);
    }
  }

  Future<void> _submit() async {
    final success = await _controller.createProject(
      title: _titleController.text,
      description: _descriptionController.text,
      budgetText: _budgetController.text,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Project berhasil dibuat.')));

      _titleController.clear();
      _descriptionController.clear();
      _budgetController.clear();

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_controller.errorMessage ?? 'Project gagal dibuat.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        if (_controller.isLoading && _controller.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Text('Buat Project', style: AppTextStyles.headingLg),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Isi kebutuhan project dengan jelas agar freelancer memahami scope, deadline, dan budget.',
              style: AppTextStyles.bodyMd,
            ),
            const SizedBox(height: AppSpacing.xl),

            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Project',
                hintText: 'Contoh: Desain Poster Event Kampus',
                border: OutlineInputBorder(),
              ),
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

            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Project',
                hintText:
                    'Jelaskan kebutuhan, output yang diharapkan, referensi, dan aturan kerja.',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.base),

            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Budget',
                hintText: 'Contoh: 150000',
                border: OutlineInputBorder(),
              ),
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
            const SizedBox(height: AppSpacing.lg),

            if (_controller.errorMessage != null) ...[
              Text(
                _controller.errorMessage!,
                style: AppTextStyles.bodySm.copyWith(color: Colors.red),
              ),
              const SizedBox(height: AppSpacing.base),
            ],

            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _controller.isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: _controller.isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Publikasikan Project'),
              ),
            ),
          ],
        );
      },
    );
  }
}
