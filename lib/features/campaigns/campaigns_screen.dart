// lib/features/campaigns/screens/campaigns_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:project_beauty_admin/data/models/campaign_model.dart';
import 'package:project_beauty_admin/viewmodels/auth_viewmodel.dart';
import 'package:project_beauty_admin/viewmodels/campaigns_viewmodel.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_app_bar.dart';
import 'campaign_create_screen.dart';
import 'campaign_edit_screen.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final saloonId = context.read<AuthViewModel>().currentAdmin?.saloonId;
      if (saloonId != null) {
        context.read<CampaignsViewModel>().fetchCampaigns(saloonId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Salon bulunamadı (saloonId null).')),
        );
      }
    });
  }

  Future<void> _onDelete(CampaignModel campaign) async {
    final saloonId = context.read<AuthViewModel>().currentAdmin?.saloonId;
    if (saloonId == null) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Kampanya silinsin mi?'),
        content: Text('“${campaign.title}” kampanyasını silmek üzeresin. Bu işlem geri alınamaz.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Vazgeç')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sil')),
        ],
      ),
    );
    if (ok != true) return;

    final success = await context
        .read<CampaignsViewModel>()
        .deleteCampaign(campaign.id, saloonId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Kampanya silindi.'
              : 'Silme başarısız: ${context.read<CampaignsViewModel>().errorMessage}'),
        ),
      );
    }
  }

  Future<void> _openCreate() async {
    final saloonId = context.read<AuthViewModel>().currentAdmin?.saloonId;
    if (saloonId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Salon bulunamadı.')),
      );
      return;
    }

    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CampaignCreateScreen(saloonId: saloonId)),
    );

    if (created == true && mounted) {
      await context.read<CampaignsViewModel>().fetchCampaigns(saloonId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kampanya eklendi.')),
      );
    }
  }

  Future<void> _openEdit(CampaignModel campaign) async {
    final saloonId = context.read<AuthViewModel>().currentAdmin?.saloonId;
    if (saloonId == null) return;

    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CampaignEditScreen(
          saloonId: saloonId,
          campaign: campaign,
        ),
      ),
    );

    if (updated == true && mounted) {
      await context.read<CampaignsViewModel>().fetchCampaigns(saloonId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kampanya başarıyla güncellendi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CampaignsViewModel>();

    return Scaffold(
      appBar: const AdminAppBar(title: 'Kampanyalarım'),
      body: _buildBody(viewModel),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreate,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(CampaignsViewModel viewModel) {
    switch (viewModel.state) {
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator());
      case ViewState.error:
        return Center(child: Text('Hata: ${viewModel.errorMessage}'));
      case ViewState.idle:
        if (viewModel.campaigns.isEmpty) {
          return const Center(child: Text('Henüz bir kampanya oluşturmadınız.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: viewModel.campaigns.length,
          itemBuilder: (context, index) {
            final campaign = viewModel.campaigns[index];
            return _CampaignCard(
              campaign: campaign,
              onDelete: () => _onDelete(campaign),
              onEdit: () => _openEdit(campaign),
            );
          },
        );
    }
  }
}

class _CampaignCard extends StatelessWidget {
  final CampaignModel campaign;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _CampaignCard({
    required this.campaign,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy', 'tr_TR');
    final now = DateTime.now();
    final bool isActive =
        !now.isBefore(campaign.startDate) && !now.isAfter(campaign.endDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    campaign.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(
                  label: Text(isActive ? 'Aktif' : 'Pasif'),
                  backgroundColor: isActive ? Colors.green.shade100 : Colors.grey.shade200,
                  labelStyle: TextStyle(color: isActive ? Colors.green.shade800 : Colors.grey.shade700),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (campaign.description != null && campaign.description!.isNotEmpty)
              Text(
                campaign.description!,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.sell_outlined, size: 20, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(
                  'İndirim: ${campaign.discountValue.toStringAsFixed(0)} '
                      '${campaign.discountType == DiscountType.percent ? '%' : 'TL'}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.date_range_outlined, size: 20, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(
                  'Tarih: ${dateFormat.format(campaign.startDate)} - ${dateFormat.format(campaign.endDate)}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: onDelete,
                  tooltip: 'Sil',
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent),
                  onPressed: onEdit,
                  tooltip: 'Düzenle',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
