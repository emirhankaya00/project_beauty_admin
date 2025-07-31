import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/features/appointment_requests/screens/appointment_requests_unified_screen.dart';
import 'package:project_beauty_admin/features/staff_management/screens/staff_unified_screen.dart';
import 'package:project_beauty_admin/features/service_management/screens/service_unified_screen.dart';
import 'package:project_beauty_admin/features/comments/comments_screen.dart';
import 'package:project_beauty_admin/features/salons/my_salon_screen.dart';
import 'package:project_beauty_admin/features/campaigns/campaigns_screen.dart';
import 'package:project_beauty_admin/features/stats/stats_screen.dart';
import 'package:project_beauty_admin/viewmodels/auth_viewmodel.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authVm = context.read<AuthViewModel>();
    final saloonId = authVm.currentAdmin?.saloonId ?? '';
    final userName = authVm.currentAdmin?.username ?? 'Misafir Kullanıcı';

    final modules = [
      {
        'title': 'Randevu İsteklerim',
        'icon': Icons.calendar_today_outlined,
        'metric': '3 Bekleyen',
        'background': AppColors.lightBlue,
        'screen': const AppointmentRequestsUnifiedScreen(),
      },
      {
        'title': 'Personel Takibim',
        'icon': Icons.group_outlined,
        'metric': '12 Aktif',
        'background': AppColors.lightGreen,
        'screen': const StaffUnifiedScreen(),
      },
      {
        'title': 'Hizmetlerim',
        'icon': Icons.star_border_outlined,
        'metric': '45 Hizmet',
        'background': AppColors.lightPink,
        'screen': const ServiceUnifiedScreen(),
      },
      {
        'title': 'Müşteri Yorumlarım',
        'icon': Icons.star_outline,
        'metric': '8 Yeni Yorum',
        'background': AppColors.lightYellow,
        'screen': null,
      },
      {
        'title': 'Kampanyalar',
        'icon': Icons.local_offer_outlined,
        'metric': '3 Bekleyen',
        'background': AppColors.lightCyan,
        'screen': const CampaignsScreen(),
      },
      {
        'title': 'İstatistik ve Raporlar',
        'icon': Icons.bar_chart_outlined,
        'metric': 'Detaylı Analiz',
        'background': AppColors.lightCoral,
        'screen': const StatsScreen(),
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: AppColors.primaryColor),
              accountName: Text(userName, style: AppTextStyles.headline3.copyWith(color: Colors.white)),
              accountEmail: Text(authVm.currentAdmin?.email ?? '', style: AppTextStyles.bodyText2.copyWith(color: Colors.white70)),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: AppColors.primaryColor),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Ana Sayfa'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                // TODO: Profil ekranına geçiş
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'),
              onTap: () {
                // TODO: Ayarlar ekranına geçiş
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Çıkış Yap'),
              onTap: () {
                // TODO: Çıkış işlemi
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                  Expanded(
                    child: Text(
                      userName,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headline2.copyWith(color: Colors.black),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white, size: 24),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Ara...',
                  prefixIcon: const Icon(Icons.search, color: Colors.black54, size: 24),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            const SizedBox(height: 24),
            // Content cards
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Big Salonum card
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const MySalonScreen()),
                        );
                      },
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Salonum',
                                  style: AppTextStyles.headline3.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Image.asset(
                                'assets/logos/iris_primary_logo.png',
                                width: 48,
                                height: 48,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Grid of modules
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: modules.length,
                      itemBuilder: (context, index) {
                        final module = modules[index];
                        return GestureDetector(
                          onTap: () {
                            final title = module['title'];
                            final screen = module['screen'];
                            if (title == 'Müşteri Yorumlarım') {
                              if (saloonId.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CommentsScreen(saloonId: saloonId),
                                  ),
                                );
                              }
                            } else if (screen != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => screen as Widget),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: module['background'] as Color,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Stack(
                              children: [
                                // Icon top-right
                                Positioned(
                                  top: 16,
                                  right: 16,
                                  child: Icon(
                                    module['icon'] as IconData,
                                    size: 36,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                // Text bottom-left
                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        module['title'] as String,
                                        style: AppTextStyles.headline3.copyWith(color: Colors.black),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        module['metric'] as String,
                                        style: AppTextStyles.bodyText1.copyWith(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
