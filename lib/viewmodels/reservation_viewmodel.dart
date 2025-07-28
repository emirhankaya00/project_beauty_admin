// lib/viewmodels/reservation_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/data/models/reservation_model.dart';
import 'package:project_beauty_admin/repositories/reservation_repository.dart';

enum ViewState { idle, loading, error }

class ReservationViewModel with ChangeNotifier {
  final ReservationRepository _repository = ReservationRepository();

  List<ReservationModel> _allReservations = [];
  DateTime _selectedDate = DateTime.now();
  ViewState _state = ViewState.idle;
  String? _errorMessage;

  List<ReservationModel> get filteredReservations {
    return _allReservations.where((r) {
      return r.reservationDate.year == _selectedDate.year &&
          r.reservationDate.month == _selectedDate.month &&
          r.reservationDate.day == _selectedDate.day;
    }).toList()
    // DÜZELTME: reservationDate yerine reservationTime'a göre sıralıyoruz.
      ..sort((a, b) => a.reservationTime.compareTo(b.reservationTime));
  }

  DateTime get selectedDate => _selectedDate;

  ViewState get state => _state;

  String? get errorMessage => _errorMessage;

  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> fetchReservations(String saloonId) async {
    _setState(ViewState.loading);
    try {
      _allReservations = await _repository.fetchReservationsForSaloon(saloonId);
      _errorMessage = null; // Hata mesajını temizle
      _setState(ViewState.idle);
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("HATA (ReservationViewModel): $e"); // Debug için hatayı yazdır
      _setState(ViewState.error);
    }
  }

  // Geri kalan metotlarda değişiklik yapmaya gerek yok, hepsi doğru.

  void selectDate(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }

  Future<void> approveReservation(String reservationId) async {
    try {
      await _repository.updateReservationStatus(
          reservationId, ReservationStatus.confirmed);
      final index = _allReservations
          .indexWhere((r) => r.reservationId == reservationId);
      if (index != -1) {
        _allReservations[index] =
            _allReservations[index].copyWith(status: ReservationStatus.confirmed);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Onaylama işlemi başarısız oldu.';
      notifyListeners();
    }
  }

  Future<void> rejectReservation(String reservationId) async {
    try {
      await _repository.updateReservationStatus(
          reservationId, ReservationStatus.cancelled);
      final index = _allReservations
          .indexWhere((r) => r.reservationId == reservationId);
      if (index != -1) {
        _allReservations[index] =
            _allReservations[index].copyWith(status: ReservationStatus.cancelled);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Reddetme işlemi başarısız oldu.';
      notifyListeners();
    }
  }

  Future<void> proposeNewDateTime(
      String reservationId, DateTime newDateTime) async {
    try {
      await _repository.proposeNewDateTime(reservationId, newDateTime);
      final index = _allReservations
          .indexWhere((r) => r.reservationId == reservationId);
      if (index != -1) {
        _allReservations[index] = _allReservations[index].copyWith(
          status: ReservationStatus.offered,
        );
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Tarih önerme işlemi başarısız oldu.';
      notifyListeners();
    }
  }
}