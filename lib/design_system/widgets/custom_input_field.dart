// lib/design_system/widgets/custom_input_field.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_border_radius.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';

/// Uygulama genelinde kullanılan özel input alanı widget'ı.
/// Figma tasarımındaki yuvarlak kenarlı, gri arka planlı input prensiplerine uygun olarak tasarlanmıştır.
/// Şifre görünürlüğü, validasyon ve farklı klavye tipleri gibi özelliklere sahiptir.
class CustomInputField extends StatelessWidget {
  final TextEditingController? controller; // Input alanının kontrolcüsü
  final String? hintText; // Input alanının ipucu metni
  final TextInputType? keyboardType; // Klavye tipi (örn. email, number)
  final bool obscureText; // Metni gizle (şifre gibi)
  final Widget? suffixIcon; // Input alanının sağındaki ikon
  final Widget? prefixIcon; // Input alanının solundaki ikon
  final String? Function(String?)? validator; // Validasyon fonksiyonu
  final ValueChanged<String>? onChanged; // Metin değiştiğinde çağrılan fonksiyon
  final ValueChanged<String>? onSubmitted; // Enter'a basıldığında çağrılan fonksiyon
  final bool readOnly; // Sadece okunur mu
  final VoidCallback? onTap; // Input alanına tıklandığında çağrılan fonksiyon
  final int? maxLines; // Maksimum satır sayısı
  final int? minLines; // Minimum satır sayısı
  final bool enabled; // Etkin mi (tıklanabilir ve düzenlenebilir mi)
  final String? labelText; // Alanın etiketi

  /// Varsayılan özel input alanı.
  const CustomInputField({
    Key? key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.obscureText = false, // Varsayılan olarak metin gizlenmez
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false, // Varsayılan olarak düzenlenebilir
    this.onTap,
    this.maxLines = 1, // Varsayılan olarak tek satır
    this.minLines,
    this.enabled = true, // Varsayılan olarak etkin
    this.labelText,
  }) : super(key: key);

  /// Çok satırlı metin girişi için özel input alanı.
  CustomInputField.multiline({
    Key? key,
    this.controller,
    this.hintText,
    this.keyboardType = TextInputType.multiline, // Çok satırlı klavye
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.onTap,
    this.maxLines, // Maksimum satır sınırı yok
    this.minLines = 3, // Minimum 3 satır
    this.enabled = true,
    this.labelText,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      minLines: minLines,
      enabled: enabled,
      style: AppTextStyles.bodyText1.copyWith(color: AppColors.black), // Metin stili
      cursorColor: AppColors.primaryColor, // İmleç rengi

      decoration: InputDecoration(
        labelText: labelText, // Etiket metni
        hintText: hintText, // İpucu metni
        hintStyle: AppTextStyles.bodyText1.copyWith(color: AppColors.grey), // İpucu metin stili
        labelStyle: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey), // Etiket metin stili

        filled: true, // Arka planı doldur
        fillColor: AppColors.inputFillColor, // Arka plan rengi (açık gri)

        // Kenarlık stilleri (AppTheme'den gelen varsayılanları geçersiz kılar veya tamamlar)
        border: OutlineInputBorder(
          borderRadius: AppBorderRadius.small, // Yuvarlak kenarlar (AppBorderRadius.small kullanıldı)
          borderSide: BorderSide.none, // Varsayılan kenarlığı kaldır
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.small,
          borderSide: BorderSide.none, // Etkin durumda kenarlık yok
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.small,
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0), // Odaklandığında ana tema renginde kenarlık
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.small,
          borderSide: BorderSide(color: AppColors.red, width: 2.0), // Hata durumunda kırmızı kenarlık
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.small,
          borderSide: BorderSide(color: AppColors.red, width: 2.0),
        ),

        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // İç boşluk

        suffixIcon: suffixIcon, // Sağdaki ikon
        prefixIcon: prefixIcon, // Soldaki ikon
      ),
    );
  }
}
