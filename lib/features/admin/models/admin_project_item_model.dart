class AdminProjectItemModel {
  final String id;
  final String ownerId;
  final String ownerName;
  final String title;
  final String projectField;
  final String status;
  final double budget;
  final DateTime? deadline;
  final DateTime? createdAt;
  final int proposalCount;
  final int reportCount;

  const AdminProjectItemModel({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.title,
    required this.projectField,
    required this.status,
    required this.budget,
    this.deadline,
    this.createdAt,
    this.proposalCount = 0,
    this.reportCount = 0,
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

  bool matches(String query) {
    final cleanQuery = query.trim().toLowerCase();

    if (cleanQuery.isEmpty) return true;

    final source = [
      title,
      ownerName,
      projectField,
      statusLabel,
    ].join(' ').toLowerCase();

    return source.contains(cleanQuery);
  }
}
