import 'package:flutter/material.dart';

import '../models/owner_proposal_item.dart';
import '../services/proposal_service.dart';

class OwnerProposalController extends ChangeNotifier {
  final ProposalService _proposalService;

  OwnerProposalController({ProposalService? proposalService})
    : _proposalService = proposalService ?? ProposalService();

  bool isLoading = false;
  String? errorMessage;
  List<OwnerProposalItem> proposals = [];

  Future<void> loadProposals() async {
    _setLoading(true);
    errorMessage = null;

    try {
      proposals = await _proposalService.getOwnerProposals();
    } catch (error) {
      errorMessage = _cleanError(error);
    }

    _setLoading(false);
  }

  Future<bool> acceptProposal(OwnerProposalItem proposal) async {
    _setLoading(true);
    errorMessage = null;

    try {
      await _proposalService.acceptOwnerProposal(proposal);
      proposals = await _proposalService.getOwnerProposals();
      _setLoading(false);
      return true;
    } catch (error) {
      errorMessage = _cleanError(error);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> rejectProposal(String proposalId) async {
    _setLoading(true);
    errorMessage = null;

    try {
      await _proposalService.rejectProposal(proposalId);
      proposals = await _proposalService.getOwnerProposals();
      _setLoading(false);
      return true;
    } catch (error) {
      errorMessage = _cleanError(error);
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
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
