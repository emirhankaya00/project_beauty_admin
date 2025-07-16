// lib/features/shared_admin_components/search_bar_widget.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_border_radius.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';

/// Uygulama genelinde kullanılabilen özelleştirilmiş arama çubuğu widget'ı.
/// Figma tasarımındaki gri arka planlı, yuvarlak kenarlı arama çubuğuna uygun.
class SearchBarWidget extends StatelessWidget {
  final String hintText; // Arama çubuğunun ipucu metni
  final ValueChanged<String>? onChanged; // Metin değiştiğinde çağrılan fonksiyon
  final ValueChanged<String>? onSubmitted; // Arama yapıldığında çağrılan fonksiyon
  final TextEditingController? controller; // Arama çubuğu kontrolcüsü

  const SearchBarWidget({
    Key? key,
    this.hintText = 'Ara...', // Varsayılan ipucu metni
    this.onChanged,
    this.onSubmitted,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputFillColor, // Gri arka plan rengi
        borderRadius: AppBorderRadius.small, // Yuvarlak kenarlar
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // İç boşluk
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.bodyText1.copyWith(color: AppColors.grey), // İpucu metin stili
          border: InputBorder.none, // Varsayılan kenarlığı kaldır
          suffixIcon: const Icon(Icons.search, color: AppColors.primaryColor), // Arama ikonu
        ),
        style: AppTextStyles.bodyText1.copyWith(color: AppColors.black), // Metin stili
        cursorColor: AppColors.primaryColor, // İmleç rengi
      ),
    );
  }
}
