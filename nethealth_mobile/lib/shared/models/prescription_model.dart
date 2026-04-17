import 'enums.dart';
import 'doctor_model.dart';

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
      final expiryDate = createdDate.add(const Duration(days: 30));
      return expiryDate.toIso8601String();
    } catch (_) {
      return "";
    }
  }

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      prescriptionStatus: PrescriptionStatus.fromString(json['prescription_status']?.toString() ?? ''),
      createdAt: json['created_at']?.toString() ?? '',
      expiresAtApi: json['expires_at']?.toString(),
      diagnosisNotes: json['diagnosis_notes']?.toString(),
      medicines: (json['medicines'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      doctor: (json['doctor'] != null && json['doctor'] is Map<String, dynamic>) ? DoctorSummaryModel.fromJson(json['doctor']) : null,
    );
  }
}

class PrescriptionDetailModel {
  final int id;
  final String generatedDate;
  final PrescriptionStatus prescriptionStatus;
  final List<String> notes;
  final DoctorSummaryModel? doctor;
  final Map<String, dynamic>? patient;
  final Map<String, dynamic>? diagnosis;
  final List<PrescriptionItemModel> items;

  PrescriptionDetailModel({
    required this.id,
    required this.generatedDate,
    required this.prescriptionStatus,
    this.notes = const [],
    this.doctor,
    this.patient,
    this.diagnosis,
    this.items = const [],
  });

  factory PrescriptionDetailModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionDetailModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      generatedDate: json['generated_date']?.toString() ?? '',
      prescriptionStatus: PrescriptionStatus.fromString(json['prescription_status']?.toString() ?? ''),
      notes: (json['notes'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      doctor: (json['doctor'] != null && json['doctor'] is Map<String, dynamic>) ? DoctorSummaryModel.fromJson(json['doctor']) : null,
      patient: json['patient'] is Map<String, dynamic> ? json['patient'] : null,
      diagnosis: json['diagnosis'] is Map<String, dynamic> ? json['diagnosis'] : null,
      items: (json['items'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => PrescriptionItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class PrescriptionItemModel {
  final String name;
  final String? category;
  final String? dosage;
  final String? frequency;
  final int? durationDays;
  final String? instructions;
  final MedicineModel? medicine;

  PrescriptionItemModel({
    required this.name,
    this.category,
    this.dosage,
    this.frequency,
    this.durationDays,
    this.instructions,
    this.medicine,
  });

  factory PrescriptionItemModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionItemModel(
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString(),
      dosage: json['dosage']?.toString(),
      frequency: json['frequency']?.toString(),
      durationDays: int.tryParse(json['duration_days']?.toString() ?? ''),
      instructions: json['instructions']?.toString(),
      medicine: (json['medicine'] != null && json['medicine'] is Map<String, dynamic>) ? MedicineModel.fromJson(json['medicine']) : null,
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
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString(),
    );
  }
}
