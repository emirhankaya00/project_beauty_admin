import 'package:project_beauty_admin/core/supabase_init.dart';
import 'package:project_beauty_admin/data/models/campaign_model.dart';
import 'package:project_beauty_admin/data/models/saloon_service_list_item.dart';

class CampaignRepository {
  /// Salona ait hizmetleri (saloon_services + services join) getir
  Future<List<SaloonServiceListItem>> fetchSaloonServices(String saloonId) async {
    final res = await supa
        .from('saloon_services')
        .select('''
          id,
          price,
          services:service_id(service_name)
        ''')
        .eq('saloon_id', saloonId)
        .eq('is_active', true)
        .order('id');

    return (res as List)
        .map((e) => SaloonServiceListItem.fromJoin(e))
        .toList();
  }

  /// Çakışan kampanya var mı? (tarih kesişimi)
  Future<List<Map<String, dynamic>>> findOverlaps({
    required List<String> saloonServiceIds,
    required DateTime start,
    required DateTime end,
  }) async {
    if (saloonServiceIds.isEmpty) return [];
    final res = await supa
        .from('campaign_services')
        .select('''
          saloon_service_id,
          campaigns:campaign_id(id, title, start_date, end_date)
        ''')
        .inFilter('saloon_service_id', saloonServiceIds)
        .lte('campaigns.start_date', end.toUtc().toIso8601String())
        .gte('campaigns.end_date', start.toUtc().toIso8601String());
    // Not: lte/gte karşılıklı koşulla “overlap”ı kapsar.
    return (res as List).cast<Map<String, dynamic>>();
  }

  /// Kampanya + ilişkileri tek seferde oluştur
  Future<String> createCampaign({
    required CampaignModel data,
    required List<String> selectedSaloonServiceIds,
  }) async {
    // 1) Çakışma kontrolü
    final overlaps = await findOverlaps(
      saloonServiceIds: selectedSaloonServiceIds,
      start: data.startDate,
      end: data.endDate,
    );
    if (overlaps.isNotEmpty) {
      throw Exception('Seçilen hizmetlerden bazıları bu tarih aralığında zaten kampanyalı.');
    }

    // 2) campaigns insert (id döner)
    final inserted = await supa.from('campaigns')
        .insert(data.toInsertMap())
        .select()
        .single();

    final String campaignId = inserted['id'];

    // 3) campaign_services bulk insert
    final links = selectedSaloonServiceIds.map((sid) => {
      'campaign_id': campaignId,
      'saloon_service_id': sid,
    }).toList();

    if (links.isNotEmpty) {
      await supa.from('campaign_services').insert(links);
    }

    return campaignId;
  }

  Future<List<CampaignModel>> listCampaigns(String saloonId) async {
    final res = await supa
        .from('campaigns')
        .select()
        .eq('saloon_id', saloonId)
        .order('start_date', ascending: false);
    return (res as List).map((e) => CampaignModel.fromJson(e)).toList();
  }

  Future<void> deleteCampaign(String campaignId) async {
    // önce linkleri sil
    await supa.from('campaign_services').delete().eq('campaign_id', campaignId);
    await supa.from('campaigns').delete().eq('id', campaignId);
  }
}
