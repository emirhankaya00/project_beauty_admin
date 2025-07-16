// lib/features/service_management/screens/service_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/extensions/context_extensions.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_app_bar.dart';
import 'package:project_beauty_admin/data/models/service_model.dart'; // IMPORT YOLU DÜZELTİLDİ: service_models.dart
import 'package:project_beauty_admin/design_system/app_border_radius.dart';

class ServiceDetailScreen extends StatelessWidget {
  final ServiceItem service;

  const ServiceDetailScreen({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AdminAppBar(
        title: service.name,
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
            // Hizmet Görseli
            if (service.imageUrl != null)
              Center(
                child: ClipRRect(
                  borderRadius: AppBorderRadius.medium,
                  child: Image.network(
                    service.imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Center(
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: AppBorderRadius.medium,
                  ),
                  child: Icon(Icons.palette, color: AppColors.darkGrey, size: 80),
                ),
              ),
            const SizedBox(height: 24.0),

            Text(
              service.name,
              style: AppTextStyles.headline1.copyWith(color: AppColors.black),
            ),
            Text(
              service.category,
              style: AppTextStyles.headline3.copyWith(color: AppColors.darkGrey),
            ),
            const SizedBox(height: 16.0),
            Divider(color: AppColors.lightGrey),
            const SizedBox(height: 16.0),

            Text(
              'Fiyat:',
              style: AppTextStyles.headline3.copyWith(color: AppColors.black),
            ),
            const SizedBox(height: 8.0),
            Text(
              '₺${service.price.toStringAsFixed(2)}',
              style: AppTextStyles.bodyText1.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Ortalama Süre:',
              style: AppTextStyles.headline3.copyWith(color: AppColors.black),
            ),
            const SizedBox(height: 8.0),
            Text(
              service.duration,
              style: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey),
            ),
            if (service.description != null && service.description!.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              Divider(color: AppColors.lightGrey),
              const SizedBox(height: 16.0),
              Text(
                'Açıklama:',
                style: AppTextStyles.headline3.copyWith(color: AppColors.black),
              ),
              const SizedBox(height: 8.0),
              Text(
                service.description!,
                style: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey),
              ),
            ],
            const SizedBox(height: 16.0),
            Divider(color: AppColors.lightGrey),
            const SizedBox(height: 16.0),
            Text(
              'Durum:',
              style: AppTextStyles.headline3.copyWith(color: AppColors.black),
            ),
            const SizedBox(height: 8.0),
            Text(
              service.isActive ? 'Aktif' : 'Pasif',
              style: AppTextStyles.bodyText1.copyWith(
                color: service.isActive ? AppColors.green : AppColors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}