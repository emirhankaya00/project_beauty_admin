import 'package:project_beauty_admin/data/models/appointment_status.dart';

class AppointmentModel {
  final String id;
  final String customerName;
  final String serviceName;
  final DateTime dateTime;
  final AppointmentStatus status;
  final String? note;
  final String? staffMemberId;
  final String? rejectionReason;
  final DateTime? proposedDateTime;

  AppointmentModel({
    required this.id,
    required this.customerName,
    required this.serviceName,
    required this.dateTime,
    required this.status,
    this.note,
    this.staffMemberId,
    this.rejectionReason,
    this.proposedDateTime,
  });

  // copyWith metodunu daha basit ve doğrudan nullable değerleri alacak şekilde güncelledik.
  AppointmentModel copyWith({
    String? id,
    String? customerName,
    String? serviceName,
    DateTime? dateTime,
    AppointmentStatus? status,
    String? note, // Değişti: ValueGetter<String?>? yerine String?
    String? staffMemberId, // Değişti: ValueGetter<String?>? yerine String?
    String? rejectionReason, // Değişti: ValueGetter<String?>? yerine String?
    DateTime? proposedDateTime, // Değişti: ValueGetter<DateTime?>? yerine DateTime?
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      serviceName: serviceName ?? this.serviceName,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      // Parametre null değilse yeni değeri kullan, null ise mevcut değeri koru.
      note: note ?? this.note,
      staffMemberId: staffMemberId ?? this.staffMemberId,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      proposedDateTime: proposedDateTime ?? this.proposedDateTime,
    );
  }
}