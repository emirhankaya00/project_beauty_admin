import 'package:flutter/material.dart';
import 'package:project_beauty_admin/repositories/service_repository.dart';

import '../data/models/admin_model.dart';
import '../data/models/service_model.dart';

class ServiceViewModel with ChangeNotifier {
  final ServiceRepository _repository = ServiceRepository();

  List<Map<String, dynamic>> _services = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchText = '';

  List<Map<String, dynamic>> get filteredServices {
    if (_searchText.isEmpty) return _services;
    return _services.where((service) {
      final serviceInfo = service['services'] as Map<String, dynamic>? ?? {};
      final nameLower = (serviceInfo['service_name'] as String? ?? '').toLowerCase();
      final searchLower = _searchText.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchServices(AdminModel admin) async {
    _isLoading = true;
    notifyListeners();
    try {
      _services = await _repository.getServicesForSaloon(admin.saloonId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Hizmetler yüklenirken bir hata oluştu.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String text) {
    _searchText = text;
    notifyListeners();
  }

  // DÜZELTİLMİŞ KISIM BURASI
  Future<void> saveService({
    required AdminModel admin,
    String? saloonServiceId,
    String? serviceId,
    required String name,
    required double price,
    required Duration duration,
    String? description,
    required bool isActive,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final savedData = await _repository.saveSaloonService(
        saloonId: admin.saloonId,
        saloonServiceId: saloonServiceId,
        // 1. services tablosu için gönderilecek veri
        serviceData: {
          'service_name': name,
          'description': description,
          'estimated_time': ServiceModel.formatDuration(duration),
          // EKSİK OLDUĞUNU DÜŞÜNDÜĞÜMÜZ ALANI EKLİYORUZ:
          'base_price': price,
        },
        // 2. saloon_services tablosu için gönderilecek veri
        saloonServiceData: {
          'price': price,
          'is_active': isActive,
          'service_id': serviceId, // Güncelleme için gerekli
        },
      );

      if (saloonServiceId == null) { // Ekleme işlemi başarılı olduysa
        _services.add(savedData);
      } else { // Güncelleme işlemi başarılı olduysa
        final index = _services.indexWhere((s) => s['id'] == saloonServiceId);
        if (index != -1) {
          _services[index] = savedData;
        }
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Hizmet kaydedilirken bir hata oluştu.';
      print('KAYDETME HATASI: $e'); // Hatanın ne olduğunu konsolda görmek için
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> deleteService(String saloonServiceId, String serviceId) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Repository'deki yeni fonksiyonu çağırıyoruz.
      await _repository.deleteServiceAndAssociations(saloonServiceId, serviceId);

      // Hizmeti yerel listeden de kaldırıyoruz.
      _services.removeWhere((s) => s['id'] == saloonServiceId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Hizmet silinirken bir hata oluştu.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}