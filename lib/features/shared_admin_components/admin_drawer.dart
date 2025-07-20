// lib/features/shared_admin_components/admin_drawer.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/widgets/app_icons.dart';
import 'package:project_beauty_admin/features/authentication/screens/admin_login_screen.dart';
import 'package:provider/provider.dart';
import 'package:project_beauty_admin/design_system/extensions/context_extensions.dart';

import '../authentication/auth_viewmodel.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final admin = authViewModel.currentAdmin;

    // Dinamik olarak tam adı oluşturuyoruz
    final String fullName = (admin != null && admin.name.isNotEmpty)
        ? '${admin.name} ${admin.surname}'
        : 'Yönetici Adı';

    // Rol enum'ını okunabilir bir metne çeviriyoruz (isteğe bağlı)
    final String roleText = admin?.role.name ?? 'Yönetici';

    return Drawer(
      backgroundColor: AppColors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.white,
                  child: Icon(Icons.person, size: 40, color: AppColors.primaryColor),
                ),
                const SizedBox(height: 8),
                Text(
                  fullName, // Doğru şekilde oluşturulmuş tam adı kullanıyoruz
                  style: AppTextStyles.headline3.copyWith(color: AppColors.white),
                ),
                Text(
                  roleText, // Doğru rolü kullanıyoruz
                  style: AppTextStyles.bodyText2.copyWith(color: AppColors.white.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),

          // ... Diğer menü öğeleri isteğin üzerine dokunulmadan bırakıldı ...
          _buildDrawerItem(
            context,
            icon: AppIcons.home,
            title: 'Ana Sayfa',
            onTap: () => context.pop(),
          ),

          const Divider(),

          // Sadece bu buton çalışacak
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            title: 'Çıkış Yap',
            onTap: () async {
              final navigator = Navigator.of(context);
              final authVm = context.read<AuthViewModel>();
              await authVm.signOut();
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(title, style: AppTextStyles.bodyText1.copyWith(color: AppColors.black)),
      onTap: onTap,
    );
  }
}