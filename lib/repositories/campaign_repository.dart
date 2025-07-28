// lib/data/repositories/campaign_repository.dart

import 'package:flutter/foundation.dart';
import 'package:project_beauty_admin/data/models/campaign_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CampaignRepository {
  final SupabaseClient _client;
  CampaignRepository(this._client);

  /// Belirtilen salona ait tüm kampanyaları, bağlı hizmetleriyle birlikte çeker.
  Future<List<CampaignModel>> getCampaignsForSaloon(String saloonId) async {
    try {
      final response = await _client
          .from('campaigns')
          .select('''
            *,
            campaign_services (
              services (*)
            )
          ''')
          .eq('saloon_id', saloonId)
          .order('created_at', ascending: false);

      if (response is List) {
        return response
            .map((data) => CampaignModel.fromJson(data as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Kampanyaları çekerken hata: $e');
      throw Exception('Kampanyalar yüklenemedi.');
    }
  }

  /// Yeni bir kampanya oluşturur veya mevcut bir kampanyayı günceller.
  /// Bu işlemi atomik (bölünmez) hale getirmek için bir veritabanı fonksiyonu (RPC) kullanmak en iyisidir.
  /// Şimdilik bu fonksiyonu taslak olarak bırakıyoruz, daha sonra bir RPC ile güçlendirebiliriz.
  Future<void> saveCampaign({
    required CampaignModel campaign,
    required List<String> selectedSaloonServiceIds, // Seçilen 'saloon_services' ID'leri
    String? campaignId, // Eğer null değilse, güncelleme yapılır
  }) async {
    try {
      // Adım 1: Ana kampanya verisini 'campaigns' tablosuna ekle veya güncelle.
      final campaignData = campaign.toJson();

      // Upsert, ID varsa günceller, yoksa ekler.
      final savedCampaign = await _client
          .from('campaigns')
          .upsert(campaignData)
          .select()
          .single();

      final newCampaignId = savedCampaign['id'];

      // Adım 2: 'campaign_services' tablosunu yönet.
      // Önce bu kampanyaya ait eski hizmet bağlantılarını temizle.
      await _client
          .from('campaign_services')
          .delete()
          .eq('campaign_id', newCampaignId);

      // Sonra yeni seçilen hizmetleri ekle.
      if (selectedSaloonServiceIds.isNotEmpty) {
        final List<Map<String, dynamic>> campaignServiceRows =
        selectedSaloonServiceIds.map((serviceId) => {
          'campaign_id': newCampaignId,
          'saloon_service_id': serviceId,
        }).toList();

        await _client.from('campaign_services').insert(campaignServiceRows);
      }

    } catch (e) {
      debugPrint('Kampanya kaydedilirken hata: $e');
      throw Exception('Kampanya kaydedilemedi.');
    }
  }

  /// Belirtilen kampanyayı siler.
  /// Veritabanında ON DELETE CASCADE ayarlandığı için,
  /// bu kampanyaya bağlı 'campaign_services' kayıtları da otomatik silinecektir.
  Future<void> deleteCampaign(String campaignId) async {
    try {
      await _client
          .from('campaigns')
          .delete()
          .eq('id', campaignId);
    } catch (e) {
      debugPrint('Kampanya silinirken hata: $e');
      throw Exception('Kampanya silinemedi.');
    }
  }
}