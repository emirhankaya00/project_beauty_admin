// lib/viewmodels/reservation_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/data/models/reservation_model.dart';
import 'package:project_beauty_admin/repositories/reservation_repository.dart';

// Arayüzün hangi durumda olduğunu belirtmek için bir enum
enum ViewState { idle, loading, error }

class ReservationViewModel with ChangeNotifier {
  final ReservationRepository _repository = ReservationRepository();

  // State (Durum) Değişkenleri
  List<ReservationModel> _allReservations = [];
  DateTime _selectedDate = DateTime.now();
  ViewState _state = ViewState.idle;
  String? _errorMessage;

  // Getter'lar: Arayüzün (View) bu değişkenlere güvenli bir şekilde erişmesini sağlar.
  List<ReservationModel> get filteredReservations {
    return _allReservations.where((r) {
      return r.reservationDate.year == _selectedDate.year &&
          r.reservationDate.month == _selectedDate.month &&
          r.reservationDate.day == _selectedDate.day;
    }).toList()
      ..sort((a, b) =>
          a.reservationDate.compareTo(b.reservationDate)); // Saate göre sırala
  }

  DateTime get selectedDate => _selectedDate;

  ViewState get state => _state;

  String? get errorMessage => _errorMessage;

  // --- PRIVATE YARDIMCI METOTLAR ---
  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners(); // Arayüze "durum değişti, kendini güncelle" sinyali gönderir.
  }

  // --- PUBLIC METOTLAR (Arayüzden çağrılacak olanlar) ---

  // Sayfa ilk açıldığında verileri çekmek için
  Future<void> fetchReservations(String saloonId) async {
    _setState(ViewState.loading);
    try {
      _allReservations = await _repository.fetchReservationsForSaloon(saloonId);
      _errorMessage = null;
      _setState(ViewState.idle);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  // Kullanıcı takvimden farklı bir gün seçtiğinde
  void selectDate(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners(); // Sadece arayüzü güncelle, yeni veri çekmeye gerek yok.
  }

  // Randevuyu onaylama
  // Randevuyu onaylama
  Future<void> approveReservation(String reservationId) async {
    try {
      await _repository.updateReservationStatus(
          reservationId, ReservationStatus.confirmed);
      final index = _allReservations.indexWhere((r) =>
      r.reservationId == reservationId);
      if (index != -1) {
        // DÜZELTME: Doğrudan değiştirmek yerine kopyasını oluşturuyoruz.
        _allReservations[index] = _allReservations[index].copyWith(
            status: ReservationStatus.confirmed);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Onaylama işlemi başarısız oldu.';
      notifyListeners();
    }
  }

  // Randevuyu reddetme
  Future<void> rejectReservation(String reservationId) async {
    try {
      await _repository.updateReservationStatus(
          reservationId, ReservationStatus.cancelled);
      final index = _allReservations.indexWhere((r) =>
      r.reservationId == reservationId);
      if (index != -1) {
        // DÜZELTME:
        _allReservations[index] = _allReservations[index].copyWith(
            status: ReservationStatus.cancelled);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Reddetme işlemi başarısız oldu.';
      notifyListeners();
    }
  }

  // Yeni tarih önerme
  Future<void> proposeNewDateTime(String reservationId,
      DateTime newDateTime) async {
    try {
      // Repository'ye hem yeni tarihi hem de 'offered' durumunu gönderiyoruz.
      await _repository.proposeNewDateTime(reservationId, newDateTime);

      final index = _allReservations.indexWhere((r) =>
      r.reservationId == reservationId);
      if (index != -1) {
        // DÜZELTME:
        // Yerel listeyi de yeni durum ve tarihle güncellenmiş bir kopya ile değiştiriyoruz.
        _allReservations[index] = _allReservations[index].copyWith(
          status: ReservationStatus.offered,
          // Not: Eğer modele 'proposedDateTime' gibi bir alan eklediysen,
          // onu da burada güncelleyebilirsin:
          // proposedDateTime: newDateTime,
        );
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Tarih önerme işlemi başarısız oldu.';
      notifyListeners();
    }
  }
}