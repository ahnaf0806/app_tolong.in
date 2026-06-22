import 'package:flutter/foundation.dart';

import '../models/project_model.dart';
import '../services/project_service.dart';

/// Controller untuk halaman Cari Project (freelancer).
/// Mengelola state daftar project, loading, dan error.
class ProjectListController extends ChangeNotifier {
  final ProjectService _projectService;

  ProjectListController({ProjectService? projectService})
    : _projectService = projectService ?? ProjectService();

  bool isLoading = false;
  String? errorMessage;
  List<ProjectModel> projects = [];

  /// Memuat daftar project dengan status 'open' dari Supabase.
  Future<void> loadProjects() async {
    _setLoading(true);
    errorMessage = null;

    try {
      projects = await _projectService.getOpenProjects();
    } catch (error, stack) {
      debugPrint('[ProjectListController] Error: $error');
      debugPrint('[ProjectListController] Stack: $stack');
      errorMessage = _cleanError(error);
    }

    _setLoading(false);
  }

  /// Refresh data project (untuk RefreshIndicator).
  Future<void> refresh() async {
    await loadProjects();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  String _cleanError(Object error) {
    final message = error.toString();

    if (message.contains('JWTExpired') || message.contains('not authenticated')) {
      return 'Sesi kamu telah berakhir. Silakan login ulang.';
    }

    if (message.contains('permission denied') || message.contains('row-level security')) {
      return 'Akses ditolak (RLS). Pastikan policy SELECT pada tabel projects sudah aktif.';
    }

    if (message.contains('Could not find a relationship')) {
      return 'Relasi tabel tidak ditemukan. Periksa foreign key projects → profiles di Supabase.';
    }

    // Tampilkan pesan asli dari Supabase agar mudah debug
    return 'Error: $message';
  }
}
