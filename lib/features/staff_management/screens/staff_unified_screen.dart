import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_border_radius.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_card.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_app_bar.dart';

class StaffUnifiedScreen extends StatefulWidget {
  const StaffUnifiedScreen({super.key});

  @override
  State<StaffUnifiedScreen> createState() => _StaffUnifiedScreenState();
}

class _StaffUnifiedScreenState extends State<StaffUnifiedScreen> {
  // Statik personel verileri (örnek amaçlı)
  List<Map<String, dynamic>> _allStaffMembers = [
    {
      'id': '1',
      'name': 'Elif Yılmaz',
      'title': 'Kuaför',
      'email': 'elif.yilmaz@salon.com',
      'phone': '555-123-4567',
      'isActive': true,
      'imageUrl': 'https://via.placeholder.com/150/FF5733/FFFFFF?text=EY',
      'services': ['Saç Kesimi', 'Saç Boyama', 'Fön'],
      'description': 'Modern saç kesimleri ve renklendirme konusunda uzman.',
    },
    {
      'id': '2',
      'name': 'Can Demir',
      'title': 'Manikürist',
      'email': 'can.demir@salon.com',
      'phone': '555-987-6543',
      'isActive': true,
      'imageUrl': 'https://via.placeholder.com/150/33FF57/FFFFFF?text=CD',
      'services': ['Manikür', 'Pedikür', 'Kalıcı Oje'],
      'description': 'Detaylı el ve ayak bakımı hizmetleri sunar.',
    },
    {
      'id': '3',
      'name': 'Zeynep Kaya',
      'title': 'Cilt Uzmanı',
      'email': 'zeynep.kaya@salon.com',
      'phone': '555-111-2233',
      'isActive': false,
      'imageUrl': 'https://via.placeholder.com/150/3357FF/FFFFFF?text=ZK',
      'services': ['Cilt Bakımı', 'Akne Tedavisi', 'Anti-aging'],
      'description': 'Cilt sağlığı ve güzelliği üzerine kişiselleştirilmiş çözümler.',
    },
    {
      'id': '4',
      'name': 'Murat Aslan',
      'title': 'Masör',
      'email': 'murat.aslan@salon.com',
      'phone': '555-444-5566',
      'isActive': true,
      'imageUrl': 'https://via.placeholder.com/150/FFFF33/000000?text=MA',
      'services': ['Klasik Masaj', 'Spor Masajı', 'Aromaterapi'],
      'description': 'Vücut ve zihin rahatlaması için çeşitli masaj teknikleri.',
    },
  ];

