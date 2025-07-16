// lib/design_system/widgets/custom_card.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_border_radius.dart';

/// Uygulama genelinde kullanılan özel kart widget'ı.
/// Figma tasarımındaki yuvarlak kenarlı, gölgeli kart prensiplerine uygun olarak tasarlanmıştır.
/// Farklı kullanım senaryoları için çeşitli varyasyonlara sahiptir.
class CustomCard extends StatelessWidget {
  final Widget child; // Kartın içine yerleştirilecek içerik
  final BorderRadiusGeometry? borderRadius; // Kartın köşe yuvarlaklığı
  final EdgeInsetsGeometry? padding; // Kartın iç boşluğu
  final Color? backgroundColor; // Kartın arka plan rengi
  final double? elevation; // Kartın gölge yüksekliği
  final Color? shadowColor; // Kartın gölge rengi
  final BoxBorder? border; // Kartın kenarlığı (stroke)
  final Gradient? gradient; // Kartın arka planına uygulanacak degrade
  final VoidCallback? onTap; // Kartın tıklanma callback'i eklendi

  /// Varsayılan özel kart.
  /// Beyaz arka plan, büyük yuvarlaklık ve varsayılan gölgeye sahiptir.
  const CustomCard({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.border,
    this.gradient,
    this.onTap, // onTap eklendi
  });

  /// Kenarlıklı (stroklu) kart varyasyonu.
  /// Beyaz arka plan, orta yuvarlaklık ve ana tema renginde kenarlığa sahiptir.
  CustomCard.bordered({
    Key? key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.backgroundColor = AppColors.white,
    this.elevation = 4.0, // Kenarlık olduğu için daha az belirgin gölge
    this.shadowColor = AppColors.shadowColor,
    this.border = const Border.fromBorderSide(
        BorderSide(color: AppColors.strokeColor, width: 1.0)), // Ana tema renginde 1px kenarlık
    this.gradient,
    this.onTap, // onTap eklendi
  }) : super(key: key);

  /// Degrade arka planlı kart varyasyonu.
  /// Figma'daki Ana Sayfa kartları gibi degrade arka planlara sahiptir.
  CustomCard.gradient({
    Key? key,
    required this.child,
    required this.gradient, // Degrade zorunlu
    this.borderRadius = AppBorderRadius.large, // Büyük yuvarlaklık
    this.padding,
    this.backgroundColor, // Degrade varsa arka plan rengi genellikle null olur
    this.elevation = 6.0, // Degrade kartlar için orta gölge
    this.shadowColor = AppColors.shadowColor,
    this.border,
    this.onTap, // onTap eklendi
  }) : super(key: key);

  /// Küçük boyutlu kart varyasyonu.
  /// Daha küçük yuvarlaklık ve daha az dolguya sahiptir.
  CustomCard.small({
    Key? key,
    required this.child,
    this.borderRadius = AppBorderRadius.small, // Küçük yuvarlaklık (6.0)
    this.padding = const EdgeInsets.all(12.0), // Daha az iç boşluk
    this.backgroundColor = AppColors.white,
    this.elevation = 4.0,
    this.shadowColor = AppColors.shadowColor,
    this.border,
    this.gradient,
    this.onTap, // onTap eklendi
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // Nihai borderRadius değerini belirle ve TİPİ KESİN OLARAK BorderRadius olarak belirt
    final BorderRadius resolvedBorderRadius = (
        borderRadius?.toBorderRadius() ?? // Eğer borderRadius varsa, onu dönüştür
            (Theme.of(context).cardTheme.shape is RoundedRectangleBorder
                ? (Theme.of(context).cardTheme.shape as RoundedRectangleBorder).borderRadius.toBorderRadius()
                : null) ??
            AppBorderRadius.medium // Varsayılan değer olarak BorderRadius döndürür
    );

    return Container(
      // Kartın arka plan rengi veya degrade
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? Theme.of(context).cardTheme.color ?? AppColors.white) : null,
        gradient: gradient,
        borderRadius: resolvedBorderRadius, // Düzeltilmiş BorderRadius kullanıldı
        border: border, // Kenarlık
        boxShadow: elevation != null && elevation! > 0
            ? [
          BoxShadow(
            color: shadowColor ?? Theme.of(context).cardTheme.shadowColor ?? AppColors.shadowColor,
            blurRadius: elevation!, // elevation kadar blur
            offset: Offset(0, elevation! / 2), // Gölgeyi biraz alta yay
          ),
        ]
            : null,
      ),
      child: ClipRRect( // Kartın içeriğini yuvarlak köşelere göre kırpmak için
        borderRadius: resolvedBorderRadius,
        child: Material(
          color: Colors.transparent, // Material'ın kendi rengi olmasın, Container'ın rengini alsın
          child: InkWell( // Tıklanabilir alanlar için
            borderRadius: resolvedBorderRadius,
            onTap: onTap, // onTap callback'i kullanıldı
            child: Padding(
              padding: padding ?? Theme.of(context).cardTheme.margin ?? const EdgeInsets.all(16.0),
              child: child, // CustomCard'a gelen child artık burada!
            ),
          ),
        ),
      ),
    );
  }
}

// BorderRadiusGeometry'den BorderRadius'a güvenli bir dönüşüm sağlayan Extension
// Adı "toBorderRadius" olarak değiştirildi, daha anlaşılır olması için.
extension BorderRadiusGeometryToBorderRadius on BorderRadiusGeometry {
  BorderRadius toBorderRadius() {
    if (this is BorderRadius) {
      return this as BorderRadius;
    }
    // Eğer doğrudan BorderRadius değilse, her bir köşe yarıçapını alıp
    // yeni bir BorderRadius nesnesi oluştururuz. Bu, daha genel durumlar için güvenli bir yöntemdir.
    final resolvedRadius = resolve(TextDirection.ltr); // Varsayılan bir TextDirection kullan
    return BorderRadius.only(
      topLeft: resolvedRadius.topLeft,
      topRight: resolvedRadius.topRight,
      bottomLeft: resolvedRadius.bottomLeft,
      bottomRight: resolvedRadius.bottomRight,
    );
  }
}