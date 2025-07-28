// lib/repositories/saloon_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_beauty_admin/data/models/saloon_model.dart';

class SaloonRepository {
  final SupabaseClient _client;
  SaloonRepository([SupabaseClient? c]) : _client = c ?? Supabase.instance.client;

  /// Tek bir salonu getir
  Future<SaloonModel> fetchSaloon(String saloonId) async {
    // maybeSingle() doğrudan Map<String, dynamic>? döner
    final data = await _client
        .from('saloons')
        .select()
        .eq('saloon_id', saloonId)
        .maybeSingle();

    if (data == null) {
      throw Exception('Salon bulunamadı');
    }
    return SaloonModel.fromJson(data as Map<String, dynamic>);
  }

  /// Salonu güncelle
  Future<void> updateSaloon(SaloonModel s) async {
    // Burada da .execute() yok, direkt await
    await _client
        .from('saloons')
        .update(s.toJson())      // veya toUpdateMap()
        .eq('saloon_id', s.saloonId);
    // Hata durumunda PostgrestException fırlatır, kendi katmanınızda yakalayabilirsiniz.
  }
}
