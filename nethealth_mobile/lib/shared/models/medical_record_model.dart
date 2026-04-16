import 'enums.dart';
import 'doctor_model.dart';
import 'appointment_model.dart';

class MedicalRecordModel {
  final int id;
  final RecordStatus recordStatus;
  final String? diagnosisNotes;
  final String createdAt;
  final DoctorSummaryModel? doctor;
  final AppointmentModel? appointment;

  MedicalRecordModel({
    required this.id,
    required this.recordStatus,
    this.diagnosisNotes,
    required this.createdAt,
    this.doctor,
    this.appointment,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      recordStatus: RecordStatus.fromString(json['record_status']?.toString() ?? ''),
      diagnosisNotes: json['diagnosis_notes']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      doctor: (json['doctor'] != null && json['doctor'] is Map<String, dynamic>) ? DoctorSummaryModel.fromJson(json['doctor']) : null,
      appointment: (json['appointment'] != null && json['appointment'] is Map<String, dynamic>) ? AppointmentModel.fromJson(json['appointment']) : null,
    );
  }
}
