import 'enums.dart';

class TestResultModel {
  final int id;
  final String name;
  final String? category;
  final TestResultStatus testResultStatus;
  final String uploadedAt;

  TestResultModel({
    required this.id,
    required this.name,
    this.category,
    required this.testResultStatus,
    required this.uploadedAt,
  });

  factory TestResultModel.fromJson(Map<String, dynamic> json) {
    return TestResultModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString(),
      testResultStatus: TestResultStatus.fromString(json['test_result_status']?.toString() ?? ''),
      uploadedAt: json['uploaded_at']?.toString() ?? '',
    );
  }
}

class TestResultDetailModel extends TestResultModel {
  final String? fileUrl;
  final String? mimeType;
  final String? notes;

  TestResultDetailModel({
    required super.id,
    required super.name,
    super.category,
    required super.testResultStatus,
    required super.uploadedAt,
    this.fileUrl,
    this.mimeType,
    this.notes,
  });

  factory TestResultDetailModel.fromJson(Map<String, dynamic> json) {
    return TestResultDetailModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString(),
      testResultStatus: TestResultStatus.fromString(json['test_result_status']?.toString() ?? ''),
      uploadedAt: json['uploaded_at']?.toString() ?? '',
      fileUrl: json['file_url']?.toString(),
      mimeType: json['mime_type']?.toString(),
      notes: json['notes']?.toString(),
    );
  }
}
