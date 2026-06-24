import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';
import '../models/admin_category_item_model.dart';

class AdminCategoryFormResult {
  final String name;
  final String description;
  final int displayOrder;
  final bool isActive;

  const AdminCategoryFormResult({
    required this.name,
    required this.description,
    required this.displayOrder,
    required this.isActive,
  });
}

class AdminCategoryFormSheet extends StatefulWidget {
  final AdminCategoryItemModel? initialCategory;

  const AdminCategoryFormSheet({super.key, this.initialCategory});

  @override
  State<AdminCategoryFormSheet> createState() => _AdminCategoryFormSheetState();
}

class _AdminCategoryFormSheetState extends State<AdminCategoryFormSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _displayOrderController;

  late bool _isActive;

  bool get _isEdit => widget.initialCategory != null;

  @override
  void initState() {
    super.initState();

    final category = widget.initialCategory;

    _nameController = TextEditingController(text: category?.name ?? '');
    _descriptionController = TextEditingController(
      text: category?.description ?? '',
    );
    _displayOrderController = TextEditingController(
      text: (category?.displayOrder ?? 0).toString(),
    );
    _isActive = category?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _displayOrderController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final result = AdminCategoryFormResult(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      displayOrder: int.tryParse(_displayOrderController.text.trim()) ?? 0,
      isActive: _isActive,
    );

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHandle(),
                const SizedBox(height: AppSpacing.xl),
                _buildTitle(),
                const SizedBox(height: AppSpacing.lg),
                CustomTextField(
                  controller: _nameController,
                  label: 'Nama kategori',
                  hint: 'Contoh: UI/UX Design',
                  prefixIcon: Icons.category_rounded,
                  validator: _validateName,
                ),
                const SizedBox(height: AppSpacing.md),
                CustomTextField(
                  controller: _descriptionController,
                  label: 'Deskripsi',
                  hint: 'Jelaskan jenis project dalam kategori ini.',
                  prefixIcon: Icons.notes_rounded,
                  maxLines: 4,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _displayOrderController,
                  keyboardType: TextInputType.number,
                  validator: _validateOrder,
                  decoration: const InputDecoration(
                    labelText: 'Urutan tampil',
                    hintText: '0',
                    prefixIcon: Icon(Icons.sort_rounded),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SwitchListTile(
                  value: _isActive,
                  activeColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Kategori aktif',
                    style: AppTextStyles.bodyMdBold,
                  ),
                  subtitle: Text(
                    'Kategori aktif akan muncul pada form buat project.',
                    style: AppTextStyles.caption,
                  ),
                  onChanged: (value) {
                    setState(() => _isActive = value);
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  text: _isEdit ? 'Simpan Perubahan' : 'Tambah Kategori',
                  icon: _isEdit ? Icons.save_rounded : Icons.add_rounded,
                  variant: PrimaryButtonVariant.cobalt,
                  onPressed: _submit,
                ),
                const SizedBox(height: AppSpacing.sm),
                SecondaryButton(
                  text: 'Batal',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 44,
      height: 5,
      decoration: BoxDecoration(
        color: AppColors.hairline,
        borderRadius: AppRadius.all(AppRadius.full),
      ),
    );
  }

  Widget _buildTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        _isEdit ? 'Edit Kategori' : 'Tambah Kategori',
        style: AppTextStyles.headingSm,
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().length < 3) {
      return 'Nama kategori minimal 3 karakter.';
    }

    return null;
  }

  String? _validateOrder(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Urutan tampil wajib diisi.';
    }

    if (int.tryParse(value.trim()) == null) {
      return 'Urutan tampil harus berupa angka.';
    }

    return null;
  }
}
