import 'package:flutter/material.dart';

class AppStatusBadge extends StatelessWidget {
  final String status;
  final String type;

  const AppStatusBadge({super.key, required this.status, required this.type});

  @override
  Widget build(BuildContext context) {
    final label = _getLabel();
    final color = _getColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _getLabel() {
    if (type == 'project') {
      if (status == 'open') return 'Terbuka';
      if (status == 'in_progress') return 'Berjalan';
      if (status == 'completed') return 'Selesai';
      if (status == 'cancelled') return 'Dibatalkan';
    }

    if (type == 'proposal') {
      if (status == 'pending') return 'Menunggu';
      if (status == 'accepted') return 'Diterima';
      if (status == 'rejected') return 'Ditolak';
    }

    if (type == 'workspace') {
      if (status == 'active') return 'Aktif';
      if (status == 'submitted') return 'Hasil Dikirim';
      if (status == 'completed') return 'Selesai';
      if (status == 'cancelled') return 'Dibatalkan';
    }

    if (type == 'account') {
      if (status == 'verified') return 'Terverifikasi';
      if (status == 'rejected') return 'Ditolak';
      return 'Aktif';
    }

    return status;
  }

  Color _getColor() {
    if (status == 'open' ||
        status == 'active' ||
        status == 'accepted' ||
        status == 'verified') {
      return Colors.green;
    }

    if (status == 'pending' ||
        status == 'submitted' ||
        status == 'in_progress') {
      return Colors.orange;
    }

    if (status == 'rejected' || status == 'cancelled') {
      return Colors.red;
    }

    if (status == 'completed') {
      return Colors.blue;
    }

    return Colors.grey;
  }
}
