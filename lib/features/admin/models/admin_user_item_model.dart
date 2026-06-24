class AdminUserItemModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String accountStatus;
  final String? university;
  final String? studyProgram;
  final DateTime? createdAt;

  final String? verificationStatus;
  final double ratingAverage;
  final int totalProjects;

  const AdminUserItemModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.accountStatus,
    this.university,
    this.studyProgram,
    this.createdAt,
    this.verificationStatus,
    this.ratingAverage = 0,
    this.totalProjects = 0,
  });

  String get roleLabel {
    switch (role) {
      case 'admin':
        return 'Admin';
      case 'project_owner':
        return 'Project Owner';
      default:
        return 'Freelancer';
    }
  }

  String get statusLabel {
    switch (accountStatus) {
      case 'blocked':
        return 'Diblokir';
      case 'warned':
        return 'Peringatan';
      default:
        return 'Aktif';
    }
  }

  String get verificationLabel {
    switch (verificationStatus) {
      case 'verified':
        return 'Terverifikasi';
      case 'rejected':
        return 'Ditolak';
      case 'pending':
        return 'Menunggu';
      default:
        return '-';
    }
  }

  bool matches(String query) {
    final cleanQuery = query.trim().toLowerCase();

    if (cleanQuery.isEmpty) return true;

    final source = [
      name,
      email,
      roleLabel,
      statusLabel,
      university ?? '',
      studyProgram ?? '',
      verificationLabel,
    ].join(' ').toLowerCase();

    return source.contains(cleanQuery);
  }
}
