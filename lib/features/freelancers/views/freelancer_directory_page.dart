import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_error_state.dart';
import '../controllers/freelancer_directory_controller.dart';
import '../models/freelancer_summary_model.dart';
import '../widgets/freelancer_card.dart';

class FreelancerDirectoryPage extends StatefulWidget {
  const FreelancerDirectoryPage({super.key});

  @override
  State<FreelancerDirectoryPage> createState() =>
      _FreelancerDirectoryPageState();
}

class _FreelancerDirectoryPageState extends State<FreelancerDirectoryPage> {
  final FreelancerDirectoryController _controller =
      FreelancerDirectoryController();

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

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final freelancers = _filteredFreelancers;

        return Scaffold(
          backgroundColor: AppColors.canvas,
          body: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.xl),
              children: [
                _buildHeader(),
                const SizedBox(height: AppSpacing.lg),
                _buildSearchField(),
                const SizedBox(height: AppSpacing.xl),
                if (_controller.isLoading && _controller.freelancers.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: AppSpacing.xxxl),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_controller.errorMessage != null &&
                    _controller.freelancers.isEmpty)
                  AppErrorState(
                    message: _controller.errorMessage!,
                    onRetry: _refresh,
                  )
                else if (_controller.freelancers.isEmpty)
                  _buildEmptyState(
                    icon: Icons.groups_outlined,
                    title: 'Belum Ada Freelancer',
                    message:
                        'Freelancer akan muncul setelah pengguna mendaftar sebagai student freelancer.',
                  )
                else if (freelancers.isEmpty)
                  _buildEmptyState(
                    icon: Icons.manage_search_rounded,
                    title: 'Freelancer Tidak Ditemukan',
                    message:
                        'Tidak ada freelancer yang cocok dengan "$_searchQuery". Coba kata kunci lain.',
                  )
                else ...[
                  _buildResultInfo(freelancers.length),
                  const SizedBox(height: AppSpacing.md),
                  ..._buildFreelancerItems(freelancers),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return AppCard(
      backgroundColor: AppColors.inkDeep,
      hasBorder: false,
      radius: AppRadius.xxxl,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.canvas.withValues(alpha: 0.12),
              borderRadius: AppRadius.all(AppRadius.full),
            ),
            child: const Icon(
              Icons.groups_rounded,
              color: AppColors.canvas,
              size: 30,
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cari Freelancer',
                  style: AppTextStyles.headingSm.copyWith(
                    color: AppColors.canvas,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Temukan mahasiswa berdasarkan skill, portofolio, dan reputasi project.',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.canvas.withValues(alpha: 0.80),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
          borderRadius: BorderRadius.circular(AppRadius.xl),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.base,
        ),
      ),
    );
  }

  Widget _buildResultInfo(int count) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$count freelancer tersedia',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.stone),
          ),
        ),
        if (_searchQuery.isNotEmpty)
          TextButton(onPressed: _clearSearch, child: const Text('Reset')),
      ],
    );
  }

  List<Widget> _buildFreelancerItems(List<FreelancerSummaryModel> freelancers) {
    final items = <Widget>[];

    for (var index = 0; index < freelancers.length; index++) {
      items.add(FreelancerCard(freelancer: freelancers[index]));

      if (index != freelancers.length - 1) {
        items.add(const SizedBox(height: AppSpacing.md));
      }
    }

    return items;
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return AppCard(
      child: Column(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: AppRadius.all(AppRadius.xxl),
            ),
            child: Icon(icon, color: AppColors.primary, size: 38),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: AppTextStyles.subtitleLg,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: AppTextStyles.bodySm.copyWith(color: AppColors.stone),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
