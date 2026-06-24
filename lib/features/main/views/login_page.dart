import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_brand_logo.dart';
import '../../../core/widgets/app_gradient_background.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/premium_glass_card.dart';
import '../../../core/widgets/premium_gradient_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';
import '../../auth/controllers/auth_controller.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _controller = AuthController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final success = await _controller.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_controller.errorMessage ?? 'Login gagal.')),
      );
    }
  }

  void _goToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          body: AppGradientBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      children: [
                        const SizedBox(height: AppSpacing.xxl),
                        const _LoginHero(),
                        const SizedBox(height: AppSpacing.xl),
                        PremiumGlassCard(
                          radius: AppRadius.xxxl,
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selamat datang kembali!',
                                  style: AppTextStyles.headingSm,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'Masuk untuk melanjutkan project, chat, dan kolaborasi Anda.',
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: AppColors.slate,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                CustomTextField(
                                  controller: _emailController,
                                  label: 'Email',
                                  hint: 'contoh@email.com',
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icons.email_outlined,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Email wajib diisi.';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Format email belum benar.';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: AppSpacing.base),
                                CustomTextField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  hint: 'Masukkan password',
                                  obscureText: _obscurePassword,
                                  prefixIcon: Icons.lock_outline,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password wajib diisi.';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: AppSpacing.xl),
                                PrimaryButton(
                                  text: 'Masuk',
                                  icon: Icons.login_rounded,
                                  variant: PrimaryButtonVariant.cobalt,
                                  isLoading: _controller.isLoading,
                                  onPressed: _handleLogin,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                SecondaryButton(
                                  text: 'Daftar Akun Baru',
                                  icon: Icons.person_add_alt_1_rounded,
                                  onPressed: _controller.isLoading
                                      ? null
                                      : _goToRegisterPage,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const _TrustFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LoginHero extends StatelessWidget {
  const _LoginHero();

  @override
  Widget build(BuildContext context) {
    return PremiumGradientCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppBrandLogo(size: 78),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tolong.in',
                      style: AppTextStyles.headingLg.copyWith(
                        color: AppColors.canvas,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Kolaborasi. Terpercaya. Terselesaikan.',
                      style: AppTextStyles.bodySmBold.copyWith(
                        color: AppColors.canvas.withValues(alpha: 0.86),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Platform project mahasiswa yang terasa modern, aman, dan profesional.',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.canvas.withValues(alpha: 0.90),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: const [
              _HeroPill(icon: Icons.verified_user_rounded, label: 'Aman'),
              _HeroPill(icon: Icons.groups_rounded, label: 'Kolaboratif'),
              _HeroPill(icon: Icons.task_alt_rounded, label: 'Efisien'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.canvas.withValues(alpha: 0.16),
        borderRadius: AppRadius.all(AppRadius.full),
        border: Border.all(color: AppColors.canvas.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.canvas),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.captionBold.copyWith(
              color: AppColors.canvas,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustFooter extends StatelessWidget {
  const _TrustFooter();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Dibangun untuk kolaborasi project tanpa mengubah keamanan data dan logic aplikasi.',
      textAlign: TextAlign.center,
      style: AppTextStyles.caption.copyWith(color: AppColors.stone),
    );
  }
}
