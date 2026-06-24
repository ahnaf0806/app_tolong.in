class AdminAuditLogModel {
  final String id;
  final String adminId;
  final String adminName;
  final String action;
  final String targetTable;
  final String? targetId;
  final String description;
  final DateTime? createdAt;

  const AdminAuditLogModel({
    required this.id,
    required this.adminId,
    required this.adminName,
    required this.action,
    required this.targetTable,
    this.targetId,
    required this.description,
    this.createdAt,
  });

  factory AdminAuditLogModel.fromJson(
    Map<String, dynamic> json, {
    String adminName = 'Admin',
  }) {
    return AdminAuditLogModel(
      id: json['id'] as String,
      adminId: json['admin_id'] as String? ?? '',
      adminName: adminName,
      action: json['action'] as String? ?? '-',
      targetTable: json['target_table'] as String? ?? '-',
      targetId: json['target_id'] as String?,
      description: json['description'] as String? ?? '-',
      createdAt: _parseDate(json['created_at']),
    );
  }

  String get actionLabel {
    switch (action) {
      case 'create':
        return 'Tambah';
      case 'update':
        return 'Ubah';
      case 'delete':
        return 'Hapus';
      case 'moderate':
        return 'Moderasi';
      default:
        return action;
    }
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
