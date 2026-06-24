import 'package:flutter/foundation.dart';

import '../models/admin_dashboard_data.dart';
import '../models/admin_project_item_model.dart';
import '../models/admin_report_item_model.dart';
import '../models/admin_stats_model.dart';
import '../models/admin_user_item_model.dart';
import '../services/admin_dashboard_service.dart';

class AdminDashboardController extends ChangeNotifier {
  final AdminDashboardService _service;

  AdminDashboardController({AdminDashboardService? service})
    : _service = service ?? AdminDashboardService();

  bool isLoading = false;
  bool isActionLoading = false;
  String? errorMessage;
  AdminDashboardData? data;

  AdminStatsModel? get stats => data?.stats;
  List<AdminReportItemModel> get reports => data?.reports ?? [];
  List<AdminUserItemModel> get users => data?.users ?? [];
  List<AdminProjectItemModel> get projects => data?.projects ?? [];

  Future<void> loadDashboard() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      data = await _service.getDashboardData();
    } catch (error, stackTrace) {
      debugPrint('[AdminDashboardController] Error: $error');
      debugPrint('[AdminDashboardController] Stack: $stackTrace');
      errorMessage = error.toString().replaceAll('Exception:', '').trim();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadDashboard();
  }

  Future<void> updateReportStatus(String reportId, String status) async {
    await _runAction(() {
      return _service.updateReportStatus(reportId: reportId, status: status);
    });
  }

  Future<void> updateUserStatus(String userId, String accountStatus) async {
    await _runAction(() {
      return _service.updateUserStatus(
        userId: userId,
        accountStatus: accountStatus,
      );
    });
  }

  Future<void> updateFreelancerVerification(
    String userId,
    String verificationStatus,
  ) async {
    await _runAction(() {
      return _service.updateFreelancerVerification(
        userId: userId,
        verificationStatus: verificationStatus,
      );
    });
  }

  Future<void> updateProjectStatus(String projectId, String status) async {
    await _runAction(() {
      return _service.updateProjectStatus(projectId: projectId, status: status);
    });
  }

  Future<void> _runAction(Future<void> Function() action) async {
    isActionLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await action();
      await loadDashboard();
    } catch (error, stackTrace) {
      debugPrint('[AdminDashboardController] Action Error: $error');
      debugPrint('[AdminDashboardController] Stack: $stackTrace');
      errorMessage = error.toString().replaceAll('Exception:', '').trim();
      isActionLoading = false;
      notifyListeners();
    }
  }
}
