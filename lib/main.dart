import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project_beauty_admin/design_system/app_theme.dart';
import 'package:project_beauty_admin/features/authentication/screens/admin_login_screen.dart';
import 'package:project_beauty_admin/viewmodels/auth_viewmodel.dart';
import 'package:project_beauty_admin/viewmodels/reservation_viewmodel.dart';
import 'package:project_beauty_admin/viewmodels/service_viewmodel.dart';
import 'package:project_beauty_admin/viewmodels/staff_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Uygulamanın ana giriş noktası.
void main() async {
  // Flutter binding'lerinin ve native kodla iletişimin hazır olduğundan emin oluyoruz.
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase'i başlatıyoruz.
  await Supabase.initialize(
    url: 'https://ndptlhgrilvxrxogzuyw.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5kcHRsaGdyaWx2eHJ4b2d6dXl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE5MjI3OTUsImV4cCI6MjA2NzQ5ODc5NX0.rhLSmN3BMgxovaOxOkUoTxSMaa-V3Nh_x9Hfv5B9aWA',
  );

  // Tarih formatlaması için Türkçe yerelleştirmesini yüklüyoruz.
  await initializeDateFormatting('tr_TR', null);

  // Performans ve yerleşim hatalarını ayıklamak için kullanılan
  // debug bayraklarının kapalı olduğundan emin oluyoruz.
  debugPaintSizeEnabled = false;
  debugPaintBaselinesEnabled = false;
  debugPaintPointersEnabled = false;
  debugRepaintRainbowEnabled = false;
  debugProfileLayoutsEnabled = false;

  // Flutter uygulamasını başlatıyoruz.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => ServiceViewModel()),
        ChangeNotifierProvider(create: (context) => StaffViewModel()),
        ChangeNotifierProvider(create: (context) => ReservationViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

/// Supabase istemcisine kolay erişim için global değişken.
final supabase = Supabase.instance.client;

/// Uygulamanın kök widget'ı.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Beauty Admin',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AdminLoginScreen(),
    );
  }
}