import 'package:flutter/material.dart';
import 'package:project_beauty_admin/data/models/campaign_model.dart';
import 'package:project_beauty_admin/repositories/campaign_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Arayüzün hangi durumda olduğunu belirtmek için bir enum
enum ViewState { idle, loading, error }

class CampaignsViewModel extends ChangeNotifier {
  // Repository: argümansız (çünkü ctor 0 parametre bekliyor)
  final CampaignRepository _repository = CampaignRepository();

  // --- State (Durum) Değişkenleri ---
  ViewState _state = ViewState.idle;
  String? _errorMessage;
  List<CampaignModel> _campaigns = [];

  // --- Getter'lar ---
  ViewState get state => _state;
  bool get isBusy => _state == ViewState.loading;
  String? get errorMessage => _errorMessage;
  List<CampaignModel> get campaigns => _campaigns;

  // --- İç yardımcılar ---
  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(Object e) {
    if (e is PostgrestException) {
      _errorMessage = e.message;
    } else {
      _errorMessage = e.toString();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // --- Public Metotlar ---

  /// Belirtilen salonun kampanyalarını yükler.
  Future<void> fetchCampaigns(String saloonId) async {
    _setState(ViewState.loading);
    try {
      // getCampaignsForSaloon yerine listCampaigns kullan
      _campaigns = await _repository.listCampaigns(saloonId);
      _errorMessage = null;
      _setState(ViewState.idle);
    } catch (e) {
      _setError(e);
      _setState(ViewState.error);
    }
  }

  /// Yeni bir kampanya oluşturur (create).
  /// Not: Repo'da update yoksa yalnızca create yapıyoruz.
  Future<bool> saveCampaign({
    required CampaignModel campaign,
    required List<String> selectedSaloonServiceIds,
    String? campaignId, // şimdilik kullanılmıyor (update yoksa)
    required String saloonId,
  }) async {
    _setState(ViewState.loading);
    try {
      // saveCampaign yerine createCampaign çağır
      await _repository.createCampaign(
        data: campaign,
        selectedSaloonServiceIds: selectedSaloonServiceIds,
      );

      await fetchCampaigns(saloonId);
      _errorMessage = null;
      _setState(ViewState.idle);
      return true;
    } catch (e) {
      _setError(e);
      _setState(ViewState.error);
      return false;
    }
  }

  /// Bir kampanyayı siler (iyimser güncelleme ile).
  Future<bool> deleteCampaign(String campaignId, String saloonId) async {
    final old = List<CampaignModel>.from(_campaigns);
    _campaigns.removeWhere((c) => c.id == campaignId);
    notifyListeners();

    try {
      await _repository.deleteCampaign(campaignId);
      await fetchCampaigns(saloonId);
      return true;
    } catch (e) {
      _setError(e);
      _campaigns = old;
      notifyListeners();
      return false;
    }
  }
}
