import 'package:flutter/material.dart';
import 'package:project_beauty_admin/repositories/service_repository.dart';
import 'package:project_beauty_admin/repositories/staff_repository.dart';

import '../data/models/admin_model.dart';

class StaffViewModel with ChangeNotifier {
  final StaffRepository _staffRepo = StaffRepository();
  final ServiceRepository _serviceRepo = ServiceRepository();

  List<Map<String, dynamic>> _staffMembers = [];
  List<Map<String, dynamic>> _availableServices = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchText = '';

  List<Map<String, dynamic>> get filteredStaffMembers {
    if (_searchText.isEmpty) {
      return _staffMembers;
    }
    return _staffMembers.where((staff) {
      final nameLower = (staff['name'] as String? ?? '').toLowerCase();
      final surnameLower = (staff['surname'] as String? ?? '').toLowerCase();
      final searchTextLower = _searchText.toLowerCase();
      return nameLower.contains(searchTextLower) ||
          surnameLower.contains(searchTextLower);
    }).toList();
  }

  List<Map<String, dynamic>> get availableServices => _availableServices;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchInitialData(AdminModel admin) async {
    _isLoading = true;
    notifyListeners();
    try {
      final staffFuture = _staffRepo.getStaffForSaloon(admin.saloonId);
      final servicesFuture = _serviceRepo.getServicesForSaloon(admin.saloonId);

      final results = await Future.wait([staffFuture, servicesFuture]);

      _staffMembers = results[0];
      _availableServices = results[1];
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Veriler yüklenirken bir hata oluştu.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String text) {
    _searchText = text;
    notifyListeners();
  }

  Future<void> saveStaff({
    required AdminModel admin,
    String? personalId,
    required String name,
    required String surname,
    required List<String> specialty, // Artık zorunlu ve boş liste olabilir
    String? email,
    String? phone,
    String? photoUrl,
    required Map<String, double> selectedServices,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final serviceIds = selectedServices.keys.toList();
      final servicePrices = selectedServices.values.toList();

      await _staffRepo.saveStaff({
        'p_personal_id': personalId,
        'p_saloon_id': admin.saloonId,
        'p_name': name,
        'p_surname': surname,
        'p_specialty': specialty, // ViewModel'e gelen specialty'yi RPC'ye iletiyoruz
        'p_email': email,
        'p_phone_number': phone,
        'p_profile_photo_url': photoUrl,
        'p_service_ids': serviceIds,
        'p_service_prices': servicePrices,
      });
      await fetchInitialData(admin);
    } catch (e) {
      _errorMessage = 'Personel kaydedilirken bir hata oluştu.';
      notifyListeners();
    }
  }
  Future<void> deleteStaff(String personalId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _staffRepo.deleteStaff(personalId);
      // Personeli yerel listeden de kaldırıyoruz ki arayüz anında güncellensin.
      _staffMembers.removeWhere((staff) => staff['personal_id'] == personalId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Personel silinirken bir hata oluştu.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}