// lib/features/dashboard/screens/admin_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/app_border_radius.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_card.dart';
import 'package:project_beauty_admin/design_system/widgets/app_icons.dart'; // Özel ikonlar için
import 'package:project_beauty_admin/design_system/extensions/context_extensions.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_app_bar.dart'; // Admin AppBar'ı import edildi
import 'package:project_beauty_admin/features/shared_admin_components/admin_drawer.dart'; // Admin Drawer import edildi
import 'package:project_beauty_admin/features/shared_admin_components/search_bar_widget.dart'; // SearchBarWidget import edildi
import 'package:project_beauty_admin/features/dashboard/widgets/dashboard_card.dart'; // DashboardCard import edildi
import 'package:project_beauty_admin/features/dashboard/widgets/dashboard_summary_widget.dart'; // DashboardSummaryWidget import edildi

// Modül ekranlarını import et
import 'package:project_beauty_admin/features/appointment_requests/screens/appointment_requests_list_screen.dart';
import 'package:project_beauty_admin/features/staff_management/screens/staff_list_screen.dart';
import 'package:project_beauty_admin/features/service_management/screens/service_list_screen.dart';
// TODO: Diğer modül ekranlarını buraya import etmelisin (örn: customer_reviews_screen.dart, campaigns_screen.dart, statistics_reports_screen.dart)


/// Admin Dashboard Sayfası
/// Yönetici panelinin ana ekranıdır.
/// Figma tasarımındaki ana sayfa görünümüne ve onaylanan istatistik/raporlama önerilerine uygun olarak tasarlanmıştır.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key}); // super.key kullanımı daha modern ve doğrudur

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white, // Arka plan rengi beyaz
      appBar: const AdminAppBar(
        title: 'Ana Sayfa', // AppBar başlığı
      ),
      drawer: const AdminDrawer(), // Sol çekmece menü
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Genel sayfa boşluğu
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Arama Çubuğu (Figma'daki gibi)
            const SearchBarWidget(
              hintText: 'Ara...',
              // onChanged: (query) { /* Arama sorgusu değiştiğinde yapılacaklar */ },
              // onSubmitted: (query) { /* Arama butonu basıldığında yapılacaklar */ },
            ),
            const SizedBox(height: 24.0),

            // Genel Bakış Kartı (Kapsamlı Performans Paneli - Özet)
            CustomCard(
              borderRadius: AppBorderRadius.large, // Büyük yuvarlaklık
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bugünkü Genel Bakış',
                    style: AppTextStyles.headline2.copyWith(color: AppColors.primaryColor),
                  ),
                  const SizedBox(height: 16.0),
                  const Row( // İçindeki widget'lar sabit olduğu için const eklendi
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // DashboardSummaryWidget'ları kullanıldı
                      DashboardSummaryWidget(
                        title: 'Toplam Randevu',
                        value: '25',
                        icon: AppIcons.appointmentRequests, // Randevu ikonu
                      ),
                      DashboardSummaryWidget(
                        title: 'Bugünkü Gelir',
                        value: '₺1.500',
                        icon: Icons.attach_money_outlined, // Para ikonu
                      ),
                      DashboardSummaryWidget(
                        title: 'Yeni Yorumlar',
                        value: '5',
                        icon: AppIcons.customerReviews, // Yorum ikonu
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Modül Navigasyon Kartları (Figma'daki Renkli Kartlar)
            GridView.builder(
              shrinkWrap: true, // İçeriğe göre boyutlan
              physics: const NeverScrollableScrollPhysics(), // Kaydırmayı devre dışı bırak
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Her satırda 2 kart
                crossAxisSpacing: 16.0, // Yatay boşluk
                mainAxisSpacing: 16.0, // Dikey boşluk
                childAspectRatio: 0.9, // Kartların en boy oranı (daha dikey)
              ),
              itemCount: 6, // Toplam 6 modül kartı
              itemBuilder: (context, index) {
                // Her bir kart için veri ve renkler
                // 'screen' değeri olarak doğrudan widget'ları atadık.
                final List<Map<String, dynamic>> moduleData = [
                  {
                    'title': 'Randevu İsteklerim',
                    'icon': AppIcons.appointmentRequests,
                    'metric': '3 Bekleyen',
                    'colors': [const Color(0xFFFEE140), const Color(0xFFFA709A)], // Figma'daki degrade örnekleri
                    'screen': const AppointmentRequestsListScreen(), // Randevu İstekleri ekranı
                  },
                  {
                    'title': 'Personel Takibim',
                    'icon': AppIcons.staffManagement,
                    'metric': '12 Aktif',
                    'colors': [const Color(0xFF6A11CB), const Color(0xFF2575FC)],
                    'screen': const StaffListScreen(), // StaffListScreen zaten import edilmiş. Constructor'ı const ise const ekledik.
                  },
                  {
                    'title': 'Hizmetlerim',
                    'icon': AppIcons.services,
                    'metric': '45 Hizmet',
                    'colors': [const Color(0xFF00C6FB), const Color(0xFF005BEA)],
                    'screen': const ServiceListScreen(), // ServiceListScreen zaten import edilmiş. Constructor'ı const ise const ekledik.
                  },
                  {
                    'title': 'Müşteri Yorumlarım',
                    'icon': AppIcons.customerReviews,
                    'metric': '8 Yeni Yorum',
                    'colors': [const Color(0xFFFF758C), const Color(0xFFFF7EB3)],
                    'screen': null, // TODO: Müşteri Yorumları ekranı oluşturulduğunda buraya atayın
                  },
                  {
                    'title': 'Kampanyalarım',
                    'icon': AppIcons.campaigns,
                    'metric': '5 Aktif',
                    'colors': [const Color(0xFFFAD961), const Color(0xFFF76B1C)],
                    'screen': null, // TODO: Kampanyalarım ekranı oluşturulduğunda buraya atayın
                  },
                  {
                    'title': 'İstatistik ve Raporlar',
                    'icon': AppIcons.statisticsReports,
                    'metric': 'Detaylı Analiz',
                    'colors': [const Color(0xFF2AF598), const Color(0xFF009EFD)],
                    'screen': null, // TODO: İstatistik ve Raporlar ekranı oluşturulduğunda buraya atayın
                  },
                ];

                final data = moduleData[index];

                return DashboardCard( // DashboardCard widget'ı kullanıldı
                  title: data['title'] as String,
                  icon: data['icon'] as IconData,
                  metric: data['metric'] as String,
                  gradientColors: data['colors'] as List<Color>,
                  onTap: () {
                    // print('${data['title']} tıklandı!'); // Bu satırı debug için kullanabilirsiniz
                    if (data['screen'] != null) {
                      // context.push() uzantı metodunu kullanarak yönlendirme
                      context.push(MaterialPageRoute(builder: (context) => data['screen'] as Widget));
                    } else {
                      // Eğer ekran atanmamışsa bir mesaj gösterebilirsiniz
                      if (context.mounted) { // mounted kontrolü iyi bir pratik
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${data['title']} ekranı henüz mevcut değil.'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentRequestsListScreen {
  const AppointmentRequestsListScreen();
}