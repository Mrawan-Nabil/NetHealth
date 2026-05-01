import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/test_results_repository.dart';
import '../data/imaging_repository.dart';
import '../../../shared/models/test_result_model.dart';
import '../../../shared/models/imaging_model.dart';
import '../../../core/network/dio_provider.dart';

// ── Repositories ─────────────────────────────────────────────────────────────

final testResultsRepositoryProvider = Provider<TestResultsRepository>((ref) {
  return TestResultsRepository(ref.watch(dioProvider));
});

final imagingRepositoryProvider = Provider<ImagingRepository>((ref) {
  return ImagingRepository(ref.watch(dioProvider));
});

// ── Test Results List: GET /patient/test-results ──────────────────────────────

final testResultsProvider = FutureProvider<List<TestResultListModel>>((ref) async {
  final repo = ref.watch(testResultsRepositoryProvider);
  final response = await repo.getTestResults(perPage: 50);
  return response.data;
});

// ── Test Result Detail: GET /patient/test-results/{id} ───────────────────────

final testResultDetailProvider =
    FutureProvider.family<TestResultDetailModel, String>((ref, id) async {
  final repo = ref.watch(testResultsRepositoryProvider);
  return repo.getTestResultDetails(id);
});

// ── Imaging List: GET /patient/imaging ───────────────────────────────────────

final imagingProvider = FutureProvider<List<ImagingListModel>>((ref) async {
  final repo = ref.watch(imagingRepositoryProvider);
  final response = await repo.getImaging(perPage: 50);
  return response.data;
});

// ── Imaging Detail: GET /patient/imaging/{id} ────────────────────────────────

final imagingDetailProvider =
    FutureProvider.family<ImagingDetailModel, String>((ref, id) async {
  final repo = ref.watch(imagingRepositoryProvider);
  return repo.getImagingDetails(id);
});
