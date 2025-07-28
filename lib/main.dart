// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project_beauty_admin/core/provider_list.dart'; // Provider listesini buradan alacağız
import 'package:project_beauty_admin/design_system/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_beauty_admin/viewmodels/campaigns_viewmodel.dart';

import 'features/authentication/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Gizli anahtarları .env dosyasından güvenli bir şekilde yükle
  await dotenv.load(fileName: ".env");
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];


  if (supabaseUrl == null || supabaseAnonKey == null) {
    throw Exception('.env dosyanızı kontrol edin. Supabase anahtarları bulunamadı.');
  }

  // 2. Supabase'i güvenli anahtarlarla başlat
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  await initializeDateFormatting('tr_TR', null);

  // 3. Uygulamayı, tüm provider'lar ile birlikte çalıştır
  runApp(
    MultiProvider(
      providers: appProviders, // Provider'ları ayrı bir dosyadan alıyoruz
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
      home: const AuthGate(),
    );
  }
}