import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/features/dashboard/screens/admin_dashboard_screen.dart';
import '../../../viewmodels/auth_viewmodel.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Consumer<AuthViewModel>(
        builder: (context, viewModel, child) {
          // Show error snack
          if (viewModel.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(viewModel.errorMessage!)),
              );
              viewModel.clearError();
            });
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    // Logo
                    Center(
                      child: Image.asset(
                        'assets/logos/3.png',
                        width: 64,
                        height: 64,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Admin Giriş',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headline1.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 48),

                    // E-posta / kullanıcı label
                    Text(
                      'Kullanıcı Adı veya E-posta',
                      style: AppTextStyles.bodyText2.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Kullanıcı adı veya e-posta giriniz.',
                        hintStyle: TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (val) => (val == null || val.isEmpty) ? 'Bu alan boş bırakılamaz' : null,
                    ),
                    const SizedBox(height: 24),

                    // Şifre label
                    Text(
                      'Şifre',
                      style: AppTextStyles.bodyText2.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Şifre giriniz',
                        hintStyle: TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (val) => (val == null || val.isEmpty) ? 'Bu alan boş bırakılamaz' : null,
                    ),
                    const SizedBox(height: 36),

                    // Giriş Yap butonu or loading
                    viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator(color: Colors.white))
                        : ElevatedButton(
                      onPressed: () => _handleLogin(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Giriş Yap',
                        style: AppTextStyles.bodyText1.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.white54)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Google ile devam et',
                            style: AppTextStyles.bodyText2.copyWith(color: Colors.white),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.white54)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Google buton
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.g_mobiledata, size: 48, color: Colors.white),
                          onPressed: () {},
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Google',
                          style: AppTextStyles.bodyText1.copyWith(color: Colors.white),
                        ),
                      ],
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
