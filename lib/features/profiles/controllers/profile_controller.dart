import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/profile_model.dart';
import '../services/profile_service.dart';

class ProfileController extends ChangeNotifier {
  final ProfileService _profileService;

  ProfileController({ProfileService? profileService})
    : _profileService = profileService ?? ProfileService();

  bool isLoading = false;
  bool isSaving = false;
  bool isUploadingPhoto = false;
  String? errorMessage;

  ProfileModel? profile;

  Future<void> loadProfile() async {
    _setLoading(true);
    errorMessage = null;

    try {
      profile = await _profileService.getCurrentProfile();
    } catch (error) {
      errorMessage = _cleanError(error);
    }

    _setLoading(false);
  }

  Future<bool> updateProfile({
    required String name,
    String? university,
    String? studyProgram,
    int? semester,
    String? bio,
    required String skillsText,
    String? portfolioUrl,
  }) async {
    errorMessage = null;

    final currentProfile = profile;

    if (currentProfile == null) {
      return _setError('Profil tidak ditemukan.');
    }

    if (name.trim().isEmpty) {
      return _setError('Nama wajib diisi.');
    }

    final skills = skillsText
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    _setSaving(true);

    try {
      await _profileService.updateProfile(
        name: name,
        university: university,
        studyProgram: studyProgram,
        semester: semester,
        bio: bio,
        skills: skills,
        portfolioUrl: portfolioUrl,
        isFreelancer: currentProfile.isFreelancer,
      );

      profile = await _profileService.getCurrentProfile();

      _setSaving(false);
      return true;
    } catch (error) {
      errorMessage = _cleanError(error);
      _setSaving(false);
      return false;
    }
  }

  Future<bool> pickAndUploadPhoto() async {
    errorMessage = null;

    try {
      final picker = ImagePicker();

      final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
        maxWidth: 800,
      );

      if (image == null) {
        return false;
      }

      _setUploadingPhoto(true);

      await _profileService.uploadProfilePhoto(image.path);

      profile = await _profileService.getCurrentProfile();

      _setUploadingPhoto(false);
      return true;
    } catch (error) {
      errorMessage = _cleanError(error);
      _setUploadingPhoto(false);
      return false;
    }
  }

  bool _setError(String message) {
    errorMessage = message;
    notifyListeners();
    return false;
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setSaving(bool value) {
    isSaving = value;
    notifyListeners();
  }

  void _setUploadingPhoto(bool value) {
    isUploadingPhoto = value;
    notifyListeners();
  }

  String _cleanError(Object error) {
    final message = error.toString();

    if (message.contains('violates row-level security') ||
        message.contains('permission denied')) {
      return 'Akses profil ditolak oleh Supabase RLS.';
    }

    if (message.contains('User belum login')) {
      return 'User belum login. Silakan login ulang.';
    }

    if (message.contains('StorageException')) {
      return 'Gagal mengupload foto. Pastikan bucket profile-photos sudah dibuat.';
    }

    return message.replaceAll('Exception:', '').trim();
  }
}
