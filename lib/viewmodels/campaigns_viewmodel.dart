// lib/viewmodels/campaigns_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/data/models/campaign_model.dart';
import 'package:project_beauty_admin/repositories/campaign_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Arayüzün hangi durumda olduğunu belirtmek için bir enum
enum ViewState { idle, loading, error }

class CampaignsViewModel extends ChangeNotifier {
  // Repository'yi Supabase client ile başlatıyoruz.
  final CampaignRepository _repository = CampaignRepository(Supabase.instance.client);

  // --- State (Durum) Değişkenleri ---
  ViewState _state = ViewState.idle;
  String? _errorMessage;
  List<CampaignModel> _campaigns = [];

  // --- Getter'lar (Arayüzün bu verilere güvenli erişimi için) ---
  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  List<CampaignModel> get campaigns => _campaigns;

  // --- Özel Metotlar ---

  /// ViewModel'in durumunu günceller ve arayüzü yeniden çizmesi için sinyal gönderir.
  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  // --- Public Metotlar (Arayüzden Çağrılacak Olanlar) ---

  /// Belirtilen salonun kampanyalarını yükler.
  Future<void> fetchCampaigns(String saloonId) async {
    _setState(ViewState.loading);
    try {
      _campaigns = await _repository.getCampaignsForSaloon(saloonId);
      _errorMessage = null;
      _setState(ViewState.idle);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  /// Yeni bir kampanya oluşturur veya mevcut olanı günceller.
  Future<bool> saveCampaign({
    required CampaignModel campaign,
    required List<String> selectedSaloonServiceIds,
    String? campaignId,
    required String saloonId, // Hangi salona ait olduğunu bilmeliyiz
  }) async {
    _setState(ViewState.loading);
    try {
      await _repository.saveCampaign(
        campaign: campaign,
        selectedSaloonServiceIds: selectedSaloonServiceIds,
        campaignId: campaignId,
      );
      // İşlem başarılı olduktan sonra listeyi tazeleyelim.
      await fetchCampaigns(saloonId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
      return false;
    }
  }

  /// Bir kampanyayı siler.
  Future<bool> deleteCampaign(String campaignId, String saloonId) async {
    try {
      await _repository.deleteCampaign(campaignId);
      // İşlem başarılı olduktan sonra listeden ilgili kampanyayı çıkaralım.
      _campaigns.removeWhere((c) => c.id == campaignId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}