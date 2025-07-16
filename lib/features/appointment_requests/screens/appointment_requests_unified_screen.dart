import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_beauty_admin/design_system/app_border_radius.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_card.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_app_bar.dart';

// AppointmentStatus enum'unu artık doğrudan kullanmıyoruz, onun yerine String kullanacağız.
// import 'package:project_beauty_admin/data/models/appointment_status.dart'; // Bu satırı kaldırıyoruz
// import 'package:project_beauty_admin/data/models/appointment_model.dart'; // Bu satırı kaldırıyoruz

class AppointmentRequestsUnifiedScreen extends StatefulWidget {
  const AppointmentRequestsUnifiedScreen({super.key});

  @override
  State<AppointmentRequestsUnifiedScreen> createState() => _AppointmentRequestsUnifiedScreenState();
}

class _AppointmentRequestsUnifiedScreenState extends State<AppointmentRequestsUnifiedScreen> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _rejectionReasonController = TextEditingController();

  // Tüm randevu verilerini doğrudan burada Map olarak tutuyoruz, model kullanmıyoruz.
  final List<Map<String, dynamic>> _allAppointmentRequests = [
    {
      'id': '1',
      'customerName': 'Ayşe Yılmaz',
      'serviceName': 'Saç Kesimi',
      'dateTime': DateTime.now().add(const Duration(hours: 2)),
      'status': 'pending', // Enum yerine String
      'note': 'Acil bir randevu, lütfen hızlı onaylayın.',
    },
    {
      'id': '2',
      'customerName': 'Mehmet Demir',
      'serviceName': 'Cilt Bakımı',
      'dateTime': DateTime.now().add(const Duration(days: 1, hours: 4)),
      'status': 'approved', // Enum yerine String
      'note': null,
    },
    {
      'id': '3',
      'customerName': 'Zeynep Can',
      'serviceName': 'Manikür & Pedikür',
      'dateTime': DateTime.now().add(const Duration(days: 1, hours: 1)),
      'status': 'rejected', // Enum yerine String
      'rejectionReason': 'Personel müsait değil.',
    },
    {
      'id': '4',
      'customerName': 'Ali Veli',
      'serviceName': 'Masaj Terapisi',
      'dateTime': DateTime.now().add(const Duration(days: 2, hours: 3)),
      'status': 'pending', // Enum yerine String
      'note': null,
    },
    {
      'id': '5',
      'customerName': 'Elif Su',
      'serviceName': 'Ağda',
      'dateTime': DateTime.now().add(const Duration(days: 2, hours: 1)),
      'status': 'cancelledByCustomer', // Enum yerine String
      'note': 'Müşteri iptal etti.',
    },
    {
      'id': '6',
      'customerName': 'Can Tekin',
      'serviceName': 'Saç Boyama',
      'dateTime': DateTime.now().add(const Duration(days: 3, hours: 2)),
      'status': 'offered', // Enum yerine String
      'proposedDateTime': DateTime.now().add(const Duration(days: 5, hours: 10)),
      'note': 'Müşteriye alternatif saat önerildi.',
    },
    // Geçmiş bir tarih için örnek
    {
      'id': '7',
      'customerName': 'Burak Kara',
      'serviceName': 'Fön Çekimi',
      'dateTime': DateTime.now().subtract(const Duration(days: 5, hours: 1)),
      'status': 'approved', // Enum yerine String
    },
    {
      'id': '8',
      'customerName': 'Deniz Ak',
      'serviceName': 'Kaş Tasarımı',
      'dateTime': DateTime.now().add(const Duration(days: 4, hours: 10)),
      'status': 'pending', // Enum yerine String
    },
  ];

  // Seçili tarihe göre randevuları filtrele
  List<Map<String, dynamic>> get _filteredAppointmentRequests {
    return _allAppointmentRequests.where((appointment) {
      final appointmentDateTime = appointment['dateTime'] as DateTime;
      return appointmentDateTime.year == _selectedDate.year &&
          appointmentDateTime.month == _selectedDate.month &&
          appointmentDateTime.day == _selectedDate.day;
    }).toList();
  }

  @override
  void dispose() {
    _rejectionReasonController.dispose();
    super.dispose();
  }

  // Randevu durumuna göre renk döndüren yardımcı metot (String ile çalışacak şekilde güncellendi)
  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.orange;
      case 'approved':
        return AppColors.green;
      case 'rejected':
        return AppColors.red;
      case 'cancelledByCustomer':
        return AppColors.darkGrey;
      case 'offered':
        return Colors.black;
      case 'suggested':
        return AppColors.yellow;
      default:
        return AppColors.darkGrey;
    }
  }

  // Randevu durumuna göre metin döndüren yardımcı metot (String ile çalışacak şekilde güncellendi)
  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Onay Bekliyor';
      case 'approved':
        return 'Onaylandı';
      case 'rejected':
        return 'Reddedildi';
      case 'cancelledByCustomer':
        return 'Müşteri İptal Etti';
      case 'offered':
        return 'Alternatif Önerildi';
      case 'suggested':
        return 'Öneri Bekleniyor';
      default:
        return 'Bilinmiyor';
    }
  }

  // Durum metninin rengini belirleyen yardımcı metot (String ile çalışacak şekilde güncellendi)
  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'pending':
      case 'approved':
      case 'rejected':
        return AppColors.white;
      case 'cancelledByCustomer':
      case 'offered':
      case 'suggested':
        return AppColors.darkGrey;
      default:
        return AppColors.white;
    }
  }

  // Onaylama onayı için pop-up (Map ile çalışacak şekilde güncellendi)
  Future<void> _showApproveConfirmationDialog(BuildContext context, Map<String, dynamic> request) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Randevuyu Onayla'),
          content: Text('${request['customerName']} adlı müşterinin randevu talebini onaylamak istediğinizden emin misiniz?'),
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
                debugPrint('${request['customerName']} adlı müşterinin randevusu onaylandı.');
                setState(() {
                  // Mock data güncellemesi
                  final index = _allAppointmentRequests.indexWhere((r) => r['id'] == request['id']);
                  if (index != -1) {
                    _allAppointmentRequests[index]['status'] = 'approved'; // String olarak güncelle
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

  // Reddetme/Yeni tarih önerme pop-up (Map ile çalışacak şekilde güncellendi)
  Future<void> _showRejectProposeDialog(BuildContext context, Map<String, dynamic> request) async {
    _rejectionReasonController.clear();

    DateTime? selectedProposedDate;
    TimeOfDay? selectedProposedTime;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setInnerState) {
            return AlertDialog(
              title: Text('${request['customerName']} Randevusunu Yönet'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Randevu Reddetme Nedeni:'),
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
                    const Text('Veya Yeni Bir Tarih Önerin:'),
                    const SizedBox(height: 8.0),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(selectedProposedDate == null
                          ? 'Tarih Seç'
                          : DateFormat('dd MMM yyyy').format(selectedProposedDate!)),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedProposedDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                        );
                        if (pickedDate != null) {
                          setInnerState(() {
                            selectedProposedDate = pickedDate;
                          });
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text(selectedProposedTime == null
                          ? 'Saat Seç'
                          : selectedProposedTime!.format(context)),
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: selectedProposedTime ?? TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setInnerState(() {
                            selectedProposedTime = pickedTime;
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
                    if (_rejectionReasonController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lütfen bir reddetme nedeni girin.')),
                      );
                      return;
                    }
                    debugPrint('${request['customerName']} randevusu reddedildi. Neden: ${_rejectionReasonController.text}');
                    setState(() {
                      final index = _allAppointmentRequests.indexWhere((r) => r['id'] == request['id']);
                      if (index != -1) {
                        _allAppointmentRequests[index]['status'] = 'rejected';
                        _allAppointmentRequests[index]['rejectionReason'] = _rejectionReasonController.text;
                      }
                    });
                    Navigator.of(dialogContext).pop();
                  },
                ),
                TextButton(
                  child: const Text('Öner ve Reddet', style: TextStyle(color: AppColors.primaryColor)),
                  onPressed: () {
                    if (selectedProposedDate == null || selectedProposedTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lütfen önerilen tarih ve saati seçin.')),
                      );
                      return;
                    }
                    final proposedDateTime = DateTime(
                      selectedProposedDate!.year,
                      selectedProposedDate!.month,
                      selectedProposedDate!.day,
                      selectedProposedTime!.hour,
                      selectedProposedTime!.minute,
                    );
                    debugPrint('${request['customerName']} randevusu reddedildi ve yeni tarih önerildi: $proposedDateTime');
                    setState(() {
                      final index = _allAppointmentRequests.indexWhere((r) => r['id'] == request['id']);
                      if (index != -1) {
                        _allAppointmentRequests[index]['status'] = 'offered';
                        _allAppointmentRequests[index]['proposedDateTime'] = proposedDateTime;
                        _allAppointmentRequests[index]['rejectionReason'] = _rejectionReasonController.text.isNotEmpty
                            ? _rejectionReasonController.text
                            : 'Alternatif tarih önerildi.';
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
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 30,
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
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : AppColors.lightGrey,
                borderRadius: AppBorderRadius.medium,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE', 'tr_TR').format(date),
                    style: AppTextStyles.bodyText2.copyWith(
                      color: isSelected ? AppColors.white : AppColors.darkGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('dd').format(date),
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
                Expanded(child: _buildDateNavigator()),
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
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
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
              style: AppTextStyles.headline3.copyWith(color: AppColors.primaryColor), // headline3 kullanıldı
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
                  final String status = request['status'] as String; // String olarak al
                  final bool showActionButtons = status == 'pending' || status == 'offered' || status == 'suggested';

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
                                  'Müşteri Adı: ${request['customerName']}',
                                  style: AppTextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                DateFormat('HH:mm (dd.MM.yyyy)').format(request['dateTime'] as DateTime),
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
                              'Müşteri Notu: ${request['note']}',
                              style: AppTextStyles.bodyText2.copyWith(color: AppColors.grey),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          // Reddetme nedeni veya önerilen tarih varsa göster
                          if (status == 'rejected' && request['rejectionReason'] != null && (request['rejectionReason'] as String).isNotEmpty) ...[
                            const SizedBox(height: 8.0),
                            Text(
                              'Reddetme Nedeni: ${request['rejectionReason']}',
                              style: AppTextStyles.bodyText2.copyWith(color: AppColors.red),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          if (status == 'offered' && request['proposedDateTime'] != null) ...[
                            const SizedBox(height: 8.0),
                            Text(
                              'Önerilen Yeni Tarih: ${DateFormat('dd MMM yyyy HH:mm').format(request['proposedDateTime'] as DateTime)}',
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
                                  onPressed: () => _showRejectProposeDialog(context, request),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.red),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: const RoundedRectangleBorder(borderRadius: AppBorderRadius.medium),
                                  ),
                                  child: Text('Reddet / Öner', style: AppTextStyles.buttonText.copyWith(color: AppColors.red)),
                                ),
                                const SizedBox(width: 8.0),
                                ElevatedButton(
                                  onPressed: () => _showApproveConfirmationDialog(context, request),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: const RoundedRectangleBorder(borderRadius: AppBorderRadius.medium),
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