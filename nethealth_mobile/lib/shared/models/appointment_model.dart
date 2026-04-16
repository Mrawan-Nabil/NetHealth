import 'enums.dart';
import 'doctor_model.dart';
import 'clinic_model.dart';

class AppointmentModel {
  final int id;
  final String appointmentTime;
  final AppointmentStatus status;
  final AppointmentType appointmentType;
  final String? visitReason;
  final String? cancelledBy;
  final String? cancellationReason;
  final DoctorSummaryModel? doctor;
  final ClinicModel? clinic;

  AppointmentModel({
    required this.id,
    required this.appointmentTime,
    required this.status,
    required this.appointmentType,
    this.visitReason,
    this.cancelledBy,
    this.cancellationReason,
    this.doctor,
    this.clinic,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      appointmentTime: json['appointment_time']?.toString() ?? '',
      status: AppointmentStatus.fromString((json['appointment_status'] ?? json['status'])?.toString() ?? ''),
      appointmentType: AppointmentType.fromString((json['appointment_type'] ?? json['type'])?.toString() ?? ''),
      visitReason: json['visit_reason']?.toString(),
      cancelledBy: json['cancelled_by']?.toString(),
      cancellationReason: json['cancellation_reason']?.toString(),
      doctor: (json['doctor'] != null && json['doctor'] is Map<String, dynamic>) ? DoctorSummaryModel.fromJson(json['doctor']) : null,
      clinic: (json['clinic'] != null && json['clinic'] is Map<String, dynamic>) ? ClinicModel.fromJson(json['clinic']) : null,
    );
  }
}
