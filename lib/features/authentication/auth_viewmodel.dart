import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_beauty_admin/main.dart';
import '../../data/models/admin_model.dart';

class AuthViewModel with ChangeNotifier {
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
      // 1. ADIM: SADECE KİMLİK DOĞRULAMA
      final authResponse = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw const AuthException('Kullanıcı bilgisi alınamadı.');
      }

      final user = authResponse.user!;

      // 2. ADIM: YETKİ KONTROLÜ
      final adminData = await supabase
          .from('admins')
          .select()
          .eq('admin_id', user.id)
          .single(); // Kayıt yoksa hata fırlatır

      // 3. ADIM: GÜVENLİ MODELİ KULLANARAK VERİYİ İŞLEME
      _currentAdmin = AdminModel.fromJson(adminData);

      _setLoading(false);
      return true;

    } on PostgrestException catch (_) {
      // Bu hata, kullanıcı doğrulandı ama 'admins' tablosunda bulunamadı demektir.
      await supabase.auth.signOut();
      _errorMessage = 'Bu panele erişim yetkiniz bulunmamaktadır.';
      _setLoading(false);
      return false;
    } on AuthException catch (e) {
      // BU, SENİN ALDIĞIN ASIL HATA
      debugPrint('>>> AUTH HATASI: ${e.message}');
      _errorMessage = e.message; // 'Invalid login credentials'
      _setLoading(false);
      return false;
    } catch (e) {
      // Bu, bizim 'Null' hatasını veren genel hata yakalayıcıydı.
      debugPrint('>>> BİLİNMEYEN HATA: ${e.toString()}');
      _errorMessage = 'Bilinmeyen bir hata oluştu: ${e.toString()}';
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    _currentAdmin = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}