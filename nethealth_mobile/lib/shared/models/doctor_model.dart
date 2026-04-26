import 'enums.dart';
import 'clinic_model.dart';


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
  final ClinicModel? clinic;

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
    this.clinic,
  });

  factory DoctorSummaryModel.fromJson(Map<String, dynamic> json) {
    // Shape A: top-level from GET /doctors — full_name and avatar_url at root.
    // Shape B: nested from appointment payloads — doctor.user.full_name / doctor.user.avatar (raw path).
    final topFullName = json['full_name']?.toString();
    final nestedFullName = json['user'] is Map<String, dynamic>
        ? json['user']['full_name']?.toString()
        : null;

    // avatar_url is the resolved URL (Shape A or PatientProfileResource).
    // user.avatar_url may also be present if the backend resolves it.
    // user.avatar is the raw storage path — we do NOT use it directly; fall back to null.
    final topAvatarUrl = json['avatar_url']?.toString();
    final nestedAvatarUrl = json['user'] is Map<String, dynamic>
        ? (json['user']['avatar_url'] ?? json['user']['avatar_url'])?.toString()
        : null;

    return DoctorSummaryModel(
      id: int.tryParse((json['id'] ?? json['user_id'])?.toString() ?? '0') ?? 0,
      fullName: topFullName ?? nestedFullName ?? 'Unknown Doctor',
      specialty: json['specialty']?.toString() ?? 'General Physician',
      professionalTitle: ProfessionalTitle.fromString(json['professional_title']?.toString() ?? ''),
      avatarUrl: topAvatarUrl ?? nestedAvatarUrl,
      consultationFee: json['consultation_fee']?.toString(),
      clinicName: json['clinic_name']?.toString() ?? (json['clinic'] is Map<String, dynamic> ? json['clinic']['name']?.toString() : null),
      experience: json['experience']?.toString(),
      qualifications: json['qualifications']?.toString(),
      clinic: json['clinic'] != null ? ClinicModel.fromJson(json['clinic'] as Map<String, dynamic>) : null,
    );
  }

  String get initials {
    if (fullName.trim().isEmpty) return '?';
    final clean = fullName
        .replaceAll(RegExp(r'^(Dr\.?|Prof\.?|Mr\.?|Ms\.?|Mrs\.?)\s+', caseSensitive: false), '')
        .trim();
    final parts = clean.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (clean.length >= 2) {
      return clean.substring(0, 2).toUpperCase();
    }
    return clean.isNotEmpty ? clean[0].toUpperCase() : '?';
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
    super.clinic,
    this.medicalLicense,
    this.syndicateId,
  });

  factory DoctorDetailModel.fromJson(Map<String, dynamic> json) {
    // Shape A: top-level from GET /doctors — full_name and avatar_url at root.
    // Shape B: nested from appointment payloads — doctor.user.full_name.
    final topFullName = json['full_name']?.toString();
    final nestedFullName = json['user'] is Map<String, dynamic>
        ? json['user']['full_name']?.toString()
        : null;

    final topAvatarUrl = json['avatar_url']?.toString();
    final nestedAvatarUrl = json['user'] is Map<String, dynamic>
        ? json['user']['avatar_url']?.toString()
        : null;

    return DoctorDetailModel(
      id: int.tryParse((json['id'] ?? json['user_id'])?.toString() ?? '0') ?? 0,
      fullName: topFullName ?? nestedFullName ?? 'Unknown Doctor',
      specialty: json['specialty']?.toString() ?? 'General Physician',
      professionalTitle: ProfessionalTitle.fromString(json['professional_title']?.toString() ?? ''),
      avatarUrl: topAvatarUrl ?? nestedAvatarUrl,
      consultationFee: json['consultation_fee']?.toString(),
      clinicName: json['clinic_name']?.toString() ?? (json['clinic'] is Map<String, dynamic> ? json['clinic']['name']?.toString() : null),
      experience: json['experience']?.toString(),
      qualifications: json['qualifications']?.toString(),
      medicalLicense: json['medical_license']?.toString(),
      syndicateId: json['syndicate_id']?.toString(),
      clinic: json['clinic'] != null ? ClinicModel.fromJson(json['clinic'] as Map<String, dynamic>) : null,
    );
  }
}
