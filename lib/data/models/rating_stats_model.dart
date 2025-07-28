import 'package:flutter/foundation.dart';

@immutable
class RatingStatsModel {
  final double averageRating;
  final int totalCommentCount;
  final int fiveStarCount;
  final int fourStarCount;
  final int threeStarCount;
  final int twoStarCount;
  final int oneStarCount;

  const RatingStatsModel({
    this.averageRating = 0.0,
    this.totalCommentCount = 0,
    this.fiveStarCount = 0,
    this.fourStarCount = 0,
    this.threeStarCount = 0,
    this.twoStarCount = 0,
    this.oneStarCount = 0,
  });

  // Bu getter'lar, ilerleme çubuklarını doldururken
  // 0 ile 1 arasında bir değer hesaplamak için kullanılır.
  double get fiveStarPercentage => totalCommentCount == 0 ? 0 : fiveStarCount / totalCommentCount;
  double get fourStarPercentage => totalCommentCount == 0 ? 0 : fourStarCount / totalCommentCount;
  double get threeStarPercentage => totalCommentCount == 0 ? 0 : threeStarCount / totalCommentCount;
  double get twoStarPercentage => totalCommentCount == 0 ? 0 : twoStarCount / totalCommentCount;
  double get oneStarPercentage => totalCommentCount == 0 ? 0 : oneStarCount / totalCommentCount;
}