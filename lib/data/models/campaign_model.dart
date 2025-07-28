// lib/data/models/campaign_model.dart

enum DiscountType { percent, fixed, percentage }

extension DiscountTypeX on DiscountType {
  String get dbValue => this == DiscountType.percent ? 'percent' : 'fixed';

  static DiscountType parse(dynamic v) {
    final s = (v ?? '').toString().toLowerCase().trim();
    if (s == 'percent' || s == 'percentage' || s == '%') return DiscountType.percent;
    // olası eşdeğerler
    if (s == 'fixed' || s == 'try' || s == 'tl' || s == '₺') return DiscountType.fixed;
    // varsayılan
    return DiscountType.percent;
  }
}

class CampaignModel {
  final String id;
  final String saloonId;
  final String title;
  final String? description;
  final DiscountType discountType; // enum oldu
  final double discountValue;
  final DateTime startDate;
  final DateTime endDate;

  CampaignModel({
    required this.id,
    required this.saloonId,
    required this.title,
    this.description,
    required this.discountType,
    required this.discountValue,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toInsertMap() => {
    'saloon_id': saloonId,
    'title': title,
    'description': description,
    'discount_type': discountType.dbValue, // enum -> string
    'discount_value': discountValue,
    'start_date': startDate.toUtc().toIso8601String(),
    'end_date': endDate.toUtc().toIso8601String(),
  };

  factory CampaignModel.fromJson(Map<String, dynamic> j) => CampaignModel(
    id: j['id'] as String,
    saloonId: j['saloon_id'] as String,
    title: j['title'] as String,
    description: j['description'] as String?,
    discountType: DiscountTypeX.parse(j['discount_type']),
    discountValue: (j['discount_value'] as num).toDouble(),
    startDate: DateTime.parse(j['start_date']).toLocal(),
    endDate: DateTime.parse(j['end_date']).toLocal(),
  );

  CampaignModel copyWith({
    String? id,
    String? saloonId,
    String? title,
    String? description,
    DiscountType? discountType,
    double? discountValue,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return CampaignModel(
      id: id ?? this.id,
      saloonId: saloonId ?? this.saloonId,
      title: title ?? this.title,
      description: description ?? this.description,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
