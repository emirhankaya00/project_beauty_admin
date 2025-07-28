// lib/view/view_models/comments_viewmodel.dart

import 'package:flutter/foundation.dart';
import 'package:project_beauty_admin/data/models/comment_model.dart';
import 'package:project_beauty_admin/data/models/rating_stats_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../repositories/comment_repository.dart';

// Arayüzün hangi durumda olduğunu belirtmek için bir enum
enum ViewState { idle, loading, error }

class CommentsViewModel with ChangeNotifier {
  // Repository'yi Supabase client ile başlatıyoruz.
  // Not: Bunu bir dependency injection yapısıyla sağlamak daha iyi bir pratiktir.
  final CommentRepository _repository = CommentRepository(Supabase.instance.client);

  // --- State (Durum) Değişkenleri ---
  ViewState _state = ViewState.idle;
  String? _errorMessage;
  List<CommentModel> _comments = [];
  RatingStatsModel _stats = const RatingStatsModel();

  // --- Getter'lar (Arayüzün bu verilere güvenli erişimi için) ---
  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  List<CommentModel> get comments => _comments;
  RatingStatsModel get stats => _stats;

  // --- Özel Metotlar ---

  /// ViewModel'in durumunu günceller ve arayüzü yeniden çizmesi için sinyal gönderir.
  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Gelen yorum listesinden tüm istatistikleri hesaplar.
  void _calculateStats(List<CommentModel> comments) {
    if (comments.isEmpty) {
      _stats = const RatingStatsModel();
      return;
    }

    int totalCount = comments.length;
    double totalRating = comments.fold(0.0, (sum, item) => sum + item.rating);

    _stats = RatingStatsModel(
      totalCommentCount: totalCount,
      averageRating: totalRating / totalCount,
      fiveStarCount: comments.where((c) => c.rating == 5).length,
      fourStarCount: comments.where((c) => c.rating == 4).length,
      threeStarCount: comments.where((c) => c.rating == 3).length,
      twoStarCount: comments.where((c) => c.rating == 2).length,
      oneStarCount: comments.where((c) => c.rating == 1).length,
    );
  }

  // --- Public Metot (Arayüzden Çağrılacak Olan) ---

  /// Belirtilen salonun yorumlarını ve istatistiklerini yükler.
  Future<void> fetchComments(String saloonId) async {
    _setState(ViewState.loading);
    try {
      // Repository'den yorumları çek
      _comments = await _repository.getCommentsForSaloon(saloonId);

      // Gelen yorumlardan istatistikleri hesapla
      _calculateStats(_comments);

      _errorMessage = null;
      _setState(ViewState.idle); // Durumu 'boşta' olarak ayarla
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error); // Hata durumuna geç
    }
  }
}