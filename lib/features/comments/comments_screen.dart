// lib/view/screens/comments/comments_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:project_beauty_admin/data/models/comment_model.dart';
import 'package:project_beauty_admin/data/models/rating_stats_model.dart';

import '../../viewmodels/comments_viewmodel.dart';

// --- ANA SAYFA WIDGET'I ---

class CommentsScreen extends StatefulWidget {
  final String saloonId; // Yorumları gösterilecek salonun ID'si

  const CommentsScreen({super.key, required this.saloonId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  void initState() {
    super.initState();
    // Sayfa ilk açıldığında ViewModel'den verileri çekmesini istiyoruz.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommentsViewModel>().fetchComments(widget.saloonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CommentsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Müşteri Yorumları'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: Colors.grey[50],
      body: _buildBody(viewModel),
    );
  }

  // --- SAYFA İÇERİĞİNİ OLUŞTURAN ANA METOT ---
  Widget _buildBody(CommentsViewModel viewModel) {
    switch (viewModel.state) {
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator());
      case ViewState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Hata: ${viewModel.errorMessage ?? "Yorumlar yüklenemedi."}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        );
      case ViewState.idle:
        if (viewModel.comments.isEmpty) {
          return const Center(child: Text('Bu salon için henüz yorum yapılmamış.'));
        }
        // Yorumlar varsa, listeyi ve istatistikleri göster
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildStatsHeader(viewModel.stats),
            const SizedBox(height: 24),
            // Yorumları listeleyen döngü
            ...viewModel.comments.map((comment) => _buildCommentCard(comment)),
          ],
        );
    }
  }
}

// --- YARDIMCI WIDGET'LAR ---

/// Ekranın üst kısmındaki istatistik bölümünü oluşturur.
Widget _buildStatsHeader(RatingStatsModel stats) {
  return Card(
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Sol taraf: Ortalama Puan ve Toplam Yorum
          Column(
            children: [
              Text(
                stats.averageRating.toStringAsFixed(1),
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              _buildStarRating(stats.averageRating, itemSize: 20),
              const SizedBox(height: 8),
              Text(
                '${stats.totalCommentCount} Yorum',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
          const SizedBox(width: 24),
          // Sağ taraf: Puan Dağılımı İlerleme Çubukları
          Expanded(
            child: Column(
              children: [
                _buildRatingProgressBar('5', stats.fiveStarPercentage),
                _buildRatingProgressBar('4', stats.fourStarPercentage),
                _buildRatingProgressBar('3', stats.threeStarPercentage),
                _buildRatingProgressBar('2', stats.twoStarPercentage),
                _buildRatingProgressBar('1', stats.oneStarPercentage),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Tek bir yorum kartını oluşturur.
Widget _buildCommentCard(CommentModel comment) {
  return Card(
    margin: const EdgeInsets.only(bottom: 12.0),
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Kullanıcı adı
              Text(
                // UserModel içindeki name ve surname alanlarını kullandığını varsayıyoruz.
                '${comment.user?.name ?? 'Anonim'} ${comment.user?.surname ?? ''}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              // Yorum tarihi
              Text(
                DateFormat('d MMM yyyy', 'tr_TR').format(comment.createdAt),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Yıldızlı puanlama
          _buildStarRating(comment.rating.toDouble()),
          const SizedBox(height: 12),
          // Yorum metni
          Text(
            comment.commentText,
            style: TextStyle(color: Colors.grey[800], height: 1.4),
          ),
        ],
      ),
    ),
  );
}

/// Puan dağılımı için tek bir ilerleme çubuğu satırını oluşturur.
Widget _buildRatingProgressBar(String starLabel, double percentage) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Row(
      children: [
        Text(starLabel),
        const SizedBox(width: 4),
        const Icon(Icons.star, color: Colors.amber, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    ),
  );
}

/// Verilen puana göre sarı yıldızları oluşturan bir widget.
Widget _buildStarRating(double rating, {double itemSize = 18.0}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(5, (index) {
      return Icon(
        index < rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: itemSize,
      );
    }),
  );
}