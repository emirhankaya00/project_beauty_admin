import 'package:flutter/foundation.dart';
// Projendeki user_model.dart dosyasının doğru yolunu belirttiğinden emin ol
import './user_model.dart';

@immutable
class CommentModel {
  final String commentId;
  final int rating; // 1 ile 5 arası
  final String commentText;
  final DateTime createdAt;

  // DÜZELTME: Yorumu yapan kullanıcının bilgilerini tutmak için
  // UserModel türünde bir alan ekledik.
  final UserModel? user;

  const CommentModel({
    required this.commentId,
    required this.rating,
    required this.commentText,
    required this.createdAt,
    this.user, // Constructor'a eklendi
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    // Yorumla birlikte gelen 'users' (veya 'profiles') tablosundaki
    // kullanıcı bilgisini ayrıştırıyoruz.
    UserModel? parsedUser;
    if (json['users'] != null && json['users'] is Map<String, dynamic>) {
      parsedUser = UserModel.fromJson(json['users']);
    } else if (json['profiles'] != null && json['profiles'] is Map<String, dynamic>) {
      // Bazen Supabase 'profiles' adını kullanır.
      parsedUser = UserModel.fromJson(json['profiles']);
    }

    return CommentModel(
      commentId: json['comment_id'] as String? ?? '',
      commentText: json['comment_text'] as String? ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      user: parsedUser, // Ayrıştırılan kullanıcı modelini ata
    );
  }
}