import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/profile_controller.dart';
import '../models/profile_model.dart';
import '../widgets/profile_edit_sheet.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_info_card.dart';

class ProfilePage extends StatefulWidget {
  final Future<void> Function()? onLogout;

  const ProfilePage({super.key, this.onLogout});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController _controller = ProfileController();

  @override
  void initState() {
    super.initState();
    _controller.loadProfile();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _changePhoto() async {
    final success = await _controller.pickAndUploadPhoto();

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto profil berhasil diperbarui.')),
      );
      return;
    }

    if (_controller.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_controller.errorMessage!)));
    }
  }

  Future<void> _openEditSheet(ProfileModel profile) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.canvas,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return ProfileEditSheet(
              profile: profile,
              isSaving: _controller.isSaving,
              onSave: _controller.updateProfile,
            );
          },
        );
      },
    );

    if (!mounted) {
      return;
    }

    if (_controller.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_controller.errorMessage!)));
    }
  }

  Future<void> _logout() async {
    if (widget.onLogout != null) {
      await widget.onLogout!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        if (_controller.isLoading && _controller.profile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.errorMessage != null && _controller.profile == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(
                _controller.errorMessage!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.critical),
              ),
            ),
          );
        }

        final profile = _controller.profile;

        if (profile == null) {
          return const Center(child: Text('Profil tidak ditemukan.'));
        }

        return RefreshIndicator(
          onRefresh: _controller.loadProfile,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              ProfileHeaderCard(
                profile: profile,
                isUploadingPhoto: _controller.isUploadingPhoto,
                onChangePhoto: _changePhoto,
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _openEditSheet(profile),
                      icon: const Icon(Icons.edit_rounded),
                      label: const Text('Edit Profil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout_rounded),
                    tooltip: 'Logout',
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surfaceSoft,
                      foregroundColor: AppColors.critical,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(profile: profile),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        );
      },
    );
  }
}
