// lib/features/authentication/screens/admin_login_screen.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_button.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_input_field.dart';
import 'package:project_beauty_admin/features/dashboard/screens/admin_dashboard_screen.dart';
import 'package:provider/provider.dart';

import '../auth_viewmodel.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController(text: "admin@gmail.com");
  final _passwordController = TextEditingController(text: "123456");
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  Future<void> _handleLogin(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final authViewModel = context.read<AuthViewModel>();

    final success = await authViewModel.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white, // HATA DÜZELTİLDİ: 'background' yerine 'white' kullandık.
      body: Consumer<AuthViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(viewModel.errorMessage!),
                  backgroundColor: AppColors.red, // HATA DÜZELTİLDİ: 'error' yerine 'red' kullandık.
                ),
              );
              viewModel.clearError();
            });
          }

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Admin Paneli', style: AppTextStyles.headline1),
                    const SizedBox(height: 8),
                    Text('Giriş Yap', style: AppTextStyles.bodyText1.copyWith(color: AppColors.grey)),
                    const SizedBox(height: 40),
                    CustomInputField(
                      controller: _emailController,
                      hintText: 'E-posta', // labelText yerine hintText kullandık, tasarımına daha uygun.
                      // HATA DÜZELTİLDİ: IconData yerine Icon widget'ı gönderildi.
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primaryColor),
                      validator: (value) => value!.isEmpty ? 'Bu alan boş bırakılamaz' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomInputField(
                      controller: _passwordController,
                      hintText: 'Şifre',
                      // HATA DÜZELTİLDİ: 'isPassword' yok, 'obscureText' var.
                      obscureText: !_isPasswordVisible,
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primaryColor),
                      // suffixIcon'u da tasarımına uygun hale getirelim
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      validator: (value) => value!.isEmpty ? 'Bu alan boş bırakılamaz' : null,
                    ),
                    const SizedBox(height: 24),
                    viewModel.isLoading
                        ? const CircularProgressIndicator()
                        : CustomButton(
                      onPressed: () => _handleLogin(context),
                      // HATA DÜZELTİLDİ: 'text' parametresi yok, 'child' var.
                      child: Text('Giriş Yap', style: AppTextStyles.buttonText),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}