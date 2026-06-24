import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../models/profile_model.dart';

class ProfileEditSheet extends StatefulWidget {
  final ProfileModel profile;
  final bool isSaving;
  final Future<bool> Function({
    required String name,
    String? university,
    String? studyProgram,
    int? semester,
    String? bio,
    required String skillsText,
    String? portfolioUrl,
  }) onSave;

  const ProfileEditSheet({
    super.key,
    required this.profile,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends State<ProfileEditSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _universityController;
  late final TextEditingController _studyProgramController;
  late final TextEditingController _semesterController;
  late final TextEditingController _bioController;
  late final TextEditingController _skillsController;
  late final TextEditingController _portfolioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _universityController = TextEditingController(text: widget.profile.university ?? '');
    _studyProgramController = TextEditingController(text: widget.profile.studyProgram ?? '');
    _semesterController = TextEditingController(text: widget.profile.semester?.toString() ?? '');
    _bioController = TextEditingController(text: widget.profile.bio ?? '');
    _skillsController = TextEditingController(text: widget.profile.skills.join(', '));
    _portfolioController = TextEditingController(text: widget.profile.portfolioUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _universityController.dispose();
    _studyProgramController.dispose();
    _semesterController.dispose();
    _bioController.dispose();
    _skillsController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final semester = _semesterController.text.trim().isEmpty
        ? null
        : int.tryParse(_semesterController.text.trim());

    final success = await widget.onSave(
      name: _nameController.text,
      university: _universityController.text,
      studyProgram: _studyProgramController.text,
      semester: semester,
      bio: _bioController.text,
      skillsText: _skillsController.text,
      portfolioUrl: _portfolioController.text,
    );

    if (!mounted) return;
    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isFreelancer = widget.profile.isFreelancer;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.xl,
          right: AppSpacing.xl,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
        ),
        child: SingleChildScrollView(
          child: Column(
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
              Text('Edit Profil', style: AppTextStyles.headingSm),
              const SizedBox(height: AppSpacing.lg),
              _input(controller: _nameController, label: 'Nama Lengkap', icon: Icons.person_rounded),
              if (isFreelancer) ...[
                const SizedBox(height: AppSpacing.base),
                _input(controller: _universityController, label: 'Universitas', icon: Icons.school_rounded),
                const SizedBox(height: AppSpacing.base),
                _input(controller: _studyProgramController, label: 'Program Studi', icon: Icons.menu_book_rounded),
                const SizedBox(height: AppSpacing.base),
                _input(
                  controller: _semesterController,
                  label: 'Semester',
                  icon: Icons.timeline_rounded,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.base),
                _input(controller: _skillsController, label: 'Skills', hint: 'Contoh: Flutter, UI Design, Excel', icon: Icons.psychology_rounded),
                const SizedBox(height: AppSpacing.base),
                _input(controller: _portfolioController, label: 'Link Portfolio', icon: Icons.link_rounded),
                const SizedBox(height: AppSpacing.base),
                _input(controller: _bioController, label: 'Bio', icon: Icons.notes_rounded, maxLines: 4),
              ],
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                text: 'Simpan Profil',
                icon: Icons.save_rounded,
                isLoading: widget.isSaving,
                variant: PrimaryButtonVariant.cobalt,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
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
