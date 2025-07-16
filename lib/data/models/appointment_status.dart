// lib/data/models/appointment_status.dart
enum AppointmentStatus {
  pending, // Beklemede
  approved, // Onaylandı
  rejected, // Reddedildi
  cancelledByCustomer, // Müşteri tarafından iptal edildi
  offered, suggested, // Teklif Edildi (Alternatif önerildi) - Yeni eklediğimiz durum!
  // Eğer 'suggested' durumunu kullanmayacaksan, buradan kaldırabilirsin.
}