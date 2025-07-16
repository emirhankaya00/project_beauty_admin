// lib/features/authentication/screens/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/app_border_radius.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_card.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_button.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_input_field.dart';
import 'package:project_beauty_admin/design_system/extensions/context_extensions.dart'; // Context extensions for navigation

/// Kayıt Ol Sayfası
/// Yeni kullanıcıların e-posta/telefon numarası ve şifre ile kayıt olmasını sağlar.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Formun durumunu yönetmek için GlobalKey
  final _formKey = GlobalKey<FormState>();

  // E-posta/telefon, şifre ve şifre tekrarı için TextEditingController'lar
  final TextEditingController _emailPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Şifre görünürlüğü durumları
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _emailPhoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Kayıt Ol butonuna basıldığında çalışacak fonksiyon
  void _handleSignUp() {
    // Klavyeyi gizle
    context.hideKeyboard();

    if (_formKey.currentState!.validate()) {
      // Form doğrulandıysa kayıt işlemini başlat
      final String emailPhone = _emailPhoneController.text;
      final String password = _passwordController.text;

      // TODO: Burada kimlik doğrulama (authentication) servisi çağrılacak
      // Örneğin: AuthRepository().signUp(emailPhone, password);

      // Şimdilik sadece konsola yazdıralım
      print('Kayıt Denemesi:');
      print('E-posta/Telefon: $emailPhone');
      print('Şifre: $password');

      // Başarılı kayıt sonrası kullanıcıya bilgi verip giriş sayfasına yönlendirme
      context.showSnackBar('Kayıt başarılı! Lütfen giriş yapın.');
      context.pop(); // Giriş sayfasına geri dön
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white, // Arka plan rengi beyaz
      appBar: AppBar(
        // Geri butonu ve başlık
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: AppColors.white),
          onPressed: () => context.pop(), // Geri gitme
        ),
        title: Text('Kayıt Ol', style: AppTextStyles.headline3.copyWith(color: AppColors.white)),
        backgroundColor: AppColors.primaryColor, // AppBar arka plan rengi
        elevation: 0, // Gölge yok
        centerTitle: true, // Başlığı ortala
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.bottomOnlyMedium, // Alt kenarları yuvarlatılmış
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0), // Genel sayfa boşluğu
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Kayıt Formunu İçeren Özel Kart
              CustomCard(
                borderRadius: AppBorderRadius.large, // Kartın border radius'u
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0), // Kartın iç boşluğu
                elevation: 8.0, // Kartın gölge yüksekliği
                shadowColor: AppColors.shadowColor, // Kartın gölge rengi
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // İçeriğe göre boyutlan
                    children: [
                      // E-posta & Telefon Numarası Input Alanı
                      CustomInputField(
                        controller: _emailPhoneController,
                        hintText: 'E-posta & telefon no',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen e-posta veya telefon numaranızı girin.';
                          }
                          // TODO: Daha gelişmiş e-posta/telefon validasyonu eklenebilir
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0), // Input alanları arası boşluk

                      // Şifre Input Alanı
                      CustomInputField(
                        controller: _passwordController,
                        hintText: 'Şifre',
                        obscureText: !_isPasswordVisible,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen şifrenizi girin.';
                          }
                          if (value.length < 6) {
                            return 'Şifre en az 6 karakter olmalıdır.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0), // Input alanları arası boşluk

                      // Şifre Tekrarı Input Alanı
                      CustomInputField(
                        controller: _confirmPasswordController,
                        hintText: 'Şifre Tekrarı',
                        obscureText: !_isConfirmPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: AppColors.primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen şifrenizi tekrar girin.';
                          }
                          if (value != _passwordController.text) {
                            return 'Şifreler eşleşmiyor.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32.0), // Input ile buton arası boşluk

                      // Kayıt Ol Butonu
                      CustomButton(
                        onPressed: _handleSignUp,
                        borderRadius: AppBorderRadius.mediumSmall,
                        child: Text(
                          'Kayıt Ol',
                          style: AppTextStyles.buttonText,
                        ),
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0), // Kart ile diğer elementler arası boşluk

              // Zaten hesabın var mı? Giriş Yap linki
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Zaten hesabın var mı?',
                    style: AppTextStyles.bodyText1.copyWith(color: Colors.black54),
                  ),
                  TextButton(
                    onPressed: () {
                      context.pop(); // Giriş sayfasına geri dön
                    },
                    child: Text(
                      'Giriş Yap',
                      style: AppTextStyles.bodyText1.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
