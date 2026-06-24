import 'package:flutter/material.dart';

import '../models/my_proposal_item.dart';
import '../services/proposal_service.dart';

class MyProposalController extends ChangeNotifier {
  final ProposalService _proposalService;

  MyProposalController({ProposalService? proposalService})
    : _proposalService = proposalService ?? ProposalService();

  bool isLoading = false;
  String? errorMessage;
  List<MyProposalItem> proposals = [];

  Future<void> loadProposals() async {
    _setLoading(true);
    errorMessage = null;

    try {
      proposals = await _proposalService.getMyProposals();
    } catch (error) {
      errorMessage = _cleanError(error);
    }

    _setLoading(false);
  }

  Future<void> refresh() async {
    await loadProposals();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  String _cleanError(Object error) {
    final message = error.toString();

    if (message.contains('SocketException') ||
        message.contains('Failed host lookup') ||
        message.contains('Network is unreachable')) {
      return 'Koneksi internet bermasalah. Silakan coba lagi.';
    }

    if (message.contains('violates row-level security') ||
        message.contains('permission denied')) {
      return 'Akses ditolak. Kamu tidak memiliki izin melihat proposal ini.';
    }

    if (message.contains('User belum login')) {
      return 'Sesi login berakhir. Silakan login ulang.';
    }

    if (message.contains('PostgrestException')) {
      return 'Gagal memuat proposal. Silakan coba lagi.';
    }

    return 'Terjadi kesalahan. Silakan coba lagi.';
  }
}
