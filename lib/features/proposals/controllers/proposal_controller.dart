import 'package:flutter/material.dart';

import '../models/proposal_model.dart';
import '../services/proposal_service.dart';

class ProposalController extends ChangeNotifier {
  final ProposalService _proposalService;

  ProposalController({ProposalService? proposalService})
    : _proposalService = proposalService ?? ProposalService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> createProposal({
    required String projectId,
    required String projectStatus,
    required String message,
    required String priceText,
    required String estimatedTime,
    required String workMethod,
  }) async {
    errorMessage = null;

    final cleanProjectId = projectId.trim();
    final cleanMessage = message.trim();
    final cleanPriceText = priceText.trim();
    final cleanEstimatedTime = estimatedTime.trim();
    final cleanWorkMethod = workMethod.trim();

    if (cleanProjectId.isEmpty) {
      return _setError('Project tidak valid.');
    }

    if (projectStatus != 'open') {
      return _setError('Project ini sudah tidak menerima proposal.');
    }

    if (cleanMessage.isEmpty) {
      return _setError('Pesan proposal wajib diisi.');
    }

    final price = double.tryParse(cleanPriceText);

    if (price == null) {
      return _setError('Harga proposal harus berupa angka.');
    }

    if (price <= 0) {
      return _setError('Harga proposal harus lebih dari 0.');
    }

    if (cleanEstimatedTime.isEmpty) {
      return _setError('Estimasi waktu wajib diisi.');
    }

    if (cleanWorkMethod.isEmpty) {
      return _setError('Metode kerja wajib diisi.');
    }

    _setLoading(true);

    try {
      final freelancerId = _proposalService.getCurrentUserId();

      final alreadySubmitted = await _proposalService.hasExistingProposal(
        projectId: cleanProjectId,
        freelancerId: freelancerId,
      );

      if (alreadySubmitted) {
        _setLoading(false);
        return _setError('Kamu sudah mengajukan proposal pada project ini.');
      }

      final proposal = ProposalModel(
        projectId: cleanProjectId,
        freelancerId: freelancerId,
        message: cleanMessage,
        price: price,
        estimatedTime: cleanEstimatedTime,
        workMethod: cleanWorkMethod,
      );

      await _proposalService.createProposal(proposal);

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

    if (message.contains('violates row-level security') ||
        message.contains('permission denied')) {
      return 'Akses ditolak. Hanya freelancer yang dapat mengajukan proposal.';
    }

    if (message.contains('duplicate key')) {
      return 'Kamu sudah pernah mengajukan proposal pada project ini.';
    }

    if (message.contains('User belum login')) {
      return 'User belum login. Silakan login ulang.';
    }

    return message.replaceAll('Exception:', '').trim();
  }
}
