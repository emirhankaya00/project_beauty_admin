enum AdminRole { admin, worker, manager, owner }

class AdminModel {
  final String adminId;
  final String saloonId;
  final String username;
  final String name;
  final String surname;
  final AdminRole role;
  final DateTime createdAt;
  final DateTime updatedAt;

  var email;

  AdminModel({
    required this.adminId,
    required this.saloonId,
    required this.username,
    required this.name,
    required this.surname,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  // Gelen veride bir alan eksik/null olsa bile hata vermeyecek,
  // varsayılan bir değer atayacak şekilde güncellendi.
  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      adminId: json['admin_id'] ?? 'hata-id-yok',
      saloonId: json['saloon_id'] ?? 'hata-salon-id-yok',
      username: json['username'] ?? '',
      name: json['name'] ?? 'İsimsiz',
      surname: json['surname'] ?? 'Kullanıcı',
      role: AdminRole.values.firstWhere(
            (e) => e.name == json['role'],
        orElse: () => AdminRole.worker,
      ),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  // toJson fonksiyonu aynı kalabilir.
  Map<String, dynamic> toJson() {
    return {
      'admin_id': adminId,
      'saloon_id': saloonId,
      'username': username,
      'name': name,
      'surname': surname,
      'role': role.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}