// lib/features/authentication/screens/admin_login_screen.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/app_border_radius.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_card.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_button.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_input_field.dart'; // Özel input alanı widget'ı
import 'package:project_beauty_admin/design_system/extensions/context_extensions.dart'; // Context extensions for navigation
import 'package:project_beauty_admin/features/authentication/screens/signup_screen.dart'; // Kayıt Ol sayfasını import ediyoruz
import 'package:project_beauty_admin/features/dashboard/screens/admin_dashboard_screen.dart'; // Admin Dashboard sayfasını import ediyoruz

/// Admin Giriş Sayfası
/// Kullanıcıların e-posta/telefon numarası ve şifre ile giriş yapmasını sağlar.
/// Figma tasarımına (image_588c9d.png) ve belirlenen tasarım prensiplerine uygun olarak tasarlanmıştır.
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  // Formun durumunu yönetmek için GlobalKey
  final _formKey = GlobalKey<FormState>();

  // E-posta/telefon ve şifre için TextEditingController'lar
  final TextEditingController _emailPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Şifre görünürlüğü durumu
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Giriş butonuna basıldığında çalışacak fonksiyon
  void _handleLogin() {
    // Klavyeyi gizle
    context.hideKeyboard();

    if (_formKey.currentState!.validate()) {
      // Form doğrulandıysa giriş işlemini başlat
      // final String emailPhone = _emailPhoneController.text;
      // final String password = _passwordController.text;

      // TODO: Burada kimlik doğrulama (authentication) servisi çağrılacak
      // Örneğin: AuthRepository().login(emailPhone, password);

      // Şimdilik sadece konsola yazdıralım
      debugPrint('Giriş Denemesi: Doğrulandı.');
      // print('E-posta/Telefon: $emailPhone');
      // print('Şifre: $password');

      // Başarılı giriş sonrası AdminDashboardScreen'e yönlendirme
      // pushReplacement kullanılarak giriş ekranına geri dönülmesi engellenir.
      context.pushReplacement(MaterialPageRoute(builder: (context) => const AdminDashboardScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Arka plan rengi beyaz
      backgroundColor: AppColors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0), // Genel sayfa boşluğu
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // "Giriş yap" Başlığı
              Text(
                'Giriş yap',
                style: AppTextStyles.headline1.copyWith(
                  color: Colors.black, // Başlık rengi siyah
                  fontSize: 32.0, // Figma'daki gibi daha büyük başlık
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48.0), // Başlık ile kart arası boşluk

              // Giriş Formunu İçeren Özel Kart
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
                        keyboardType: TextInputType.emailAddress, // Klavye tipi
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
                        obscureText: !_isPasswordVisible, // Şifreyi gizle/göster
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: AppColors.primaryColor, // İkon rengi ana tema rengi
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible; // Şifre görünürlüğünü değiştir
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
                      const SizedBox(height: 32.0), // Input ile buton arası boşluk

                      // Giriş Yap Butonu
                      CustomButton(
                        onPressed: _handleLogin, // Butona basıldığında _handleLogin fonksiyonunu çağır
                        borderRadius: AppBorderRadius.mediumSmall,
                        backgroundColor: AppColors.primaryColor, // Buton arka plan rengi
                        padding: const EdgeInsets.symmetric(vertical: 16.0), // Butonun border radius'u
                        child: Text(
                          'Giriş yap',
                          style: AppTextStyles.buttonText, // Buton metin stili
                        ), // Buton iç boşluğu
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0), // Kart ile diğer elementler arası boşluk

              // Şifremi Unuttum ve Kayıt Ol Linkleri (Figma'da yoktu, eklendi)
              // Kullanıcı deneyimi için önemli
              TextButton(
                onPressed: () {
                  // TODO: Şifremi Unuttum sayfasına yönlendirme
                  debugPrint('Şifremi Unuttum Tıklandı');
                },
                child: Text(
                  'Şifremi Unuttum?',
                  style: AppTextStyles.bodyText1.copyWith(
                    color: AppColors.primaryColor, // Ana tema renginde link
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hesabın yok mu?',
                    style: AppTextStyles.bodyText1.copyWith(color: Colors.black54),
                  ),
                  TextButton(
                    onPressed: () {
                      // Kayıt Ol sayfasına yönlendirme
                      context.push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
                    },
                    child: Text(
                      'Kayıt Ol',
                      style: AppTextStyles.bodyText1.copyWith(
                        color: AppColors.primaryColor, // Ana tema renginde link
                        fontWeight: FontWeight.w600,
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
