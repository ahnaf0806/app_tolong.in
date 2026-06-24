import 'package:flutter/foundation.dart';

import '../models/admin_moderation_item_model.dart';
import '../services/admin_moderation_service.dart';

class AdminModerationController extends ChangeNotifier {
  final AdminModerationService _service;

  AdminModerationController({AdminModerationService? service})
      : _service = service ?? AdminModerationService();

  bool isLoading = false;
  String? errorMessage;
  List<AdminModerationItemModel> items = [];

  Future<void> loadQueue() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      items = await _service.getQueue();
    } catch (error, stackTrace) {
      debugPrint('[AdminModerationController] Error: $error');
      debugPrint('[AdminModerationController] Stack: $stackTrace');
      errorMessage = error.toString().replaceAll('Exception:', '').trim();
    }

    isLoading = false;
    notifyListeners();
  }
}
