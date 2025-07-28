// lib/features/salons/my_salon_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_beauty_admin/viewmodels/auth_viewmodel.dart';
import 'package:project_beauty_admin/viewmodels/saloon_viewmodel.dart';
import 'package:project_beauty_admin/data/models/saloon_model.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
class MySalonScreen extends StatefulWidget {
  const MySalonScreen({Key? key}) : super(key: key);

  @override
  State<MySalonScreen> createState() => _MySalonScreenState();
}

class _MySalonScreenState extends State<MySalonScreen> {
  final _nameCtrl  = TextEditingController();
  final _descCtrl  = TextEditingController();
  final _addrCtrl  = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _photoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Sayfa yüklendikten sonra çalışsın:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authVm = context.read<AuthViewModel>();
      final saloonId = authVm.currentAdmin?.saloonId;
      if (saloonId == null) {
        // Eğer admin ya da salonId null ise hata gösterip çıkabilirsiniz:
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Salon bilgisi alınamadı.'))
        );
        Navigator.of(context).pop();
        return;
      }

      // Yükleme çağrısı:
      context.read<SaloonViewModel>().loadSalon(saloonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SaloonViewModel>(
      builder: (context, vm, _) {
        // 1) Yükleniyorsa:
        if (vm.state == SaloonState.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2) Hata varsa:
        if (vm.state == SaloonState.error || vm.saloon == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Salonum')),
            body: Center(child: Text('Hata: ${vm.errorMessage ?? "Bilinmeyen"}')),
          );
        }

        // 3) Başarıyla yüklendiyse formu doldur:
        final s = vm.saloon!;
        _nameCtrl.text  = s.saloonName;
        _descCtrl.text  = s.saloonDescription ?? '';
        _addrCtrl.text  = s.saloonAddress ?? '';
        _phoneCtrl.text = s.phoneNumber ?? '';
        _emailCtrl.text = s.email ?? '';
        _photoCtrl.text = s.titlePhotoUrl ?? '';

        return Scaffold(
          appBar: AppBar(title: const Text('Salonum')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text('Salon Bilgilerim', style: AppTextStyles.headline3.copyWith(color: AppColors.primaryColor)),
                const SizedBox(height: 12),
                TextField(controller: _nameCtrl,  decoration: const InputDecoration(labelText: 'Başlık')),
                const SizedBox(height: 8),
                TextField(controller: _descCtrl,  decoration: const InputDecoration(labelText: 'Açıklama')),
                const SizedBox(height: 8),
                TextField(controller: _addrCtrl,  decoration: const InputDecoration(labelText: 'Adres')),
                const SizedBox(height: 8),
                TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Telefon')),
                const SizedBox(height: 8),
                TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'E‑posta')),
                const SizedBox(height: 8),
                TextField(controller: _photoCtrl, decoration: const InputDecoration(labelText: 'Foto URL')),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Kaydet'),
                  onPressed: () async {
                    // Oluşturduğunuz SaloonModel'e göre alan isimlerini
                    // ve yapısını kontrol edin:
                    final updated = s.copyWith(
                      saloonName: _nameCtrl.text.trim(),
                      saloonDescription: _descCtrl.text.trim(),
                      saloonAddress: _addrCtrl.text.trim(),
                      phoneNumber: _phoneCtrl.text.trim(),
                      email: _emailCtrl.text.trim(),
                      titlePhotoUrl: _photoCtrl.text.trim(),
                    );
                    final ok = await vm.saveSalon(updated);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(ok ? 'Güncellendi' : 'Hata: ${vm.errorMessage}')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
