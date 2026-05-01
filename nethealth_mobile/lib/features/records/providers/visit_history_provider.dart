import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/visit_history_repository.dart';
import '../../../shared/models/visit_history_model.dart';
import '../../../core/network/dio_provider.dart';

// ── Repository provider ───────────────────────────────────────────────────────

final visitHistoryRepositoryProvider = Provider<VisitHistoryRepository>((ref) {
  return VisitHistoryRepository(ref.watch(dioProvider));
});

// ── Visit History List: GET /patient/visit-history ───────────────────────────

final visitHistoryProvider = FutureProvider<List<VisitHistoryModel>>((ref) async {
  final repo = ref.watch(visitHistoryRepositoryProvider);
  final response = await repo.getVisitHistory(perPage: 50);
  return response.data;
});
