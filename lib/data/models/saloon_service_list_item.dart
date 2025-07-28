class SaloonServiceListItem {
  final String id;          // saloon_services.id
  final String serviceName; // services.service_name
  final double price;

  SaloonServiceListItem({
    required this.id,
    required this.serviceName,
    required this.price,
  });

  factory SaloonServiceListItem.fromJoin(Map<String, dynamic> j) {
    return SaloonServiceListItem(
      id: j['id'],
      serviceName: j['services']['service_name'],
      price: (j['price'] as num).toDouble(),
    );
  }
}
