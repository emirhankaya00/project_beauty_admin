// lib/features/service_management/screens/service_list_screen.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/extensions/context_extensions.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_app_bar.dart';
import 'package:project_beauty_admin/features/shared_admin_components/search_bar_widget.dart';
import 'package:project_beauty_admin/data/models/service_model.dart'; // IMPORT YOLU DÜZELTİLDİ: service_models.dart
import 'package:project_beauty_admin/features/service_management/widgets/service_list_item.dart';
import 'package:project_beauty_admin/features/service_management/screens/service_detail_screen.dart';


class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({Key? key}) : super(key: key);

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  final List<ServiceItem> _allServices = [
    ServiceItem(
      id: 'h001',
      name: 'Kadın Saç Kesimi',
      category: 'Saç Bakımı',
      price: 250.00,
      duration: '60 dk',
      description: 'Modern ve klasik kadın saç kesimi teknikleri.',
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/2932/2932264.png',
      isActive: true,
    ),
    ServiceItem(
      id: 'h002',
      name: 'Manikür & Pedikür',
      category: 'El & Ayak Bakımı',
      price: 180.00,
      duration: '90 dk',
      description: 'Detaylı el ve ayak bakımı hizmeti.',
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/3673/3673894.png',
      isActive: true,
    ),
    ServiceItem(
      id: 'h003',
      name: 'Cilt Bakımı',
      category: 'Cilt & Vücut',
      price: 350.00,
      duration: '75 dk',
      description: 'Cildin ihtiyaçlarına göre kişiselleştirilmiş cilt bakımı.',
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/4117/4117466.png',
      isActive: true,
    ),
    ServiceItem(
      id: 'h004',
      name: 'Kaş Tasarımı',
      category: 'Makyaj & Kaş',
      price: 80.00,
      duration: '30 dk',
      description: 'Yüze en uygun kaş şekillendirme.',
      imageUrl: null,
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AdminAppBar(
        title: 'Hizmetlerim',
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
              hintText: 'Hizmet ara...',
            ),
            const SizedBox(height: 16.0),
            Text(
              'Tüm Hizmetler (${_allServices.length})',
              style: AppTextStyles.headline3.copyWith(color: AppColors.black),
            ),
            const SizedBox(height: 12.0),
            // Hizmet listesi
            if (_allServices.isNotEmpty)
              Column(
                children: _allServices.map((service) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ServiceListItem(
                      service: service,
                      onTap: () {
                        context.push(MaterialPageRoute(
                          builder: (context) => ServiceDetailScreen(service: service),
                        ));
                      },
                    ),
                  );
                }).toList(),
              )
            else
              Text(
                'Henüz hizmet bulunmamaktadır.',
                style: AppTextStyles.bodyText1.copyWith(color: AppColors.grey),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Yeni hizmet ekleme sayfasına yönlendirme
          context.showSnackBar('Yeni hizmet ekle!');
        },
        backgroundColor: AppColors.primaryColor,
        child: Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}