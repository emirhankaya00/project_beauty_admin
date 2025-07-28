import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_beauty_admin/data/models/campaign_model.dart'; // DiscountType enum burada
import 'package:project_beauty_admin/data/models/saloon_service_list_item.dart';
import 'package:project_beauty_admin/repositories/campaign_repository.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';

class CampaignCreateScreen extends StatefulWidget {
  final String saloonId;
  const CampaignCreateScreen({super.key, required this.saloonId});

  @override
  State<CampaignCreateScreen> createState() => _CampaignCreateScreenState();
}

class _CampaignCreateScreenState extends State<CampaignCreateScreen> {
  final _repo = CampaignRepository();

  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _discountValue = TextEditingController();

  DiscountType _discountType = DiscountType.percent; // enum
  DateTime? _start;
  DateTime? _end;

  List<SaloonServiceListItem> _services = [];
  final Set<String> _selectedServiceIds = {};

  bool _loading = true;
  final _fmt = DateFormat('dd.MM.yyyy HH:mm', 'tr_TR');

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await _repo.fetchSaloonServices(widget.saloonId);
      if (!mounted) return;
      setState(() {
        _services = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hizmetler yüklenemedi: $e')),
      );
    }
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final from = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: now,
      locale: const Locale('tr', 'TR'),
    );
    if (from == null) return;
    final to = await showDatePicker(
      context: context,
      firstDate: from,
      lastDate: from.add(const Duration(days: 365)),
      initialDate: from.add(const Duration(days: 7)),
      locale: const Locale('tr', 'TR'),
    );
    if (to == null) return;

    setState(() {
      _start = DateTime(from.year, from.month, from.day, 0, 0);
      _end = DateTime(to.year, to.month, to.day, 23, 59);
    });
  }

  double? _parseDiscount(String s) {
    // Türkçe ondalık girişleri için virgülü noktaya çevir
    final cleaned = s.replaceAll(',', '.').trim();
    return double.tryParse(cleaned);
  }

  Future<void> _save() async {
    if (_title.text.isEmpty ||
        _discountValue.text.isEmpty ||
        _start == null ||
        _end == null ||
        _selectedServiceIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Başlık, indirim, tarih ve en az bir hizmet seçmelisin.')),
      );
      return;
    }

    if (_start!.isAfter(_end!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Başlangıç tarihi, bitiş tarihinden sonra olamaz.')),
      );
      return;
    }

    final val = _parseDiscount(_discountValue.text);
    if (val == null || val <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçerli bir indirim değeri gir.')),
      );
      return;
    }

    // Yüzdede makul üst limit (örn. %90) – istersen kaldır.
    if (_discountType == DiscountType.percent && val > 90) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yüzde indirim 90’ı geçmemeli.')),
      );
      return;
    }

    try {
      final id = await _repo.createCampaign(
        data: CampaignModel(
          id: '',
          saloonId: widget.saloonId,
          title: _title.text.trim(),
          description: _desc.text.trim().isEmpty ? null : _desc.text.trim(),
          discountType: _discountType, // enum
          discountValue: val,
          startDate: _start!,
          endDate: _end!,
        ),
        selectedSaloonServiceIds: _selectedServiceIds.toList(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kampanya oluşturuldu (#$id)')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kayıt başarısız: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Kampanya Oluştur')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _save,
        label: const Text('Kaydet'),
        icon: const Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Detaylar',
              style: AppTextStyles.headline3.copyWith(color: AppColors.primaryColor),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Başlık'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _desc,
              decoration: const InputDecoration(labelText: 'Açıklama (opsiyonel)'),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<DiscountType>(
                    value: _discountType,
                    items: const [
                      DropdownMenuItem(
                        value: DiscountType.percent,
                        child: Text('% Yüzde'),
                      ),
                      DropdownMenuItem(
                        value: DiscountType.fixed,
                        child: Text('₺ Sabit'),
                      ),
                    ],
                    onChanged: (v) => setState(() => _discountType = v!),
                    decoration: const InputDecoration(labelText: 'İndirim Tipi'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _discountValue,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: _discountType == DiscountType.percent
                          ? 'İndirim (%)'
                          : 'İndirim (₺)',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Tarih Aralığı'),
              subtitle: Text(
                (_start == null || _end == null)
                    ? 'Seçilmedi'
                    : '${_fmt.format(_start!)}  →  ${_fmt.format(_end!)}',
              ),
              trailing: OutlinedButton.icon(
                onPressed: _pickRange,
                icon: const Icon(Icons.date_range),
                label: const Text('Seç'),
              ),
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hizmet Seçimi',
                  style: AppTextStyles.headline3.copyWith(color: AppColors.primaryColor),
                ),
                Text('${_selectedServiceIds.length} seçildi'),
              ],
            ),
            const SizedBox(height: 8),
            ..._services.map((s) {
              final selected = _selectedServiceIds.contains(s.id);
              final d = _parseDiscount(_discountValue.text);
              double? discounted;
              if (d != null && d > 0) {
                final raw = _discountType == DiscountType.percent
                    ? s.price * (1 - d / 100)
                    : s.price - d;
                discounted = raw < 0 ? 0.0 : raw;
              }

              return CheckboxListTile(
                value: selected,
                onChanged: (v) {
                  setState(() {
                    if (v == true) {
                      _selectedServiceIds.add(s.id);
                    } else {
                      _selectedServiceIds.remove(s.id);
                    }
                  });
                },
                title: Text(s.serviceName),
                subtitle: Text(
                  discounted == null
                      ? '₺${s.price.toStringAsFixed(2)}'
                      : '₺${s.price.toStringAsFixed(2)}  →  ₺${discounted.toStringAsFixed(2)}',
                ),
              );
            }),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
