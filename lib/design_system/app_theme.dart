// lib/design_system/app_theme.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/app_border_radius.dart';

/// Uygulamanın genel tema ayarlarını tanımlayan sınıf.
/// Bu tema, MaterialApp widget'ına uygulanarak uygulamanın tüm UI bileşenlerinde
/// tutarlı bir görünüm ve his sağlar.
class AppTheme {
  /// Uygulamanın varsayılan açık tema ayarları.
  static ThemeData lightTheme = ThemeData(
    // Material Design 3'ü etkinleştir
    useMaterial3: true,

    // Ana renk paleti
    primaryColor: AppColors.primaryColor, // Birincil renk
    hintColor: AppColors.primaryColor, // Vurgu rengi (eski accentColor)
    scaffoldBackgroundColor: AppColors.white, // Sayfa arka plan rengi

    // Renk şeması (Material 3 için önerilen)
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor, // Ana renk olarak belirlenen tohum rengi
      primary: AppColors.primaryColor,
      onPrimary: AppColors.white,
      secondary: AppColors.primaryColor, // İkincil renk olarak ana rengi kullanabiliriz veya farklı bir renk belirleyebiliriz
      onSecondary: AppColors.white,
      surface: AppColors.white, // Kartlar, diyaloglar gibi yüzeyler için
      onSurface: AppColors.black,
      error: AppColors.red, // Hata durumları için
      onError: AppColors.white,
    ),

    // Metin teması
    textTheme: TextTheme(
      // Başlıklar
      displayLarge: AppTextStyles.headline1, // En büyük başlık
      displayMedium: AppTextStyles.headline2,
      headlineLarge: AppTextStyles.headline3, // Daha küçük başlıklar
      headlineMedium: AppTextStyles.headline3,
      headlineSmall: AppTextStyles.headline3,

      // Gövde metinleri
      bodyLarge: AppTextStyles.bodyText1, // Normal gövde metni
      bodyMedium: AppTextStyles.bodyText1,
      bodySmall: AppTextStyles.bodyText2, // Küçük gövde metni

      // Butonlar, etiketler vb.
      labelLarge: AppTextStyles.buttonText, // Büyük etiket/buton metni
      labelMedium: AppTextStyles.labelText, // Orta etiket metni
      labelSmall: AppTextStyles.labelText, // Küçük etiket metni
    ),

    // Buton teması (ElevatedButton)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor, // Buton arka plan rengi
        foregroundColor: AppColors.white, // Buton metin rengi
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.mediumSmall, // Buton kenar yuvarlaklığı
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Buton iç boşluğu
        textStyle: AppTextStyles.buttonText, // Buton metin stili
        elevation: 0, // Gölgeyi kaldır (daha düz bir görünüm için)
      ),
    ),

    // Kart teması (Card)
    cardTheme: CardThemeData( // 'CardTheme' yerine 'CardThemeData' olarak düzeltildi
      color: AppColors.white, // Kart arka plan rengi
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.large, // Kart kenar yuvarlaklığı (Figma'ya göre)
      ),
      elevation: 8.0, // Kart gölge yüksekliği (Figma'ya göre)
      shadowColor: AppColors.shadowColor, // Kart gölge rengi
      margin: EdgeInsets.zero, // Varsayılan margin'i sıfırla, CustomCard'da yönetilecek
    ),

    // AppBar teması
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor, // AppBar arka plan rengi
      foregroundColor: AppColors.white, // AppBar ikon ve metin rengi
      elevation: 0, // Gölgeyi kaldır
      centerTitle: true, // Başlığı ortala
      titleTextStyle: AppTextStyles.headline3.copyWith(color: AppColors.white), // AppBar başlık stili
      toolbarHeight: 60.0, // AppBar yüksekliği
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.bottomOnlyMedium, // Alt kenarları yuvarlatılmış AppBar (Figma'daki gibi)
      ),
    ),

    // Input alanları (TextField, TextFormField) teması
    inputDecorationTheme: InputDecorationTheme(
      filled: true, // Arka plan doldurulsun
      fillColor: AppColors.inputFillColor, // Doldurma rengi
      border: OutlineInputBorder(
        borderRadius: AppBorderRadius.small, // Input kenar yuvarlaklığı
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
      labelStyle: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey), // Label metin stili
      hintStyle: AppTextStyles.bodyText1.copyWith(color: AppColors.grey), // Hint metin stili
      errorStyle: AppTextStyles.bodyText2.copyWith(color: AppColors.red), // Hata metin stili
    ),

    // İkon teması
    iconTheme: const IconThemeData(
      color: AppColors.primaryColor, // Varsayılan ikon rengi
      size: 24.0, // Varsayılan ikon boyutu
    ),

    // BottomNavigationBar teması
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.primaryColor, // Alt navigasyon çubuğu arka planı
      selectedItemColor: AppColors.white, // Seçili ikon rengi
      unselectedItemColor: AppColors.white.withOpacity(0.7), // Seçili olmayan ikon rengi
      selectedLabelStyle: AppTextStyles.bodyText2.copyWith(color: AppColors.white),
      unselectedLabelStyle: AppTextStyles.bodyText2.copyWith(color: AppColors.white.withOpacity(0.7)),
      type: BottomNavigationBarType.fixed, // İkonların sabit kalmasını sağlar
      elevation: 10.0, // Gölge
    ),

    // Dialog teması
    dialogTheme: DialogThemeData( // 'DialogTheme' yerine 'DialogThemeData' olarak düzeltildi
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.medium, // Diyalog kutularının kenar yuvarlaklığı
      ),
      elevation: 8.0,
      titleTextStyle: AppTextStyles.headline3,
      contentTextStyle: AppTextStyles.bodyText1,
    ),

    // SnackBar teması
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primaryColor,
      contentTextStyle: AppTextStyles.bodyText1.copyWith(color: AppColors.white),
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.small,
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
