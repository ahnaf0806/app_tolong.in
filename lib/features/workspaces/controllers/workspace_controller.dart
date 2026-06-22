import 'package:flutter/material.dart';

import '../models/workspace_model.dart';
import '../services/workspace_service.dart';

class WorkspaceController extends ChangeNotifier {
  final WorkspaceService _workspaceService = WorkspaceService();

  bool _isLoading = false;
  String? _errorMessage;
  List<WorkspaceModel> _workspaces = [];
  WorkspaceModel? _selectedWorkspace;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<WorkspaceModel> get workspaces => _workspaces;
  WorkspaceModel? get selectedWorkspace => _selectedWorkspace;

  Future<void> loadWorkspaces() async {
    _setLoading(true);
    _clearError();

    try {
      _workspaces = await _workspaceService.getMyWorkspaces();
      _setLoading(false);
    } catch (error) {
      _setError(_cleanError(error));
      _setLoading(false);
    }
  }

  Future<void> loadWorkspaceDetail(String workspaceId) async {
    _setLoading(true);
    _clearError();

    try {
      _selectedWorkspace = await _workspaceService.getWorkspaceDetail(workspaceId);
      _setLoading(false);
    } catch (error) {
      _setError(_cleanError(error));
      _setLoading(false);
    }
  }

  Future<bool> submitWorkspace({
    required String workspaceId,
    required String resultFileUrl,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _workspaceService.markWorkspaceSubmitted(
        workspaceId: workspaceId,
        resultFileUrl: resultFileUrl,
      );
      await loadWorkspaces();
      _setLoading(false);
      return true;
    } catch (error) {
      _setError(_cleanError(error));
      _setLoading(false);
      return false;
    }
  }

  Future<bool> completeWorkspace(String workspaceId) async {
    _setLoading(true);
    _clearError();

    try {
      await _workspaceService.markWorkspaceCompleted(workspaceId);
      await loadWorkspaces();
      _setLoading(false);
      return true;
    } catch (error) {
      _setError(_cleanError(error));
      _setLoading(false);
      return false;
    }
  }

  void clearSelectedWorkspace() {
    _selectedWorkspace = null;
    notifyListeners();
  }

  String getCurrentUserId() {
    return _workspaceService.getCurrentUserId();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  String _cleanError(Object error) {
    final message = error.toString();

    if (message.contains('User belum login')) {
      return 'Silakan login terlebih dahulu.';
    }

    if (message.contains('violates row-level security')) {
      return 'Akses ditolak. Anda tidak memiliki izin untuk workspace ini.';
    }

    return message.replaceAll('Exception:', '').trim();
  }
}