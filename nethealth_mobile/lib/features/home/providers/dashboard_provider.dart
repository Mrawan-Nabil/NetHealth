import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/dashboard_repository.dart';
import '../../../core/network/dio_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../shared/models/dashboard_model.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return DashboardRepository(dio);
});

final dashboardProvider = FutureProvider<DashboardModel?>((ref) async {
  final authState = ref.watch(authProvider).valueOrNull;
  if (authState == null) return null;
  
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getDashboardData();
});
