import 'package:flutter/material.dart';

import '../models/project_category_model.dart';
import '../models/project_model.dart';
import '../services/project_service.dart';

class ProjectController extends ChangeNotifier {
  final ProjectService _projectService;

  ProjectController({ProjectService? projectService})
    : _projectService = projectService ?? ProjectService();

  bool isLoading = false;
  String? errorMessage;

  List<ProjectCategoryModel> categories = [];
  String? selectedCategoryId;
  String selectedDifficulty = 'medium';
  DateTime? selectedDeadline;
  bool antiJokiAccepted = false;

  ProjectCategoryModel? get selectedCategory {
    if (selectedCategoryId == null) {
      return null;
    }

    for (final category in categories) {
      if (category.id == selectedCategoryId) {
        return category;
      }
    }

    return null;
  }

  Future<void> loadCategories() async {
    _setLoading(true);
    errorMessage = null;

    try {
      categories = await _projectService.getCategories();

      if (categories.isNotEmpty) {
        selectedCategoryId = categories.first.id;
      }
    } catch (error) {
      errorMessage = _cleanError(error);
    }

    _setLoading(false);
  }

  void selectCategory(String? categoryId) {
    selectedCategoryId = categoryId;
    notifyListeners();
  }

  void selectDifficulty(String difficulty) {
    selectedDifficulty = difficulty;
    notifyListeners();
  }

  void selectDeadline(DateTime date) {
    selectedDeadline = date;
    notifyListeners();
  }

  void setAntiJokiAccepted(bool value) {
    antiJokiAccepted = value;
    notifyListeners();
  }

  Future<bool> createProject({
    required String title,
    required String description,
    required String budgetText,
  }) async {
    errorMessage = null;

    final cleanTitle = title.trim();
    final cleanDescription = description.trim();
    final cleanBudgetText = budgetText.trim();

    if (cleanTitle.isEmpty) {
      errorMessage = 'Judul project wajib diisi.';
      notifyListeners();
      return false;
    }

    if (selectedCategory == null) {
      errorMessage = 'Kategori project wajib dipilih.';
      notifyListeners();
      return false;
    }

    if (cleanDescription.isEmpty) {
      errorMessage = 'Deskripsi project wajib diisi.';
      notifyListeners();
      return false;
    }

    if (selectedDeadline == null) {
      errorMessage = 'Deadline project wajib dipilih.';
      notifyListeners();
      return false;
    }

    final budget = double.tryParse(cleanBudgetText);

    if (budget == null || budget <= 0) {
      errorMessage = 'Budget harus berupa angka lebih dari 0.';
      notifyListeners();
      return false;
    }

    if (!antiJokiAccepted) {
      errorMessage =
          'Kamu harus menyetujui bahwa project ini bukan joki tugas.';
      notifyListeners();
      return false;
    }

    if (_containsForbiddenKeyword('$cleanTitle $cleanDescription')) {
      errorMessage =
          'Project terdeteksi mengandung kata yang mengarah ke joki/ujian. Ubah deskripsi agar sesuai aturan.';
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      final ownerId = _projectService.getCurrentUserId();

      final project = ProjectModel(
        ownerId: ownerId,
        categoryId: selectedCategory!.id,
        title: cleanTitle,
        projectField: selectedCategory!.name,
        description: cleanDescription,
        deadline: selectedDeadline!,
        budget: budget,
        difficulty: selectedDifficulty,
      );

      await _projectService.createProject(project);

      _setLoading(false);
      return true;
    } catch (error) {
      errorMessage = _cleanError(error);
      _setLoading(false);
      return false;
    }
  }

  bool _containsForbiddenKeyword(String text) {
    final lowerText = text.toLowerCase();

    final keywords = [
      'joki',
      'ujian',
      'quiz',
      'kuis',
      'jawaban ujian',
      'kerjakan tugas',
      'tinggal kumpul',
      'skripsi full',
      'tesis full',
      'buatkan skripsi',
      'buatkan tesis',
    ];

    return keywords.any(lowerText.contains);
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  String _cleanError(Object error) {
    final message = error.toString();

    if (message.contains('violates row-level security')) {
      return 'Akses ditolak. Hanya Project Owner yang dapat membuat project.';
    }

    if (message.contains('User belum login')) {
      return 'User belum login. Silakan login ulang.';
    }

    return message.replaceAll('Exception:', '').trim();
  }
}
