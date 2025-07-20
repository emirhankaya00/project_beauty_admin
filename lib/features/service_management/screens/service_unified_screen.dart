import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_border_radius.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_card.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_app_bar.dart';

class ServiceUnifiedScreen extends StatefulWidget {
  const ServiceUnifiedScreen({super.key});

  @override
  State<ServiceUnifiedScreen> createState() => _ServiceUnifiedScreenState();
}

class _ServiceUnifiedScreenState extends State<ServiceUnifiedScreen> {
  // Statik hizmet verileri (örnek amaçlı)
  final List<Map<String, dynamic>> _allServices = [
    {
      'id': 's1',
      'name': 'Saç Kesimi (Kadın)',
      'price': 250.0,
      'durationMinutes': 60,
      'description': 'Uzman kuaförlerimizden modern ve şık saç kesimi hizmeti.',
      'isActive': true,
    },
    {
      'id': 's2',
      'name': 'Saç Boyama',
      'price': 500.0,
      'durationMinutes': 120,
      'description': 'Saçınızın rengini değiştirin veya doğal tonunu canlandırın.',
      'isActive': true,
    },
    {
      'id': 's3',
      'name': 'Manikür & Pedikür',
      'price': 180.0,
      'durationMinutes': 90,
      'description': 'El ve ayaklarınız için kapsamlı bakım ve oje uygulaması.',
      'isActive': true,
    },
    {
      'id': 's4',
      'name': 'Cilt Bakımı',
      'price': 400.0,
      'durationMinutes': 75,
      'description': 'Cilt tipinize özel derinlemesine temizlik ve bakım.',
      'isActive': true,
    },
    {
      'id': 's5',
      'name': 'Masaj Terapisi (60 dk)',
      'price': 350.0,
      'durationMinutes': 60,
      'description': 'Stresi azaltan ve kasları rahatlatan klasik masaj.',
      'isActive': true,
    },
    {
      'id': 's6',
      'name': 'Sakal Traşı',
      'price': 80.0,
      'durationMinutes': 30,
      'description': 'Profesyonel sakal traşı ve bakımı.',
      'isActive': false, // Pasif hizmet
    },
  ];

  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  List<Map<String, dynamic>> get _filteredServices {
    if (_searchText.isEmpty) {
      return _allServices;
    }
    return _allServices.where((service) {
      final name = service['name']?.toLowerCase() ?? '';
      final description = service['description']?.toLowerCase() ?? '';
      final searchTextLower = _searchText.toLowerCase();
      return name.contains(searchTextLower) || description.contains(searchTextLower);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Hizmet Ekle/Düzenle Pop-up'ı
  Future<void> _showEditServiceDialog(BuildContext context, Map<String, dynamic>? service) async {
    final bool isNewService = service == null;
    final TextEditingController nameController = TextEditingController(text: service?['name']);
    final TextEditingController priceController = TextEditingController(text: service?['price']?.toStringAsFixed(2) ?? '');
    final TextEditingController durationController = TextEditingController(text: service?['durationMinutes']?.toString() ?? '');
    final TextEditingController descriptionController = TextEditingController(text: service?['description']);
    bool isActive = service?['isActive'] as bool? ?? true; // Yeni hizmetler için varsayılan aktif

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setInnerState) {
            return AlertDialog(
              title: Text(isNewService ? 'Yeni Hizmet Ekle' : '${service['name']} Düzenle'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Hizmet Adı'),
                      style: AppTextStyles.bodyText1,
                    ),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Fiyat (TL)'),
                      style: AppTextStyles.bodyText1,
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: durationController,
                      decoration: const InputDecoration(labelText: 'Süre (Dakika)'),
                      style: AppTextStyles.bodyText1,
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Açıklama'),
                      style: AppTextStyles.bodyText1,
                      maxLines: 3,
                      minLines: 1,
                    ),
                    SwitchListTile(
                      title: Text('Aktif', style: AppTextStyles.bodyText1),
                      value: isActive,
                      onChanged: (bool value) {
                        setInnerState(() {
                          isActive = value;
                        });
                      },
                      activeColor: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('İptal', style: TextStyle(color: AppColors.darkGrey)),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                  onPressed: () {
                    // Validasyon
                    if (nameController.text.isEmpty ||
                        priceController.text.isEmpty ||
                        durationController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lütfen gerekli tüm alanları doldurun.')),
                      );
                      return;
                    }
                    final double? price = double.tryParse(priceController.text);
                    final int? duration = int.tryParse(durationController.text);

                    if (price == null || duration == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fiyat ve Süre geçerli sayılar olmalıdır.')),
                      );
                      return;
                    }

                    setState(() {
                      if (isNewService) {
                        // Yeni hizmet ekleme
                        _allServices.add({
                          'id': UniqueKey().toString(), // Benzersiz ID oluştur
                          'name': nameController.text,
                          'price': price,
                          'durationMinutes': duration,
                          'description': descriptionController.text,
                          'isActive': isActive,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${nameController.text} başarıyla eklendi.')),
                        );
                      } else {
                        // Mevcut hizmeti güncelleme
                        final index = _allServices.indexWhere((s) => s['id'] == service['id']);
                        if (index != -1) {
                          _allServices[index]['name'] = nameController.text;
                          _allServices[index]['price'] = price;
                          _allServices[index]['durationMinutes'] = duration;
                          _allServices[index]['description'] = descriptionController.text;
                          _allServices[index]['isActive'] = isActive;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${nameController.text} başarıyla güncellendi.')),
                        );
                      }
                    });
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Kaydet', style: TextStyle(color: AppColors.white)),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    priceController.dispose();
    durationController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: 'Hizmet Yönetimi'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hizmet Listesi',
              style: AppTextStyles.headline3.copyWith(color: AppColors.primaryColor),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Hizmet Ara...',
                prefixIcon: Icon(Icons.search, color: AppColors.darkGrey),
                border: OutlineInputBorder(
                  borderRadius: AppBorderRadius.medium,
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.lightGrey,
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              style: AppTextStyles.bodyText1,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _filteredServices.isEmpty
                  ? Center(
                child: Text(
                  'Hizmet bulunmamaktadır.',
                  style: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey),
                ),
              )
                  : ListView.builder(
                itemCount: _filteredServices.length,
                itemBuilder: (context, index) {
                  final service = _filteredServices[index];
                  final bool isActive = service['isActive'] as bool;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: CustomCard(
                      borderRadius: AppBorderRadius.medium,
                      padding: const EdgeInsets.all(16.0),
                      onTap: () {
                        // Hizmet detayını göstermek veya düzenlemek için
                        debugPrint('${service['name']} detayları gösteriliyor.');
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  service['name'] as String,
                                  style: AppTextStyles.headline3.copyWith(color: AppColors.black),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${service['price']?.toStringAsFixed(2)} TL',
                                style: AppTextStyles.headline3.copyWith(color: AppColors.primaryColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Süre: ${service['durationMinutes']} dk',
                            style: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey),
                          ),
                          const SizedBox(height: 8),
                          if (service['description'] != null && (service['description'] as String).isNotEmpty) ...[
                            Text(
                              'Açıklama: ${service['description']}',
                              style: AppTextStyles.bodyText2.copyWith(color: AppColors.grey),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                          ],
                          // Aktif/Pasif durumu
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isActive ? AppColors.green.withOpacity(0.1) : AppColors.red.withOpacity(0.1),
                              borderRadius: AppBorderRadius.small,
                            ),
                            child: Text(
                              isActive ? 'Aktif' : 'Pasif',
                              style: AppTextStyles.labelText.copyWith(
                                color: isActive ? AppColors.green : AppColors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                OutlinedButton(
                                  onPressed: () => _showEditServiceDialog(context, service),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.darkGrey),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    shape: const RoundedRectangleBorder(borderRadius: AppBorderRadius.medium),
                                  ),
                                  child: Text('Düzenle', style: AppTextStyles.buttonText.copyWith(color: AppColors.darkGrey, fontSize: 12)),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    debugPrint('${service['name']} sil');
                                    setState(() {
                                      _allServices.removeWhere((s) => s['id'] == service['id']);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.red,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    shape: const RoundedRectangleBorder(borderRadius: AppBorderRadius.medium),
                                  ),
                                  child: Text('Sil', style: AppTextStyles.buttonText.copyWith(fontSize: 12)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditServiceDialog(context, null), // Yeni hizmet eklemek için null gönderiyoruz
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}