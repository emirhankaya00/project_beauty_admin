// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project_beauty_admin/core/provider_list.dart'; // Provider listesi
import 'package:project_beauty_admin/design_system/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/authentication/screens/admin_login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) .env yükle
  await dotenv.load(fileName: ".env");
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    throw Exception('.env dosyanızı kontrol edin. Supabase anahtarları bulunamadı.');
  }

  // 2) Supabase init
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // 3) TR yerelleştirme (tarih formatları)
  await initializeDateFormatting('tr_TR', null);

  // 4) Uygulama
  runApp(
    MultiProvider(
      providers: appProviders,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Beauty Admin',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,

      // --- Yerelleştirme (DatePicker vb. için şart) ---
      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // İstersen sabit TR dili kullan:
      // locale: const Locale('tr', 'TR'),

      // Uygulama başlarken direkt olarak login ekranını göster
      home: const AdminLoginScreen(),
    );
  }
}
