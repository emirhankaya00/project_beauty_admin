// lib/design_system/app_border_radius.dart

import 'package:flutter/material.dart';

/// Uygulamanın genelinde kullanılacak kenar yuvarlaklığı (border radius) değerlerini tanımlayan sınıf.
/// Card'lar, butonlar ve diğer UI bileşenleri için tutarlı yuvarlaklıklar sağlar.
class AppBorderRadius {
  // Çok küçük yuvarlaklık (örn. küçük kartlar veya input alanları için)
  // Figma tasarımında belirtilen 6 birimlik yuvarlaklık. Daha yumuşak kenarlar için 10.0'a yükseltildi.
  static const BorderRadius small = BorderRadius.all(Radius.circular(10.0));

  // Orta küçük yuvarlaklık (örn. butonlar için)
  // Figma tasarımında belirtilen 8 birimlik yuvarlaklık. Daha yumuşak kenarlar için 15.0'a yükseltildi.
  static const BorderRadius mediumSmall = BorderRadius.all(Radius.circular(15.0));

  // Orta yuvarlaklık (örn. genel kartlar için)
  // Figma tasarımında belirtilen 12 birimlik yuvarlaklık. Daha yumuşak kenarlar için 20.0'a yükseltildi.
  static const BorderRadius medium = BorderRadius.all(Radius.circular(20.0));

  // Büyük yuvarlaklık (örn. daha büyük kartlar veya özel durumlar için)
  // Figma tasarımında belirtilen 15 birimlik yuvarlaklık. Daha yumuşak kenarlar için 30.0'a yükseltildi.
  static const BorderRadius large = BorderRadius.all(Radius.circular(30.0));

  // Çok büyük yuvarlaklık (örn. en büyük kartlar veya özel durumlar için)
  // Figma tasarımında belirtilen 18 birimlik yuvarlaklık. Daha yumuşak kenarlar için 40.0'a yükseltildi.
  static const BorderRadius extraLarge = BorderRadius.all(Radius.circular(40.0));

  // Sadece belirli köşeleri yuvarlatmak için örnekler (kullanıma göre eklenebilir)
  static const BorderRadius topOnlyMedium = BorderRadius.only(
    topLeft: Radius.circular(20.0), // Yeni medium değeriyle uyumlu
    topRight: Radius.circular(20.0), // Yeni medium değeriyle uyumlu
  );

  static const BorderRadius bottomOnlyMedium = BorderRadius.only(
    bottomLeft: Radius.circular(20.0), // Yeni medium değeriyle uyumlu
    bottomRight: Radius.circular(20.0), // Yeni medium değeriyle uyumlu
  );
}
