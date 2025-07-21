import 'package:project_beauty_admin/main.dart';

class ServiceRepository {
  /// ViewModel'in aradığı doğru metot ismi.
  Future<List<Map<String, dynamic>>> getServicesForSaloon(String saloonId) async {
    try {
      final data = await supabase
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
      await supabase
          .from('saloon_services')
          .delete()
          .eq('id', saloonServiceId);
    } catch (e) {
      print('Salon hizmeti silerken hata: $e');
      rethrow;
    }
  }

  /// Ekleme ve Güncelleme için tek bir fonksiyon.
  /// Bu fonksiyon, Supabase'e bir RPC (veritabanı fonksiyonu) çağrısı yapabilir
  /// veya doğrudan insert/update yapabilir. Şimdilik basit tutalım.
  Future<Map<String, dynamic>> saveSaloonService({
    required String saloonId,
    String? saloonServiceId, // Bu null ise ekleme, dolu ise güncelleme
    required Map<String, dynamic> serviceData, // services tablosu için
    required Map<String, dynamic> saloonServiceData, // saloon_services tablosu için
  }) async {
    // Bu kısım normalde bir veritabanı transaction'ı ile yapılmalıdır.
    // Şimdilik iki ayrı adımda yapıyoruz.
    if (saloonServiceId == null) { // Ekleme
      // 1. Ana hizmeti 'services' tablosuna ekle
      final newService = await supabase
          .from('services')
          .insert(serviceData)
          .select()
          .single();

      // 2. Salona özel fiyatı/durumu 'saloon_services' tablosuna ekle
      saloonServiceData['service_id'] = newService['service_id'];
      saloonServiceData['saloon_id'] = saloonId;

      final newSaloonService = await supabase
          .from('saloon_services')
          .insert(saloonServiceData)
          .select('*, services(*)')
          .single();
      return newSaloonService;
    } else { // Güncelleme
      // 1. Ana hizmeti güncelle
      await supabase
          .from('services')
          .update(serviceData)
          .eq('service_id', saloonServiceData['service_id']);

      // 2. Salona özel hizmeti güncelle
      final updatedSaloonService = await supabase
          .from('saloon_services')
          .update(saloonServiceData)
          .eq('id', saloonServiceId)
          .select('*, services(*)')
          .single();
      return updatedSaloonService;
    }
  }
}