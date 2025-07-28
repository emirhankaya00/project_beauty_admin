import 'package:flutter/cupertino.dart';
import 'package:project_beauty_admin/main.dart';

class StaffRepository {
  /// Belirli bir salona ait tüm personelleri, verdikleri hizmetlerle birlikte çeker.
  Future<List<Map<String, dynamic>>> getStaffForSaloon(String saloonId) async {
    try {
      // ÇÖZÜM: Sorguya 'price' ve 'is_available' alanlarını ekliyoruz.
      final data = await supabase
          .from('personals')
          .select('''
            personal_id,
            saloon_id,
            name,
            surname,
            specialty,
            profile_photo_url,
            phone_number,
            email,
            personal_saloon_services (
              price,
              is_available,
              services (
                service_id,
                service_name
              )
            )
          ''')
          .eq('saloon_id', saloonId);

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      debugPrint('Personelleri çekerken hata: $e');
      rethrow;
    }
  }

  /// Veritabanı fonksiyonunu (RPC) kullanarak personel ekler veya günceller.
  Future<void> saveStaff(Map<String, dynamic> params) async {
    try {
      await supabase.rpc('handle_personal_and_services', params: params);
    } catch (e) {
      debugPrint('Personel kaydedilirken RPC hatası: $e');
      rethrow;
    }
  }

  /// Personeli siler.
  Future<void> deleteStaff(String personalId) async {
    try {
      await supabase.from('personals').delete().eq('personal_id', personalId);
    } catch (e) {
      debugPrint('Personel silerken hata: $e');
      rethrow;
    }
  }
}