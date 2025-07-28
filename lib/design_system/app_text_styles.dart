// lib/design_system/app_text_styles.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Poppins fontunu kullanmak için
import 'package:project_beauty_admin/design_system/app_colors.dart'; // Renkleri kullanmak için

/// Uygulamanın metin stillerini tanımlayan sınıf.
/// Poppins font ailesi kullanılır.
class AppTextStyles {
  // Başlıklar için varsayılan stil (örn. "Giriş yap" başlığı)
  static TextStyle headline1 = GoogleFonts.poppins(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  // Alt başlıklar veya önemli vurgular için stil (örn. kart başlıkları)
  static TextStyle headline2 = GoogleFonts.poppins(
    fontSize: 24.0,
    fontWeight: FontWeight.w600, // Semi-bold
    color: AppColors.black,
  );

  // Daha küçük başlıklar veya bölüm başlıkları için stil
  static TextStyle headline3 = GoogleFonts.poppins(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  // Genel gövde metinleri için stil (normal boyut)
  static TextStyle bodyText1 = GoogleFonts.poppins(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.darkGrey,
  );

  // Daha küçük gövde metinleri veya açıklayıcı notlar için stil
  static TextStyle bodyText2 = GoogleFonts.poppins(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
  );

  // Buton metinleri için stil (onay pop-up'ında kullanılan)
  static TextStyle buttonText = GoogleFonts.poppins(
    fontSize: 16.0,
    fontWeight: FontWeight.w600, // Semi-bold
    color: AppColors.white,
  );

  // Küçük etiketler veya durum göstergeleri için stil (badge'ler)
  static TextStyle labelText = GoogleFonts.poppins(
    fontSize: 10.0,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.black,
  );

  // Link metinleri için stil
  static TextStyle linkText = GoogleFonts.poppins(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
  );
}