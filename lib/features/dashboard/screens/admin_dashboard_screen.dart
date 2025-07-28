// lib/features/dashboard/salons/admin_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_beauty_admin/features/appointment_requests/screens/appointment_requests_unified_screen.dart';
import 'package:project_beauty_admin/features/staff_management/screens/staff_unified_screen.dart';
import 'package:project_beauty_admin/features/service_management/screens/service_unified_screen.dart';
import 'package:project_beauty_admin/features/comments/comments_screen.dart';
import 'package:project_beauty_admin/features/salons/my_salon_screen.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_app_bar.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_drawer.dart';
import 'package:project_beauty_admin/features/shared_admin_components/search_bar_widget.dart';
import 'package:project_beauty_admin/features/dashboard/widgets/dashboard_card.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/widgets/app_icons.dart';
import 'package:project_beauty_admin/viewmodels/auth_viewmodel.dart';
import '../../campaigns/campaigns_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authVm = context.read<AuthViewModel>();
    final saloonId = authVm.currentAdmin?.saloonId;

    final modules = <Map<String, dynamic>>[
      {
        'title': 'Randevu İsteklerim',
        'icon': AppIcons.appointmentRequests,
        'metric': '3 Bekleyen',
        'colors': [Color(0xFFFEE140), Color(0xFFFA709A)],
        'screen': const AppointmentRequestsUnifiedScreen(),
      },
      {
        'title': 'Personel Takibim',
        'icon': AppIcons.staffManagement,
        'metric': '12 Aktif',
        'colors': [Color(0xFF6A11CB), Color(0xFF2575FC)],
        'screen': const StaffUnifiedScreen(),
      },
      {
        'title': 'Hizmetlerim',
        'icon': AppIcons.services,
        'metric': '45 Hizmet',
        'colors': [Color(0xFF00C6FB), Color(0xFF005BEA)],
        'screen': const ServiceUnifiedScreen(),
      },
      {
        'title': 'Müşteri Yorumlarım',
        'icon': AppIcons.customerReviews,
        'metric': '8 Yeni Yorum',
        'colors': [Color(0xFFFF758C), Color(0xFFFF7EB3)],
        'screen': null,
      },
      {
        'title': 'Salonum',
        'icon': AppIcons.search,
        'metric': 'Bilgilerim',
        'colors': [Color(0xFF00B894), Color(0xFF55E6C1)],
        'screen': const MySalonScreen(),
      },
      {
        'title': 'Kampanyalarım',
        'icon': AppIcons.campaigns,
        'metric': '5 Aktif',
        'colors': [Color(0xFFFAD961), Color(0xFFF76B1C)],
        'screen': const CampaignsScreen(),
      },
      {
        'title': 'İstatistik ve Raporlar',
        'icon': AppIcons.statisticsReports,
        'metric': 'Detaylı Analiz',
        'colors': [Color(0xFF2AF598), Color(0xFF009EFD)],
        'screen': null,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AdminAppBar(title: 'Ana Sayfa'),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchBarWidget(hintText: 'Ara...'),
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
              itemCount: modules.length,
              itemBuilder: (context, index) {
                final data = modules[index];
                return DashboardCard(
                  title: data['title'] as String,
                  icon: data['icon'] as IconData,
                  metric: data['metric'] as String,
                  gradientColors: data['colors'] as List<Color>,
                  onTap: () {
                    final title = data['title'] as String;
                    if (title == 'Müşteri Yorumlarım') {
                      if (saloonId != null && saloonId.isNotEmpty) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CommentsScreen(saloonId: saloonId),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Salon bilgisi bulunamadı.'),
                            backgroundColor: AppColors.red,
                          ),
                        );
                      }
                    } else if (data['screen'] != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => data['screen'] as Widget),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${data['title']} ekranı henüz mevcut değil.')),
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
