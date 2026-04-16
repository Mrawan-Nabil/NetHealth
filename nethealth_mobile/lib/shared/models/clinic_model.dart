class ClinicModel {
  final int id;
  final String clinicName;
  final String clinicAddress;
  final String? clinicPhone;
  final String? clinicGovernorate;

  ClinicModel({
    required this.id,
    required this.clinicName,
    required this.clinicAddress,
    this.clinicPhone,
    this.clinicGovernorate,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      clinicName: json['clinic_name']?.toString() ?? '',
      clinicAddress: json['clinic_address']?.toString() ?? '',
      clinicPhone: json['clinic_phone']?.toString(),
      clinicGovernorate: json['clinic_governorate']?.toString(),
    );
  }
}
