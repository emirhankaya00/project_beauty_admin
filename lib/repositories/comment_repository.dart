// lib/data/repositories/comment_repository.dart

import 'package:flutter/foundation.dart';
import 'package:project_beauty_admin/data/models/comment_model.dart'; // Modelimizi import ediyoruz
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentRepository {
  final SupabaseClient _client;

  CommentRepository(this._client);

  /// Belirtilen salona ait tüm yorumları, kullanıcı bilgileriyle birlikte çeker.
  /// En yeni yorumlar en üstte olacak şekilde sıralar.
  Future<List<CommentModel>> getCommentsForSaloon(String saloonId) async {
    try {
      final response = await _client
          .from('comments')
          .select('''
            comment_id,
            comment_text,
            rating,
            created_at,
            users (*) 
          ''')
          .eq('saloon_id', saloonId)
          .order('created_at', ascending: false);

      // Gelen veri bir liste ise, her bir elemanı CommentModel'e dönüştür.
      if (response is List) {
        return response
            .map((data) => CommentModel.fromJson(data as Map<String, dynamic>))
            .toList();
      }

      // Beklenmedik bir durum olursa boş liste döndür.
      return [];
    } catch (e) {
      debugPrint('Yorumları çekerken hata oluştu: $e');
      // Hata durumunda kullanıcıya bir mesaj göstermek için
      // burada özel bir exception fırlatılabilir.
      throw Exception('Yorumlar yüklenemedi.');
    }
  }
}