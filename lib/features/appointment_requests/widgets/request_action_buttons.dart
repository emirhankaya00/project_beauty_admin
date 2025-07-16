// lib/features/appointment_requests/widgets/request_action_buttons.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_button.dart';
import 'package:project_beauty_admin/data/models/appointment_status.dart'; // AppointmentStatus enum için

/// Randevu detay sayfasında veya benzeri yerlerde kullanılan
/// randevu onaylama, reddetme ve yeniden planlama aksiyon butonlarını içeren widget.
class RequestActionButtons extends StatelessWidget {
  final AppointmentStatus currentStatus; // Mevcut randevu durumu
  final VoidCallback? onApprove; // Onayla butonu callback'i
  final VoidCallback? onReject; // Reddet butonu callback'i
  final VoidCallback? onReschedule; // Yeniden Planla butonu callback'i

  const RequestActionButtons({
    Key? key,
    required this.currentStatus,
    this.onApprove,
    this.onReject,
    this.onReschedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sadece belirli durumlarda gösterilecek butonlar
    if (currentStatus == AppointmentStatus.pending) {
      return Column(
        children: [
          CustomButton(
            onPressed: onApprove ?? () => print('Randevu Onaylandı'),
            child: const Text('Randevuyu Onayla'),
            backgroundColor: AppColors.green, // Onay için yeşil buton
          ),
          const SizedBox(height: 16.0),
          CustomButton.secondary(
            onPressed: onReject ?? () => print('Randevu Reddedildi'),
            child: const Text('Randevuyu Reddet'),
            backgroundColor: AppColors.red.withOpacity(0.1), // Reddet için hafif kırmızı
            foregroundColor: AppColors.red,
          ),
          const SizedBox(height: 16.0),
          CustomButton.outline(
            onPressed: onReschedule ?? () => print('Randevu Yeniden Planlandı'),
            child: const Text('Randevuyu Değiştir/Yeniden Planla'),
          ),
        ],
      );
    } else if (currentStatus == AppointmentStatus.approved) {
      // Onaylanmış randevu için sadece yeniden planlama seçeneği
      return CustomButton.outline(
        onPressed: onReschedule ?? () => print('Randevu Yeniden Planlandı'),
        child: const Text('Randevuyu Yeniden Planla'),
      );
    } else {
      // Reddedildi veya iptal edildi gibi durumlar için aksiyon yok
      return const SizedBox.shrink(); // Boş bir widget döndür
    }
  }
}
