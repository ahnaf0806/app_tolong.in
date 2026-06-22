import 'package:flutter/foundation.dart';

import '../models/project_model.dart';
import '../services/project_service.dart';

class OwnerProjectListController extends ChangeNotifier {
  final ProjectService _projectService;

  OwnerProjectListController({ProjectService? projectService})
      : _projectService = projectService ?? ProjectService();

  bool isLoading = false;
  String? errorMessage;
  List<ProjectModel> projects = [];

  Future<void> loadProjects() async {
    _setLoading(true);
    errorMessage = null;

    try {
      final ownerId = _projectService.getCurrentUserId();
      projects = await _projectService.getProjectsByOwner(ownerId);
    } catch (error, stack) {
      debugPrint('[OwnerProjectListController] Error: $error');
      debugPrint('[OwnerProjectListController] Stack: $stack');
      errorMessage = _cleanError(error);
    }

    _setLoading(false);
  }

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
    return 'Gagal memuat project: $message';
  }
}
