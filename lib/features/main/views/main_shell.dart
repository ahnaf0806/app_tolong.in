import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/controllers/auth_controller.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final AuthController _authController = AuthController();

  int _currentIndex = 0;

  final List<Widget> _pages = const [
    _PlaceholderPage(
      title: 'Home',
      description:
          'Ringkasan aktivitas, project terbaru, dan rekomendasi freelancer.',
      icon: Icons.home_rounded,
    ),
    _PlaceholderPage(
      title: 'Cari Project',
      description: 'Lihat daftar project yang tersedia untuk freelancer.',
      icon: Icons.search_rounded,
    ),
    _PlaceholderPage(
      title: 'Buat Project',
      description: 'Buat project baru dan cari freelancer mahasiswa.',
      icon: Icons.add_circle_rounded,
    ),
    _PlaceholderPage(
      title: 'Chat',
      description: 'Diskusi project antara project owner dan freelancer.',
      icon: Icons.chat_bubble_rounded,
    ),
    _PlaceholderPage(
      title: 'Aktivitas',
      description: 'Pantau project, proposal, workspace, dan riwayat project.',
      icon: Icons.assignment_rounded,
    ),
  ];

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    await _authController.logout();
  }

  @override
  Widget build(BuildContext context) {
    final bool isProfilePage = _currentIndex == 5;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tolingin'),
        actions: [
          if (isProfilePage)
            IconButton(
              onPressed: _logout,
              icon: const Icon(Icons.logout_rounded),
              tooltip: 'Logout',
            ),
        ],
      ),
      body: isProfilePage
          ? const _ProfilePlaceholderPage()
          : _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        indicatorColor: AppColors.primary.withOpacity(0.12),
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'Project',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle_rounded),
            label: 'Buat',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment_rounded),
            label: 'Aktivitas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
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

class _ProfilePlaceholderPage extends StatelessWidget {
  const _ProfilePlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.surfaceSoft,
            child: Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: 40,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Profil', style: AppTextStyles.headingLg),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Nanti halaman ini berisi data diri, skill, portofolio, rating, dan riwayat project.',
            style: AppTextStyles.bodyMd,
          ),
        ],
      ),
    );
  }
}
