// lib/features/campaigns/screens/campaigns_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:project_beauty_admin/data/models/campaign_model.dart';
import 'package:project_beauty_admin/viewmodels/auth_viewmodel.dart';
import 'package:project_beauty_admin/viewmodels/campaigns_viewmodel.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_app_bar.dart';

// Henüz oluşturmadığımız kampanya ekleme/düzenleme sayfası için import
// import 'campaign_edit_screen.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  @override
  void initState() {
    super.initState();
    // Sayfa ilk açıldığında ViewModel'den verileri çekmesini istiyoruz.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final saloonId = context.read<AuthViewModel>().currentAdmin?.saloonId;
      if (saloonId != null) {
        context.read<CampaignsViewModel>().fetchCampaigns(saloonId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CampaignsViewModel>();
    final saloonId = context.read<AuthViewModel>().currentAdmin?.saloonId;

    return Scaffold(
      appBar: const AdminAppBar(title: 'Kampanyalarım'),
      body: _buildBody(viewModel),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Yeni kampanya ekleme ekranına yönlendirme yapılacak.
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => CampaignEditScreen(saloonId: saloonId!),
          //   ),
          // );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kampanya ekleme ekranı yakında!')),
          );
        },
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
            return _CampaignCard(campaign: campaign);
          },
        );
    }
  }
}

// Tek bir kampanya kartını temsil eden widget
class _CampaignCard extends StatelessWidget {
  final CampaignModel campaign;
  const _CampaignCard({required this.campaign});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy', 'tr_TR');
    final bool isActive = DateTime.now().isAfter(campaign.startDate) &&
        DateTime.now().isBefore(campaign.endDate);

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
                  ),
                ),
                // Aktif/Pasif durumunu gösteren etiket
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
            // İndirim Bilgisi
            Row(
              children: [
                const Icon(Icons.sell_outlined, size: 20, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(
                  'İndirim: ${campaign.discountValue.toStringAsFixed(0)} ${campaign.discountType == DiscountType.percentage ? '%' : 'TL'}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Geçerlilik Tarihi
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
            // Düzenle ve Sil Butonları
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () {
                    // TODO: Silme onayı ve işlemi yapılacak
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent),
                  onPressed: () {
                    // TODO: Düzenleme ekranına yönlendirme yapılacak
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}