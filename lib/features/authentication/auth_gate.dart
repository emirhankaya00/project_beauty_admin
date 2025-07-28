// lib/features/authentication/screens/auth_gate.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/features/authentication/screens/admin_login_screen.dart';
import 'package:project_beauty_admin/features/dashboard/screens/admin_dashboard_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final session = snapshot.data?.session;
          // Eğer kullanıcı giriş yapmışsa Ana Sayfa'ya yönlendir
          if (session != null) {
            return const AdminDashboardScreen();
          }
        }
        // Giriş yapmamışsa Login Ekranı'nı göster
        return const AdminLoginScreen();
      },
    );
  }
}