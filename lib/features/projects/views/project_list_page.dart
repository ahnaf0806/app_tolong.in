import 'package:app_tolongin/core/widgets/app_empety_state.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_error_state.dart';
import '../controllers/project_list_controller.dart';
import '../models/project_model.dart';
import '../widgets/project_card.dart';
import 'project_detail_page.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  final ProjectListController _controller = ProjectListController();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _controller.loadProjects();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await _controller.refresh();

    if (mounted) {
      setState(() {});
    }
  }

  List<ProjectModel> get _filteredProjects {
    if (_searchQuery.isEmpty) {
      return _controller.projects;
    }

    return _controller.projects.where((project) {
      final title = project.title.toLowerCase();
      final field = project.projectField.toLowerCase();
      final difficulty = project.difficulty.toLowerCase();
      final description = project.description.toLowerCase();

      return title.contains(_searchQuery) ||
          field.contains(_searchQuery) ||
          difficulty.contains(_searchQuery) ||
          description.contains(_searchQuery);
    }).toList();
  }

  void _openDetail(ProjectModel project) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProjectDetailPage(project: project)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredProjects = _filteredProjects;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              Text('Cari Project', style: AppTextStyles.headingLg),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Temukan project yang sesuai dengan skill kamu.',
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.stone),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildSearchField(),
              const SizedBox(height: AppSpacing.xl),
              if (_controller.isLoading && _controller.projects.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xl),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_controller.errorMessage != null &&
                  _controller.projects.isEmpty)
                AppErrorState(
                  message: _controller.errorMessage!,
                  onRetry: _refresh,
                )
              else if (_controller.projects.isEmpty)
                const AppEmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'Belum Ada Project',
                  message: 'Project yang tersedia akan tampil di halaman ini.',
                )
              else if (filteredProjects.isEmpty)
                AppEmptyState(
                  icon: Icons.manage_search_rounded,
                  title: 'Project Tidak Ditemukan',
                  message:
                      'Tidak ada project yang cocok dengan "$_searchQuery". Coba kata kunci lain.',
                )
              else ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${filteredProjects.length} project tersedia',
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.stone,
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      TextButton(
                        onPressed: _clearSearch,
                        child: const Text('Reset'),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ..._buildProjectItems(filteredProjects),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Cari judul, bidang, atau tingkat kesulitan...',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: _searchQuery.isEmpty
            ? null
            : IconButton(
                onPressed: _clearSearch,
                icon: const Icon(Icons.close_rounded),
              ),
        filled: true,
        fillColor: AppColors.surfaceSoft,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.base,
        ),
      ),
    );
  }

  List<Widget> _buildProjectItems(List<ProjectModel> projects) {
    final items = <Widget>[];

    for (var index = 0; index < projects.length; index++) {
      final project = projects[index];

      items.add(
        ProjectCard(project: project, onTap: () => _openDetail(project)),
      );

      if (index != projects.length - 1) {
        items.add(const SizedBox(height: AppSpacing.md));
      }
    }

    return items;
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _searchQuery = '';
    });
  }
}
