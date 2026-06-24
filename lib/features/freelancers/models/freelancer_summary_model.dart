class FreelancerSummaryModel {
  final String id;
  final String name;
  final String email;
  final String? university;
  final String? studyProgram;
  final int? semester;
  final String? photoUrl;
  final String? bio;
  final List<String> skills;
  final String? portfolioUrl;
  final double ratingAverage;
  final int totalProjects;
  final String verificationStatus;

  const FreelancerSummaryModel({
    required this.id,
    required this.name,
    required this.email,
    this.university,
    this.studyProgram,
    this.semester,
    this.photoUrl,
    this.bio,
    this.skills = const [],
    this.portfolioUrl,
    this.ratingAverage = 0,
    this.totalProjects = 0,
    this.verificationStatus = 'pending',
  });

  factory FreelancerSummaryModel.fromMaps({
    required Map<String, dynamic> profile,
    Map<String, dynamic>? freelancerProfile,
  }) {
    final rawSkills = freelancerProfile?['skills'];

    final skills = rawSkills is List
        ? rawSkills.map((item) => item.toString()).toList()
        : <String>[];

    return FreelancerSummaryModel(
      id: profile['id'] as String,
      name:
          profile['name'] as String? ??
          profile['full_name'] as String? ??
          'Freelancer',
      email: profile['email'] as String? ?? '-',
      university: profile['university'] as String?,
      studyProgram: profile['study_program'] as String?,
      semester: (profile['semester'] as num?)?.toInt(),
      photoUrl: profile['photo_url'] as String?,
      bio: freelancerProfile?['bio'] as String?,
      skills: skills,
      portfolioUrl: freelancerProfile?['portfolio_url'] as String?,
      ratingAverage:
          (freelancerProfile?['rating_average'] as num?)?.toDouble() ?? 0,
      totalProjects:
          (freelancerProfile?['total_projects'] as num?)?.toInt() ?? 0,
      verificationStatus:
          freelancerProfile?['verification_status'] as String? ?? 'pending',
    );
  }

  String get skillsText {
    if (skills.isEmpty) {
      return 'Belum ada keahlian';
    }

    return skills.join(', ');
  }

  String get verificationLabel {
    switch (verificationStatus) {
      case 'verified':
        return 'Terverifikasi';
      case 'rejected':
        return 'Ditolak';
      default:
        return 'Menunggu Verifikasi';
    }
  }

  bool matches(String query) {
    final cleanQuery = query.trim().toLowerCase();

    if (cleanQuery.isEmpty) {
      return true;
    }

    final searchableText = [
      name,
      email,
      university ?? '',
      studyProgram ?? '',
      bio ?? '',
      skills.join(' '),
      verificationLabel,
    ].join(' ').toLowerCase();

    return searchableText.contains(cleanQuery);
  }
}
