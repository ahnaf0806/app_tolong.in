import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/premium_glass_card.dart';
import '../models/admin_project_item_model.dart';
import '../widgets/admin_project_card.dart';

class AdminProjectsTab extends StatefulWidget {
  final List<AdminProjectItemModel> projects;
  final Future<void> Function(String projectId, String status) onChangeStatus;
  final void Function(AdminProjectItemModel project) onOpenProject;

  const AdminProjectsTab({
    super.key,
    required this.projects,
    required this.onChangeStatus,
    required this.onOpenProject,
  });

  @override
  State<AdminProjectsTab> createState() => _AdminProjectsTabState();
}

class _AdminProjectsTabState extends State<AdminProjectsTab> {
  final TextEditingController _searchController = TextEditingController();

  String _status = 'all';
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AdminProjectItemModel> get _filteredProjects {
    return widget.projects.where((project) {
      final statusMatch = _status == 'all' || project.status == _status;
      return statusMatch && project.matches(_query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final projects = _filteredProjects;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        _buildSearchAndFilter(),
        const SizedBox(height: AppSpacing.lg),
        if (projects.isEmpty)
          const AppEmptyState(
            icon: Icons.folder_off_rounded,
            title: 'Project tidak ditemukan',
            message: 'Coba ubah pencarian atau filter status project.',
          )
        else
          ...projects.map(
            (project) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AdminProjectCard(
                project: project,
                onTap: () => widget.onOpenProject(project),
                onChangeStatus: (status) => widget.onChangeStatus(project.id, status),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return PremiumGlassCard(
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Cari project',
              hintText: 'Judul, owner, bidang, atau status',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _status,
            decoration: const InputDecoration(
              labelText: 'Filter Status',
              prefixIcon: Icon(Icons.tune_rounded),
            ),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('Semua Status')),
              DropdownMenuItem(value: 'open', child: Text('Terbuka')),
              DropdownMenuItem(value: 'in_progress', child: Text('Berjalan')),
              DropdownMenuItem(value: 'completed', child: Text('Selesai')),
              DropdownMenuItem(value: 'cancelled', child: Text('Dibatalkan')),
            ],
            dropdownColor: AppColors.canvas,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _status = value);
            },
          ),
        ],
      ),
    );
  }
}
