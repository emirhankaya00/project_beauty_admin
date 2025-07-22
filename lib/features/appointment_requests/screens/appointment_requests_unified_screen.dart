import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// MVVM Yapısı için Gerekli Importlar
import 'package:project_beauty_admin/data/models/reservation_model.dart';
import 'package:project_beauty_admin/viewmodels/auth_viewmodel.dart'; // AuthViewModel'i içeri aktardık
import 'package:project_beauty_admin/viewmodels/reservation_viewmodel.dart';

// Kendi Design System Importların
import 'package:project_beauty_admin/design_system/app_border_radius.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_card.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_app_bar.dart';

class AppointmentRequestsUnifiedScreen extends StatefulWidget {
  const AppointmentRequestsUnifiedScreen({super.key});

  @override
  State<AppointmentRequestsUnifiedScreen> createState() =>
      _AppointmentRequestsUnifiedScreenState();
}

class _AppointmentRequestsUnifiedScreenState
    extends State<AppointmentRequestsUnifiedScreen> {
  final TextEditingController _rejectionReasonController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Bu widget ağaca eklendikten hemen sonra, ViewModel'den verileri çekmesini istiyoruz.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // DÜZELTME: AuthViewModel'i context'ten, dinlemeden, tek seferlik okuyoruz.
      final authViewModel = context.read<AuthViewModel>();
      final reservationViewModel = context.read<ReservationViewModel>();

      // Giriş yapmış bir admin ve bu admin'e atanmış bir salon ID'si var mı diye kontrol ediyoruz.
      final saloonId = authViewModel.currentAdmin?.saloonId;
      if (saloonId != null && saloonId.isNotEmpty) {
        // Eğer salon ID'si varsa, randevuları bu ID'ye göre çekiyoruz.
        reservationViewModel.fetchReservations(saloonId);
      } else {
        // Eğer bir sebepten salon ID'si bulunamazsa, bu durumu kullanıcıya bildirmek
        // veya loglamak önemlidir.
        debugPrint(
            "HATA: Aktif salon ID'si AuthViewModel'de bulunamadı! Randevular çekilemiyor.");
        // Opsiyonel: Kullanıcıya bir hata mesajı gösterebilirsiniz.
        // reservationViewModel.setError("Salon bilgisi bulunamadı. Lütfen tekrar giriş yapın.");
      }
    });
  }

  @override
  void dispose() {
    _rejectionReasonController.dispose();
    super.dispose();
  }

  // --- YARDIMCI METOTLAR (Renk ve Metinler) ---
  Color _getStatusColor(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.pending:
        return AppColors.orange;
      case ReservationStatus.confirmed:
        return AppColors.green;
      case ReservationStatus.cancelled:
        return AppColors.red;
      case ReservationStatus.offered:
        return AppColors.yellow;
      default:
        return AppColors.darkGrey;
    }
  }

  String _getStatusText(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.pending:
        return 'Onay Bekliyor';
      case ReservationStatus.confirmed:
        return 'Onaylandı';
      case ReservationStatus.cancelled:
        return 'Reddedildi';
      case ReservationStatus.completed:
        return 'Tamamlandı';
      case ReservationStatus.noShow:
        return 'Müşteri Gelmedi';
      case ReservationStatus.offered:
        return 'Yeni Tarih Önerildi';
      default:
        return 'Bilinmiyor';
    }
  }

  Color _getStatusTextColor(ReservationStatus status) {
    return AppColors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReservationViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: const AdminAppBar(title: 'Randevu Talepleri'),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateNavigator(viewModel),
                const SizedBox(height: 20),
                Text(
                  '${DateFormat('dd MMMM yyyy EEEE', 'tr_TR').format(viewModel.selectedDate)} Tarihli Randevular',
                  style: AppTextStyles.headline3
                      .copyWith(color: AppColors.primaryColor),
                ),
                const SizedBox(height: 10),
                Expanded(child: _buildContentBody(viewModel)),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- ANA İÇERİK OLUŞTURMA ---
  Widget _buildContentBody(ReservationViewModel viewModel) {
    if (viewModel.state == ViewState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.state == ViewState.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Hata: ${viewModel.errorMessage ?? "Bilinmeyen bir hata oluştu."}',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyText1.copyWith(color: AppColors.red),
          ),
        ),
      );
    }
    if (viewModel.filteredReservations.isEmpty) {
      return Center(
        child: Text(
          'Bu tarihte randevu bulunmamaktadır.',
          style: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: viewModel.filteredReservations.length,
      itemBuilder: (context, index) {
        final reservation = viewModel.filteredReservations[index];
        return _buildReservationCard(context, reservation, viewModel);
      },
    );
  }

  // --- RANDEVU KARTI ---
// --- RANDEVU KARTI ---
  Widget _buildReservationCard(BuildContext context, ReservationModel reservation, ReservationViewModel viewModel) {
    // Sadece 'beklemede' veya 'önerildi' durumundaki randevular için aksiyon butonlarını göster
    final bool showActionButtons = reservation.status == ReservationStatus.pending || reservation.status == ReservationStatus.offered;

    // Veritabanından gelen tarih ve saati birleştirelim
    final reservationCombinedDateTime = DateTime(
        reservation.reservationDate.year,
        reservation.reservationDate.month,
        reservation.reservationDate.day,
        int.tryParse(reservation.reservationTime.split(':')[0]) ?? 0,
        int.tryParse(reservation.reservationTime.split(':')[1]) ?? 0
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: CustomCard(
        borderRadius: AppBorderRadius.medium,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Müşteri Adı ve Randevu Saati
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Müşteri: ${reservation.user?.name ?? "İsimsiz"} ${reservation.user?.surname ?? ""}',
                    style: AppTextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  DateFormat('HH:mm').format(reservationCombinedDateTime),
                  style: AppTextStyles.headline3.copyWith(color: AppColors.black),
                ),
              ],
            ),
            const SizedBox(height: 8.0),

            // Hizmet Bilgisi
            Text(
              'Hizmet: ${reservation.service?.serviceName ?? "Hizmet Belirtilmemiş"}',
              style: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey),
            ),

            // Personel Bilgisi (Eğer varsa)
            if (reservation.personal != null) ...[
              const SizedBox(height: 8.0),
              Text(
                'Personel: ${reservation.personal!.name} ${reservation.personal!.surname}',
                style: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey, fontStyle: FontStyle.italic),
              ),
            ],

            const SizedBox(height: 8.0),

            // Randevu Durum Etiketi
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: _getStatusColor(reservation.status),
                borderRadius: AppBorderRadius.small,
              ),
              child: Text(
                _getStatusText(reservation.status),
                style: AppTextStyles.labelText.copyWith(color: _getStatusTextColor(reservation.status)),
              ),
            ),

            // Aksiyon Butonları (Gerekliyse gösterilir)
            if (showActionButtons) ...[
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => _showRejectProposeDialog(context, reservation, viewModel),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.red),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: const RoundedRectangleBorder(borderRadius: AppBorderRadius.medium),
                    ),
                    child: Text('Reddet / Öner', style: AppTextStyles.buttonText.copyWith(color: AppColors.red)),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () => _showApproveConfirmationDialog(context, reservation, viewModel),
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
  }

  // --- DIALOG METOTLARI ---
  Future<void> _showApproveConfirmationDialog(BuildContext context,
      ReservationModel reservation, ReservationViewModel viewModel) async {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Randevuyu Onayla'),
        content: Text(
            '${reservation.user?.name ?? "Müşteri"} adlı müşterinin randevu talebini onaylamak istediğinizden emin misiniz?'),
        actions: [
          TextButton(
              child: const Text('İptal',
                  style: TextStyle(color: AppColors.darkGrey)),
              onPressed: () => Navigator.of(dialogContext).pop()),
          TextButton(
              child: const Text('Onayla',
                  style: TextStyle(color: AppColors.primaryColor)),
              onPressed: () {
                viewModel.approveReservation(reservation.reservationId);
                Navigator.of(dialogContext).pop();
              }),
        ],
      ),
    );
  }

  Future<void> _showRejectProposeDialog(BuildContext context,
      ReservationModel reservation, ReservationViewModel viewModel) async {
    _rejectionReasonController.clear();
    DateTime? selectedProposedDate;
    TimeOfDay? selectedProposedTime;

    return showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setInnerState) => AlertDialog(
          title: Text('${reservation.user?.name ?? ""} Randevusunu Yönet'),
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                  maxLines: 3,
                ),
                const SizedBox(height: 20.0),
                const Text('Veya Yeni Bir Tarih Önerin:'),
                const SizedBox(height: 8.0),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(selectedProposedDate == null
                      ? 'Tarih Seç'
                      : DateFormat('dd MMM yyyy')
                          .format(selectedProposedDate!)),
                  onTap: () async {
                    final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365)));
                    if (picked != null)
                      setInnerState(() => selectedProposedDate = picked);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: Text(selectedProposedTime == null
                      ? 'Saat Seç'
                      : selectedProposedTime!.format(context)),
                  onTap: () async {
                    final picked = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    if (picked != null)
                      setInnerState(() => selectedProposedTime = picked);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                child: const Text('İptal',
                    style: TextStyle(color: AppColors.darkGrey)),
                onPressed: () => Navigator.of(dialogContext).pop()),
            TextButton(
                child: const Text('Reddet',
                    style: TextStyle(color: AppColors.red)),
                onPressed: () {
                  if (_rejectionReasonController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Lütfen bir reddetme nedeni girin.')));
                    return;
                  }
                  viewModel.rejectReservation(reservation.reservationId);
                  Navigator.of(dialogContext).pop();
                }),
            TextButton(
                child: const Text('Öner ve Reddet',
                    style: TextStyle(color: AppColors.primaryColor)),
                onPressed: () {
                  if (selectedProposedDate == null ||
                      selectedProposedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text('Lütfen önerilen tarih ve saati seçin.')));
                    return;
                  }
                  final proposedDateTime = DateTime(
                      selectedProposedDate!.year,
                      selectedProposedDate!.month,
                      selectedProposedDate!.day,
                      selectedProposedTime!.hour,
                      selectedProposedTime!.minute);
                  viewModel.proposeNewDateTime(
                      reservation.reservationId, proposedDateTime);
                  Navigator.of(dialogContext).pop();
                }),
          ],
        ),
      ),
    );
  }

  // --- TARİH NAVİGASYON BARI ---
  Widget _buildDateNavigator(ReservationViewModel viewModel) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 30, // İleriye dönük 30 gün
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          final isSelected = date.year == viewModel.selectedDate.year &&
              date.month == viewModel.selectedDate.month &&
              date.day == viewModel.selectedDate.day;

          return GestureDetector(
            onTap: () => viewModel.selectDate(date),
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                  color:
                      isSelected ? AppColors.primaryColor : AppColors.lightGrey,
                  borderRadius: AppBorderRadius.medium),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('EEE', 'tr_TR').format(date),
                      style: AppTextStyles.bodyText2.copyWith(
                          color:
                              isSelected ? AppColors.white : AppColors.darkGrey,
                          fontWeight: FontWeight.bold)),
                  Text(DateFormat('dd').format(date),
                      style: AppTextStyles.headline3.copyWith(
                          color:
                              isSelected ? AppColors.white : AppColors.black)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
