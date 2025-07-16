// lib/design_system/widgets/app_icons.dart

import 'package:flutter/material.dart';
// Eğer özel ikon fontları kullanılacaksa buraya import edilebilir (örn. font_awesome_flutter)

/// Uygulama genelinde kullanılacak ikonları tanımlayan sınıf.
/// Flutter'ın Material Icons kütüphanesini kullanır.
/// İleride özel ikonlar eklenecekse buraya eklenebilir veya IconData'lar gruplanabilir.
class AppIcons {
  // Kimlik doğrulama ikonları
  static const IconData email = Icons.email_outlined;
  static const IconData phone = Icons.phone_outlined;
  static const IconData password = Icons.lock_outline;
  static const IconData visibility = Icons.visibility_outlined;
  static const IconData visibilityOff = Icons.visibility_off_outlined;

  // Genel navigasyon ve aksiyon ikonları
  static const IconData home = Icons.home_outlined;
  static const IconData search = Icons.search;
  static const IconData filter = Icons.filter_list;
  static const IconData add = Icons.add_circle_outline;
  static const IconData edit = Icons.edit_outlined;
  static const IconData delete = Icons.delete_outline;
  static const IconData back = Icons.arrow_back_ios_new_outlined;
  static const IconData settings = Icons.settings_outlined;
  static const IconData notifications = Icons.notifications_outlined;
  static const IconData person = Icons.person_outline; // Genel kullanıcı/personel ikonu
  static const IconData calendar = Icons.calendar_today_outlined; // Takvim/Randevu ikonu
  static const IconData check = Icons.check_circle_outline; // Onay ikonu
  static const IconData close = Icons.cancel_outlined; // İptal/Kapat ikonu
  static const IconData info = Icons.info_outline; // Bilgi ikonu

  // Admin Paneli ana başlık ikonları için öneriler (Figma'daki ikonlara göre)
  // Bu ikonlar, Figma'daki genel şekillere uygun seçilmiştir.
  static const IconData appointmentRequests = Icons.event_note_outlined; // Randevu İsteklerim
  static const IconData staffManagement = Icons.people_outline; // Personel Takibim
  static const IconData services = Icons.spa_outlined; // Hizmetlerim (veya Icons.cut, Icons.palette vb.)
  static const IconData customerReviews = Icons.star_outline; // Müşteri Yorumlarım
  static const IconData campaigns = Icons.campaign_outlined; // Kampanyalarım
  static const IconData statisticsReports = Icons.bar_chart_outlined; // İstatistik ve Raporlarım

  // Randevu durumu ikonları
  static const IconData pending = Icons.access_time; // Onay bekliyor
  static const IconData approved = Icons.check_circle_outline; // Onaylandı
  static const IconData rejected = Icons.cancel_outlined; // Reddedildi
  static const IconData cancelledByCustomer = Icons.event_busy_outlined;

  static const IconData suggested = Icons.lightbulb_outline;
}
