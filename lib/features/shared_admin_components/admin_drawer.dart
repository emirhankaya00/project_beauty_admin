// lib/features/shared_admin_components/admin_drawer.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/widgets/app_icons.dart'; // İkonlar için
import 'package:project_beauty_admin/design_system/extensions/context_extensions.dart'; // Navigasyon için

/// Admin Paneli için özelleştirilmiş çekmece menü (Drawer) widget'ı.
/// Admin panelinin ana başlıklarına navigasyon sağlar.
class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white, // Drawer arka plan rengi
      child: ListView(
        padding: EdgeInsets.zero, // Varsayılan padding'i kaldır
        children: <Widget>[
          // Drawer Başlığı / Kullanıcı Bilgisi Alanı
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primaryColor, // Ana tema renginde başlık
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Kullanıcı avatarı/ikona
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.white,
                  child: Icon(Icons.person, size: 40, color: AppColors.primaryColor),
                ),
                const SizedBox(height: 8),
                // Kullanıcı Adı
                Text(
                  'Yönetici Adı Soyadı', // TODO: Dinamik olarak kullanıcı adı çekilecek
                  style: AppTextStyles.headline3.copyWith(color: AppColors.white),
                ),
                // Kullanıcı Rolü
                Text(
                  'Güzellik Salonu Yöneticisi', // TODO: Dinamik olarak rol çekilecek
                  style: AppTextStyles.bodyText2.copyWith(color: AppColors.white.withAlpha(5)),
                ),
              ],
            ),
          ),

          // Menü Öğeleri
          _buildDrawerItem(
            context,
            icon: AppIcons.home, // Ana Sayfa ikonu
            title: 'Ana Sayfa',
            onTap: () {
              context.pop(); // Drawer'ı kapat
              // TODO: Dashboard sayfasına yönlendir (eğer zaten değilse)
              // context.pushReplacement(MaterialPageRoute(builder: (context) => const AdminDashboardScreen()));
            },
          ),
          _buildDrawerItem(
            context,
            icon: AppIcons.appointmentRequests, // Randevu İstekleri ikonu
            title: 'Randevu İsteklerim',
            onTap: () {
              context.pop(); // Drawer'ı kapat
              // TODO: Randevu İstekleri sayfasına yönlendir
              // context.push(MaterialPageRoute(builder: (context) => const AppointmentRequestsListScreen()));
            },
          ),
          _buildDrawerItem(
            context,
            icon: AppIcons.staffManagement, // Personel Takibi ikonu
            title: 'Personel Takibim',
            onTap: () {
              context.pop(); // Drawer'ı kapat
              // TODO: Personel Takibi sayfasına yönlendir
              // context.push(MaterialPageRoute(builder: (context) => const StaffListScreen()));
            },
          ),
          _buildDrawerItem(
            context,
            icon: AppIcons.services, // Hizmetlerim ikonu
            title: 'Hizmetlerim',
            onTap: () {
              context.pop(); // Drawer'ı kapat
              // TODO: Hizmetlerim sayfasına yönlendir
              // context.push(MaterialPageRoute(builder: (context) => const ServiceListScreen()));
            },
          ),
          _buildDrawerItem(
            context,
            icon: AppIcons.customerReviews, // Müşteri Yorumlarım ikonu
            title: 'Müşteri Yorumlarım',
            onTap: () {
              context.pop(); // Drawer'ı kapat
              // TODO: Müşteri Yorumları sayfasına yönlendir
              // context.push(MaterialPageRoute(builder: (context) => const ReviewListScreen()));
            },
          ),
          _buildDrawerItem(
            context,
            icon: AppIcons.campaigns, // Kampanyalarım ikonu
            title: 'Kampanyalarım',
            onTap: () {
              context.pop(); // Drawer'ı kapat
              // TODO: Kampanyalarım sayfasına yönlendir
              // context.push(MaterialPageRoute(builder: (context) => const CampaignListScreen()));
            },
          ),
          _buildDrawerItem(
            context,
            icon: AppIcons.statisticsReports, // İstatistik ve Raporlarım ikonu
            title: 'İstatistik ve Raporlarım',
            onTap: () {
              context.pop(); // Drawer'ı kapat
              // TODO: İstatistik ve Raporlar sayfasına yönlendir
              // context.push(MaterialPageRoute(builder: (context) => const StatisticsDashboardScreen()));
            },
          ),
          const Divider(), // Menü öğeleri arasına ayırıcı
          _buildDrawerItem(
            context,
            icon: AppIcons.settings, // Ayarlar ikonu
            title: 'Ayarlar',
            onTap: () {
              context.pop(); // Drawer'ı kapat
              // TODO: Ayarlar sayfasına yönlendir
              debugPrint('Ayarlar tıklandı');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.logout, // Çıkış ikonu
            title: 'Çıkış Yap',
            onTap: () {
              context.pop(); // Drawer'ı kapat
              // TODO: Çıkış yapma işlemi ve giriş sayfasına yönlendirme
              debugPrint('Çıkış Yap tıklandı');
            },
          ),
        ],
      ),
    );
  }

  /// Drawer menü öğeleri için yardımcı widget.
  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor), // İkon rengi ana tema rengi
      title: Text(title, style: AppTextStyles.bodyText1.copyWith(color: AppColors.black)), // Metin stili
      onTap: onTap,
    );
  }
}
