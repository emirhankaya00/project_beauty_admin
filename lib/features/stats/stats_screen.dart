import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:project_beauty_admin/viewmodels/stats_viewmodel.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StatsViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('İstatistik & Raporlar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Builder(
          builder: (_) {
            if (vm.state == StatsState.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.state == StatsState.error) {
              return Center(child: Text('Hata: ${vm.error}'));
            }
            return ListView(
              children: [
                _buildDateRangePicker(context, vm),
                const SizedBox(height: 16),
                _buildSummaryCards(vm),
                const SizedBox(height: 24),
                _buildRevenueChart(vm),
                const SizedBox(height: 24),
                _buildBookingChart(vm),
                const SizedBox(height: 24),
                _buildServiceTable(vm),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateRangePicker(BuildContext c, StatsViewModel vm) {
    final fmt = DateFormat('dd.MM.yyyy');
    return Row(
      children: [
        Expanded(child: Text('Aralık: ${fmt.format(vm.from)} → ${fmt.format(vm.to)}')),
        OutlinedButton(
          onPressed: () async {
            final r = await showDateRangePicker(
              context: c,
              firstDate: DateTime.now().subtract(Duration(days: 365)),
              lastDate: DateTime.now().add(Duration(days: 1)),
              initialDateRange: DateTimeRange(start: vm.from, end: vm.to),
            );
            if (r != null) vm.fetchAll(from: r.start, to: r.end);
          },
          child: const Text('Değiştir'),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(StatsViewModel vm) {
    final totalRev = vm.revenue.fold(0.0, (sum, p) => sum + p.amount);
    final totalBookings = vm.bookings.fold(0, (sum, p) => sum + p.count);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _card('Ciro', '₺${totalRev.toStringAsFixed(0)}'),
        _card('Rezervasyon', '$totalBookings adet'),
        // istersen başka metrikler de ekle
      ],
    );
  }
  Widget _card(String title, String value) => Card(
    color: AppColors.primaryColor,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(title, style: AppTextStyles.bodyText2.copyWith(color: Colors.white)),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.headline3.copyWith(color: Colors.white)),
        ],
      ),
    ),
  );

  Widget _buildRevenueChart(StatsViewModel vm) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 5)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: vm.revenue.map((p) => FlSpot(p.date.millisecondsSinceEpoch.toDouble(), p.amount)).toList(),
              isCurved: true,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBookingChart(StatsViewModel vm) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 5)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          ),
          barGroups: vm.bookings.map((p) => BarChartGroupData(
            x: p.date.millisecondsSinceEpoch ~/ 100000,
            barRods: [BarChartRodData(toY: p.count.toDouble())],
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildServiceTable(StatsViewModel vm) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Hizmet')),
        DataColumn(label: Text('Satış')),
        DataColumn(label: Text('Ciro')),
      ],
      rows: vm.services.map((s) => DataRow(cells: [
        DataCell(Text(s.serviceName)),
        DataCell(Text(s.totalSold.toString())),
        DataCell(Text('₺${s.totalRevenue.toStringAsFixed(0)}')),
      ])).toList(),
    );
  }
}
