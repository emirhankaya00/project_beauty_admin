// lib/features/shared_admin_components/admin_app_bar.dart

import 'package:flutter/material.dart';

/// Admin Paneli için özelleştirilmiş AppBar widget'ı.
/// Figma tasarımındaki ana tema renginde ve alt kenarları yuvarlatılmış AppBar prensibine uygun.
class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // AppBar'ın başlığı
  final List<Widget>? actions; // AppBar'ın sağındaki aksiyon ikonları/widget'ları
  final Widget? leading; // AppBar'ın solundaki widget (geri butonu, menü ikonu vb.)

  const AdminAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading, // Yeni eklenen leading parametresi
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Tema dosyasından gelen AppBar ayarlarını kullanır
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      elevation: Theme.of(context).appBarTheme.elevation,
      centerTitle: Theme.of(context).appBarTheme.centerTitle,
      titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
      toolbarHeight: Theme.of(context).appBarTheme.toolbarHeight,
      shape: Theme.of(context).appBarTheme.shape, // Alt kenar yuvarlaklığı

      // Sol taraftaki ikon (leading parametresi sağlanırsa onu kullan, yoksa varsayılan menü ikonunu göster)
      leading: leading ?? Builder( // Eğer leading null ise varsayılan menü ikonunu göster
        builder: (BuildContext context) {
          // Eğer Scaffold'da drawer varsa, otomatik olarak menü ikonu gösterir.
          return IconButton(
            icon: Icon(Icons.menu, color: Theme.of(context).appBarTheme.foregroundColor),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Drawer'ı aç
            },
          );
        },
      ),

      title: Text(title), // Başlık metni
      actions: actions, // Sağdaki aksiyonlar
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10.0); // AppBar'ın tercih edilen boyutu
}
