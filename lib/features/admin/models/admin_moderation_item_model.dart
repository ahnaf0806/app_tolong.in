class AdminModerationItemModel {
  final String id;
  final String title;
  final String subtitle;
  final String type;
  final String priority;
  final String status;
  final DateTime? createdAt;

  const AdminModerationItemModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.priority,
    required this.status,
    this.createdAt,
  });

  String get typeLabel {
    switch (type) {
      case 'report':
        return 'Laporan';
      case 'verification':
        return 'Verifikasi';
      case 'flagged_project':
        return 'Project Berisiko';
      case 'blocked_user':
        return 'User Diblokir';
      default:
        return type;
    }
  }

  String get priorityLabel {
    switch (priority) {
      case 'high':
        return 'Prioritas Tinggi';
      case 'medium':
        return 'Prioritas Sedang';
      default:
        return 'Prioritas Rendah';
    }
  }
}
