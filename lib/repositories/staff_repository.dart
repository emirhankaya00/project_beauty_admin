// lib/repositories/staff_repository.dart

import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // DÜZELTME: Doğru import eklendi.

class StaffRepository {
  // DÜZELTME: Artık global 'supabase' değişkeni yerine,
  // Supabase.instance.client kullanarak Supabase'e ulaşıyoruz.
  final _client = Supabase.instance.client;

  /// Belirli bir salona ait tüm personelleri, verdikleri hizmetlerle birlikte çeker.
  Future<List<Map<String, dynamic>>> getStaffForSaloon(String saloonId) async {
    try {
      final data = await _client // DÜZELTME: 'supabase' -> '_client'
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
      await _client.rpc('handle_personal_and_services', params: params); // DÜZELTME: 'supabase' -> '_client'
    } catch (e) {
      debugPrint('Personel kaydedilirken RPC hatası: $e');
      rethrow;
    }
  }

  /// Personeli siler.
  Future<void> deleteStaff(String personalId) async {
    try {
      await _client.from('personals').delete().eq('personal_id', personalId); // DÜZELTME: 'supabase' -> '_client'
    } catch (e) {
      debugPrint('Personel silerken hata: $e');
      rethrow;
    }
  }
}