// lib/viewmodels/auth_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// DÜZELTME: main.dart import'u kaldırıldı, bu bir anti-patterndir.
import '../data/models/admin_model.dart';

class AuthViewModel with ChangeNotifier {
  // DÜZELTME: Artık global 'supabase' değişkeni yerine,
  // Supabase.instance.client kullanarak Supabase'e ulaşıyoruz.
  final _supabase = Supabase.instance.client;

  bool _isLoading = false;
  String? _errorMessage;
  AdminModel? _currentAdmin;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AdminModel? get currentAdmin => _currentAdmin;

  void clearError() {
    _errorMessage = null;
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      // 1. ADIM: KİMLİK DOĞRULAMA
      final authResponse = await _supabase.auth.signInWithPassword( // DÜZELTME
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw const AuthException('Kullanıcı bilgisi alınamadı.');
      }

      final user = authResponse.user!;

      // 2. ADIM: YETKİ KONTROLÜ
      final adminData = await _supabase // DÜZELTME
          .from('admins')
          .select()
          .eq('admin_id', user.id)
          .single();

      // 3. ADIM: VERİYİ İŞLEME
      _currentAdmin = AdminModel.fromJson(adminData);

      _setLoading(false);
      return true;

    } on PostgrestException catch (_) {
      await _supabase.auth.signOut(); // DÜZELTME
      _errorMessage = 'Bu panele erişim yetkiniz bulunmamaktadır.';
      _setLoading(false);
      return false;
    } on AuthException catch (e) {
      debugPrint('>>> AUTH HATASI: ${e.message}');
      _errorMessage = e.message;
      _setLoading(false);
      return false;
    } catch (e) {
      debugPrint('>>> BİLİNMEYEN HATA: ${e.toString()}');
      _errorMessage = 'Bilinmeyen bir hata oluştu: ${e.toString()}';
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut(); // DÜZELTME
    _currentAdmin = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}