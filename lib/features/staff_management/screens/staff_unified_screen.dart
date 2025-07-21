import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_app_bar.dart';
import 'package:project_beauty_admin/viewmodels/auth_viewmodel.dart';
import 'package:project_beauty_admin/viewmodels/staff_viewmodel.dart';
import 'package:provider/provider.dart';

class StaffUnifiedScreen extends StatefulWidget {
  const StaffUnifiedScreen({super.key});

  @override
  State<StaffUnifiedScreen> createState() => _StaffUnifiedScreenState();
}

class _StaffUnifiedScreenState extends State<StaffUnifiedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = context.read<AuthViewModel>();
      if (authViewModel.currentAdmin != null) {
        context.read<StaffViewModel>().fetchInitialData(authViewModel.currentAdmin!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StaffViewModel>();
    return Scaffold(
      appBar: const AdminAppBar(title: 'Personel Yönetimi'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Personel Listesi', style: AppTextStyles.headline3.copyWith(color: AppColors.primaryColor)),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) => viewModel.search(value),
              decoration: const InputDecoration(hintText: 'Personel Ara...'),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildBody(viewModel)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditStaffDialog(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(StaffViewModel viewModel) {
    if (viewModel.isLoading && viewModel.filteredStaffMembers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null) {
      return Center(child: Text('Hata: ${viewModel.errorMessage}'));
    }
    if (viewModel.filteredStaffMembers.isEmpty) {
      return const Center(child: Text('Personel bulunamadı.'));
    }
    return ListView.builder(
      itemCount: viewModel.filteredStaffMembers.length,
      itemBuilder: (context, index) {
        final staffData = viewModel.filteredStaffMembers[index];
        return _buildStaffCard(context, staffData);
      },
    );
  }

  String _formatSpecialtyForDisplay(dynamic specialtyData) {
    if (specialtyData == null) return 'Uzmanlık Belirtilmemiş';
    if (specialtyData is List) {
      if (specialtyData.isEmpty) return 'Uzmanlık Belirtilmemiş';
      return specialtyData.join(', ');
    }
    if (specialtyData is String) {
      if (specialtyData.isEmpty || specialtyData == '{}') return 'Uzmanlık Belirtilmemiş';
      return specialtyData.replaceAll(RegExp(r'[{}"\\]'), '');
    }
    return 'Uzmanlık Belirtilmemiş';
  }

  Widget _buildStaffCard(BuildContext context, Map<String, dynamic> staff) {
    final personalId = staff['personal_id'] as String? ?? '';
    final name = staff['name'] as String? ?? 'İsimsiz';
    final surname = staff['surname'] as String? ?? '';
    final email = staff['email'] as String?;
    final phone = staff['phone_number'] as String?;
    final imageUrl = staff['profile_photo_url'] as String?;
    final specialtyText = _formatSpecialtyForDisplay(staff['specialty']);
    final assignedServicesData = staff['personal_saloon_services'] as List? ?? [];
    final serviceNames = assignedServicesData.map((service) {
      final serviceDetails = service['services'] as Map<String, dynamic>? ?? {};
      return serviceDetails['service_name'] as String? ?? '';
    }).where((name) => name.isNotEmpty).toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: imageUrl != null && imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                  child: (imageUrl == null || imageUrl.isEmpty) ? Text('${name.isNotEmpty ? name[0] : ''}${surname.isNotEmpty ? surname[0] : ''}') : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$name $surname', style: AppTextStyles.headline3),
                      Text(specialtyText, style: AppTextStyles.bodyText1),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (email != null && email.isNotEmpty) Text('E-posta: $email'),
            if (phone != null && phone.isNotEmpty) Text('Telefon: $phone'),
            const SizedBox(height: 8),
            if (serviceNames.isNotEmpty) ...[
              Text('Verdiği Hizmetler:', style: AppTextStyles.bodyText2.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6.0,
                children: serviceNames.map((name) => Chip(label: Text(name))).toList(),
              ),
            ],
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () => _showEditStaffDialog(context, staff),
                    child: const Text('Düzenle'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Personeli Sil'),
                          content: Text("'$name $surname' adlı personeli silmek istediğinizden emin misiniz?"),
                          actions: [
                            TextButton(
                              child: const Text('İptal'),
                              onPressed: () => Navigator.of(dialogContext).pop(),
                            ),
                            ElevatedButton(
                              child: const Text('Sil'),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
                              onPressed: () {
                                context.read<StaffViewModel>().deleteStaff(personalId);
                                Navigator.of(dialogContext).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.red.withOpacity(0.8)),
                    child: const Text('Sil'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditStaffDialog(BuildContext context, Map<String, dynamic>? staff) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _EditStaffDialog(staff: staff);
      },
    );
  }
}

// AYRI STATEFUL WIDGET (TÜM MANTIK BURADA)
class _EditStaffDialog extends StatefulWidget {
  final Map<String, dynamic>? staff;
  const _EditStaffDialog({this.staff});

  @override
  State<_EditStaffDialog> createState() => _EditStaffDialogState();
}

class _EditStaffDialogState extends State<_EditStaffDialog> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController nameController;
  late final TextEditingController surnameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController photoController;
  late final TextEditingController specialtyController;
  late final Map<String, double> selectedServices;

  bool get isNew => widget.staff == null;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    final staff = widget.staff;

    nameController = TextEditingController(text: staff?['name']);
    surnameController = TextEditingController(text: staff?['surname']);
    emailController = TextEditingController(text: staff?['email']);
    phoneController = TextEditingController(text: staff?['phone_number']);
    photoController = TextEditingController(text: staff?['profile_photo_url']);

    dynamic specialtyData = staff?['specialty'];
    String initialSpecialtyText = '';
    if (specialtyData is List) {
      initialSpecialtyText = specialtyData.join(', ');
    } else if (specialtyData is String) {
      initialSpecialtyText = specialtyData.replaceAll(RegExp(r'[{}"\\]'), '');
    }
    specialtyController = TextEditingController(text: initialSpecialtyText);

    selectedServices = {};
    final assignedServices = (staff?['personal_saloon_services'] as List? ?? []);

    for (final s in assignedServices) {
      final serviceMap = s as Map<String, dynamic>?;
      if (serviceMap == null) continue;
      final servicesSubMap = serviceMap['services'] as Map<String, dynamic>?;
      if (servicesSubMap == null || servicesSubMap['service_id'] == null) continue;
      final priceNum = serviceMap['price'] as num?;
      if (priceNum == null) continue;
      final serviceId = servicesSubMap['service_id'] as String;
      selectedServices[serviceId] = priceNum.toDouble();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    photoController.dispose();
    specialtyController.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final viewModel = context.read<StaffViewModel>();
    final authViewModel = context.read<AuthViewModel>();

    final specialtyList = specialtyController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    viewModel.saveStaff(
      admin: authViewModel.currentAdmin!,
      personalId: widget.staff?['personal_id'],
      name: nameController.text,
      surname: surnameController.text,
      email: emailController.text,
      phone: phoneController.text,
      photoUrl: photoController.text,
      selectedServices: selectedServices,
      specialty: specialtyList,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final availableServices = context.read<StaffViewModel>().availableServices;

    return AlertDialog(
      title: Text(isNew ? 'Yeni Personel Ekle' : 'Personeli Düzenle'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(controller: nameController, decoration: const InputDecoration(labelText: 'Adı'), validator: (v) => v!.isEmpty ? 'Boş olamaz' : null),
              TextFormField(controller: surnameController, decoration: const InputDecoration(labelText: 'Soyadı'), validator: (v) => v!.isEmpty ? 'Boş olamaz' : null),
              TextFormField(controller: specialtyController, decoration: const InputDecoration(labelText: 'Uzmanlık Alanları (virgülle ayırın)')),
              TextFormField(controller: emailController, decoration: const InputDecoration(labelText: 'E-posta'), keyboardType: TextInputType.emailAddress),
              TextFormField(controller: phoneController, decoration: const InputDecoration(labelText: 'Telefon'), keyboardType: TextInputType.phone),
              TextFormField(controller: photoController, decoration: const InputDecoration(labelText: 'Fotoğraf URL')),
              const SizedBox(height: 16),
              Text('Verilen Hizmetler:', style: AppTextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: availableServices.map((service) {
                  final serviceMap = service['services'] as Map<String, dynamic>? ?? {};
                  final serviceId = serviceMap['service_id'] as String? ?? '';
                  final serviceName = serviceMap['service_name'] as String? ?? 'Bilinmeyen';
                  final price = (service['price'] as num?)?.toDouble() ?? 0.0;
                  final isSelected = selectedServices.containsKey(serviceId);

                  return FilterChip(
                    label: Text(serviceName),
                    selected: isSelected,
                    onSelected: (bool value) {
                      setState(() {
                        if (value) {
                          selectedServices[serviceId] = price;
                        } else {
                          selectedServices.remove(serviceId);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('İptal')),
        ElevatedButton(onPressed: _onSavePressed, child: const Text('Kaydet')),
      ],
    );
  }
}