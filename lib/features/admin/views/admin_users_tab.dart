import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/premium_glass_card.dart';
import '../models/admin_user_item_model.dart';
import '../widgets/admin_user_card.dart';

class AdminUsersTab extends StatefulWidget {
  final List<AdminUserItemModel> users;
  final Future<void> Function(String userId, String status) onChangeUserStatus;
  final Future<void> Function(String userId, String status) onChangeVerification;
  final void Function(AdminUserItemModel user) onOpenUser;

  const AdminUsersTab({
    super.key,
    required this.users,
    required this.onChangeUserStatus,
    required this.onChangeVerification,
    required this.onOpenUser,
  });

  @override
  State<AdminUsersTab> createState() => _AdminUsersTabState();
}

class _AdminUsersTabState extends State<AdminUsersTab> {
  final TextEditingController _searchController = TextEditingController();

  String _role = 'all';
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

  List<AdminUserItemModel> get _filteredUsers {
    return widget.users.where((user) {
      final roleMatch = _role == 'all' || user.role == _role;
      return roleMatch && user.matches(_query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final users = _filteredUsers;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        _buildSearchAndFilter(),
        const SizedBox(height: AppSpacing.lg),
        if (users.isEmpty)
          const AppEmptyState(
            icon: Icons.person_search_rounded,
            title: 'User tidak ditemukan',
            message: 'Coba ubah kata kunci pencarian atau filter role.',
          )
        else
          ...users.map(
            (user) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AdminUserCard(
                user: user,
                onTap: () => widget.onOpenUser(user),
                onChangeAccountStatus: (status) {
                  widget.onChangeUserStatus(user.id, status);
                },
                onChangeVerification: (status) {
                  widget.onChangeVerification(user.id, status);
                },
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
              labelText: 'Cari user',
              hintText: 'Nama, email, kampus, atau role',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _role,
            decoration: const InputDecoration(
              labelText: 'Filter Role',
              prefixIcon: Icon(Icons.badge_rounded),
            ),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('Semua Role')),
              DropdownMenuItem(value: 'project_owner', child: Text('Project Owner')),
              DropdownMenuItem(value: 'freelancer', child: Text('Freelancer')),
              DropdownMenuItem(value: 'admin', child: Text('Admin')),
            ],
            dropdownColor: AppColors.canvas,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _role = value);
            },
          ),
        ],
      ),
    );
  }
}