  // Tüm mevcut hizmetlerin statik listesi (şimdilik)
  final List<String> _availableServices = [
    'Saç Kesimi',
    'Saç Boyama',
    'Fön',
    'Manikür',
    'Pedikür',
    'Kalıcı Oje',
    'Cilt Bakımı',
    'Akne Tedavisi',
    'Anti-aging',
    'Klasik Masaj',
    'Spor Masajı',
    'Aromaterapi',
    'Kaş Tasarımı',
    'Ağda',
    'Sakal Traşı',
    'Topuz Yapımı'
  ];

  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  List<Map<String, dynamic>> get _filteredStaffMembers {
    if (_searchText.isEmpty) {
      return _allStaffMembers;
    }
    return _allStaffMembers.where((staff) {
      final name = staff['name']?.toLowerCase() ?? '';
      final title = staff['title']?.toLowerCase() ?? '';
      final searchTextLower = _searchText.toLowerCase();
      return name.contains(searchTextLower) || title.contains(searchTextLower);
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

  // Personel Düzenleme Pop-up'ı
  Future<void> _showEditStaffDialog(BuildContext context, Map<String, dynamic> staff) async {
    final TextEditingController nameController = TextEditingController(text: staff['name']);
    final TextEditingController titleController = TextEditingController(text: staff['title']);
    final TextEditingController emailController = TextEditingController(text: staff['email']);
    final TextEditingController phoneController = TextEditingController(text: staff['phone']);
    final TextEditingController descriptionController = TextEditingController(text: staff['description']);

    bool isActive = staff['isActive'] as bool;
    List<String> selectedServices = List<String>.from(staff['services'] as List? ?? []); // Mevcut hizmetleri kopyala

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setInnerState) {
            return AlertDialog(
              title: Text('${staff['name']} Düzenle'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Adı Soyadı'),
                      style: AppTextStyles.bodyText1,
                    ),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Ünvanı'),
                      style: AppTextStyles.bodyText1,
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'E-posta'),
                      style: AppTextStyles.bodyText1,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: 'Telefon'),
                      style: AppTextStyles.bodyText1,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Verilen Hizmetler:', style: AppTextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0, // Yatay boşluk
                      runSpacing: 4.0, // Dikey boşluk
                      children: _availableServices.map((service) {
                        final isSelected = selectedServices.contains(service);
                        return FilterChip(
                          key: ValueKey(service), // FilterChip'e key eklendi
                          label: Text(service),
                          selected: isSelected,
                          onSelected: (bool value) {
                            setInnerState(() {
                              if (value) {
                                selectedServices.add(service);
                              } else {
                                selectedServices.remove(service);
                              }
                            });
                          },
                          selectedColor: AppColors.primaryColor.withOpacity(0.2),
                          checkmarkColor: AppColors.primaryColor,
                          labelStyle: AppTextStyles.bodyText2.copyWith(
                            color: isSelected ? AppColors.primaryColor : AppColors.darkGrey,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppBorderRadius.small,
                            side: BorderSide(
                              color: isSelected ? AppColors.primaryColor : AppColors.lightGrey,
                            ),
                          ),
                          backgroundColor: AppColors.lightGrey.withOpacity(0.5),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
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
                    debugPrint('Düzenleme iptal edildi, değişiklik yapılmadı.');
                    Navigator.of(dialogContext).pop();
                    FocusScope.of(context).unfocus(); // Odak temizlendi
                  },
                ),
                ElevatedButton(
                  child: const Text('Kaydet', style: TextStyle(color: AppColors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                  onPressed: () {
                    setState(() {
                      final index = _allStaffMembers.indexWhere((s) => s['id'] == staff['id']);
                      if (index != -1) {
                        _allStaffMembers[index]['name'] = nameController.text;
                        _allStaffMembers[index]['title'] = titleController.text;
                        _allStaffMembers[index]['email'] = emailController.text;
                        _allStaffMembers[index]['phone'] = phoneController.text;
                        _allStaffMembers[index]['description'] = descriptionController.text;
                        _allStaffMembers[index]['services'] = selectedServices;
                        _allStaffMembers[index]['isActive'] = isActive;
                      }
                    });
                    Navigator.of(dialogContext).pop();
                    FocusScope.of(context).unfocus(); // Odak temizlendi
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${nameController.text} başarıyla güncellendi.')),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );

    // Dialog kapandıktan sonra controllerları dispose et
    nameController.dispose();
    titleController.dispose();
    emailController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: 'Personel Yönetimi'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personel Listesi',
              style: AppTextStyles.headline3.copyWith(color: AppColors.primaryColor),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Personel Ara...',
                prefixIcon: const Icon(Icons.search, color: AppColors.darkGrey),
                border: OutlineInputBorder(
                  borderRadius: AppBorderRadius.medium,
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.lightGrey,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              style: AppTextStyles.bodyText1,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _filteredStaffMembers.isEmpty
                  ? Center(
                child: Text(
                  'Personel bulunmamaktadır.',
                  style: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey),
                ),
              )
                  : ListView.builder(
                itemCount: _filteredStaffMembers.length,
                itemBuilder: (context, index) {
                  final staff = _filteredStaffMembers[index];
                  final bool isActive = staff['isActive'] as bool;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: CustomCard(
                      key: ValueKey(staff['id']), // Her bir CustomCard'a benzersiz key eklendi
                      borderRadius: AppBorderRadius.medium,
                      padding: const EdgeInsets.all(16.0),
                      onTap: () {
                        debugPrint('${staff['name']} detayları gösteriliyor.');
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(staff['imageUrl'] as String),
                                radius: 30,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      staff['name'] as String,
                                      style: AppTextStyles.headline3.copyWith(color: AppColors.black),
                                    ),
                                    Text(
                                      staff['title'] as String,
                                      style: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey),
                                    ),
                                  ],
                                ),
                              ),
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
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Detay bilgileri (telefon, e-posta, hizmetler, açıklama)
                          Text(
                            'E-posta: ${staff['email']}',
                            style: AppTextStyles.bodyText2,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Telefon: ${staff['phone']}',
                            style: AppTextStyles.bodyText2,
                          ),
                          const SizedBox(height: 8),
                          if (staff['services'] != null && (staff['services'] as List).isNotEmpty) ...[
                            Text(
                              'Hizmetler:',
                              style: AppTextStyles.bodyText2.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 6.0,
                              runSpacing: 4.0,
                              children: (staff['services'] as List).map<Widget>((service) {
                                return Chip(
                                  label: Text(service as String, style: AppTextStyles.labelText),
                                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                                  labelStyle: AppTextStyles.labelText.copyWith(color: AppColors.primaryColor),
                                );
                              }).toList(),
                            ),
                          ],
                          if (staff['description'] != null && (staff['description'] as String).isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Açıklama: ${staff['description']}',
                              style: AppTextStyles.bodyText2.copyWith(color: AppColors.grey),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          // Düzenle/Sil gibi aksiyon butonları
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                OutlinedButton(
                                  onPressed: () => _showEditStaffDialog(context, staff),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.darkGrey),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.medium),
                                  ),
                                  child: Text('Düzenle', style: AppTextStyles.buttonText.copyWith(color: AppColors.darkGrey, fontSize: 12)),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    debugPrint('${staff['name']} sil');
                                    setState(() {
                                      _allStaffMembers.removeWhere((s) => s['id'] == staff['id']);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.red,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.medium),
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
    );
  }
}