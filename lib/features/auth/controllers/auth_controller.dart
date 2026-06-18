import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService;

  AuthController({AuthService? authService})
    : _authService = authService ?? AuthService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    errorMessage = null;

    try {
      await _authService.login(email: email, password: password);

      _setLoading(false);
      return true;
    } catch (error) {
      errorMessage = _cleanError(error);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String university,
    required String studyProgram,
    required int semester,
    required String role,
  }) async {
    _setLoading(true);
    errorMessage = null;

    try {
      await _authService.register(
        name: name,
        email: email,
        password: password,
        university: university,
        studyProgram: studyProgram,
        semester: semester,
        role: role,
      );

      _setLoading(false);
      return true;
    } catch (error) {
      errorMessage = _cleanError(error);
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  String _cleanError(Object error) {
    final message = error.toString();

    if (message.contains('Invalid login credentials')) {
      return 'Email atau password salah.';
    }

    if (message.contains('User already registered')) {
      return 'Email ini sudah terdaftar.';
    }

    if (message.contains('Password should be at least')) {
      return 'Password terlalu pendek.';
    }

    if (message.contains('duplicate key')) {
      return 'Data sudah terdaftar.';
    }

    if (message.contains('violates row-level security')) {
      return 'Akses ditolak oleh Supabase RLS.';
    }
    if (message.contains('Email not confirmed')) {
      return 'Email belum dikonfirmasi. Silakan cek inbox atau spam email kamu.';
    }

    return message.replaceAll('Exception:', '').trim();
  }
}
