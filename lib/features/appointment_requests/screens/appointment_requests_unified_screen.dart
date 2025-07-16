import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tarih formatlama için ekledik, pubspec.yaml'a intl paketi eklenmeli
import 'package:project_beauty_admin/design_system/app_border_radius.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_card.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_app_bar.dart';
import 'package:project_beauty_admin/data/models/appointment_status.dart';
// Randevu modelini buraya dahil ediyoruz
import 'package:project_beauty_admin/data/models/appointment_model.dart'; // CİTE: 1

class AppointmentRequestsUnifiedScreen extends StatefulWidget {
  const AppointmentRequestsUnifiedScreen({super.key});

  @override
  State<AppointmentRequestsUnifiedScreen> createState() => _AppointmentRequestsUnifiedScreenState();
}

class _AppointmentRequestsUnifiedScreenState extends State<AppointmentRequestsUnifiedScreen> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _rejectionReasonController = TextEditingController();

  // Örnek randevu verileri, gerçek ViewModel'den gelecektir.
  // Burada AppointmentModel kullanarak daha gerçekçi bir simülasyon yapıyoruz.
  List<AppointmentModel> _allAppointmentRequests = [
    AppointmentModel(
      id: '1',
      customerName: 'Ayşe Yılmaz',
      serviceName: 'Saç Kesimi',
      dateTime: DateTime.now().add(const Duration(hours: 2)),
      status: AppointmentStatus.pending,
      note: 'Acil bir randevu, lütfen hızlı onaylayın.',
    ),
    AppointmentModel(
      id: '2',
      customerName: 'Mehmet Demir',
      serviceName: 'Cilt Bakımı',
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 4)),
      status: AppointmentStatus.approved,
    ),
    AppointmentModel(
      id: '3',
      customerName: 'Zeynep Can',
      serviceName: 'Manikür & Pedikür',
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 1)),
      status: AppointmentStatus.rejected,
      rejectionReason: 'Personel müsait değil.',
    ),
    AppointmentModel(
      id: '4',
      customerName: 'Ali Veli',
      serviceName: 'Masaj Terapisi',
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 3)),
      status: AppointmentStatus.pending,
    ),
    AppointmentModel(
      id: '5',
      customerName: 'Elif Su',
      serviceName: 'Ağda',
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 1)),
      status: AppointmentStatus.cancelledByCustomer,
      note: 'Müşteri iptal etti.',
    ),
    AppointmentModel(
      id: '6',
      customerName: 'Can Tekin',
      serviceName: 'Saç Boyama',
      dateTime: DateTime.now().add(const Duration(days: 3, hours: 2)),
      status: AppointmentStatus.offered,
      proposedDateTime: DateTime.now().add(const Duration(days: 5, hours: 10)),
      note: 'Müşteriye alternatif saat önerildi.',
    ),
    // Geçmiş bir tarih için örnek
    AppointmentModel(
      id: '7',
      customerName: 'Burak Kara',
      serviceName: 'Fön Çekimi',
      dateTime: DateTime.now().subtract(const Duration(days: 5, hours: 1)),
      status: AppointmentStatus.approved,
    ),
    AppointmentModel(
      id: '8',
      customerName: 'Deniz Ak',
      serviceName: 'Kaş Tasarımı',
      dateTime: DateTime.now().add(const Duration(days: 4, hours: 10)),
      status: AppointmentStatus.pending,
    ),
  ];

  // Seçili tarihe göre randevuları filtrele
  List<AppointmentModel> get _filteredAppointmentRequests {
    return _allAppointmentRequests.where((appointment) {
      return appointment.dateTime.year == _selectedDate.year &&
          appointment.dateTime.month == _selectedDate.month &&
          appointment.dateTime.day == _selectedDate.day;
    }).toList();
  }

  @override
  void dispose() {
    _rejectionReasonController.dispose();
    super.dispose();
  }

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
      }
  }

  // Onaylama onayı için pop-up
  Future<void> _showApproveConfirmationDialog(BuildContext context, AppointmentModel request) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Randevuyu Onayla'),
          content: Text('${request.customerName} adlı müşterinin randevu talebini onaylamak istediğinizden emin misiniz?'),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal', style: TextStyle(color: AppColors.darkGrey)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Onayla', style: TextStyle(color: AppColors.primaryColor)),
              onPressed: () {
                // Burada onaylama işlemi yapılacak (ViewModel'e çağrı)
                debugPrint('${request.customerName} adlı müşterinin randevusu onaylandı.');
                setState(() {
                  // Mock data güncellemesi
                  final index = _allAppointmentRequests.indexWhere((r) => r.id == request.id);
                  if (index != -1) {
                    _allAppointmentRequests[index] = _allAppointmentRequests[index].copyWith(status: AppointmentStatus.approved);
                  }
                });
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Reddetme/Yeni tarih önerme pop-up
  Future<void> _showRejectProposeDialog(BuildContext context, AppointmentModel request) async {
    _rejectionReasonController.clear(); // Her açıldığında temizle

    DateTime? _selectedProposedDate;
    TimeOfDay? _selectedProposedTime;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder( // AlertDialog içindeki state'i yönetmek için
          builder: (context, setInnerState) {
            return AlertDialog(
              title: Text('${request.customerName} Randevusunu Yönet'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Randevu Reddetme Nedeni:'),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: _rejectionReasonController,
                      decoration: const InputDecoration(
                        hintText: 'Örn: Personel müsait değil',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20.0),
                    Text('Veya Yeni Bir Tarih Önerin:'),
                    const SizedBox(height: 8.0),
                    ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text(_selectedProposedDate == null
                          ? 'Tarih Seç'
                          : DateFormat('dd MMM yyyy').format(_selectedProposedDate!)),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedProposedDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                        );
                        if (pickedDate != null) {
                          setInnerState(() {
                            _selectedProposedDate = pickedDate;
                          });
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text(_selectedProposedTime == null
                          ? 'Saat Seç'
                          : _selectedProposedTime!.format(context)),
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: _selectedProposedTime ?? TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setInnerState(() {
                            _selectedProposedTime = pickedTime;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('İptal', style: TextStyle(color: AppColors.darkGrey)),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
                TextButton(
                  child: const Text('Reddet', style: TextStyle(color: AppColors.red)),
                  onPressed: () {
                    // Sadece reddetme işlemi
                    if (_rejectionReasonController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lütfen bir reddetme nedeni girin.')),
                      );
                      return;
                    }
                    debugPrint('${request.customerName} randevusu reddedildi. Neden: ${_rejectionReasonController.text}');
                    setState(() {
                      final index = _allAppointmentRequests.indexWhere((r) => r.id == request.id);
                      if (index != -1) {
                        _allAppointmentRequests[index] = _allAppointmentRequests[index].copyWith(
                          status: AppointmentStatus.rejected,
                          rejectionReason: _rejectionReasonController.text,
                        );
                      }
                    });
                    Navigator.of(dialogContext).pop();
                  },
                ),
                TextButton(
                  child: const Text('Öner ve Reddet', style: TextStyle(color: AppColors.primaryColor)),
                  onPressed: () {
                    // Yeni tarih önerme işlemi
                    if (_selectedProposedDate == null || _selectedProposedTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lütfen önerilen tarih ve saati seçin.')),
                      );
                      return;
                    }
                    final proposedDateTime = DateTime(
                      _selectedProposedDate!.year,
                      _selectedProposedDate!.month,
                      _selectedProposedDate!.day,
                      _selectedProposedTime!.hour,
                      _selectedProposedTime!.minute,
                    );
                    debugPrint('${request.customerName} randevusu reddedildi ve yeni tarih önerildi: $proposedDateTime');
                    setState(() {
                      final index = _allAppointmentRequests.indexWhere((r) => r.id == request.id);
                      if (index != -1) {
                        _allAppointmentRequests[index] = _allAppointmentRequests[index].copyWith(
                          status: AppointmentStatus.offered, // Durumu 'offered' olarak ayarla
                          proposedDateTime: proposedDateTime,
                          rejectionReason: _rejectionReasonController.text.isNotEmpty
                              ? _rejectionReasonController.text
                              : 'Alternatif tarih önerildi.',
                        );
                      }
                    });
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Tarih navigasyonu için haftalık kaydırıcı
  Widget _buildDateNavigator() {
    return SizedBox(
      height: 80, // Tarih çubuğunun yüksekliği
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 30, // Bugün ve sonraki 29 gün (yaklaşık 1 ay)
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          final isSelected = date.day == _selectedDate.day &&
              date.month == _selectedDate.month &&
              date.year == _selectedDate.year;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            child: Container(
              width: 60, // Her gün kutusunun genişliği
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : AppColors.lightGrey,
                borderRadius: AppBorderRadius.medium,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE', 'tr_TR').format(date), // Haftanın günü (örn: Çar)
                    style: AppTextStyles.bodyText2.copyWith(
                      color: isSelected ? AppColors.white : AppColors.darkGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('dd').format(date), // Gün (örn: 16)
                    style: AppTextStyles.headline3.copyWith(
                      color: isSelected ? AppColors.white : AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
            // Tarih navigasyon kısmı
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
                    });
                  },
                ),
                Expanded(child: _buildDateNavigator()), // Haftalık kaydırıcı
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.add(const Duration(days: 7));
                    });
                  },
                ),
                // Daha çok bakmak için takvim butonu
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now().subtract(const Duration(days: 365)), // Geçmişe de bakabilmek için
                      lastDate: DateTime.now().add(const Duration(days: 365 * 2)), // 2 yıl ileri
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '${DateFormat('dd MMMM yyyy EEEE', 'tr_TR').format(_selectedDate)} Tarihli Randevular',
              style: AppTextStyles.headline1.copyWith(color: AppColors.primaryColor),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _filteredAppointmentRequests.isEmpty
                  ? Center(
                child: Text(
                  'Bu tarihte randevu bulunmamaktadır.',
                  style: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey),
                ),
              )
                  : ListView.builder(
                itemCount: _filteredAppointmentRequests.length,
                itemBuilder: (context, index) {
                  final request = _filteredAppointmentRequests[index];
                  final showActionButtons = request.status == AppointmentStatus.pending ||
                      request.status == AppointmentStatus.offered ||
                      request.status == AppointmentStatus.suggested;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: CustomCard(
                      borderRadius: AppBorderRadius.medium,
                      padding: const EdgeInsets.all(16.0),
                      onTap: () {
                        // Kartın kendisine tıklanıldığında ek detay gösterebilir (opsiyonel)
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Müşteri Adı: ${request.customerName}',
                                  style: AppTextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                DateFormat('HH:mm (dd.MM.yyyy)').format(request.dateTime),
                                style: AppTextStyles.headline3.copyWith(color: AppColors.black),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Text('Hizmet: ${request.serviceName}', style: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey)),
                          const SizedBox(height: 8.0),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: _getStatusColor(request.status),
                              borderRadius: AppBorderRadius.small,
                            ),
                            child: Text(
                              _getStatusText(request.status),
                              style: AppTextStyles.labelText.copyWith(color: _getStatusTextColor(request.status)),
                            ),
                          ),
                          if (request.note != null && request.note!.isNotEmpty) ...[
                            const SizedBox(height: 8.0),
                            Text(
                              'Müşteri Notu: ${request.note}',
                              style: AppTextStyles.bodyText2.copyWith(color: AppColors.grey),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          // Reddetme nedeni veya önerilen tarih varsa göster
                          if (request.status == AppointmentStatus.rejected && request.rejectionReason != null && request.rejectionReason!.isNotEmpty) ...[
                            const SizedBox(height: 8.0),
                            Text(
                              'Reddetme Nedeni: ${request.rejectionReason}',
                              style: AppTextStyles.bodyText2.copyWith(color: AppColors.red),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          if (request.status == AppointmentStatus.offered && request.proposedDateTime != null) ...[
                            const SizedBox(height: 8.0),
                            Text(
                              'Önerilen Yeni Tarih: ${DateFormat('dd MMM yyyy HH:mm').format(request.proposedDateTime!)}',
                              style: AppTextStyles.bodyText2.copyWith(color: AppColors.primaryColor),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          // Aksiyon Butonları
                          if (showActionButtons) ...[
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: () => _showRejectProposeDialog(context, request), // Yeni reddet/öner pop-up'ı
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.red),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.medium),
                                  ),
                                  child: Text('Reddet / Öner', style: AppTextStyles.buttonText.copyWith(color: AppColors.red)),
                                ),
                                const SizedBox(width: 8.0),
                                ElevatedButton(
                                  onPressed: () => _showApproveConfirmationDialog(context, request),
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