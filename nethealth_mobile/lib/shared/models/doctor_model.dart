import 'enums.dart';

class DoctorSummaryModel {
  final int id;
  final String fullName;
  final String specialty;
  final ProfessionalTitle professionalTitle;
  final String? avatarUrl;
  final String? consultationFee;
  final String? clinicName;
  final String? experience;
  final String? qualifications;

  DoctorSummaryModel({
    required this.id,
    required this.fullName,
    required this.specialty,
    required this.professionalTitle,
    this.avatarUrl,
    this.consultationFee,
    this.clinicName,
    this.experience,
    this.qualifications,
  });

  factory DoctorSummaryModel.fromJson(Map<String, dynamic> json) {
    return DoctorSummaryModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      fullName: json['full_name']?.toString() ?? '',
      specialty: json['specialty']?.toString() ?? '',
      professionalTitle: ProfessionalTitle.fromString(json['professional_title']?.toString() ?? ''),
      avatarUrl: json['avatar_url']?.toString(),
      consultationFee: json['consultation_fee']?.toString(),
      clinicName: json['clinic_name']?.toString(),
      experience: json['experience']?.toString(),
      qualifications: json['qualifications']?.toString(),
    );
  }
}

class DoctorDetailModel extends DoctorSummaryModel {
  final String? medicalLicense;
  final String? syndicateId;

  DoctorDetailModel({
    required super.id,
    required super.fullName,
    required super.specialty,
    required super.professionalTitle,
    super.avatarUrl,
    super.consultationFee,
    super.clinicName,
    super.experience,
    super.qualifications,
    this.medicalLicense,
    this.syndicateId,
  });

  factory DoctorDetailModel.fromJson(Map<String, dynamic> json) {
    return DoctorDetailModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      fullName: json['full_name']?.toString() ?? '',
      specialty: json['specialty']?.toString() ?? '',
      professionalTitle: ProfessionalTitle.fromString(json['professional_title']?.toString() ?? ''),
      avatarUrl: json['avatar_url']?.toString(),
      consultationFee: json['consultation_fee']?.toString(),
      clinicName: json['clinic_name']?.toString(),
      experience: json['experience']?.toString(),
      qualifications: json['qualifications']?.toString(),
      medicalLicense: json['medical_license']?.toString(),
      syndicateId: json['syndicate_id']?.toString(),
    );
  }
}
