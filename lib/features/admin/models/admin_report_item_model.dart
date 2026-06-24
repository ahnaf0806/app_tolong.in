class AdminReportItemModel {
  final String id;
  final String reporterId;
  final String? reportedUserId;
  final String? projectId;
  final String reason;
  final String description;
  final String status;
  final DateTime? createdAt;

  final String reporterName;
  final String reporterEmail;
  final String reportedUserName;
  final String reportedUserEmail;
  final String projectTitle;

  const AdminReportItemModel({
    required this.id,
    required this.reporterId,
    this.reportedUserId,
    this.projectId,
    required this.reason,
    required this.description,
    required this.status,
    this.createdAt,
    required this.reporterName,
    required this.reporterEmail,
    required this.reportedUserName,
    required this.reportedUserEmail,
    required this.projectTitle,
  });

  String get reasonLabel {
    switch (reason) {
      case 'permintaan_joki_tugas':
        return 'Permintaan Joki Tugas';
      case 'penipuan':
        return 'Penipuan';
      case 'project_palsu':
        return 'Project Palsu';
      case 'bahasa_tidak_sopan':
        return 'Bahasa Tidak Sopan';
      case 'penyalahgunaan_file':
        return 'Penyalahgunaan File';
      default:
        return 'Lainnya';
    }
  }

  String get statusLabel {
    switch (status) {
      case 'reviewed':
        return 'Ditinjau';
      case 'resolved':
        return 'Selesai';
      default:
        return 'Menunggu';
    }
  }
}
