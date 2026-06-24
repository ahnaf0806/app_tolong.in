import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../profiles/services/profile_service.dart';
import '../../projects/views/create_project_page.dart';
import '../../projects/views/project_list_page.dart';
import 'owner_activity_page.dart';
import '../../profiles/views/profile_page.dart';
import 'freelancer_activity_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final AuthController _authController = AuthController();
  final ProfileService _profileService = ProfileService();

  String? _currentRole;
  bool _isLoadingRole = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCurrentRole();
  }

  Future<void> _loadCurrentRole() async {
    final role = await _profileService.getCurrentUserRole();

    if (!mounted) {
      return;
    }

    setState(() {
      _currentRole = role;
      _isLoadingRole = false;
      _currentIndex = 0;
    });
  }

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    await _authController.logout();
  }

  List<_MainNavItem> _getNavigationItems() {
    if (_currentRole == 'project_owner') {
      return [
        const _MainNavItem(
          page: _PlaceholderPage(
            title: 'Home',
            description:
                'Ringkasan aktivitas, project terbaru, dan rekomendasi freelancer.',
            icon: Icons.home_rounded,
          ),
          destination: NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
        ),
        const _MainNavItem(
          page: _PlaceholderPage(
            title: 'Cari Freelancer',
            description:
                'Temukan freelancer mahasiswa berdasarkan skill, portofolio, dan rating.',
            icon: Icons.groups_rounded,
          ),
          destination: NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups_rounded),
            label: 'Freelancer',
          ),
        ),
        const _MainNavItem(
          page: CreateProjectPage(),
          destination: NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle_rounded),
            label: 'Buat',
          ),
        ),
        const _MainNavItem(
          page: _PlaceholderPage(
            title: 'Chat',
            description: 'Diskusi project antara project owner dan freelancer.',
            icon: Icons.chat_bubble_rounded,
          ),
          destination: NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Chat',
          ),
        ),
        const _MainNavItem(
          page: OwnerActivityPage(),
          destination: NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment_rounded),
            label: 'Aktivitas',
          ),
        ),
        _MainNavItem(
          page: ProfilePage(onLogout: _logout),
          destination: NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ),
      ];
    }

    return [
      const _MainNavItem(
        page: _PlaceholderPage(
          title: 'Home',
          description:
              'Ringkasan aktivitas, project terbaru, dan rekomendasi project.',
          icon: Icons.home_rounded,
        ),
        destination: NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
      ),
      const _MainNavItem(
        page: ProjectListPage(),
        destination: NavigationDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search_rounded),
          label: 'Project',
        ),
      ),
      const _MainNavItem(
        page: _PlaceholderPage(
          title: 'Chat',
          description: 'Diskusi project antara project owner dan freelancer.',
          icon: Icons.chat_bubble_rounded,
        ),
        destination: NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline),
          selectedIcon: Icon(Icons.chat_bubble_rounded),
          label: 'Chat',
        ),
      ),
      const _MainNavItem(
        page: FreelancerActivityPage(),
        destination: NavigationDestination(
          icon: Icon(Icons.assignment_outlined),
          selectedIcon: Icon(Icons.assignment_rounded),
          label: 'Aktivitas',
        ),
      ),
      _MainNavItem(
        page: ProfilePage(onLogout: _logout),
        destination: NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Profil',
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingRole) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final navItems = _getNavigationItems();
    final safeIndex = _currentIndex >= navItems.length ? 0 : _currentIndex;
    final currentPage = navItems[safeIndex].page;

    return Scaffold(
      appBar: AppBar(title: const Text('Tolong.in')),
      body: currentPage,
      bottomNavigationBar: NavigationBar(
        selectedIndex: safeIndex,
        indicatorColor: AppColors.primary.withValues(alpha: 0.12),
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: navItems.map((item) => item.destination).toList(),
      ),
    );
  }
}

class _MainNavItem {
  final Widget page;
  final NavigationDestination destination;

  const _MainNavItem({required this.page, required this.destination});
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _PlaceholderPage({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 48, color: AppColors.primary),
          const SizedBox(height: AppSpacing.lg),
          Text(title, style: AppTextStyles.headingLg),
          const SizedBox(height: AppSpacing.sm),
          Text(description, style: AppTextStyles.bodyMd),
        ],
      ),
    );
  }
}
