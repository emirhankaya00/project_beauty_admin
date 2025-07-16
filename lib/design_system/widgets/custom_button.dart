// lib/design_system/widgets/custom_button.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_border_radius.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';

/// Uygulama genelinde kullanılan özel buton widget'ı.
/// Figma tasarımındaki yuvarlak kenarlı, ana tema rengindeki buton prensiplerine uygun olarak tasarlanmıştır.
/// Farklı kullanım senaryoları için çeşitli varyasyonlara sahiptir.
class CustomButton extends StatelessWidget {
  final VoidCallback onPressed; // Butona tıklandığında çalışacak fonksiyon
  final Widget child; // Butonun içinde gösterilecek içerik (genellikle Text)
  final BorderRadiusGeometry? borderRadius; // Butonun köşe yuvarlaklığı
  final EdgeInsetsGeometry? padding; // Butonun iç boşluğu
  final Color? backgroundColor; // Butonun arka plan rengi
  final TextStyle? textStyle; // Buton metninin stili
  final BoxBorder? border; // Butonun kenarlığı (stroke)
  final Color? foregroundColor; // Butonun ön plan rengi (metin/ikon rengi)
  final double? width; // Butonun genişliği
  final double? height; // Butonun yüksekliği

  /// Varsayılan özel buton.
  /// Ana tema renginde arka plan, orta küçük yuvarlaklık ve beyaz metne sahiptir.
  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.padding,
    this.backgroundColor,
    this.textStyle,
    this.border,
    this.foregroundColor,
    this.width,
    this.height,
  }) : super(key: key);

  /// Kenarlıklı (outlined) buton varyasyonu.
  /// Şeffaf arka plan, ana tema renginde kenarlık ve metne sahiptir.
  CustomButton.outline({
    Key? key,
    required this.onPressed,
    required this.child,
    this.borderRadius = AppBorderRadius.mediumSmall, // Varsayılan buton yuvarlaklığı
    this.padding,
    this.backgroundColor = Colors.transparent, // Arka plan şeffaf
    this.textStyle, // Metin stili (varsayılan olarak AppTextStyles.buttonText.copyWith(color: AppColors.primaryColor) kullanılabilir)
    this.border = const Border.fromBorderSide(
        BorderSide(color: AppColors.primaryColor, width: 1.5)), // Ana tema renginde kenarlık
    this.foregroundColor = AppColors.primaryColor, // Metin rengi ana tema rengi
    this.width,
    this.height,
  }) : super(key: key);

  /// İkincil (secondary) buton varyasyonu.
  /// Genellikle daha az vurgulu aksiyonlar için kullanılır.
  /// Açık gri arka plan, koyu metin.
  CustomButton.secondary({
    Key? key,
    required this.onPressed,
    required this.child,
    this.borderRadius = AppBorderRadius.mediumSmall, // Varsayılan buton yuvarlaklığı
    this.padding,
    this.backgroundColor = AppColors.lightGrey, // Açık gri arka plan
    this.textStyle, // Metin stili (varsayılan olarak AppTextStyles.buttonText.copyWith(color: AppColors.darkGrey) kullanılabilir)
    this.border,
    this.foregroundColor = AppColors.darkGrey, // Koyu gri metin
    this.width,
    this.height,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SizedBox( // Butonun genişliğini ve yüksekliğini kontrol etmek için SizedBox
      width: width ?? double.infinity, // Genişlik verilmezse tam genişlik
      height: height ?? 50.0, // Varsayılan yükseklik (daha dar)
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          // Arka plan rengi (varsayılan olarak ana tema rengi)
          backgroundColor: backgroundColor ?? AppColors.primaryColor,
          // Ön plan rengi (metin/ikon rengi, varsayılan olarak beyaz)
          foregroundColor: foregroundColor ?? AppColors.white,
          // Butonun köşe yuvarlaklığı
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? AppBorderRadius.mediumSmall, // Varsayılan buton yuvarlaklığı
            side: border is BorderSide ? (border as BorderSide) : BorderSide.none, // Kenarlık varsa uygula
          ),
          // Butonun iç boşluğu (daha geniş yatay, daha dar dikey)
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
          // Metin stilini uygula (child bir Text ise)
          textStyle: textStyle ?? AppTextStyles.buttonText,
          // Gölgeyi kaldır (daha düz bir görünüm için, Figma'ya uygun)
          elevation: 0,
        ),
        child: child,
      ),
    );
  }
}
