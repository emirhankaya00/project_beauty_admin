import 'package:project_beauty_admin/main.dart';

class ServiceRepository {
  // DÜZELTME: Metot adını ViewModel'in aradığı 'getServicesForSaloon' yapıyoruz.
  Future<List<Map<String, dynamic>>> getServicesForSaloon(String saloonId) async {
    try {
      final data = await supabase
          .from('saloon_services')
          .select('*, services(*)')
          .eq('saloon_id', saloonId);
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Birleşik hizmetleri çekerken hata: $e');
      rethrow;
    }
  }

  // DÜZELTME: Metot adını ViewModel'in aradığı 'deleteSaloonService' yapıyoruz.
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

// TODO: Ekleme ve Güncelleme fonksiyonları eklenecek.
}