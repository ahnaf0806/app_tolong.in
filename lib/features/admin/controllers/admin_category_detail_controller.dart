import 'package:flutter/foundation.dart';

import '../models/admin_category_detail_model.dart';
import '../services/admin_category_detail_service.dart';

class AdminCategoryDetailController extends ChangeNotifier {
  final AdminCategoryDetailService _service;

  AdminCategoryDetailController({AdminCategoryDetailService? service})
      : _service = service ?? AdminCategoryDetailService();

  bool isLoading = false;
  String? errorMessage;
  AdminCategoryDetailModel? category;

  Future<void> loadCategory(String categoryId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      category = await _service.getCategoryDetail(categoryId);
    } catch (error, stackTrace) {
      debugPrint('[AdminCategoryDetailController] Error: $error');
      debugPrint('[AdminCategoryDetailController] Stack: $stackTrace');
      errorMessage = error.toString().replaceAll('Exception:', '').trim();
    }

    isLoading = false;
    notifyListeners();
  }
}
