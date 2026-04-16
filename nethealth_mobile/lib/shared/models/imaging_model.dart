import 'enums.dart';

class ImagingModel {
  final int id;
  final String title;
  final String modality;
  final TestResultStatus testResultStatus;
  final String scanDate;
  final String? physicianName;
  final String? clinicName;
  final String? fileFormat;

  ImagingModel({
    required this.id,
    required this.title,
    required this.modality,
    required this.testResultStatus,
    required this.scanDate,
    this.physicianName,
    this.clinicName,
    this.fileFormat,
  });

  factory ImagingModel.fromJson(Map<String, dynamic> json) {
    return ImagingModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      modality: json['modality']?.toString() ?? '',
      testResultStatus: TestResultStatus.fromString(json['test_result_status']?.toString() ?? ''),
      scanDate: json['scan_date']?.toString() ?? '',
      physicianName: json['physician_name']?.toString(),
      clinicName: json['clinic_name']?.toString(),
      fileFormat: json['file_format']?.toString(),
    );
  }
}

class ImagingDetailModel extends ImagingModel {
  final Map<String, dynamic>? fileInfo;
  final String? imageUrl;
  final Map<String, dynamic>? physicianInterpretation;

  ImagingDetailModel({
    required super.id,
    required super.title,
    required super.modality,
    required super.testResultStatus,
    required super.scanDate,
    super.physicianName,
    super.clinicName,
    super.fileFormat,
    this.fileInfo,
    this.imageUrl,
    this.physicianInterpretation,
  });

  factory ImagingDetailModel.fromJson(Map<String, dynamic> json) {
    return ImagingDetailModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      modality: json['modality']?.toString() ?? '',
      testResultStatus: TestResultStatus.fromString(json['test_result_status']?.toString() ?? ''),
      scanDate: json['scan_date']?.toString() ?? '',
      physicianName: json['physician_name']?.toString(),
      clinicName: json['clinic_name']?.toString(),
      fileFormat: json['file_format']?.toString(),
      fileInfo: json['file_info'] is Map<String, dynamic> ? json['file_info'] : null,
      imageUrl: json['image_url']?.toString(),
      physicianInterpretation: json['physician_interpretation'] is Map<String, dynamic> ? json['physician_interpretation'] : null,
    );
  }
}
