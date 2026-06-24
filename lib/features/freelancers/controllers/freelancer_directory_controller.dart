import 'package:flutter/foundation.dart';

import '../models/freelancer_summary_model.dart';
import '../services/freelancer_service.dart';

class FreelancerDirectoryController extends ChangeNotifier {
  final FreelancerService _freelancerService;

  FreelancerDirectoryController({FreelancerService? freelancerService})
    : _freelancerService = freelancerService ?? FreelancerService();

  bool isLoading = false;
  String? errorMessage;
  List<FreelancerSummaryModel> freelancers = [];

  Future<void> loadFreelancers() async {
    _setLoading(true);
    errorMessage = null;

    try {
      freelancers = await _freelancerService.getFreelancers();
    } catch (error, stackTrace) {
      debugPrint('[FreelancerDirectoryController] Error: $error');
      debugPrint('[FreelancerDirectoryController] Stack: $stackTrace');
      errorMessage = _cleanError(error);
    }

    _setLoading(false);
  }

  Future<void> refresh() async {
    await loadFreelancers();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  String _cleanError(Object error) {
    final message = error.toString();

    if (message.contains('JWTExpired') ||
        message.contains('not authenticated')) {
      return 'Sesi kamu telah berakhir. Silakan login ulang.';
    }

    if (message.contains('permission denied') ||
        message.contains('row-level security')) {
      return 'Akses ditolak. Pastikan policy SELECT untuk profiles dan freelancer_profiles sudah aktif.';
    }

    return message.replaceAll('Exception:', '').trim();
  }
}
