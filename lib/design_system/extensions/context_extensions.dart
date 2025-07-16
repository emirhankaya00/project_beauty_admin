// lib/design_system/extensions/context_extensions.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/app_border_radius.dart';

/// BuildContext üzerine extension metodları ekleyerek,
/// tema renklerine, metin stillerine ve diğer tasarım token'larına
/// daha kolay erişim sağlar.
extension ContextExtensions on BuildContext {
  /// Tema renklerine kolay erişim.
  /// Örn: `context.colors.primaryColor`
  AppColors get colors => AppColors(); // AppColors sınıfının bir örneği döndürülür

  /// Tema metin stillerine kolay erişim.
  /// Örn: `context.textStyles.headline1`
  AppTextStyles get textStyles => AppTextStyles(); // AppTextStyles sınıfının bir örneği döndürülür

  /// Tema kenar yuvarlaklığı değerlerine kolay erişim.
  /// Örn: `context.borderRadius.medium`
  AppBorderRadius get borderRadius => AppBorderRadius(); // AppBorderRadius sınıfının bir örneği döndürülür

  /// Uygulamanın genel ThemeData'sına kolay erişim.
  /// Örn: `context.theme`
  ThemeData get theme => Theme.of(this);

  /// Uygulamanın ColorScheme'ine kolay erişim.
  /// Örn: `context.colorScheme.primary`
  ColorScheme get colorScheme => theme.colorScheme;

  /// Ekran boyutuna kolay erişim.
  /// Örn: `context.screenSize.width`
  Size get screenSize => MediaQuery.of(this).size;

  /// Ekran genişliğine kolay erişim.
  /// Örn: `context.width`
  double get width => screenSize.width;

  /// Ekran yüksekliğine kolay erişim.
  /// Örn: `context.height`
  double get height => screenSize.height;

  /// Odaklanmayı kaldırmak için.
  /// Örn: `context.unfocus()`
  void unfocus() {
    FocusScope.of(this).unfocus();
  }

  /// Klavyeyi gizlemek için.
  /// Örn: `context.hideKeyboard()`
  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// Navigasyon için geri gitme.
  /// Örn: `context.pop()`
  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }

  /// Yeni bir sayfaya gitme.
  /// Örn: `context.push(MaterialPageRoute(builder: (_) => SomeScreen()))`
  Future<T?> push<T extends Object?>(Route<T> route) {
    return Navigator.of(this).push(route);
  }

  /// Yeni bir sayfaya gitme ve mevcut rotayı değiştirme.
  /// Örn: `context.pushReplacement(MaterialPageRoute(builder: (_) => NewScreen()))`
  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(Route<T> newRoute, {TO? result}) {
    return Navigator.of(this).pushReplacement(newRoute, result: result);
  }

  /// Yeni bir sayfaya gitme ve tüm önceki rotaları kaldırma.
  /// Örn: `context.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false)`
  Future<T?> pushAndRemoveUntil<T extends Object?>(Route<T> newRoute, RoutePredicate predicate) {
    return Navigator.of(this).pushAndRemoveUntil(newRoute, predicate);
  }

  /// SnackBar gösterme.
  /// Örn: `context.showSnackBar('Mesajınız burada')`
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(String message, {Duration duration = const Duration(seconds: 2)}) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        behavior: SnackBarBehavior.floating, // Tema ayarından gelir
      ),
    );
  }

  /// Diyalog gösterme.
  /// content parametresi artık String yerine Widget alabilir.
  /// Örn: `context.showAlertDialog(title: 'Uyarı', content: Text('Bu bir uyarı mesajıdır.'))`
  /// Örn: `context.showAlertDialog(title: 'Not', content: CustomInputField.multiline(...))`
  Future<T?> showAlertDialog<T>({
    required String title,
    required Widget content, // String yerine Widget olarak değiştirildi
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: Theme.of(context).dialogTheme.titleTextStyle),
          content: content, // Widget doğrudan kullanılıyor
          actions: actions,
          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          shape: Theme.of(context).dialogTheme.shape,
          elevation: Theme.of(context).dialogTheme.elevation,
        );
      },
    );
  }
}
