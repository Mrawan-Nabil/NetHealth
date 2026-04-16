import 'appointment_model.dart';
import 'enums.dart';

class DashboardModel {
  final HealthOverview healthOverview;
  final DashboardStats stats;
  final AppointmentModel? nextAppointment;
  final List<RecentRecordModel> recentRecords;

  DashboardModel({
    required this.healthOverview,
    required this.stats,
    this.nextAppointment,
    this.recentRecords = const [],
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      healthOverview: (json['health_overview'] != null && json['health_overview'] is Map<String, dynamic>)
          ? HealthOverview.fromJson(json['health_overview'])
          : HealthOverview.fromJson({}),
      stats: (json['stats'] != null && json['stats'] is Map<String, dynamic>)
          ? DashboardStats.fromJson(json['stats'])
          : DashboardStats.fromJson({}),
      nextAppointment: (json['next_appointment'] != null && json['next_appointment'] is Map<String, dynamic>) 
          ? AppointmentModel.fromJson(json['next_appointment']) 
          : null,
      recentRecords: (json['recent_records'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => RecentRecordModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class HealthOverview {
  final BloodType? bloodType;
  final List<String> allergies;
  final String? chronicConditions;
  final PrimaryDoctorModel? primaryDoctor;

  HealthOverview({
    this.bloodType,
    this.allergies = const [],
    this.chronicConditions,
    this.primaryDoctor,
  });

  factory HealthOverview.fromJson(Map<String, dynamic> json) {
    return HealthOverview(
      bloodType: BloodType.fromString(json['blood_type']?.toString()),
      allergies: (json['allergies'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      chronicConditions: json['chronic_conditions']?.toString(),
      primaryDoctor: (json['primary_doctor'] != null && json['primary_doctor'] is Map<String, dynamic>) 
          ? PrimaryDoctorModel.fromJson(json['primary_doctor']) 
          : null,
    );
  }
}

class PrimaryDoctorModel {
  final String fullName;
  final String specialty;
  final String? avatarUrl;

  PrimaryDoctorModel({
    required this.fullName,
    required this.specialty,
    this.avatarUrl,
  });

  factory PrimaryDoctorModel.fromJson(Map<String, dynamic> json) {
    return PrimaryDoctorModel(
      fullName: json['full_name']?.toString() ?? '',
      specialty: json['specialty']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString(),
    );
  }
}

class DashboardStats {
  final int upcomingAppointments;
  final int activePrescriptions;
  final int pendingTests;

  DashboardStats({
    required this.upcomingAppointments,
    required this.activePrescriptions,
    required this.pendingTests,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      upcomingAppointments: int.tryParse(json['upcoming_appointments']?.toString() ?? '0') ?? 0,
      activePrescriptions: int.tryParse(json['active_prescriptions']?.toString() ?? '0') ?? 0,
      pendingTests: int.tryParse(json['pending_tests']?.toString() ?? '0') ?? 0,
    );
  }
}

class RecentRecordModel {
  final int appointmentId;
  final String doctorFullName;
  final String appointmentTime;
  final String status;

  RecentRecordModel({
    required this.appointmentId,
    required this.doctorFullName,
    required this.appointmentTime,
    required this.status,
  });

  factory RecentRecordModel.fromJson(Map<String, dynamic> json) {
    return RecentRecordModel(
      appointmentId: int.tryParse(json['appointment_id']?.toString() ?? '0') ?? 0,
      doctorFullName: json['doctor_full_name']?.toString() ?? '',
      appointmentTime: json['appointment_time']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}
