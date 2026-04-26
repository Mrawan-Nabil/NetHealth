import 'enums.dart';
import 'doctor_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PrescriptionListModel — matches GET /patient/prescriptions list item shape
// ─────────────────────────────────────────────────────────────────────────────

class PrescriptionListModel {
  final int id;
  final String doctor;          // pre-formatted "Dr. X" string
  final String specialty;
  final String date;
  final String expires;
  final PrescriptionStatus prescriptionStatus;
  final bool isActive;
  final String diagnosis;
  final List<String> medicines;

  PrescriptionListModel({
    required this.id,
    required this.doctor,
    required this.specialty,
    required this.date,
    required this.expires,
    required this.prescriptionStatus,
    required this.isActive,
    required this.diagnosis,
    required this.medicines,
  });

  factory PrescriptionListModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionListModel(
      id:                 int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      doctor:             json['doctor']?.toString() ?? 'Unknown',
      specialty:          json['specialty']?.toString() ?? 'General Practice',
      date:               json['date']?.toString() ?? '',
      expires:            json['expires']?.toString() ?? '',
      prescriptionStatus: PrescriptionStatus.fromString(
          json['prescription_status']?.toString() ?? 'pending'),
      isActive:           json['is_active'] == true,
      diagnosis:          json['diagnosis']?.toString() ?? '',
      medicines: (json['medicines'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PrescriptionDetailModel — matches GET /patient/prescriptions/{id} shape
// ─────────────────────────────────────────────────────────────────────────────

class PrescriptionDetailModel {
  final int id;
  final String generatedDate;
  final String expires;
  final PrescriptionStatus prescriptionStatus;
  final Map<String, dynamic>? doctor;
  final Map<String, dynamic>? patient;
  final Map<String, dynamic>? diagnosis;
  final List<PrescriptionItemModel> medicines;
  final List<String> notes;

  PrescriptionDetailModel({
    required this.id,
    required this.generatedDate,
    required this.expires,
    required this.prescriptionStatus,
    this.doctor,
    this.patient,
    this.diagnosis,
    this.medicines = const [],
    this.notes = const [],
  });

  factory PrescriptionDetailModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionDetailModel(
      id:                 int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      generatedDate:      json['generated_date']?.toString() ?? '',
      expires:            json['expires']?.toString() ?? '',
      prescriptionStatus: PrescriptionStatus.fromString(
          json['prescription_status']?.toString() ?? 'pending'),
      doctor:   json['doctor'] is Map<String, dynamic> ? json['doctor'] : null,
      patient:  json['patient'] is Map<String, dynamic> ? json['patient'] : null,
      diagnosis: json['diagnosis'] is Map<String, dynamic>
          ? json['diagnosis']
          : null,
      medicines: (json['medicines'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => PrescriptionItemModel.fromJson(e))
              .toList() ??
          [],
      notes: (json['notes'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          ['No additional notes provided.'],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PrescriptionItemModel — individual medicine row inside detail
// ─────────────────────────────────────────────────────────────────────────────

class PrescriptionItemModel {
  final String name;
  final String? type;
  final String dosage;
  final String frequency;
  final String duration;
  final String instructions;

  PrescriptionItemModel({
    required this.name,
    this.type,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
  });

  factory PrescriptionItemModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionItemModel(
      name:         json['name']?.toString() ?? 'Unknown',
      type:         json['type']?.toString(),
      dosage:       json['dosage']?.toString() ?? 'As directed',
      frequency:    json['frequency']?.toString() ?? 'As directed',
      duration:     json['duration']?.toString() ?? 'N/A',
      instructions: json['instructions']?.toString() ?? 'Take as directed.',
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Legacy PrescriptionModel — kept for backward compatibility (dashboard, etc.)
// ─────────────────────────────────────────────────────────────────────────────

class PrescriptionModel {
  final int id;
  final PrescriptionStatus prescriptionStatus;
  final String createdAt;
  final String? _expiresAtApi;
  final String? diagnosisNotes;
  final List<String> medicines;
  final DoctorSummaryModel? doctor;

  PrescriptionModel({
    required this.id,
    required this.prescriptionStatus,
    required this.createdAt,
    String? expiresAtApi,
    this.diagnosisNotes,
    this.medicines = const [],
    this.doctor,
  }) : _expiresAtApi = expiresAtApi;

  String get expiresAt {
    if (_expiresAtApi != null && _expiresAtApi.isNotEmpty) {
      return _expiresAtApi;
    }
    try {
      final createdDate = DateTime.parse(createdAt);
      final expiryDate  = createdDate.add(const Duration(days: 30));
      return expiryDate.toIso8601String();
    } catch (_) {
      return '';
    }
  }

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      prescriptionStatus: PrescriptionStatus.fromString(
          json['prescription_status']?.toString() ?? ''),
      createdAt: json['created_at']?.toString() ?? '',
      expiresAtApi: json['expires_at']?.toString(),
      diagnosisNotes: json['diagnosis_notes']?.toString(),
      medicines: (json['medicines'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      doctor: (json['doctor'] != null &&
              json['doctor'] is Map<String, dynamic>)
          ? DoctorSummaryModel.fromJson(json['doctor'])
          : null,
    );
  }
}

class MedicineModel {
  final int id;
  final String name;
  final String? category;

  MedicineModel({
    required this.id,
    required this.name,
    this.category,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id:       int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name:     json['name']?.toString() ?? '',
      category: json['category']?.toString(),
    );
  }
}
