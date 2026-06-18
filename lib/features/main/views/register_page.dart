import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/widgets/auth_header.dart';
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

  String _selectedRole = 'seeker';
  bool _obscurePassword = true;

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

    if (!isValid) {
      return;
    }

    final int semester = int.parse(_semesterController.text);

    final success = await _controller.register(
      name: _fullNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      university: _universityController.text,
      studyProgram: _studyProgramController.text,
      semester: semester,
      role: _selectedRole,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Registrasi berhasil. Silahkan cek email untuk verifikasi akun sebelum login',
          ),
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
    if (value == null || value.trim().isEmpty) {
      return 'Semester wajib diisi.';
    }

    final semester = int.tryParse(value);

    if (semester == null) {
      return 'Semester harus berupa angka.';
    }

    if (semester < 1 || semester > 14) {
      return 'Semester harus antara 1 sampai 14.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AuthHeader(
                      title: 'Buat akun baru',
                      subtitle:
                          'Lengkapi data agar bantuan akademik lebih terarah.',
                    ),
                    const SizedBox(height: AppSpacing.xxl),
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
                        if (value == null || value.isEmpty) {
                          return 'Password wajib diisi.';
                        }

                        if (value.length < 6) {
                          return 'Password minimal 6 karakter.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.base),
                    CustomTextField(
                      controller: _universityController,
                      label: 'Universitas',
                      prefixIcon: Icons.school_outlined,
                      validator: (value) {
                        return _requiredValidator(value, 'Universitas');
                      },
                    ),
                    const SizedBox(height: AppSpacing.base),
                    CustomTextField(
                      controller: _studyProgramController,
                      label: 'Program Studi',
                      prefixIcon: Icons.menu_book_outlined,
                      validator: (value) {
                        return _requiredValidator(value, 'Program studi');
                      },
                    ),
                    const SizedBox(height: AppSpacing.base),
                    CustomTextField(
                      controller: _semesterController,
                      label: 'Semester',
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.numbers_outlined,
                      validator: _semesterValidator,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    RoleSelector(
                      selectedRole: _selectedRole,
                      onChanged: (role) {
                        setState(() {
                          _selectedRole = role;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    PrimaryButton(
                      text: 'Daftar',
                      variant: PrimaryButtonVariant.cobalt,
                      isLoading: _controller.isLoading,
                      onPressed: _handleRegister,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
