import 'enums.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DoctorModel — returned by GET /v1/doctors (top-level, for booking flow).
// Separate from DoctorSummaryModel which is nested inside appointment payloads.
// ─────────────────────────────────────────────────────────────────────────────

class DoctorModel {
  final int id;
  final String fullName;
  final String specialty;
  final ProfessionalTitle professionalTitle;
  final String? avatarUrl;
  final String? consultationFee;
  final String? experience;
  final String? qualifications;
  final String? medicalLicense;

  DoctorModel({
    required this.id,
    required this.fullName,
    required this.specialty,
    required this.professionalTitle,
    this.avatarUrl,
    this.consultationFee,
    this.experience,
    this.qualifications,
    this.medicalLicense,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id:                 int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      fullName:           json['full_name']?.toString() ?? 'Unknown Doctor',
      specialty:          json['specialty']?.toString() ?? '',
      professionalTitle:  ProfessionalTitle.fromString(json['professional_title']?.toString() ?? ''),
      avatarUrl:          json['avatar_url']?.toString(),
      consultationFee:    json['consultation_fee']?.toString(),
      experience:         json['experience']?.toString(),
      qualifications:     json['qualifications']?.toString(),
      medicalLicense:     json['medical_license']?.toString(),
    );
  }

  /// Generates initials from fullName — safe for empty/null names.
  /// "Dr. John Doe" → skips honorific prefixes → "JD"
  String get initials {
    if (fullName.trim().isEmpty) return '?';
    // Strip common honorifics
    final clean = fullName
        .replaceAll(RegExp(r'^(Dr\.?|Prof\.?|Mr\.?|Ms\.?|Mrs\.?)\s+', caseSensitive: false), '')
        .trim();
    final parts = clean.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    // If only one name, take first 2 letters
    if (clean.length >= 2) {
      return clean.substring(0, 2).toUpperCase();
    }
    return clean.isNotEmpty ? clean[0].toUpperCase() : '?';
  }

  /// Display label including professional title prefix.
  String get displayName {
    final prefix = (professionalTitle == ProfessionalTitle.professor ||
            professionalTitle == ProfessionalTitle.consultant)
        ? 'Prof.'
        : 'Dr.';
    return '$prefix $fullName';
  }
}
