import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/medical_records_repository.dart';
import '../../../core/network/dio_provider.dart';

final medicalRecordsRepositoryProvider = Provider<MedicalRecordsRepository>((ref) {
  return MedicalRecordsRepository(ref.watch(dioProvider));
});
