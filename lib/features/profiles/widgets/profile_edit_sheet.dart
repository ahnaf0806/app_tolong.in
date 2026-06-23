import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
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
  })
  onSave;

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
    _universityController = TextEditingController(
      text: widget.profile.university ?? '',
    );
    _studyProgramController = TextEditingController(
      text: widget.profile.studyProgram ?? '',
    );
    _semesterController = TextEditingController(
      text: widget.profile.semester?.toString() ?? '',
    );
    _bioController = TextEditingController(text: widget.profile.bio ?? '');
    _skillsController = TextEditingController(
      text: widget.profile.skills.join(', '),
    );
    _portfolioController = TextEditingController(
      text: widget.profile.portfolioUrl ?? '',
    );
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

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFreelancer = widget.profile.isFreelancer;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.xl,
          right: AppSpacing.xl,
          top: AppSpacing.xl,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Edit Profil',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
              ),
              if (isFreelancer) ...[
                const SizedBox(height: AppSpacing.base),
                TextField(
                  controller: _universityController,
                  decoration: const InputDecoration(
                    labelText: 'Universitas',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.base),
                TextField(
                  controller: _studyProgramController,
                  decoration: const InputDecoration(
                    labelText: 'Program Studi',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.base),
                TextField(
                  controller: _semesterController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Semester',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.base),
                TextField(
                  controller: _skillsController,
                  decoration: const InputDecoration(
                    labelText: 'Skills',
                    hintText: 'Contoh: Flutter, UI Design, Excel',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.base),
                TextField(
                  controller: _portfolioController,
                  decoration: const InputDecoration(
                    labelText: 'Link Portfolio',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.base),
                TextField(
                  controller: _bioController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: widget.isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: widget.isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Simpan Profil'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
