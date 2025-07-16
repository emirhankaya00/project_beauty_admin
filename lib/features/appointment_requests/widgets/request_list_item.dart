// lib/features/appointment_requests/widgets/request_list_item.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/app_border_radius.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_card.dart';
// custom_button ve app_icons importlarını kaldırın, çünkü eski çalışan kodda yoktu
// Eğer bu widget'ları kullanmaya devam ediyorsanız, önceki cevaplardaki halini koruyun ve sorun varsa belirtin.
// import 'package:project_beauty_admin/design_system/widgets/custom_button.dart';
// import 'package:project_beauty_admin/design_system/widgets/app_icons.dart';
import 'package:project_beauty_admin/data/models/appointment_status.dart';

/// Randevu İstekleri Listesi sayfasında kullanılan tek bir randevu isteği öğesi.
/// Figma tasarımındaki kartlara ve randevu durumu senaryolarına uygun olarak tasarlanmıştır.
class AppointmentRequestListItem extends StatelessWidget {
  final String customerName; // Müşteri adı
  final String serviceName; // Hizmet adı
  final String time; // Randevu saati (örn. "12:00")
  final AppointmentStatus status; // Randevunun durumu
  final String? note; // Ek not (örn. iptal nedeni)
  final VoidCallback? onApprove; // Onayla butonuna basıldığında
  final VoidCallback? onReject; // Reddet butonuna basıldığında
  final VoidCallback onViewDetails; // Detayları görüntüle butonuna basıldığında

  const AppointmentRequestListItem({
    Key? key,
    required this.customerName,
    required this.serviceName,
    required this.time,
    required this.status,
    this.note,
    this.onApprove,
    this.onReject,
    required this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    Color? statusTextColor;
    // IconData statusIcon; // İkonları bu aşamada kullanmıyoruz
    bool showActionButtons = false;

    switch (status) {
      case AppointmentStatus.pending:
        statusColor = AppColors.orange;
        statusText = 'Onay Bekliyor';
        statusTextColor = AppColors.white;
        // statusIcon = Icons.access_time;
        showActionButtons = true;
        break;
      case AppointmentStatus.approved:
        statusColor = AppColors.green;
        statusText = 'Onaylandı';
        statusTextColor = AppColors.white;
        // statusIcon = Icons.check_circle_outline;
        break;
      case AppointmentStatus.rejected:
        statusColor = AppColors.red;
        statusText = 'Reddedildi';
        statusTextColor = AppColors.white;
        // statusIcon = Icons.cancel_outlined;
        break;
      case AppointmentStatus.cancelledByCustomer:
        statusColor = AppColors.lightGrey;
        statusText = 'Müşteri İptal Etti';
        statusTextColor = AppColors.darkGrey;
        // statusIcon = Icons.close;
        break;
      case AppointmentStatus.suggested: // YENİ DURUM
        statusColor = AppColors.yellow; // Sarı renk
        statusText = 'Öneri Bekleniyor';
        statusTextColor = AppColors.darkGrey; // Sarı üzerinde koyu metin
        showActionButtons = true; // Öneri bekleyenler için de aksiyon butonları gösterilir
        break;
      default:
        statusColor = AppColors.grey;
        statusText = 'Bilinmiyor';
        statusTextColor = AppColors.white;
    // statusIcon = Icons.help_outline;
    }

    return CustomCard(
      onTap: onViewDetails,
      borderRadius: AppBorderRadius.medium,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded( // Metnin taşmasını önlemek için
                child: Text(
                  '$customerName (${serviceName})',
                  style: AppTextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                time,
                style: AppTextStyles.headline3.copyWith(color: AppColors.black),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          // Durum badge'i
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: AppBorderRadius.small,
            ),
            child: Text(
              statusText,
              style: AppTextStyles.labelText.copyWith(color: statusTextColor),
            ),
          ),
          if (note != null && note!.isNotEmpty) ...[
            const SizedBox(height: 8.0),
            Text(
              'Not: $note',
              style: AppTextStyles.bodyText2.copyWith(color: AppColors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          // Aksiyon Butonları (Şimdi hem 'pending' hem de 'suggested' için gösterilir)
          if (showActionButtons) ...[
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.red),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.medium),
                  ),
                  child: Text('Reddet', style: AppTextStyles.buttonText.copyWith(color: AppColors.red)),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.medium),
                  ),
                  child: Text('Onayla', style: AppTextStyles.buttonText.copyWith(color: AppColors.white)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}