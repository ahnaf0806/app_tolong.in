class AdminCategoryItemModel {
  final String id;
  final String name;
  final String? description;
  final bool isActive;
  final int displayOrder;
  final int projectCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AdminCategoryItemModel({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
    required this.displayOrder,
    required this.projectCount,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminCategoryItemModel.fromJson(
    Map<String, dynamic> json, {
    int projectCount = 0,
  }) {
    return AdminCategoryItemModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '-',
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
      projectCount: projectCount,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  String get statusLabel => isActive ? 'Aktif' : 'Nonaktif';

  bool get canDelete => projectCount == 0;

  bool matches(String query) {
    final cleanQuery = query.trim().toLowerCase();

    if (cleanQuery.isEmpty) return true;

    final source = [
      name,
      description ?? '',
      statusLabel,
      displayOrder.toString(),
      projectCount.toString(),
    ].join(' ').toLowerCase();

    return source.contains(cleanQuery);
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
