import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_app_bar.dart';
import 'package:project_beauty_admin/viewmodels/auth_viewmodel.dart';
import 'package:project_beauty_admin/viewmodels/service_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../data/models/service_model.dart';

class ServiceUnifiedScreen extends StatefulWidget {
  const ServiceUnifiedScreen({super.key});

  @override
  State<ServiceUnifiedScreen> createState() => _ServiceUnifiedScreenState();
}

class _ServiceUnifiedScreenState extends State<ServiceUnifiedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = context.read<AuthViewModel>();
      if (authViewModel.currentAdmin != null) {
        context.read<ServiceViewModel>().fetchServices(authViewModel.currentAdmin!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ServiceViewModel>();
    return Scaffold(
      appBar: const AdminAppBar(title: 'Hizmet Yönetimi'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hizmet Listesi', style: AppTextStyles.headline3.copyWith(color: AppColors.primaryColor)),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) => viewModel.search(value),
              decoration: const InputDecoration(hintText: 'Hizmet Ara...'),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildBody(viewModel)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditServiceDialog(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(ServiceViewModel viewModel) {
    if (viewModel.isLoading && viewModel.filteredServices.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null) {
      return Center(child: Text('Hata: ${viewModel.errorMessage}'));
    }
    if (viewModel.filteredServices.isEmpty) {
      return const Center(child: Text('Hiç hizmet bulunamadı.'));
    }
    return ListView.builder(
      itemCount: viewModel.filteredServices.length,
      itemBuilder: (context, index) {
        final serviceData = viewModel.filteredServices[index];
        return _buildServiceCard(context, serviceData);
      },
    );
  }

  Widget _buildServiceCard(BuildContext context, Map<String, dynamic> serviceData) {
    final saloonServiceId = serviceData['id'] as String? ?? '';
    final serviceInfo = serviceData['services'] as Map<String, dynamic>? ?? {};
    final serviceId = serviceInfo['service_id'] as String? ?? '';
    final serviceName = serviceInfo['service_name'] as String? ?? 'İsimsiz Servis';
    final price = (serviceData['price'] as num?)?.toDouble() ?? 0.0;
    final isActive = serviceData['is_active'] as bool? ?? false;
    final description = serviceInfo['description'] as String?;
    final estimatedTime = ServiceModel.parseDuration(serviceInfo['estimated_time'] as String? ?? '00:00:00');

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(serviceName, style: AppTextStyles.headline3),
            Text('${price.toStringAsFixed(2)} TL'),
            Text('Süre: ${estimatedTime.inMinutes} dk'),
            if (description != null && description.isNotEmpty) Text(description),
            Text(isActive ? 'Aktif' : 'Pasif', style: TextStyle(color: isActive ? Colors.green : Colors.red)),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () => _showEditServiceDialog(context, serviceData),
                    child: const Text('Düzenle'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Silme onayı için AlertDialog göster
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Hizmeti Sil'),
                          content: Text("'$serviceName' adlı hizmeti silmek istediğinizden emin misiniz? Bu işlem, bu hizmeti veren tüm personellerden de kaldırılacaktır."),
                          actions: [
                            TextButton(
                              child: const Text('İptal'),
                              onPressed: () => Navigator.of(dialogContext).pop(),
                            ),
                            ElevatedButton(
                              child: const Text('Sil'),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
                              onPressed: () {
                                context.read<ServiceViewModel>().deleteService(saloonServiceId, serviceId);
                                Navigator.of(dialogContext).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
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

  Future<void> _showEditServiceDialog(BuildContext context, Map<String, dynamic>? serviceData) async {
    final bool isNewService = serviceData == null;
    final serviceInfo = serviceData?['services'] as Map<String, dynamic>? ?? {};

    final nameController = TextEditingController(text: serviceInfo['service_name']);
    final priceController = TextEditingController(text: (serviceData?['price'] as num?)?.toStringAsFixed(2) ?? '');
    final durationController = TextEditingController(text: ServiceModel.parseDuration(serviceInfo['estimated_time'] ?? '00:00:00').inMinutes.toString());
    final descriptionController = TextEditingController(text: serviceInfo['description']);
    bool isActive = serviceData?['is_active'] as bool? ?? true;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setInnerState) {
            return AlertDialog(
              title: Text(isNewService ? 'Yeni Hizmet Ekle' : 'Hizmeti Düzenle'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Hizmet Adı')),
                    TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Fiyat (TL)'), keyboardType: TextInputType.number),
                    TextField(controller: durationController, decoration: const InputDecoration(labelText: 'Süre (Dakika)'), keyboardType: TextInputType.number),
                    TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Açıklama'), maxLines: 3),
                    SwitchListTile(
                      title: const Text('Aktif'),
                      value: isActive,
                      onChanged: (bool value) => setInnerState(() => isActive = value),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('İptal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final authViewModel = context.read<AuthViewModel>();
                    final serviceViewModel = context.read<ServiceViewModel>();

                    final name = nameController.text;
                    final price = double.tryParse(priceController.text);
                    final duration = int.tryParse(durationController.text);

                    if (name.isEmpty || price == null || duration == null) {
                      return;
                    }

                    serviceViewModel.saveService(
                      admin: authViewModel.currentAdmin!,
                      saloonServiceId: serviceData?['id'],
                      serviceId: serviceInfo['service_id'],
                      name: name,
                      price: price,
                      duration: Duration(minutes: duration),
                      description: descriptionController.text,
                      isActive: isActive,
                    );

                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Kaydet'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}