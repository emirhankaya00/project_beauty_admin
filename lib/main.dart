// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // Rendering debug bayrakları için import edi
import 'package:intl/date_symbol_data_local.dart';
import 'package:project_beauty_admin/design_system/app_theme.dart'; // Uygulama temamızı import ediyoruz
import 'package:project_beauty_admin/features/authentication/screens/admin_login_screen.dart'; // Giriş sayfamızı import ediyoruz

/// Uygulamanın ana giriş noktası.
/// `runApp` fonksiyonu ile uygulamanın kök widget'ını başlatır.
void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Yeni satır
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
  runApp(const MyApp());
  });
}

/// Uygulamanın kök widget'ı.
/// MaterialApp widget'ını kullanarak uygulamanın temel yapısını ve temasını ayarlar.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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