class AdminStatsModel {
  final int totalUsers;
  final int totalOwners;
  final int totalFreelancers;
  final int totalAdmins;
  final int blockedUsers;

  final int totalProjects;
  final int openProjects;
  final int inProgressProjects;
  final int completedProjects;
  final int cancelledProjects;

  final int totalWorkspaces;
  final int activeWorkspaces;
  final int completedWorkspaces;

  final int totalReports;
  final int pendingReports;
  final int reviewedReports;
  final int resolvedReports;

  final int totalReviews;
  final double averageRating;

  const AdminStatsModel({
    required this.totalUsers,
    required this.totalOwners,
    required this.totalFreelancers,
    required this.totalAdmins,
    required this.blockedUsers,
    required this.totalProjects,
    required this.openProjects,
    required this.inProgressProjects,
    required this.completedProjects,
    required this.cancelledProjects,
    required this.totalWorkspaces,
    required this.activeWorkspaces,
    required this.completedWorkspaces,
    required this.totalReports,
    required this.pendingReports,
    required this.reviewedReports,
    required this.resolvedReports,
    required this.totalReviews,
    required this.averageRating,
  });
}
