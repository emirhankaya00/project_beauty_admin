import 'package:flutter/material.dart';
import 'package:project_beauty_admin/data/models/revenue_point.dart';
import 'package:project_beauty_admin/data/models/booking_point.dart';
import 'package:project_beauty_admin/data/models/service_stats.dart';
import 'package:project_beauty_admin/repositories/stats_repository.dart';

enum StatsState { idle, loading, error }

class StatsViewModel extends ChangeNotifier {
  final StatsRepository _repo = StatsRepository();

  StatsState _state = StatsState.idle;
  String? _error;
  DateTime from = DateTime.now().subtract(Duration(days: 30));
  DateTime to = DateTime.now();

  List<RevenuePoint> revenue = [];
  List<BookingPoint> bookings = [];
  List<ServiceStats> services = [];

  StatsState get state => _state;
  String? get error => _error;

  void _setState(StatsState s, [String? msg]) {
    _state = s;
    _error = msg;
    notifyListeners();
  }

  Future<void> fetchAll({DateTime? from, DateTime? to}) async {
    _setState(StatsState.loading);
    this.from = from ?? this.from;
    this.to   = to   ?? this.to;
    try {
      revenue  = await _repo.fetchRevenueSeries(this.from, this.to);
      bookings = await _repo.fetchBookingSeries(this.from, this.to);
      services = await _repo.fetchServiceStats(this.from, this.to);
      _setState(StatsState.idle);
    } catch (e) {
      _setState(StatsState.error, e.toString());
    }
  }
}
