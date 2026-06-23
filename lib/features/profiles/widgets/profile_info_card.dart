import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/profile_model.dart';

class ProfileInfoCard extends StatelessWidget {
  final ProfileModel profile;

  const ProfileInfoCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.canvas,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: AppColors.hairlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Informasi Profil', style: AppTextStyles.bodyMdBold),
            const SizedBox(height: AppSpacing.base),
            _InfoTile(
              icon: Icons.person_rounded,
              label: 'Nama',
              value: profile.name,
            ),
            _InfoTile(
              icon: Icons.email_rounded,
              label: 'Email',
              value: profile.email,
            ),
            _InfoTile(
              icon: Icons.badge_rounded,
              label: 'Role',
              value: profile.roleLabel,
            ),
            if (profile.isFreelancer) ...[
              _InfoTile(
                icon: Icons.school_rounded,
                label: 'Universitas',
                value: profile.university ?? '-',
              ),
              _InfoTile(
                icon: Icons.menu_book_rounded,
                label: 'Program Studi',
                value: profile.studyProgram ?? '-',
              ),
              _InfoTile(
                icon: Icons.timeline_rounded,
                label: 'Semester',
                value: profile.semester?.toString() ?? '-',
              ),
              _InfoTile(
                icon: Icons.psychology_rounded,
                label: 'Skills',
                value: profile.skillsText,
              ),
              _InfoTile(
                icon: Icons.link_rounded,
                label: 'Portfolio',
                value: profile.portfolioUrl ?? '-',
              ),
              _InfoTile(
                icon: Icons.notes_rounded,
                label: 'Bio',
                value: profile.bio ?? '-',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.base),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.bodySm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
