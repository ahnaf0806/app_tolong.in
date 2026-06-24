import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_error_state.dart';
import '../controllers/admin_category_controller.dart';
import '../models/admin_category_item_model.dart';
import '../widgets/admin_category_card.dart';
import '../widgets/admin_category_form_sheet.dart';
import 'admin_category_detail_page.dart';

class AdminCategoriesTab extends StatefulWidget {
  const AdminCategoriesTab({super.key});

  @override
  State<AdminCategoriesTab> createState() => _AdminCategoriesTabState();
}

class _AdminCategoriesTabState extends State<AdminCategoriesTab> {
  final AdminCategoryController _controller = AdminCategoryController();
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _controller.loadCategories();
    _searchController.addListener(() => setState(() => _query = _searchController.text));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  List<AdminCategoryItemModel> get _filteredCategories =>
      _controller.categories.where((category) => category.matches(_query)).toList();

  Future<void> _openForm({AdminCategoryItemModel? category}) async {
    final result = await showModalBottomSheet<AdminCategoryFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.canvas,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxxl)),
      ),
      builder: (_) => AdminCategoryFormSheet(initialCategory: category),
    );
    if (result == null) return;

    if (category == null) {
      await _controller.createCategory(
        name: result.name,
        description: result.description,
        displayOrder: result.displayOrder,
        isActive: result.isActive,
      );
    } else {
      await _controller.updateCategory(
        id: category.id,
        name: result.name,
        description: result.description,
        displayOrder: result.displayOrder,
        isActive: result.isActive,
      );
    }
    _showMessage(category == null ? 'Kategori ditambahkan.' : 'Kategori diperbarui.');
  }

  Future<void> _confirmDelete(AdminCategoryItemModel category) async {
    final isConfirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Kategori?'),
        content: Text(
          category.canDelete
              ? 'Kategori "${category.name}" akan dihapus permanen.'
              : 'Kategori ini sudah dipakai ${category.projectCount} project, sehingga tidak bisa dihapus.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Batal')),
          FilledButton(
            onPressed: category.canDelete ? () => Navigator.of(context).pop(true) : null,
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (isConfirmed != true) return;
    await _controller.deleteCategory(category);
    _showMessage('Kategori dihapus.');
  }

  void _openDetail(AdminCategoryItemModel category) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => AdminCategoryDetailPage(
              categoryId: category.id,
              initialName: category.name,
            ),
          ),
        )
        .then((_) => _controller.loadCategories());
  }

  Future<void> _toggleActive(AdminCategoryItemModel category) async {
    await _controller.toggleCategory(category);
    _showMessage(category.isActive ? 'Kategori dinonaktifkan.' : 'Kategori diaktifkan.');
  }

  void _showMessage(String message) {
    if (!mounted) return;
    final error = _controller.errorMessage;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: error == null ? null : AppColors.critical,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final categories = _filteredCategories;
        return Stack(
          children: [
            RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _controller.loadCategories,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                children: [
                  _buildHeader(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildSearch(),
                  const SizedBox(height: AppSpacing.lg),
                  if (_controller.isLoading && _controller.categories.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else if (_controller.errorMessage != null && _controller.categories.isEmpty)
                    AppErrorState(message: _controller.errorMessage!, onRetry: _controller.loadCategories)
                  else if (categories.isEmpty)
                    _buildEmptyState()
                  else
                    ..._buildCategoryCards(categories),
                ],
              ),
            ),
            if (_controller.isActionLoading) const LinearProgressIndicator(minHeight: 2),
          ],
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
          const Icon(Icons.category_rounded, color: AppColors.canvas, size: 36),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Manajemen Kategori', style: AppTextStyles.headingSm.copyWith(color: AppColors.canvas)),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Atur kategori project yang tampil pada marketplace dan form buat project.',
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.canvas.withValues(alpha: 0.80)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Cari kategori',
              hintText: 'Nama, deskripsi, status, atau urutan',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _openForm(),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Tambah Kategori'),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategoryCards(List<AdminCategoryItemModel> categories) {
    return categories.map((category) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: AdminCategoryCard(
          category: category,
          onTap: () => _openDetail(category),
          onEdit: () => _openForm(category: category),
          onToggleActive: () => _toggleActive(category),
          onDelete: () => _confirmDelete(category),
        ),
      );
    }).toList();
  }

  Widget _buildEmptyState() {
    return AppCard(
      child: Text('Kategori tidak ditemukan.', style: AppTextStyles.bodySm, textAlign: TextAlign.center),
    );
  }
}
