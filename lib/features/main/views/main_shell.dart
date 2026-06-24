import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_brand_logo.dart';
import '../../../core/widgets/app_gradient_background.dart';
import '../../admin/views/admin_dashboard_page.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../chat/views/chat_inbox_page.dart';
import '../../freelancers/views/freelancer_directory_page.dart';
import '../../profiles/services/profile_service.dart';
import '../../profiles/views/profile_page.dart';
import '../../projects/views/create_project_page.dart';
import '../../projects/views/project_list_page.dart';
import 'freelancer_activity_page.dart';
import 'home_dashboard_page.dart';
import 'owner_activity_page.dart';

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

    if (!mounted) return;

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
    if (_currentRole == 'admin') {
      return [
        const _MainNavItem(
          page: AdminDashboardPage(),
          destination: NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
        ),
        _MainNavItem(
          page: ProfilePage(onLogout: _logout),
          destination: const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ),
      ];
    }

    if (_currentRole == 'project_owner') {
      return [
        const _MainNavItem(
          page: HomeDashboardPage(role: 'project_owner'),
          destination: NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
        ),
        const _MainNavItem(
          page: FreelancerDirectoryPage(),
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
          page: ChatInboxPage(),
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
          destination: const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ),
      ];
    }

    return [
      const _MainNavItem(
        page: HomeDashboardPage(role: 'freelancer'),
        destination: NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Beranda',
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
        page: ChatInboxPage(),
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
        destination: const NavigationDestination(
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
      return const Scaffold(
        body: AppGradientBackground(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final navItems = _getNavigationItems();
    final safeIndex = _currentIndex >= navItems.length ? 0 : _currentIndex;
    final currentPage = navItems[safeIndex].page;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 72,
        titleSpacing: 18,
        title: Row(
          children: [
            const AppBrandLogo(size: 42),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Tolong.in'),
                  Text(
                    _roleSubtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.stone,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: AppGradientBackground(child: currentPage),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.inkDeep.withValues(alpha: 0.10),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: NavigationBar(
              selectedIndex: safeIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              destinations: navItems.map((item) => item.destination).toList(),
            ),
          ),
        ),
      ),
    );
  }

  String get _roleSubtitle {
    if (_currentRole == 'admin') return 'Admin Control Center';
    if (_currentRole == 'project_owner') return 'Project Owner Workspace';
    return 'Student Freelancer Workspace';
  }
}

class _MainNavItem {
  final Widget page;
  final NavigationDestination destination;

  const _MainNavItem({required this.page, required this.destination});
}
