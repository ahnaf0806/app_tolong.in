class AppUserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? university;
  final String? studyProgram;
  final int? semester;
  final String? photoUrl;

  const AppUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.university,
    this.studyProgram,
    this.semester,
    this.photoUrl,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      university: json['university'] as String?,
      studyProgram: json['study_program'] as String?,
      semester: json['semester'] as int?,
      photoUrl: json['photo_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'university': university,
      'study_program': studyProgram,
      'semester': semester,
      'photo_url': photoUrl,
    };
  }

  bool get isProjectOwner => role == 'project_owner';
  bool get isFreelancer => role == 'freelancer';
  bool get isAdmin => role == 'admin';
}
