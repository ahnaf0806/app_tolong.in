import 'admin_project_item_model.dart';
import 'admin_report_item_model.dart';
import 'admin_stats_model.dart';
import 'admin_user_item_model.dart';

class AdminDashboardData {
  final AdminStatsModel stats;
  final List<AdminReportItemModel> reports;
  final List<AdminUserItemModel> users;
  final List<AdminProjectItemModel> projects;

  const AdminDashboardData({
    required this.stats,
    required this.reports,
    required this.users,
    required this.projects,
  });
}
