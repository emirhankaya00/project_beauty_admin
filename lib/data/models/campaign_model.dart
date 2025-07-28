// lib/data/models/campaign_model.dart

import 'package:flutter/foundation.dart';
// Bu model, bir hizmetin kampanya içindeki temsilidir.
// Kendi ServiceModel'inize göre uyarlamanız gerekebilir.
import 'package:project_beauty_admin/data/models/service_model.dart';

// Veritabanındaki 'discount_type' ile eşleşen enum
enum DiscountType { percentage, fixed }

@immutable
class CampaignModel {
  final String id;
  final String saloonId;
  final String title;
  final String? description;
  final DiscountType discountType;
  final double discountValue;
  final DateTime startDate;
  final DateTime endDate;
  // DİKKAT: Bu liste, veritabanından JOIN ile çekilen hizmetleri tutacak.
  // Henüz bu hizmetleri tutan bir modeliniz yoksa, geçici olarak Map<String, dynamic> kullanabiliriz.
  // Şimdilik basit bir ServiceModel listesi olduğunu varsayalım.
  final List<ServiceModel> services;

  const CampaignModel({
    required this.id,
    required this.saloonId,
    required this.title,
    this.description,
    required this.discountType,
    required this.discountValue,
    required this.startDate,
    required this.endDate,
    this.services = const [], // Varsayılan olarak boş liste
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    // Veritabanından gelen 'campaign_services' listesini ServiceModel listesine çeviriyoruz.
    // Bu kısım, Supabase'den veriyi nasıl çektiğinize göre değişebilir.
    final List<ServiceModel> parsedServices = [];
    if (json['campaign_services'] is List) {
      for (var serviceEntry in (json['campaign_services'] as List)) {
        if (serviceEntry['services'] != null) {
          // 'services' tablosundan gelen veriyi parse et
          parsedServices.add(ServiceModel.fromJson(serviceEntry['services']));
        }
      }
    }

    return CampaignModel(
      id: json['id'] as String? ?? '',
      saloonId: json['saloon_id'] as String? ?? '',
      title: json['title'] as String? ?? 'Başlıksız Kampanya',
      description: json['description'] as String?,
      discountType: (json['discount_type'] == 'percentage')
          ? DiscountType.percentage
          : DiscountType.fixed,
      discountValue: (json['discount_value'] as num?)?.toDouble() ?? 0.0,
      startDate: DateTime.tryParse(json['start_date'] as String? ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['end_date'] as String? ?? '') ?? DateTime.now(),
      services: parsedServices,
    );
  }

  // Veritabanına göndermek için JSON'a dönüştüren metot.
  // 'services' hariç tutulur çünkü o ayrı bir tabloya yazılır.
  Map<String, dynamic> toJson() {
    return {
      'saloon_id': saloonId,
      'title': title,
      'description': description,
      'discount_type': discountType.name, // enum'ı string'e çevirir
      'discount_value': discountValue,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }
}