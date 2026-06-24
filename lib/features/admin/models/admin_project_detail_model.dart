class AdminProjectDetailModel {
  final String id;
  final String ownerId;
  final String ownerName;
  final String ownerEmail;
  final String title;
  final String? categoryName;
  final String projectField;
  final String description;
  final String difficulty;
  final double budget;
  final DateTime? deadline;
  final String status;
  final String? attachmentUrl;
  final DateTime? createdAt;

  final int proposalCount;
  final int pendingProposalCount;
  final int acceptedProposalCount;
  final int reportCount;
  final int pendingReportCount;
  final String? workspaceStatus;

  const AdminProjectDetailModel({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.ownerEmail,
    required this.title,
    this.categoryName,
    required this.projectField,
    required this.description,
    required this.difficulty,
    required this.budget,
    this.deadline,
    required this.status,
    this.attachmentUrl,
    this.createdAt,
    required this.proposalCount,
    required this.pendingProposalCount,
    required this.acceptedProposalCount,
    required this.reportCount,
    required this.pendingReportCount,
    this.workspaceStatus,
  });

  String get statusLabel {
    switch (status) {
      case 'in_progress':
        return 'Berjalan';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return 'Terbuka';
    }
  }

  String get difficultyLabel {
    switch (difficulty) {
      case 'easy':
        return 'Mudah';
      case 'medium':
        return 'Sedang';
      case 'hard':
        return 'Sulit';
      default:
        return difficulty;
    }
  }

  String get workspaceStatusLabel {
    switch (workspaceStatus) {
      case 'waiting':
        return 'Menunggu dimulai';
      case 'active':
        return 'Aktif';
      case 'revision':
        return 'Revisi';
      case 'waiting_confirmation':
        return 'Menunggu konfirmasi';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return 'Belum ada workspace';
    }
  }

  bool get hasReports => reportCount > 0;
  bool get hasPendingReports => pendingReportCount > 0;
  bool get hasAttachment =>
      attachmentUrl != null && attachmentUrl!.trim().isNotEmpty;
}
