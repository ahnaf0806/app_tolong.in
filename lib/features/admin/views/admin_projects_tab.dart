import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/admin_project_item_model.dart';
import '../widgets/admin_project_card.dart';

class AdminProjectsTab extends StatefulWidget {
  final List<AdminProjectItemModel> projects;
  final Future<void> Function(String projectId, String status) onChangeStatus;

  const AdminProjectsTab({
    super.key,
    required this.projects,
    required this.onChangeStatus,
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
          AppCard(
            child: Text(
              'Project tidak ditemukan.',
              style: AppTextStyles.bodySm,
              textAlign: TextAlign.center,
            ),
          )
        else
          ...projects.map(
            (project) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AdminProjectCard(
                project: project,
                onChangeStatus: (status) {
                  widget.onChangeStatus(project.id, status);
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return AppCard(
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
            decoration: const InputDecoration(labelText: 'Filter Status'),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('Semua Status')),
              DropdownMenuItem(value: 'open', child: Text('Terbuka')),
              DropdownMenuItem(value: 'in_progress', child: Text('Berjalan')),
              DropdownMenuItem(value: 'completed', child: Text('Selesai')),
              DropdownMenuItem(value: 'cancelled', child: Text('Dibatalkan')),
            ],
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
