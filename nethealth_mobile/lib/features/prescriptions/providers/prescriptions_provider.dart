import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/prescriptions_repository.dart';
import '../../../shared/models/prescription_model.dart';
import '../../../core/network/dio_provider.dart';

// ── Repository provider ───────────────────────────────────────────────────────

final prescriptionsRepositoryProvider = Provider<PrescriptionsRepository>((ref) {
  return PrescriptionsRepository(ref.watch(dioProvider));
});

// ── List: GET /patient/prescriptions ─────────────────────────────────────────

final prescriptionsProvider = FutureProvider<List<PrescriptionListModel>>((ref) async {
  final repo = ref.watch(prescriptionsRepositoryProvider);
  final response = await repo.getPrescriptions(perPage: 50);
  return response.data;
});

// ── Detail: GET /patient/prescriptions/{id} ───────────────────────────────────

final prescriptionDetailProvider =
    FutureProvider.family<PrescriptionDetailModel, String>((ref, id) async {
  final repo = ref.watch(prescriptionsRepositoryProvider);
  return repo.getPrescriptionDetails(id);
});
