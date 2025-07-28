// lib/viewmodels/saloon_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/data/models/saloon_model.dart';
import 'package:project_beauty_admin/repositories/saloon_repository.dart';
import 'package:postgrest/postgrest.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum SaloonState { idle, loading, error }

class SaloonViewModel extends ChangeNotifier {
  final SaloonRepository _repo;
  SaloonModel? saloon;
  SaloonState _state = SaloonState.idle;
  String? errorMessage;

  SaloonViewModel([SupabaseClient? c]) : _repo = SaloonRepository(c);

  SaloonState get state => _state;

  Future<void> loadSalon(String saloonId) async {
    _state = SaloonState.loading;
    notifyListeners();

    try {
      saloon = await _repo.fetchSaloon(saloonId);
      _state = SaloonState.idle;
    } on PostgrestException catch (e) {
      errorMessage = e.message;
      _state = SaloonState.error;
    } catch (e) {
      errorMessage = e.toString();
      _state = SaloonState.error;
    }

    notifyListeners();
  }

  Future<bool> saveSalon(SaloonModel s) async {
    _state = SaloonState.loading;
    notifyListeners();

    try {
      await _repo.updateSaloon(s);
      saloon = s;
      _state = SaloonState.idle;
      notifyListeners();
      return true;
    } on PostgrestException catch (e) {
      errorMessage = e.message;
      _state = SaloonState.error;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = e.toString();
      _state = SaloonState.error;
      notifyListeners();
      return false;
    }
  }
}
