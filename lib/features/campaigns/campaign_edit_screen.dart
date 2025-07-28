// lib/features/campaigns/screens/campaign_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:project_beauty_admin/data/models/campaign_model.dart';
import 'package:project_beauty_admin/data/models/saloon_service_list_item.dart';
import 'package:project_beauty_admin/viewmodels/campaigns_viewmodel.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';

import '../../repositories/campaign_repository.dart';

class CampaignEditScreen extends StatefulWidget {
  final String saloonId;
  final CampaignModel campaign;

  const CampaignEditScreen({
    super.key,
    required this.saloonId,
    required this.campaign,
  });

  @override
  State<CampaignEditScreen> createState() => _CampaignEditScreenState();
}

class _CampaignEditScreenState extends State<CampaignEditScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _discountValueController = TextEditingController();

  DiscountType _discountType = DiscountType.percent;
  DateTime? _start;
  DateTime? _end;

  List<SaloonServiceListItem> _services = [];
  final _selectedServiceIds = <String>{};

  bool _loadingServices = true;
  final _dateFmt = DateFormat('dd.MM.yyyy HH:mm', 'tr_TR');

  @override
  void initState() {
    super.initState();
    final c = widget.campaign;
    _titleController.text = c.title;
    _descController.text = c.description ?? '';
    _discountType = c.discountType;
    _discountValueController.text = c.discountValue.toStringAsFixed(0);
    _start = c.startDate;
    _end = c.endDate;
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      final list = await CampaignRepository().fetchSaloonServices(widget.saloonId);
      setState(() {
        _services = list;
        _loadingServices = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingServices = false);
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
    if (_titleController.text.isEmpty ||
        _discountValueController.text.isEmpty ||
        _start == null ||
        _end == null ||
        _selectedServiceIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Başlık, indirim, tarih ve en az bir hizmet seçmelisin.')),
      );
      return;
    }
    final val = double.tryParse(_discountValueController.text);
    if (val == null || val <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçerli bir indirim değeri gir.')),
      );
      return;
    }

    final vm = context.read<CampaignsViewModel>();
    final success = await vm.saveCampaign(
      campaign: CampaignModel(
        id: widget.campaign.id,
        saloonId: widget.saloonId,
        title: _titleController.text.trim(),
        description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
        discountType: _discountType,
        discountValue: val,
        startDate: _start!,
        endDate: _end!,
      ),
      selectedSaloonServiceIds: _selectedServiceIds.toList(),
      campaignId: widget.campaign.id,
      saloonId: widget.saloonId,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kampanya güncellendi.')),
      );
      Navigator.of(context).pop(true);
    } else if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage ?? 'Bilinmeyen hata')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingServices) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: const Text('Kampanya Düzenle')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _save,
        label: const Text('Güncelle'),
        icon: const Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Detaylar', style: AppTextStyles.headline3.copyWith(color: AppColors.primaryColor)),
            const SizedBox(height: 8),
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Başlık')),
            const SizedBox(height: 8),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Açıklama (opsiyonel)')),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: DropdownButtonFormField<DiscountType>(
                  value: _discountType,
                  items: const [
                    DropdownMenuItem(value: DiscountType.percent, child: Text('% Yüzde')),
                    DropdownMenuItem(value: DiscountType.fixed, child: Text('₺ Sabit')),
                  ],
                  onChanged: (v) => setState(() => _discountType = v!),
                  decoration: const InputDecoration(labelText: 'İndirim Tipi'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _discountValueController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: _discountType == DiscountType.percent ? 'İndirim (%)' : 'İndirim (₺)',
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Tarih Aralığı'),
              subtitle: Text(
                _start == null || _end == null
                    ? 'Seçilmedi'
                    : '${_dateFmt.format(_start!)} → ${_dateFmt.format(_end!)}',
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
              final sel = _selectedServiceIds.contains(s.id);
              final d = double.tryParse(_discountValueController.text);
              double? discounted;
              if (d != null && d > 0) {
                discounted = _discountType == DiscountType.percent
                    ? s.price * (1 - d / 100)
                    : (s.price - d).clamp(0, double.infinity);
              }
              return CheckboxListTile(
                value: sel,
                onChanged: (v) {
                  setState(() {
                    if (v == true) _selectedServiceIds.add(s.id);
                    else _selectedServiceIds.remove(s.id);
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
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
