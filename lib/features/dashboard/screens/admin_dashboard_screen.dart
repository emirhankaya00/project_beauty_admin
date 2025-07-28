// lib/features/dashboard/screens/admin_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/features/campaigns/campaigns_screen.dart';
import 'package:provider/provider.dart'; // DÜZELTME: Provider'ı import ettik
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/app_border_radius.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_card.dart';
import 'package:project_beauty_admin/design_system/widgets/app_icons.dart';
import 'package:project_beauty_admin/design_system/extensions/context_extensions.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_app_bar.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_drawer.dart';
import 'package:project_beauty_admin/features/shared_admin_components/search_bar_widget.dart';
import 'package:project_beauty_admin/features/dashboard/widgets/dashboard_card.dart';
import 'package:project_beauty_admin/features/dashboard/widgets/dashboard_summary_widget.dart';
import 'package:project_beauty_admin/viewmodels/auth_viewmodel.dart'; // DÜZELTME: AuthViewModel'i import ettik

// Mevcut modül ekranları
import 'package:project_beauty_admin/features/appointment_requests/screens/appointment_requests_unified_screen.dart';
import 'package:project_beauty_admin/features/staff_management/screens/staff_unified_screen.dart';
import 'package:project_beauty_admin/features/service_management/screens/service_unified_screen.dart';

// DÜZELTME: Yeni oluşturduğumuz yorumlar ekranını import ediyoruz
// Lütfen dosya yolunun projenizde doğru olduğundan emin olun

import '../../comments/comments_screen.dart';


class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AdminAppBar(
        title: 'Ana Sayfa',
      ),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchBarWidget(
              hintText: 'Ara...',
            ),
            const SizedBox(height: 24.0),

            // ... (Bugünkü Genel Bakış CustomCard'ı aynı kalabilir)

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.9,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                // DÜZELTME: Müşteri Yorumları kartının 'screen' alanı güncellendi.
                // Artık null değil, bir placeholder (yer tutucu) nesne içeriyor.
                final List<Map<String, dynamic>> moduleData = [
                  {
                    'title': 'Randevu İsteklerim',
                    'icon': AppIcons.appointmentRequests,
                    'metric': '3 Bekleyen',
                    'colors': [const Color(0xFFFEE140), const Color(0xFFFA709A)],
                    'screen': const AppointmentRequestsUnifiedScreen(),
                  },
                  {
                    'title': 'Personel Takibim',
                    'icon': AppIcons.staffManagement,
                    'metric': '12 Aktif',
                    'colors': [const Color(0xFF6A11CB), const Color(0xFF2575FC)],
                    'screen': const StaffUnifiedScreen(),
                  },
                  {
                    'title': 'Hizmetlerim',
                    'icon': AppIcons.services,
                    'metric': '45 Hizmet',
                    'colors': [const Color(0xFF00C6FB), const Color(0xFF005BEA)],
                    'screen': const ServiceUnifiedScreen(),
                  },
                  {
                    'title': 'Müşteri Yorumlarım',
                    'icon': AppIcons.customerReviews,
                    'metric': '8 Yeni Yorum',
                    'colors': [const Color(0xFFFF758C), const Color(0xFFFF7EB3)],
                    // Özel işlem gerektirdiği için 'screen' key'ine geçici bir değer veriyoruz.
                    'screen': const SizedBox(),
                  },
                  {
                    'title': 'Kampanyalarım',
                    'icon': AppIcons.campaigns,
                    'metric': '5 Aktif',
                    'colors': [const Color(0xFFFAD961), const Color(0xFFF76B1C)],
                    'screen': const CampaignsScreen(),
                  },
                  {
                    'title': 'İstatistik ve Raporlar',
                    'icon': AppIcons.statisticsReports,
                    'metric': 'Detaylı Analiz',
                    'colors': [const Color(0xFF2AF598), const Color(0xFF009EFD)],
                    'screen': null,
                  },
                ];

                final data = moduleData[index];

                return DashboardCard(
                  title: data['title'] as String,
                  icon: data['icon'] as IconData,
                  metric: data['metric'] as String,
                  gradientColors: data['colors'] as List<Color>,
                  onTap: () {
                    // DÜZELTME: Müşteri Yorumları kartı için özel tıklama mantığı
                    if (data['title'] == 'Müşteri Yorumlarım') {
                      // 1. AuthViewModel'den salon ID'sini al
                      final authViewModel = context.read<AuthViewModel>();
                      final saloonId = authViewModel.currentAdmin?.saloonId;

                      // 2. Salon ID'si varsa, CommentsScreen'e yönlendir
                      if (saloonId != null && saloonId.isNotEmpty) {
                        context.push(MaterialPageRoute(
                          builder: (context) => CommentsScreen(saloonId: saloonId),
                        ));
                      } else {
                        // 3. Salon ID'si yoksa, kullanıcıya bir hata mesajı göster
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Salon bilgisi bulunamadı. Lütfen tekrar giriş yapın.'),
                            backgroundColor: AppColors.red,
                          ),
                        );
                      }
                    }
                    // Diğer kartlar için mevcut mantık devam ediyor
                    else if (data['screen'] != null) {
                      context.push(MaterialPageRoute(builder: (context) => data['screen'] as Widget));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${data['title']} ekranı henüz mevcut değil.'),
                        ),
                      );
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