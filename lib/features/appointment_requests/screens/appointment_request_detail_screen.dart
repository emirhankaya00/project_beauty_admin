import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_app_bar.dart';
import 'package:project_beauty_admin/data/models/appointment_status.dart'; // Enum dosyasını import ettiğinden emin ol

// Bu, randevu detaylarını gösteren ekran Widget'ıdır.
class AppointmentRequestDetailScreen extends StatelessWidget {
  final String customerName;
  final String serviceName;
  final String time;
  final AppointmentStatus status;
  final String? note; // Not alanı opsiyonel olabilir

  const AppointmentRequestDetailScreen({
    super.key, // super.key kullanımı modern ve doğrudur
    required this.customerName,
    required this.serviceName,
    required this.time,
    required this.status,
    this.note,
  });

  // Randevu durumuna göre renk döndüren yardımcı metot
  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return AppColors.orange;
      case AppointmentStatus.approved:
        return AppColors.green;
      case AppointmentStatus.rejected:
        return AppColors.red;
      case AppointmentStatus.cancelledByCustomer:
        return AppColors.darkGrey;
      case AppointmentStatus.offered:
        return Colors.black; // 'offered' durumu için mavi renk
    // ignore: no_default_cases
      default: // Tüm enum değerleri kapsandığında bu bölüme girmez ancak eklenmesi iyi bir pratik olabilir.
        return AppColors.darkGrey;
    }
  }

  // Randevu durumuna göre metin döndüren yardımcı metot
  String _getStatusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return 'Onay Bekliyor';
      case AppointmentStatus.approved:
        return 'Onaylandı';
      case AppointmentStatus.rejected:
        return 'Reddedildi';
      case AppointmentStatus.cancelledByCustomer:
        return 'Müşteri İptal Etti';
      case AppointmentStatus.offered:
        return 'Alternatif Önerildi'; // 'offered' durumu metni
    // ignore: no_default_cases
      default: // Tüm enum değerleri kapsandığında bu bölüme girmez
        return 'Bilinmiyor';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AdminAppBar(
        title: 'Randevu Detayı',
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Theme.of(context).appBarTheme.foregroundColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Müşteri Adı:', style: AppTextStyles.bodyText2.copyWith(fontWeight: FontWeight.bold)),
            Text(customerName, style: AppTextStyles.headline3.copyWith(color: AppColors.black)),
            const SizedBox(height: 16.0),

            Text('Hizmet:', style: AppTextStyles.bodyText2.copyWith(fontWeight: FontWeight.bold)),
            Text(serviceName, style: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey)),
            const SizedBox(height: 16.0),

            Text('Randevu Saati:', style: AppTextStyles.bodyText2.copyWith(fontWeight: FontWeight.bold)),
            Text(time, style: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey)),
            const SizedBox(height: 16.0),

            Text('Durum:', style: AppTextStyles.bodyText2.copyWith(fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _getStatusColor(status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                _getStatusText(status),
                style: AppTextStyles.bodyText2.copyWith(color: _getStatusColor(status), fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16.0),

            if (note != null && note!.isNotEmpty) ...[
              Text('Müşteri Notu:', style: AppTextStyles.bodyText2.copyWith(fontWeight: FontWeight.bold)),
              Text(note!, style: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey)),
            ],
            // İsterseniz buraya ek detaylar veya butonlar ekleyebilirsiniz
          ],
        ),
      ),
    );
  }
}