import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_border_radius.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_card.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_app_bar.dart';
import 'package:project_beauty_admin/data/models/appointment_status.dart';

class AppointmentRequestsUnifiedScreen extends StatefulWidget {
  const AppointmentRequestsUnifiedScreen({super.key});

  @override
  State<AppointmentRequestsUnifiedScreen> createState() => _AppointmentRequestsUnifiedScreenState();
}

class _AppointmentRequestsUnifiedScreenState extends State<AppointmentRequestsUnifiedScreen> {
  // Örnek randevu verileri, ViewModel entegrasyonu yapıldığında buradan kaldırılacak.
  final List<Map<String, dynamic>> _appointmentRequests = [
    {
      'customerName': 'Ayşe Yılmaz',
      'serviceName': 'Saç Kesimi',
      'time': '10:00 - 11:00 (16.07.2025)',
      'status': AppointmentStatus.pending,
      'note': 'Acil bir randevu, lütfen hızlı onaylayın.',
    },
    {
      'customerName': 'Mehmet Demir',
      'serviceName': 'Cilt Bakımı',
      'time': '14:00 - 15:00 (16.07.2025)',
      'status': AppointmentStatus.approved,
      'note': null,
    },
    {
      'customerName': 'Zeynep Can',
      'serviceName': 'Manikür & Pedikür',
      'time': '11:30 - 12:30 (17.07.2025)',
      'status': AppointmentStatus.rejected,
      'note': 'Personel müsait değil.',
    },
    {
      'customerName': 'Ali Veli',
      'serviceName': 'Masaj Terapisi',
      'time': '16:00 - 17:00 (17.07.2025)',
      'status': AppointmentStatus.pending,
      'note': null,
    },
    {
      'customerName': 'Elif Su',
      'serviceName': 'Ağda',
      'time': '09:00 - 09:30 (18.07.2025)',
      'status': AppointmentStatus.cancelledByCustomer,
      'note': 'Müşteri iptal etti.',
    },
    {
      'customerName': 'Can Tekin',
      'serviceName': 'Saç Boyama',
      'time': '13:00 - 15:00 (18.07.2025)',
      'status': AppointmentStatus.offered,
      'note': 'Müşteriye alternatif saat önerildi.',
    },
  ];

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
        return Colors.black;
      case AppointmentStatus.suggested:
        return AppColors.yellow;
      default:
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
        return 'Alternatif Önerildi';
      case AppointmentStatus.suggested:
        return 'Öneri Bekleniyor';
      default:
        return 'Bilinmiyor';
    }
  }

  // Durum metninin rengini belirleyen yardımcı metot
  Color _getStatusTextColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
      case AppointmentStatus.approved:
      case AppointmentStatus.rejected:
        return AppColors.white;
      case AppointmentStatus.cancelledByCustomer:
      case AppointmentStatus.offered:
      case AppointmentStatus.suggested:
        return AppColors.darkGrey;
      default:
        return AppColors.white;
    }
  }

  // Onaylama onayı için pop-up
  Future<void> _showApproveConfirmationDialog(BuildContext context, Map<String, dynamic> request) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Kullanıcı pop-up dışında bir yere tıklayarak kapatamaz
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Randevuyu Onayla'),
          content: Text('${request['customerName']} adlı müşterinin randevu talebini onaylamak istediğinizden emin misiniz?'),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal', style: TextStyle(color: AppColors.darkGrey)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Pop-up'ı kapat
              },
            ),
            TextButton(
              child: const Text('Onayla', style: TextStyle(color: AppColors.primaryColor)),
              onPressed: () {
                // Burada onaylama işlemi (örneğin ViewModel'e çağrı) yapılacak
                debugPrint('${request['customerName']} adlı müşterinin randevusu onaylandı.');
                Navigator.of(dialogContext).pop(); // Pop-up'ı kapat
                // İsteğe bağlı: UI'ı güncellemek için setState veya ViewModel tetikleme
              },
            ),
          ],
        );
      },
    );
  }

  // Reddetme onayı için pop-up
  Future<void> _showRejectConfirmationDialog(BuildContext context, Map<String, dynamic> request) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Kullanıcı pop-up dışında bir yere tıklayarak kapatamaz
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Randevuyu Reddet'),
          content: Text('${request['customerName']} adlı müşterinin randevu talebini reddetmek istediğinizden emin misiniz?'),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal', style: TextStyle(color: AppColors.darkGrey)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Pop-up'ı kapat
              },
            ),
            TextButton(
              child: const Text('Reddet', style: TextStyle(color: AppColors.red)),
              onPressed: () {
                // Burada reddetme işlemi (örneğin ViewModel'e çağrı) yapılacak
                debugPrint('${request['customerName']} adlı müşterinin randevusu reddedildi.');
                Navigator.of(dialogContext).pop(); // Pop-up'ı kapat
                // İsteğe bağlı: UI'ı güncellemek için setState veya ViewModel tetikleme
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: 'Randevu Talepleri'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tüm Randevu Talepleri',
              style: AppTextStyles.headline1.copyWith(color: AppColors.primaryColor),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _appointmentRequests.length,
                itemBuilder: (context, index) {
                  final request = _appointmentRequests[index];
                  final status = request['status'] as AppointmentStatus;
                  final showActionButtons = status == AppointmentStatus.pending || status == AppointmentStatus.offered || status == AppointmentStatus.suggested;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: CustomCard(
                      borderRadius: AppBorderRadius.medium,
                      padding: const EdgeInsets.all(16.0),
                      onTap: () {
                        // Kartın kendisine tıklanıldığında yapılacak aksiyon (örn: daha detaylı bir bottom sheet açma)
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Müşteri Adı: ${request['customerName']}',
                                  style: AppTextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                request['time'] as String,
                                style: AppTextStyles.headline3.copyWith(color: AppColors.black),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Text('Hizmet: ${request['serviceName']}', style: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey)),
                          const SizedBox(height: 8.0),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: _getStatusColor(status),
                              borderRadius: AppBorderRadius.small,
                            ),
                            child: Text(
                              _getStatusText(status),
                              style: AppTextStyles.labelText.copyWith(color: _getStatusTextColor(status)),
                            ),
                          ),
                          if (request['note'] != null && (request['note'] as String).isNotEmpty) ...[
                            const SizedBox(height: 8.0),
                            Text(
                              'Not: ${request['note']}',
                              style: AppTextStyles.bodyText2.copyWith(color: AppColors.grey),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          if (showActionButtons) ...[
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: () => _showRejectConfirmationDialog(context, request), // Reddet pop-up'ını tetikle
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.red),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.medium),
                                  ),
                                  child: Text('Reddet', style: AppTextStyles.buttonText.copyWith(color: AppColors.red)),
                                ),
                                const SizedBox(width: 8.0),
                                ElevatedButton(
                                  onPressed: () => _showApproveConfirmationDialog(context, request), // Onayla pop-up'ını tetikle
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}