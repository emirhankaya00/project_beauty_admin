// lib/core/provider_list.dart

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:project_beauty_admin/viewmodels/auth_viewmodel.dart';
import 'package:project_beauty_admin/viewmodels/reservation_viewmodel.dart';
import 'package:project_beauty_admin/viewmodels/service_viewmodel.dart';
import 'package:project_beauty_admin/viewmodels/staff_viewmodel.dart';
import 'package:project_beauty_admin/viewmodels/comments_viewmodel.dart'; // Yorumlar ViewModel'i
import 'package:project_beauty_admin/viewmodels/campaigns_viewmodel.dart';

import '../viewmodels/saloon_viewmodel.dart';
import '../viewmodels/stats_viewmodel.dart';

final List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(create: (_) => AuthViewModel()),
  ChangeNotifierProvider(create: (_) => ServiceViewModel()),
  ChangeNotifierProvider(create: (_) => StaffViewModel()),
  ChangeNotifierProvider(create: (_) => ReservationViewModel()),
  ChangeNotifierProvider(create: (_) => CommentsViewModel()), // Yorumları ekledik
  ChangeNotifierProvider(create: (_) => CampaignsViewModel()),
  ChangeNotifierProvider(create: (_) => SaloonViewModel()),
  ChangeNotifierProvider(create: (_) => StatsViewModel()),

];