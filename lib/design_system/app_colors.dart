// lib/design_system/app_colors.dart

import 'package:flutter/material.dart';

/// Uygulamanın ana renk paletini tanımlayan sınıf.
/// Tüm UI bileşenlerinde tutarlı renk kullanımı için bu sabitler kullanılmalıdır.
class AppColors {
  // Ana tema rengi: Kırmızımsı/Bordo tonu (#DE013F)
  // Figma tasarımında belirtilen ana renk.
  static const Color primaryColor = Color(0xFFDE013F);
  static const Color secondaryColor = Color(0xFF03DAC6);
  // İkincil renk: Çoğu arka plan ve kart içi için kullanılan beyaz.
  static const Color white = Colors.white;
  static const Color orange = Color(0xFFF57C00); // Uyarı veya beklemede durumlar için
  // Kartlar ve diğer yükseltilmiş öğeler için kullanılan gölge rengi.
  // %12 opaklıkta siyah, tasarıma derinlik katmak için.
  static const Color shadowColor = Color(0x1F000000); // %12 opaklık (255 * 0.12 = 30.6 -> 0x1F)

  // Kartlara veya diğer bileşenlere eklenebilecek kenarlık (stroke) rengi.
  // Genellikle ana tema rengiyle aynı veya ona yakın bir ton olabilir.
  static const Color strokeColor = Color(0xFFDE013F);

  // Metin renkleri
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color lightGrey = Color(0xFFE0E0E0); // Açık gri tonu
  static const Color darkGrey = Color(0xFF616161); // Koyu gri tonu
  static const Color red = Colors.red; // Hata mesajları veya iptal durumları için
  static const Color green = Colors.green; // Onay veya başarı durumları için
  static const Color yellow = Colors.yellow; // Bekleyen durumlar veya uyarılar için

  // Input alanları gibi arka planı gri olan yerler için
  static const Color inputFillColor = Color(0xFFF5F5F5); // Çok açık gri
  static const Color inputBorderColor = Color(0xFFE0E0E0); // Input kenarlık rengi
}
