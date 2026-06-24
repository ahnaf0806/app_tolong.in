import 'package:flutter/foundation.dart';

import '../models/admin_audit_log_model.dart';
import '../services/admin_audit_log_service.dart';

class AdminLogsController extends ChangeNotifier {
  final AdminAuditLogService _service;

  AdminLogsController({AdminAuditLogService? service})
      : _service = service ?? AdminAuditLogService();

  bool isLoading = false;
  String? errorMessage;
  List<AdminAuditLogModel> logs = [];

  Future<void> loadLogs() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      logs = await _service.getLogs();
    } catch (error, stackTrace) {
      debugPrint('[AdminLogsController] Error: $error');
      debugPrint('[AdminLogsController] Stack: $stackTrace');
      errorMessage = error.toString().replaceAll('Exception:', '').trim();
    }

    isLoading = false;
    notifyListeners();
  }
}
