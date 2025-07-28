// lib/features/campaigns/salons/campaign_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:project_beauty_admin/data/models/campaign_model.dart';
import 'package:project_beauty_admin/data/models/saloon_service_list_item.dart';
import 'package:project_beauty_admin/viewmodels/campaigns_viewmodel.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/repositories/campaign_repository.dart';

class CampaignEditScreen extends StatefulWidget {
  final String saloonId;
  final CampaignModel campaign;

  const CampaignEditScreen({
    Key? key,
    required this.saloonId,
    required this.campaign,
  }) : super(key: key);

  @override
  State<CampaignEditScreen> createState() => _CampaignEditScreenState();
}

class _CampaignEditScreenState extends State<CampaignEditScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _discountValueCtrl = TextEditingController();

  DiscountType _discountType = DiscountType.percent;
  DateTime? _start;
  DateTime? _end;

  List<SaloonServiceListItem> _services = [];
  final _selectedServiceIds = <String>{};
  bool _loading = true;

  final _fmt = DateFormat('dd.MM.yyyy HH:mm', 'tr_TR');

  @override
  void initState() {
    super.initState();
    // Mevcut kampanya verisini alanlara bas
    final c = widget.campaign;
    _titleCtrl.text = c.title;
    _descCtrl.text = c.description ?? '';
    _discountType = c.discountType;
    _discountValueCtrl.text = c.discountValue.toStringAsFixed(0);
    _start = c.startDate;
    _end = c.endDate;
    // Hizmetleri yükle
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      final list = await CampaignRepository().fetchSaloonServices(widget.saloonId);
      setState(() {
        _services = list;
        // Kampanyaya ait service_id'leri seçili hâle getir
        _selectedServiceIds.addAll(
          list
              .where((s) => widget.campaign.id /* burada campaign içinde seçili service_id'leri tutmalısın */ == s.id)
              .map((s) => s.id),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hizmetler yüklenemedi: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final from = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: _start ?? now,
    );
    if (from == null) return;
    final to = await showDatePicker(
      context: context,
      firstDate: from,
      lastDate: from.add(const Duration(days: 365)),
      initialDate: _end ?? from.add(const Duration(days: 7)),
    );
    if (to == null) return;
    setState(() {
      _start = DateTime(from.year, from.month, from.day, 0, 0);
      _end = DateTime(to.year, to.month, to.day, 23, 59);
    });
  }

  Future<void> _save() async {
    // geçerlilik kontrolleri
    if (_titleCtrl.text.isEmpty ||
        _discountValueCtrl.text.isEmpty ||
        _start == null ||
        _end == null ||
        _selectedServiceIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Başlık, indirim, tarih ve en az bir hizmet seçmelisin.')),
      );
      return;
    }
    final val = double.tryParse(_discountValueCtrl.text);
    if (val == null || val <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçerli bir indirim değeri gir.')),
      );
      return;
    }

    final vm = context.read<CampaignsViewModel>();
    final updated = CampaignModel(
      id: widget.campaign.id,
      saloonId: widget.saloonId,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      discountType: _discountType,
      discountValue: val,
      startDate: _start!,
      endDate: _end!,
    );

    final success = await vm.saveCampaign(
      campaign: updated,
      selectedSaloonServiceIds: _selectedServiceIds.toList(),
      campaignId: widget.campaign.id,
      saloonId: widget.saloonId,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kampanya güncellendi.')),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage ?? 'Güncelleme başarısız.')),
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
      appBar: AppBar(title: const Text('Kampanya Düzenle')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Detaylar', style: AppTextStyles.headline3.copyWith(color: AppColors.primaryColor)),
            const SizedBox(height: 8),
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Başlık')),
            const SizedBox(height: 8),
            TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Açıklama (opsiyonel)')),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<DiscountType>(
                    value: _discountType,
                    decoration: const InputDecoration(labelText: 'İndirim Tipi'),
                    items: const [
                      DropdownMenuItem(value: DiscountType.percent, child: Text('% Yüzde')),
                      DropdownMenuItem(value: DiscountType.fixed, child: Text('₺ Sabit')),
                    ],
                    onChanged: (v) => setState(() => _discountType = v!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _discountValueCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: _discountType == DiscountType.percent ? 'İndirim (%)' : 'İndirim (₺)',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Tarih Aralığı'),
              subtitle: Text(
                _start == null || _end == null
                    ? 'Seçilmedi'
                    : '${_fmt.format(_start!)} → ${_fmt.format(_end!)}',
              ),
              trailing: OutlinedButton.icon(
                onPressed: _pickRange,
                icon: const Icon(Icons.date_range),
                label: const Text('Seç'),
              ),
            ),
            const Divider(height: 32),
            Text('Hizmet Seçimi', style: AppTextStyles.headline3.copyWith(color: AppColors.primaryColor)),
            const SizedBox(height: 8),
            ..._services.map((s) {
              final checked = _selectedServiceIds.contains(s.id);
              final d = double.tryParse(_discountValueCtrl.text);
              double? discounted;
              if (d != null && d > 0) {
                discounted = _discountType == DiscountType.percent
                    ? s.price * (1 - d / 100)
                    : (s.price - d).clamp(0, double.infinity);
              }
              return CheckboxListTile(
                value: checked,
                onChanged: (yes) {
                  setState(() {
                    if (yes == true) {
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
                      : '₺${s.price.toStringAsFixed(2)} → ₺${discounted.toStringAsFixed(2)}',
                ),
              );
            }),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Güncelle'),
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
