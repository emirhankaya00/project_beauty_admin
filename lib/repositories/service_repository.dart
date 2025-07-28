// lib/repositories/service_repository.dart

import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // DÜZELTME: Doğru import eklendi.

class ServiceRepository {
  // DÜZELTME: Artık global 'supabase' değişkeni yerine,
  // Supabase.instance.client kullanarak Supabase'e ulaşıyoruz.
  // Bu, en doğru ve güvenli yöntemdir.
  final _client = Supabase.instance.client;

  /// ViewModel'in aradığı doğru metot ismi.
  Future<List<Map<String, dynamic>>> getServicesForSaloon(String saloonId) async {
    try {
      final data = await _client // DÜZELTME: 'supabase' -> '_client'
          .from('saloon_services')
          .select('*, services(*)')
          .eq('saloon_id', saloonId);
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Hizmetleri çekerken hata: $e');
      rethrow;
    }
  }

  /// ViewModel'in aradığı doğru metot ismi.
  Future<void> deleteSaloonService(String saloonServiceId) async {
    try {
      await _client // DÜZELTME: 'supabase' -> '_client'
          .from('saloon_services')
          .delete()
          .eq('id', saloonServiceId);
    } catch (e) {
      print('Salon hizmeti silerken hata: $e');
      rethrow;
    }
  }

  /// Ekleme ve Güncelleme için tek bir fonksiyon.
  Future<Map<String, dynamic>> saveSaloonService({
    required String saloonId,
    String? saloonServiceId,
    required Map<String, dynamic> serviceData,
    required Map<String, dynamic> saloonServiceData,
  }) async {
    if (saloonServiceId == null) { // Ekleme
      final newService = await _client // DÜZELTME: 'supabase' -> '_client'
          .from('services')
          .insert(serviceData)
          .select()
          .single();

      saloonServiceData['service_id'] = newService['service_id'];
      saloonServiceData['saloon_id'] = saloonId;

      final newSaloonService = await _client // DÜZELTME: 'supabase' -> '_client'
          .from('saloon_services')
          .insert(saloonServiceData)
          .select('*, services(*)')
          .single();
      return newSaloonService;
    } else { // Güncelleme
      await _client // DÜZELTME: 'supabase' -> '_client'
          .from('services')
          .update(serviceData)
          .eq('service_id', saloonServiceData['service_id']);

      final updatedSaloonService = await _client // DÜZELTME: 'supabase' -> '_client'
          .from('saloon_services')
          .update(saloonServiceData)
          .eq('id', saloonServiceId)
          .select('*, services(*)')
          .single();
      return updatedSaloonService;
    }
  }

  Future<void> deleteServiceAndAssociations(String saloonServiceId, String serviceId) async {
    try {
      // 1. Adım: Bu hizmete atanmış tüm personellerin bağlantısını sil.
      await _client // DÜZELTME: 'supabase' -> '_client'
          .from('personal_saloon_services')
          .delete()
          .eq('service_id', serviceId);

      // 2. Adım: Ana hizmet kaydını sil.
      await _client // DÜZELTME: 'supabase' -> '_client'
          .from('saloon_services')
          .delete()
          .eq('id', saloonServiceId);

    } catch (e) {
      print('Hizmet ve ilişkileri silinirken hata: $e');
      rethrow;
    }
  }
}