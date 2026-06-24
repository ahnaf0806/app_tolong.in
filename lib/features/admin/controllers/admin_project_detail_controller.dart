import 'package:flutter/foundation.dart';

import '../models/admin_project_detail_model.dart';
import '../services/admin_project_detail_service.dart';

class AdminProjectDetailController extends ChangeNotifier {
  final AdminProjectDetailService _service;

  AdminProjectDetailController({AdminProjectDetailService? service})
    : _service = service ?? AdminProjectDetailService();

  bool isLoading = false;
  bool isActionLoading = false;
  String? errorMessage;
  AdminProjectDetailModel? project;

  Future<void> loadProject(String projectId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      project = await _service.getProjectDetail(projectId);
    } catch (error, stackTrace) {
      debugPrint('[AdminProjectDetailController] Error: $error');
      debugPrint('[AdminProjectDetailController] Stack: $stackTrace');
      errorMessage = _cleanError(error);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateProjectStatus(String projectId, String status) async {
    isActionLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _service.updateProjectStatus(projectId: projectId, status: status);

      await loadProject(projectId);
    } catch (error, stackTrace) {
      debugPrint('[AdminProjectDetailController] Action Error: $error');
      debugPrint('[AdminProjectDetailController] Stack: $stackTrace');
      errorMessage = _cleanError(error);
      isActionLoading = false;
      notifyListeners();
    }
  }

  String _cleanError(Object error) {
    return error.toString().replaceAll('Exception:', '').trim();
  }
}
