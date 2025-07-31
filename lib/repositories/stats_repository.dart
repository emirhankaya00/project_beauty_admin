import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_beauty_admin/data/models/revenue_point.dart';
import 'package:project_beauty_admin/data/models/booking_point.dart';
import 'package:project_beauty_admin/data/models/service_stats.dart';

class StatsRepository {
  final SupabaseClient _db = Supabase.instance.client;

  Future<List<RevenuePoint>> fetchRevenueSeries(DateTime from, DateTime to) async {
    final res = await _db
        .rpc('revenue_series', params: {
      'start_date': from.toIso8601String(),
      'end_date': to.toIso8601String(),
    });
    // assume returns [{date:..., amount:...},...]
    return (res as List).map((j) => RevenuePoint(
      date: DateTime.parse(j['date']),
      amount: (j['amount'] as num).toDouble(),
    )).toList();
  }

  Future<List<BookingPoint>> fetchBookingSeries(DateTime from, DateTime to) async {
    final res = await _db
        .rpc('booking_series', params: {
      'start_date': from.toIso8601String(),
      'end_date': to.toIso8601String(),
    });
    return (res as List).map((j) => BookingPoint(
      date: DateTime.parse(j['date']),
      count: j['count'] as int,
    )).toList();
  }

  Future<List<ServiceStats>> fetchServiceStats(DateTime from, DateTime to) async {
    final res = await _db
        .from('service_stats')
        .select()
        .gte('date', from.toIso8601String())
        .lte('date', to.toIso8601String());
    return (res as List).map((j) => ServiceStats(
      serviceName: j['service_name'],
      totalSold: j['total_sold'],
      totalRevenue: (j['total_revenue'] as num).toDouble(),
    )).toList();
  }
}
