import 'package:app_tolongin/core/widgets/app_empty_state.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_error_state.dart';
import '../controllers/freelancer_directory_controller.dart';
import '../models/freelancer_summary_model.dart';
import '../widgets/freelancer_card.dart';
import 'freelancer_detail_page.dart';

class FreelancerDirectoryPage extends StatefulWidget {
  const FreelancerDirectoryPage({super.key});

  @override
  State<FreelancerDirectoryPage> createState() => _FreelancerDirectoryPageState();
}

class _FreelancerDirectoryPageState extends State<FreelancerDirectoryPage> {
  final FreelancerDirectoryController _controller = FreelancerDirectoryController();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _controller.loadFreelancers();

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

  List<FreelancerSummaryModel> get _filteredFreelancers {
    return _controller.freelancers
        .where((freelancer) => freelancer.matches(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final freelancers = _filteredFreelancers;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              Text('Cari Freelancer', style: AppTextStyles.headingLg),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Temukan mahasiswa freelancer berdasarkan skill, portofolio, dan reputasi.',
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.stone),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildSearchField(),
              const SizedBox(height: AppSpacing.xl),
              if (_controller.isLoading && _controller.freelancers.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xl),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_controller.errorMessage != null &&
                  _controller.freelancers.isEmpty)
                AppErrorState(
                  message: _controller.errorMessage!,
                  onRetry: _refresh,
                )
              else if (_controller.freelancers.isEmpty)
                const AppEmptyState(
                  icon: Icons.groups_outlined,
                  title: 'Belum Ada Freelancer',
                  message:
                      'Freelancer akan muncul setelah pengguna mendaftar sebagai freelancer.',
                )
              else if (freelancers.isEmpty)
                AppEmptyState(
                  icon: Icons.manage_search_rounded,
                  title: 'Freelancer Tidak Ditemukan',
                  message:
                      'Tidak ada freelancer yang cocok dengan "$_searchQuery". Coba kata kunci lain.',
                )
              else ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${freelancers.length} freelancer tersedia',
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
                ..._buildFreelancerItems(freelancers),
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
        hintText: 'Cari nama, kampus, jurusan, atau skill...',
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

  List<Widget> _buildFreelancerItems(List<FreelancerSummaryModel> freelancers) {
    final items = <Widget>[];

    for (var index = 0; index < freelancers.length; index++) {
      items.add(
        FreelancerCard(
          freelancer: freelancers[index],
          onTap: () => _openFreelancerDetail(freelancers[index]),
        ),
      );

      if (index != freelancers.length - 1) {
        items.add(const SizedBox(height: AppSpacing.md));
      }
    }

    return items;
  }

  void _openFreelancerDetail(FreelancerSummaryModel freelancer) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FreelancerDetailPage(freelancer: freelancer),
      ),
    );
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _searchQuery = '';
    });
  }
}
