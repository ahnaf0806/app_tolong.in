import 'package:flutter/material.dart';

import '../models/proposal_model.dart';
import '../services/proposal_service.dart';

class ManageProposalController extends ChangeNotifier {
  final ProposalService _proposalService;

  ManageProposalController({ProposalService? proposalService})
    : _proposalService = proposalService ?? ProposalService();

  bool isLoading = false;
  bool isActionLoading = false;
  String? errorMessage;
  List<ProposalModel> proposals = [];

  Future<void> loadProposals(String projectId) async {
    _setLoading(true);
    errorMessage = null;

    try {
      proposals = await _proposalService.getProposalsByProject(projectId);
    } catch (error) {
      errorMessage = _cleanError(error);
    }

    _setLoading(false);
  }

  Future<bool> acceptProposal({
    required String proposalId,
    required String projectId,
    required String freelancerId,
  }) async {
    _setActionLoading(true);
    errorMessage = null;

    try {
      final ownerId = _proposalService.getCurrentUserId();

      await _proposalService.acceptProposal(
        proposalId: proposalId,
        projectId: projectId,
        freelancerId: freelancerId,
        ownerId: ownerId,
      );

      _setActionLoading(false);
      return true;
    } catch (error) {
      errorMessage = _cleanError(error);
      _setActionLoading(false);
      return false;
    }
  }

  Future<bool> rejectProposal(String proposalId) async {
    _setActionLoading(true);
    errorMessage = null;

    try {
      await _proposalService.rejectProposal(proposalId);

      _setActionLoading(false);
      return true;
    } catch (error) {
      errorMessage = _cleanError(error);
      _setActionLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setActionLoading(bool value) {
    isActionLoading = value;
    notifyListeners();
  }

  String _cleanError(Object error) {
    final message = error.toString();

    if (message.contains('violates row-level security') ||
        message.contains('permission denied')) {
      return 'Akses ditolak oleh Supabase RLS.';
    }

    if (message.contains('User belum login')) {
      return 'User belum login. Silakan login ulang.';
    }

    return message.replaceAll('Exception:', '').trim();
  }
}
