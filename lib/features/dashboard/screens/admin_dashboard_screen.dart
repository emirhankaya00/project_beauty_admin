// lib/features/dashboard/screens/admin_dashboard_screen.dart

import 'package:flutter/material.dart';
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

// Yeni oluşturduğumuz tek sayfa modül ekranlarını import et
import 'package:project_beauty_admin/features/appointment_requests/screens/appointment_requests_unified_screen.dart'; // Güncellendi
import 'package:project_beauty_admin/features/staff_management/screens/staff_unified_screen.dart'; // Güncellendi
import 'package:project_beauty_admin/features/service_management/screens/service_unified_screen.dart'; // Güncellendi

// TODO: Diğer modül ekranlarını buraya import etmelisin (örn: customer_reviews_screen.dart, campaigns_screen.dart, statistics_reports_screen.dart)

/// Admin Dashboard Sayfası
/// Yönetici panelinin ana ekranıdır.
/// Figma tasarımındaki ana sayfa görünümüne ve onaylanan istatistik/raporlama önerilerine uygun olarak tasarlanmıştır.
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

            CustomCard(
              borderRadius: AppBorderRadius.large,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bugünkü Genel Bakış',
                    style: AppTextStyles.headline2.copyWith(color: AppColors.primaryColor),
                  ),
                  const SizedBox(height: 16.0),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DashboardSummaryWidget(
                        title: 'Toplam Randevu',
                        value: '25',
                        icon: AppIcons.appointmentRequests,
                      ),
                      DashboardSummaryWidget(
                        title: 'Bugünkü Gelir',
                        value: '₺1.500',
                        icon: Icons.attach_money_outlined,
                      ),
                      DashboardSummaryWidget(
                        title: 'Yeni Yorumlar',
                        value: '5',
                        icon: AppIcons.customerReviews,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

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
                final List<Map<String, dynamic>> moduleData = [
                  {
                    'title': 'Randevu İsteklerim',
                    'icon': AppIcons.appointmentRequests,
                    'metric': '3 Bekleyen',
                    'colors': [const Color(0xFFFEE140), const Color(0xFFFA709A)],
                    'screen': const AppointmentRequestsUnifiedScreen(), // Güncellendi
                  },
                  {
                    'title': 'Personel Takibim',
                    'icon': AppIcons.staffManagement,
                    'metric': '12 Aktif',
                    'colors': [const Color(0xFF6A11CB), const Color(0xFF2575FC)],
                    'screen': const StaffUnifiedScreen(), // Güncellendi
                  },
                  {
                    'title': 'Hizmetlerim',
                    'icon': AppIcons.services,
                    'metric': '45 Hizmet',
                    'colors': [const Color(0xFF00C6FB), const Color(0xFF005BEA)],
                    'screen': const ServiceUnifiedScreen(), // Güncellendi
                  },
                  {
                    'title': 'Müşteri Yorumlarım',
                    'icon': AppIcons.customerReviews,
                    'metric': '8 Yeni Yorum',
                    'colors': [const Color(0xFFFF758C), const Color(0xFFFF7EB3)],
                    'screen': null,
                  },
                  {
                    'title': 'Kampanyalarım',
                    'icon': AppIcons.campaigns,
                    'metric': '5 Aktif',
                    'colors': [const Color(0xFFFAD961), const Color(0xFFF76B1C)],
                    'screen': null,
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
                    if (data['screen'] != null) {
                      context.push(MaterialPageRoute(builder: (context) => data['screen'] as Widget));
                    } else {
                      if (context.mounted) {
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