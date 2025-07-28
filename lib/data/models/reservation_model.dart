// lib/data/models/reservation_model.dart

import 'package:project_beauty_admin/data/models/personal_model.dart';
import 'package:project_beauty_admin/data/models/saloon_model.dart';
import 'package:project_beauty_admin/data/models/service_model.dart';
import 'package:project_beauty_admin/data/models/user_model.dart';

// Enum tanımı doğru, burada bir değişiklik yok.
enum ReservationStatus {
  pending,
  offered,
  confirmed,
  completed,
  cancelled,
  noShow
}

class ReservationModel {
  final String reservationId;
  final String userId;
  final String saloonId;
  final String? personalId;
  final DateTime reservationDate;
  final String reservationTime;
  final double totalPrice;
  final ReservationStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SaloonModel? saloon;
  final ServiceModel? service; // DÜZELTME: Bu model artık tek bir hizmeti temsil ediyor.
  final UserModel? user;
  final PersonalModel? personal;

  ReservationModel({
    required this.reservationId,
    required this.userId,
    required this.saloonId,
    this.personalId,
    required this.reservationDate,
    required this.reservationTime,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.saloon,
    this.service,
    this.user,
    this.personal,
  });

  // DÜZELTME: fromJson metodunu baştan sona daha güvenli ve doğru olacak şekilde güncelledim.
  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    // 1. Hizmet bilgisini daha güvenli ayrıştırma
    ServiceModel? parsedService;
    if (json['reservation_services'] != null &&
        (json['reservation_services'] as List).isNotEmpty) {
      // Gelen 'reservation_services' bir liste, ilk elemanını alıyoruz.
      final rService = json['reservation_services'][0];
      if (rService != null && rService['services'] != null) {
        parsedService = ServiceModel.fromJson(rService['services']);
      }
    }

    // 2. Kullanıcı bilgisini doğru anahtardan ('users') ayrıştırma
    UserModel? parsedUser;
    // DÜZELTME: 'profiles' yerine sorguda belirttiğimiz 'users' anahtarını kullanıyoruz.
    if (json['users'] != null) {
      parsedUser = UserModel.fromJson(json['users']);
    }

    // 3. Personel bilgisini ayrıştırma
    PersonalModel? parsedPersonal;
    if (json['personals'] != null) {
      parsedPersonal = PersonalModel.fromJson(json['personals']);
    }

    // 4. Salon bilgisini ayrıştırma
    SaloonModel? parsedSaloon;
    if (json['saloons'] != null) {
      parsedSaloon = SaloonModel.fromJson(json['saloons']);
    }

    return ReservationModel(
      reservationId: json['reservation_id'] ?? '',
      userId: json['user_id'] ?? '',
      saloonId: json['saloon_id'] ?? '',
      personalId: json['personal_id'],
      reservationDate: DateTime.tryParse(json['reservation_date'] ?? '') ?? DateTime.now(),
      reservationTime: json['reservation_time'] ?? '00:00',
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      status: ReservationStatus.values.firstWhere(
            (e) => e.name == json['status'],
        orElse: () => ReservationStatus.pending,
      ),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      user: parsedUser,
      personal: parsedPersonal,
      service: parsedService,
      saloon: parsedSaloon,
    );
  }

  // copyWith metodun doğru, burada bir değişiklik yok.
  ReservationModel copyWith({
    String? reservationId,
    String? userId,
    String? saloonId,
    String? personalId,
    DateTime? reservationDate,
    String? reservationTime,
    double? totalPrice,
    ReservationStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    SaloonModel? saloon,
    ServiceModel? service,
    UserModel? user,
    PersonalModel? personal,
  }) {
    return ReservationModel(
      reservationId: reservationId ?? this.reservationId,
      userId: userId ?? this.userId,
      saloonId: saloonId ?? this.saloonId,
      personalId: personalId ?? this.personalId,
      reservationDate: reservationDate ?? this.reservationDate,
      reservationTime: reservationTime ?? this.reservationTime,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      saloon: saloon ?? this.saloon,
      service: service ?? this.service,
      user: user ?? this.user,
      personal: personal ?? this.personal,
    );
  }

  // toJson metodun doğru, burada bir değişiklik yok.
  Map<String, dynamic> toJson() {
    return {
      'reservation_id': reservationId,
      'user_id': userId,
      'saloon_id': saloonId,
      'personal_id': personalId,
      'reservation_date': reservationDate.toIso8601String().split('T')[0],
      'reservation_time': reservationTime,
      'total_price': totalPrice,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}