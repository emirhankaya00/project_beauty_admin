// lib/features/service_management/widgets/service_list_item.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/app_border_radius.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_card.dart';
import 'package:project_beauty_admin/data/models/service_model.dart'; // IMPORT YOLU DÜZELTİLDİ: service_models.dart

class ServiceListItem extends StatelessWidget {
  final ServiceItem service;
  final VoidCallback onTap;

  const ServiceListItem({
    Key? key,
    required this.service,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard.small(
      onTap: onTap,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Hizmet Görseli (varsa) veya Placeholder
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: AppBorderRadius.medium,
              image: service.imageUrl != null
                  ? DecorationImage(
                image: NetworkImage(service.imageUrl!),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: service.imageUrl == null
                ? Icon(Icons.palette, color: AppColors.darkGrey, size: 30)
                : null,
          ),
          const SizedBox(width: 16.0),

          // Hizmet Bilgileri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: AppTextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  '${service.category} • ${service.duration}',
                  style: AppTextStyles.bodyText2.copyWith(color: AppColors.darkGrey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  '₺${service.price.toStringAsFixed(2)}',
                  style: AppTextStyles.bodyText1.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16.0),

          // Sağda Ok İkonu
          Icon(Icons.arrow_forward_ios, color: AppColors.grey, size: 18),
        ],
      ),
    );
  }
}