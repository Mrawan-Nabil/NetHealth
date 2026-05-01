import 'enums.dart';

/// Represents one row from GET /patient/visit-history.
/// Different from AppointmentModel — the server computes display fields.
class VisitHistoryModel {
  final int id;
  final String doctorName;
  final String doctorInitials;
  final String specialty;
  final String clinic;
  final String visitType;
  final String date;
  final String time;
  final AppointmentStatus appointmentStatus;
  final AppointmentType appointmentType;

  VisitHistoryModel({
    required this.id,
    required this.doctorName,
    required this.doctorInitials,
    required this.specialty,
    required this.clinic,
    required this.visitType,
    required this.date,
    required this.time,
    required this.appointmentStatus,
    required this.appointmentType,
  });

  factory VisitHistoryModel.fromJson(Map<String, dynamic> json) {
    return VisitHistoryModel(
      id:               int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      doctorName:       json['doctor_name']?.toString() ?? 'Unknown',
      doctorInitials:   json['doctor_initials']?.toString() ?? '?',
      specialty:        json['specialty']?.toString() ?? 'General Practice',
      clinic:           json['clinic']?.toString() ?? 'NetHealth Virtual Clinic',
      visitType:        json['visit_type']?.toString() ?? 'Consultation',
      date:             json['date']?.toString() ?? 'N/A',
      time:             json['time']?.toString() ?? 'N/A',
      appointmentStatus: AppointmentStatus.fromString(
        json['appointment_status']?.toString() ?? 'scheduled',
      ),
      appointmentType: AppointmentType.fromString(
        json['appointment_type']?.toString() ?? 'physical',
      ),
    );
  }
}
