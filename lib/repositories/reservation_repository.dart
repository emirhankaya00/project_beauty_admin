// lib/repositories/reservation_repository.dart

import 'package:flutter/cupertino.dart';
import 'package:project_beauty_admin/data/models/reservation_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Hata yönetimi için özel exception sınıfları
class ReservationException implements Exception {
  final String message;
  ReservationException(this.message);
}

class ReservationRepository {
  final _supabase = Supabase.instance.client;

  // Belirli bir salona ait tüm randevuları, ilişkili verilerle birlikte çeker.
  Future<List<ReservationModel>> fetchReservationsForSaloon(String saloonId) async {
    try {
      final response = await _supabase
          .from('reservations')
          .select('''
            *,
            users (*),
            personals (*), 
            reservation_services (
              services (*)
            )
          ''') // <-- DÜZELTME: 'personals(*)' sorguya eklendi.
          .eq('saloon_id', saloonId)
          .order('created_at', ascending: false);

      if (response.isEmpty) {
        return [];
      }

      final reservations = (response as List)
          .map((data) => ReservationModel.fromJson(data))
          .toList();

      return reservations;

    } catch (e) {
      debugPrint('Fetch Reservations Error: $e');
      throw ReservationException('Randevular alınırken bir hata oluştu. Lütfen tekrar deneyin.');
    }
  }

  // Bir randevunun durumunu günceller.
  Future<void> updateReservationStatus(String reservationId, ReservationStatus newStatus) async {
    try {
      await _supabase
          .from('reservations')
          .update({'status': newStatus.name})
          .eq('reservation_id', reservationId);

    } catch (e) {
      debugPrint('Update Reservation Status Error: $e');
      throw ReservationException('Randevu durumu güncellenirken bir hata oluştu.');
    }
  }

  // Bir randevu için yeni tarih önerir.
  // Not: DB'de 'proposed_date' gibi bir kolonunuz olmalı.
  Future<void> proposeNewDateTime(String reservationId, DateTime newDateTime) async {
    try {
      await _supabase
          .from('reservations')
          .update({
        'status': ReservationStatus.offered.name, // 'offered' olarak güncellendi.
        // Not: DB'de 'proposed_date' gibi bir kolonun olması bu sorgunun çalışması için gereklidir.
        'proposed_date': newDateTime.toIso8601String(),
      })
          .eq('reservation_id', reservationId);

    } catch (e) {
      debugPrint('Propose New Date Error: $e');
      throw ReservationException('Yeni tarih önerilirken bir hata oluştu.');
    }
  }
}