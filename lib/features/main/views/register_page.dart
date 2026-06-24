import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_brand_logo.dart';
import '../../../core/widgets/app_gradient_background.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/premium_glass_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/widgets/role_selector.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController _controller = AuthController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _studyProgramController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();

  String _selectedRole = 'project_owner';
  bool _obscurePassword = true;

  bool get _isFreelancer => _selectedRole == 'freelancer';

  @override
  void dispose() {
    _controller.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _universityController.dispose();
    _studyProgramController.dispose();
    _semesterController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    int? semester;

    if (_isFreelancer) {
      semester = int.tryParse(_semesterController.text.trim());
      if (semester == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Semester wajib diisi dengan angka.')),
        );
        return;
      }
    }

    final success = await _controller.register(
      name: _fullNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      university: _isFreelancer ? _universityController.text : null,
      studyProgram: _isFreelancer ? _studyProgramController.text : null,
      semester: _isFreelancer ? semester : null,
      role: _selectedRole,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi berhasil. Kamu sudah bisa login.'),
        ),
      );
      Navigator.pop(context);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_controller.errorMessage ?? 'Registrasi gagal.')),
    );
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi.';
    }
    return null;
  }

  String? _semesterValidator(String? value) {
    if (!_isFreelancer) return null;
    if (value == null || value.trim().isEmpty) {
      return 'Semester wajib diisi.';
    }

    final semester = int.tryParse(value);
    if (semester == null) return 'Semester harus berupa angka.';
    if (semester < 1 || semester > 14) return 'Semester harus antara 1 sampai 14.';
    return null;
  }

  void _onRoleChanged(String role) {
    setState(() {
      _selectedRole = role;
      if (role == 'project_owner') {
        _universityController.clear();
        _studyProgramController.clear();
        _semesterController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Daftar Akun'),
          ),
          body: AppGradientBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _RegisterHero(),
                        const SizedBox(height: AppSpacing.xl),
                        PremiumGlassCard(
                          radius: AppRadius.xxxl,
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Lengkapi Data Akun', style: AppTextStyles.headingSm),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'Pilih peran yang sesuai agar pengalaman aplikasi langsung menyesuaikan kebutuhanmu.',
                                  style: AppTextStyles.bodySm.copyWith(color: AppColors.slate),
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                CustomTextField(
                                  controller: _fullNameController,
                                  label: 'Nama Lengkap',
                                  prefixIcon: Icons.person_outline,
                                  validator: (value) {
                                    return _requiredValidator(value, 'Nama lengkap');
                                  },
                                ),
                                const SizedBox(height: AppSpacing.base),
                                CustomTextField(
                                  controller: _emailController,
                                  label: 'Email',
                                  hint: 'nama@email.com',
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icons.email_outlined,
                                  validator: (value) {
                                    final required = _requiredValidator(value, 'Email');
                                    if (required != null) return required;
                                    if (!(value?.contains('@') ?? false)) {
                                      return 'Format email belum benar.';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: AppSpacing.base),
                                CustomTextField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  hint: 'Minimal 6 karakter',
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
                                    final required = _requiredValidator(value, 'Password');
                                    if (required != null) return required;
                                    if ((value?.length ?? 0) < 6) {
                                      return 'Password minimal 6 karakter.';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                RoleSelector(
                                  selectedRole: _selectedRole,
                                  onChanged: _onRoleChanged,
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 240),
                                  child: _isFreelancer
                                      ? _FreelancerFields(
                                          universityController: _universityController,
                                          studyProgramController: _studyProgramController,
                                          semesterController: _semesterController,
                                          requiredValidator: _requiredValidator,
                                          semesterValidator: _semesterValidator,
                                        )
                                      : const SizedBox.shrink(),
                                ),
                                const SizedBox(height: AppSpacing.xl),
                                PrimaryButton(
                                  text: 'Daftar Sekarang',
                                  icon: Icons.rocket_launch_rounded,
                                  variant: PrimaryButtonVariant.cobalt,
                                  isLoading: _controller.isLoading,
                                  onPressed: _handleRegister,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Center(
                          child: Text(
                            'Dengan mendaftar, kamu bergabung dalam ekosistem project mahasiswa yang aman dan profesional.',
                            style: AppTextStyles.caption.copyWith(color: AppColors.stone),
                            textAlign: TextAlign.center,
                          ),
                        ),
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

class _RegisterHero extends StatelessWidget {
  const _RegisterHero();

  @override
  Widget build(BuildContext context) {
    return PremiumGlassCard(
      radius: AppRadius.xxxl,
      backgroundColor: AppColors.canvas.withValues(alpha: 0.80),
      child: Row(
        children: [
          const AppBrandLogo(size: 68),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Buat Akun Tolong.in', style: AppTextStyles.headingSm),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Mulai sebagai Project Owner atau Student Freelancer.',
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.slate),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FreelancerFields extends StatelessWidget {
  final TextEditingController universityController;
  final TextEditingController studyProgramController;
  final TextEditingController semesterController;
  final String? Function(String? value, String fieldName) requiredValidator;
  final String? Function(String? value) semesterValidator;

  const _FreelancerFields({
    required this.universityController,
    required this.studyProgramController,
    required this.semesterController,
    required this.requiredValidator,
    required this.semesterValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('freelancer-fields'),
      children: [
        const SizedBox(height: AppSpacing.lg),
        CustomTextField(
          controller: universityController,
          label: 'Universitas',
          prefixIcon: Icons.account_balance_outlined,
          validator: (value) => requiredValidator(value, 'Universitas'),
        ),
        const SizedBox(height: AppSpacing.base),
        CustomTextField(
          controller: studyProgramController,
          label: 'Program Studi',
          prefixIcon: Icons.school_outlined,
          validator: (value) => requiredValidator(value, 'Program studi'),
        ),
        const SizedBox(height: AppSpacing.base),
        CustomTextField(
          controller: semesterController,
          label: 'Semester',
          hint: 'Contoh: 4',
          keyboardType: TextInputType.number,
          prefixIcon: Icons.layers_outlined,
          validator: semesterValidator,
        ),
      ],
    );
  }
}
