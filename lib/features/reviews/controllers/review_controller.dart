import 'package:flutter/material.dart';

import '../models/review_model.dart';
import '../services/review_service.dart';

class ReviewController extends ChangeNotifier {
  final ReviewService _reviewService;

  ReviewController({ReviewService? reviewService})
    : _reviewService = reviewService ?? ReviewService();

  bool isLoading = false;
  String? errorMessage;
  int selectedRating = 5;

  void setRating(int rating) {
    selectedRating = rating;
    notifyListeners();
  }

  Future<bool> submitReview({
    required String workspaceId,
    required String freelancerId,
    required String workspaceStatus,
    required String comment,
  }) async {
    errorMessage = null;

    final cleanComment = comment.trim();

    if (workspaceId.isEmpty) {
      return _setError('Workspace tidak valid.');
    }

    if (freelancerId.isEmpty) {
      return _setError('Freelancer tidak valid.');
    }

    if (workspaceStatus != 'completed') {
      return _setError('Review hanya dapat diberikan setelah project selesai.');
    }

    if (selectedRating < 1 || selectedRating > 5) {
      return _setError('Rating harus bernilai 1 sampai 5.');
    }

    if (cleanComment.isEmpty) {
      return _setError('Komentar review wajib diisi.');
    }

    _setLoading(true);

    try {
      final reviewerId = _reviewService.getCurrentUserId();

      final alreadyReviewed = await _reviewService.hasReviewedWorkspace(
        workspaceId,
      );

      if (alreadyReviewed) {
        _setLoading(false);
        return _setError('Kamu sudah memberikan review untuk workspace ini.');
      }

      final review = ReviewModel(
        workspaceId: workspaceId,
        reviewerId: reviewerId,
        freelancerId: freelancerId,
        rating: selectedRating,
        comment: cleanComment,
      );

      await _reviewService.createReview(review);

      _setLoading(false);
      return true;
    } catch (error) {
      errorMessage = _cleanError(error);
      _setLoading(false);
      return false;
    }
  }

  bool _setError(String message) {
    errorMessage = message;
    notifyListeners();
    return false;
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  String _cleanError(Object error) {
    final message = error.toString();

    if (message.contains('duplicate key')) {
      return 'Kamu sudah memberikan review untuk workspace ini.';
    }

    if (message.contains('violates row-level security') ||
        message.contains('permission denied')) {
      return 'Akses ditolak. Review hanya dapat diberikan oleh project owner setelah project selesai.';
    }

    if (message.contains('User belum login')) {
      return 'User belum login. Silakan login ulang.';
    }

    return message.replaceAll('Exception:', '').trim();
  }
}
