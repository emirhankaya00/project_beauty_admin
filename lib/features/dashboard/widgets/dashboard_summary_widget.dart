// lib/features/dashboard/widgets/dashboard_summary_widget.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';

/// Admin Dashboard'daki "Bugünkü Genel Bakış" kartı içinde kullanılan
/// özet bilgi öğesini temsil eden widget.
class DashboardSummaryWidget extends StatelessWidget {
  final String title; // Özet öğesinin başlığı (örn. "Toplam Randevu")
  final String value; // Özet öğesinin değeri (örn. "25")
  final IconData icon; // Özet öğesinin ikonu

  const DashboardSummaryWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 36.0, color: AppColors.primaryColor), // İkon ana tema renginde
        const SizedBox(height: 8.0),
        Text(
          value,
          style: AppTextStyles.headline2.copyWith(color: AppColors.black), // Değer metin stili
        ),
        Text(
          title,
          style: AppTextStyles.bodyText2.copyWith(color: AppColors.darkGrey), // Başlık metin stili
        ),
      ],
    );
  }
}
