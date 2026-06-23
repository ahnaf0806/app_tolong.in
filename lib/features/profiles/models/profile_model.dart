class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? university;
  final String? studyProgram;
  final int? semester;
  final String? photoUrl;

  final String? bio;
  final List<String> skills;
  final String? portfolioUrl;
  final double ratingAverage;
  final int totalProjects;
  final String? verificationStatus;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.university,
    this.studyProgram,
    this.semester,
    this.photoUrl,
    this.bio,
    this.skills = const [],
    this.portfolioUrl,
    this.ratingAverage = 0,
    this.totalProjects = 0,
    this.verificationStatus,
  });

  factory ProfileModel.fromMaps({
    required Map<String, dynamic> profile,
    Map<String, dynamic>? freelancerProfile,
  }) {
    final rawSkills = freelancerProfile?['skills'];

    List<String> parsedSkills = [];

    if (rawSkills is List) {
      parsedSkills = rawSkills.map((item) => item.toString()).toList();
    }

    return ProfileModel(
      id: profile['id'] as String,
      name: profile['name'] as String? ?? 'Pengguna',
      email: profile['email'] as String? ?? '-',
      role: profile['role'] as String? ?? 'freelancer',
      university: profile['university'] as String?,
      studyProgram: profile['study_program'] as String?,
      semester: profile['semester'] as int?,
      photoUrl: profile['photo_url'] as String?,
      bio: freelancerProfile?['bio'] as String?,
      skills: parsedSkills,
      portfolioUrl: freelancerProfile?['portfolio_url'] as String?,
      ratingAverage:
          (freelancerProfile?['rating_average'] as num?)?.toDouble() ?? 0,
      totalProjects: freelancerProfile?['total_projects'] as int? ?? 0,
      verificationStatus: freelancerProfile?['verification_status'] as String?,
    );
  }

  bool get isFreelancer => role == 'freelancer';

  bool get isProjectOwner => role == 'project_owner';

  String get roleLabel {
    if (role == 'project_owner') {
      return 'Project Owner';
    }

    if (role == 'freelancer') {
      return 'Freelancer';
    }

    if (role == 'admin') {
      return 'Admin';
    }

    return role;
  }

  String get verificationLabel {
    if (verificationStatus == 'verified') {
      return 'Terverifikasi';
    }

    if (verificationStatus == 'rejected') {
      return 'Ditolak';
    }

    return 'Dalam Antrean';
  }

  String get skillsText {
    if (skills.isEmpty) {
      return '-';
    }

    return skills.join(', ');
  }
}
