import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_gradient_background.dart';
import '../../../core/widgets/primary_button.dart';
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
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxxl),
        ),
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
    return AppGradientBackground(
      child: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            if (_controller.isLoading && _controller.profile == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_controller.errorMessage != null &&
                _controller.profile == null) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: AppErrorState(
                  message: _controller.errorMessage!,
                  onRetry: _controller.loadProfile,
                ),
              );
            }

            final profile = _controller.profile;

            if (profile == null) {
              return const Center(child: Text('Profil tidak ditemukan.'));
            }

            return RefreshIndicator(
              color: AppColors.primary,
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
                  _ProfileActionButtons(
                    onEdit: () => _openEditSheet(profile),
                    onLogout: _logout,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ProfileInfoCard(profile: profile),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onLogout;

  const _ProfileActionButtons({required this.onEdit, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 420;

        final editButton = PrimaryButton(
          text: 'Edit Profil',
          icon: Icons.edit_rounded,
          variant: PrimaryButtonVariant.cobalt,
          onPressed: onEdit,
        );

        final logoutButton = OutlinedButton.icon(
          onPressed: onLogout,
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Logout'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: BorderSide(
              color: Colors.red.withValues(alpha: 0.45),
              width: 1.2,
            ),
            backgroundColor: Colors.red.withValues(alpha: 0.06),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.base,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
        );

        if (isCompact) {
          return Column(
            children: [
              SizedBox(width: double.infinity, child: editButton),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(width: double.infinity, child: logoutButton),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: editButton),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: logoutButton),
          ],
        );
      },
    );
  }
}
