import 'enums.dart';

class PatientProfileModel {
  final String fullName;
  final String email;
  final String? phone;
  final String? nationalId;
  final Gender gender;
  final String? birthDate;
  final String? governorate;
  final BloodType? bloodType;
  final List<String> allergies;
  final String? chronicConditions;
  final EmergencyContact? emergencyContact;

  PatientProfileModel({
    required this.fullName,
    required this.email,
    this.phone,
    this.nationalId,
    required this.gender,
    this.birthDate,
    this.governorate,
    this.bloodType,
    this.allergies = const [],
    this.chronicConditions,
    this.emergencyContact,
  });

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) {
    return PatientProfileModel(
      fullName: json['full_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      nationalId: json['national_id']?.toString(),
      gender: Gender.fromString(json['gender']?.toString() ?? ''),
      birthDate: json['birth_date']?.toString(),
      governorate: json['governorate']?.toString(),
      bloodType: BloodType.fromString(json['blood_type']?.toString()),
      allergies: (json['allergies'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      chronicConditions: json['chronic_conditions']?.toString(),
      emergencyContact: (json['emergency_contact'] != null && json['emergency_contact'] is Map<String, dynamic>) 
          ? EmergencyContact.fromJson(json['emergency_contact'])
          : null,
    );
  }
}

class EmergencyContact {
  final String? name;
  final String? phone;
  final String? relationship;

  EmergencyContact({this.name, this.phone, this.relationship});

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name']?.toString(),
      phone: json['phone']?.toString(),
      relationship: json['relationship']?.toString(),
    );
  }
}
