// lib/features/dashboard/widgets/dashboard_card.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_border_radius.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';

/// Admin Dashboard'da kullanılan modül navigasyon kartı widget'ı.
/// Figma tasarımındaki renkli, degrade arka planlı kartlara uygun olarak tasarlanmıştır.
class DashboardCard extends StatelessWidget {
  final String title; // Kartın başlığı (modül adı)
  final IconData icon; // Kartın ikonu
  final String metric; // Kartın altında gösterilen metrik (örn. "3 Bekleyen")
  final List<Color> gradientColors; // Kartın arka plan degrade renkleri
  final VoidCallback? onTap; // Karta tıklandığında çalışacak fonksiyon

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.metric,
    required this.gradientColors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppBorderRadius.large, // Figma'daki gibi büyük yuvarlaklık
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.3), // Daha belirgin gölge
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent, // Degradeyi göstermek için şeffaf
        borderRadius: AppBorderRadius.large,
        child: InkWell(
          borderRadius: AppBorderRadius.large,
          onTap: onTap, // Tıklama aksiyonu
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    icon,
                    color: AppColors.white.withValues(alpha: 0.8), // İkon rengi beyaz
                    size: 48.0, // Daha büyük ikon
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.headline3.copyWith(color: AppColors.white),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      metric,
                      style: AppTextStyles.bodyText1.copyWith(color: AppColors.white.withValues(alpha: 0.9)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
