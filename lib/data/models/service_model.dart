// lib/data/models/service_models.dart (Bu dosyayı bu isimle oluşturun/güncelleyin)

class ServiceItem { // Sınıf adı ServiceItem olarak kalıyor
  final String id;
  final String name; // Hizmet adı (örn: Saç Kesimi, Manikür)
  final String category; // Kategori (örn: Saç Bakımı, El & Ayak)
  final double price; // Fiyat
  final String duration; // Ortalama süre (örn: "30 dk", "1 saat")
  final String? description; // Hizmet açıklaması
  final String? imageUrl; // Hizmet görseli URL'si (isteğe bağlı)
  final bool isActive; // Hizmetin aktif olup olmadığı

  ServiceItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.duration,
    this.description,
    this.imageUrl,
    this.isActive = true, // Varsayılan olarak aktif
  });
}