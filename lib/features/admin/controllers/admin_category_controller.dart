import 'package:flutter/foundation.dart';

import '../models/admin_category_item_model.dart';
import '../services/admin_category_service.dart';

class AdminCategoryController extends ChangeNotifier {
  final AdminCategoryService _service;

  AdminCategoryController({AdminCategoryService? service})
    : _service = service ?? AdminCategoryService();

  bool isLoading = false;
  bool isActionLoading = false;
  String? errorMessage;
  List<AdminCategoryItemModel> categories = [];

  Future<void> loadCategories() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      categories = await _service.getCategories();
    } catch (error, stackTrace) {
      debugPrint('[AdminCategoryController] Error: $error');
      debugPrint('[AdminCategoryController] Stack: $stackTrace');
      errorMessage = _cleanError(error);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> createCategory({
    required String name,
    required String description,
    required int displayOrder,
    required bool isActive,
  }) async {
    await _runAction(() {
      return _service.createCategory(
        name: name,
        description: description,
        displayOrder: displayOrder,
        isActive: isActive,
      );
    });
  }

  Future<void> updateCategory({
    required String id,
    required String name,
    required String description,
    required int displayOrder,
    required bool isActive,
  }) async {
    await _runAction(() {
      return _service.updateCategory(
        id: id,
        name: name,
        description: description,
        displayOrder: displayOrder,
        isActive: isActive,
      );
    });
  }

  Future<void> toggleCategory(AdminCategoryItemModel category) async {
    await _runAction(() {
      return _service.setCategoryActive(
        id: category.id,
        isActive: !category.isActive,
      );
    });
  }

  Future<void> deleteCategory(AdminCategoryItemModel category) async {
    await _runAction(() {
      return _service.deleteCategory(category: category);
    });
  }

  Future<void> _runAction(Future<void> Function() action) async {
    isActionLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await action();
      await loadCategories();
    } catch (error, stackTrace) {
      debugPrint('[AdminCategoryController] Action Error: $error');
      debugPrint('[AdminCategoryController] Stack: $stackTrace');
      errorMessage = _cleanError(error);
      isActionLoading = false;
      notifyListeners();
    }
  }

  String _cleanError(Object error) {
    return error.toString().replaceAll('Exception:', '').trim();
  }
}
