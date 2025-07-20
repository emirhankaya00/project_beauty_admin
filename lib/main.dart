// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // Rendering debug bayrakları için import edi
import 'package:intl/date_symbol_data_local.dart';
import 'package:project_beauty_admin/design_system/app_theme.dart'; // Uygulama temamızı import ediyoruz
import 'package:project_beauty_admin/features/authentication/screens/admin_login_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/authentication/auth_viewmodel.dart'; // Giriş sayfamızı import ediyoruz

/// Uygulamanın ana giriş noktası.
/// `runApp` fonksiyonu ile uygulamanın kök widget'ını başlatır.
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Yeni satır
  await Supabase.initialize(
    url: 'https://ndptlhgrilvxrxogzuyw.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5kcHRsaGdyaWx2eHJ4b2d6dXl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE5MjI3OTUsImV4cCI6MjA2NzQ5ODc5NX0.rhLSmN3BMgxovaOxOkUoTxSMaa-V3Nh_x9Hfv5B9aWA',
  );
  // --- ÖNEMLİ: TÜM DEBUG GÖRSELLEŞTİRME BAYRAKLARINI KAPALI TUT ---
  // Bu bayraklar, layout (yerleşim) hatalarını tetikleyebilir
  // veya performansı olumsuz etkileyebilir.
  initializeDateFormatting('tr_TR',null).then((_) { // Yeni satır
  debugPaintSizeEnabled = false;
  debugPaintBaselinesEnabled = false;
  debugPaintPointersEnabled = false;
  debugRepaintRainbowEnabled = false;
  debugProfileLayoutsEnabled = false;
  // debug.dart import'ına gerek kalmadan rendering.dart içinden erişilir.
  // ------------------------------------------------------------------

  // Flutter uygulamasını başlat
  runApp(
      ChangeNotifierProvider(
        create: (context) => AuthViewModel(),
        child: const MyApp(),
      ),);
  });
}
final supabase = Supabase.instance.client;

/// Uygulamanın kök widget'ı.
/// MaterialApp widget'ını kullanarak uygulamanın temel yapısını ve temasını ayarlar.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Uygulamanın başlığı (cihazın görev yöneticisinde veya uygulama listesinde görünür)
      title: 'Project Beauty Admin',

      // Uygulamanın genel temasını ayarlar.
      // design_system/app_theme.dart dosyasında tanımladığımız 'lightTheme' kullanılır.
      theme: AppTheme.lightTheme,

      // Hata ayıklama (debug) bayrağını gizler. Uygulama yayınlanırken 'false' olmalıdır.
      debugShowCheckedModeBanner: false,

      // Uygulamanın başlangıç sayfası.
      // Şu an için admin giriş sayfasını belirliyoruz.
      home: const AdminLoginScreen(),
    );
  }
}