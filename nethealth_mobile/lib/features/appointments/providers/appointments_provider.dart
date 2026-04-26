import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/appointments_repository.dart';
import '../data/doctor_repository.dart';
import '../../../shared/models/appointment_model.dart';
import '../../../shared/models/doctor_booking_model.dart';
import '../../../core/network/dio_provider.dart';

// ── Repositories ─────────────────────────────────────────────────────────────

final appointmentsRepositoryProvider = Provider<AppointmentsRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AppointmentsRepository(dio);
});

final doctorRepositoryProvider = Provider<DoctorRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return DoctorRepository(dio);
});

// ── Providers ─────────────────────────────────────────────────────────────────

/// Patient's own appointment list — invalidated after book/cancel actions.
final appointmentsProvider = FutureProvider<List<AppointmentModel>>((ref) async {
  final repo = ref.watch(appointmentsRepositoryProvider);
  final response = await repo.getAppointments(perPage: 50);
  return response.data;
});

/// Detail of a specific appointment.
final appointmentDetailProvider = FutureProvider.family<AppointmentModel, String>((ref, id) async {
  final repo = ref.watch(appointmentsRepositoryProvider);
  return repo.getAppointmentDetails(id);
});

/// All available doctors — used in the Doctor Selection booking flow.
final doctorsProvider = FutureProvider<List<DoctorModel>>((ref) async {
  final repo = ref.watch(doctorRepositoryProvider);
  return repo.getDoctors();
});
