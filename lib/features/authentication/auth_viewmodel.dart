import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// main.dart dosyasında oluşturduğun global supabase değişkenini import ediyoruz
import 'package:project_beauty_admin/main.dart';

class AuthViewModel with ChangeNotifier {
  // State'leri (durumları) tutan değişkenler
  bool _isLoading = false;
  String? _errorMessage;

  // UI'ın (arayüzün) bu değişkenlere sadece okuma amaçlı erişmesini sağlayan getter'lar
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// UI'da hata mesajı gösterildikten sonra onu temizlemek için kullanılır.
  void clearError() {
    _errorMessage = null;
  }

  /// Giriş yapma işlemini yöneten ana fonksiyon
  Future<bool> login(String email, String password) async {
    // İşlem başladığında loading animasyonunu göster
    _setLoading(true);
    // Varsa eski hata mesajını temizle
    _errorMessage = null;

    try {
      // ADIM 1: SUPABASE AUTH İLE KİMLİK DOĞRULAMA
      final authResponse = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Yanıtta kullanıcı bilgisi yoksa bir sorun var demektir.
      if (authResponse.user == null) {
        throw const AuthException('Kullanıcı bilgisi alınamadı. Lütfen tekrar deneyin.');
      }

      final user = authResponse.user!;

      // ADIM 2: KULLANICININ 'admins' TABLOSUNDA YETKİSİ VAR MI KONTROL ET
      final adminCheck = await supabase
          .from('admins') // 'admins' tablosuna bak
          .select('admin_id') // Herhangi bir sütunu seçmemiz yeterli, var mı yok mu diye bakıyoruz
          .eq('admin_id', user.id) // Supabase Auth ID'si ile 'admins' tablosundaki 'admin_id' eşleşiyor mu?
          .maybeSingle(); // Kaydı bulmaya çalış, bulamazsan hata verme, null dön.

      // adminCheck null ise, kullanıcı doğrulanmış ama admin değil demektir.
      if (adminCheck == null) {
        // GÜVENLİK ADIMI: Yetkisi olmayan kullanıcının oturumunu hemen kapat!
        await supabase.auth.signOut();
        // Anlaşılır bir hata mesajı fırlat
        throw const AuthException('Bu panele erişim yetkiniz bulunmamaktadır.');
      }

      // Her iki kontrol de başarılı, işlem tamam.
      _setLoading(false);
      return true;

    } on AuthException catch (e) {
      // Supabase'den gelen kimlik doğrulama hatalarını yakala

      // Hatanın detayını konsola yazdır (sorun tespiti için)
      debugPrint('>>> SUPABASE AUTH HATASI: ${e.toString()}');

      _errorMessage = e.message; // Hata mesajını UI'da göstermek için state'e ata
      _setLoading(false);
      return false; // İşlemin başarısız olduğunu belirt
    } catch (e) {
      // Diğer beklenmedik hataları (network hatası vb.) yakala

      // Hatanın detayını konsola yazdır
      debugPrint('>>> BİLİNMEYEN HATA: ${e.toString()}');

      _errorMessage = 'Bilinmeyen bir hata oluştu.';
      _setLoading(false);
      return false;
    }
  }

  /// Oturumu sonlandıran çıkış yapma fonksiyonu
  Future<void> signOut() async {
    await supabase.auth.signOut();
    notifyListeners(); // Oturum durumu değiştiği için UI'ı bilgilendir
  }

  /// Yüklenme durumunu güncelleyen ve UI'a haber veren özel metot
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // Provider'a bağlı widget'lara "kendinizi güncelleyin" sinyali gönder
  }
}