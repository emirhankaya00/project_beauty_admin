// lib/features/staff_management/screens/staff_list_screen.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/extensions/context_extensions.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_app_bar.dart';
import 'package:project_beauty_admin/features/shared_admin_components/search_bar_widget.dart';
import 'package:project_beauty_admin/data/models/staff_member.dart';
import 'package:project_beauty_admin/features/staff_management/widgets/staff_list_item.dart'; // YOL DÜZELTİLDİ
import 'package:project_beauty_admin/features/staff_management/screens/staff_detail_screen.dart'; // YOL DÜZELTİLDİ

class StaffListScreen extends StatefulWidget {
  const StaffListScreen({Key? key}) : super(key: key);

  @override
  State<StaffListScreen> createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  final List<StaffMember> _allStaffMembers = [
    StaffMember(
      id: 's001',
      name: 'Ayşe Yılmaz',
      title: 'Kuaför',
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png', // Örnek URL
      phoneNumber: '555 111 2233',
      email: 'ayse.yilmaz@example.com',
      specialization: 'Saç Kesimi, Boyama',
      workingDays: ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma'],
      bio: '10 yıllık deneyimli saç tasarım uzmanı.',
    ),
    StaffMember(
      id: 's002',
      name: 'Fatma Demir',
      title: 'Estetisyen',
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png', // Örnek URL
      phoneNumber: '555 444 5566',
      email: 'fatma.demir@example.com',
      specialization: 'Cilt Bakımı, Lazer Epilasyon',
      workingDays: ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi'],
      bio: 'Cilt sağlığı ve güzelliği konusunda uzmandır.',
    ),
    StaffMember(
      id: 's003',
      name: 'Mehmet Kaya',
      title: 'Masör',
      imageUrl: null, // Fotoğraf yok
      phoneNumber: '555 777 8899',
      email: 'mehmet.kaya@example.com',
      specialization: 'Derin Doku Masajı, Aromaterapi',
      workingDays: ['Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'],
      bio: 'Rahatlatıcı ve tedavi edici masaj teknikleri.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AdminAppBar(
        title: 'Personellerim',
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Theme.of(context).appBarTheme.foregroundColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchBarWidget(
              hintText: 'Personel ara...',
            ),
            const SizedBox(height: 16.0),
            Text(
              'Tüm Personeller (${_allStaffMembers.length})',
              style: AppTextStyles.headline3.copyWith(color: AppColors.black),
            ),
            const SizedBox(height: 12.0),
            // Personel listesi
            if (_allStaffMembers.isNotEmpty)
              Column(
                children: _allStaffMembers.map((staff) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: StaffListItem(
                      staffMember: staff,
                      onTap: () {
                        context.push(MaterialPageRoute(
                          builder: (context) => StaffDetailScreen(staffMember: staff),
                        ));
                      },
                    ),
                  );
                }).toList(),
              )
            else
              Text(
                'Henüz personel bulunmamaktadır.',
                style: AppTextStyles.bodyText1.copyWith(color: AppColors.grey),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Yeni personel ekleme sayfasına yönlendirme
          context.showSnackBar('Yeni personel ekle!');
        },
        backgroundColor: AppColors.primaryColor,
        child: Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}