import 'enums.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TestResultListModel — matches GET /patient/test-results list item shape
// ─────────────────────────────────────────────────────────────────────────────

class TestResultListModel {
  final int id;
  final String name;
  final String category;
  final String lab;             // "Ordered by Dr. X" or "Lab Result"
  final String date;
  final TestResultStatus testResultStatus;
  final String format;

  TestResultListModel({
    required this.id,
    required this.name,
    required this.category,
    required this.lab,
    required this.date,
    required this.testResultStatus,
    required this.format,
  });

  factory TestResultListModel.fromJson(Map<String, dynamic> json) {
    return TestResultListModel(
      id:               int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name:             json['name']?.toString() ?? 'Unnamed Test',
      category:         json['category']?.toString() ?? 'Lab Result',
      lab:              json['lab']?.toString() ?? 'Lab Result',
      date:             json['date']?.toString() ?? 'N/A',
      testResultStatus: TestResultStatus.fromString(
          json['test_result_status']?.toString() ?? 'pending'),
      format:           json['format']?.toString() ?? 'FILE',
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TestResultDetailModel — matches GET /patient/test-results/{id} shape
// ─────────────────────────────────────────────────────────────────────────────

class TestResultDetailModel {
  final int id;
  final String name;
  final String category;
  final String lab;
  final String date;
  final TestResultStatus testResultStatus;
  final String format;
  final String fileSize;
  final String? fileUrl;
  final String? mimeType;
  final String? notes;

  TestResultDetailModel({
    required this.id,
    required this.name,
    required this.category,
    required this.lab,
    required this.date,
    required this.testResultStatus,
    required this.format,
    required this.fileSize,
    this.fileUrl,
    this.mimeType,
    this.notes,
  });

  factory TestResultDetailModel.fromJson(Map<String, dynamic> json) {
    return TestResultDetailModel(
      id:               int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name:             json['name']?.toString() ?? 'Unnamed Test',
      category:         json['category']?.toString() ?? 'Lab Result',
      lab:              json['lab']?.toString() ?? 'Lab Result',
      date:             json['date']?.toString() ?? 'N/A',
      testResultStatus: TestResultStatus.fromString(
          json['test_result_status']?.toString() ?? 'pending'),
      format:           json['format']?.toString() ?? 'FILE',
      fileSize:         json['file_size']?.toString() ?? 'Unknown',
      fileUrl:          json['file_url']?.toString(),
      mimeType:         json['mime_type']?.toString(),
      notes:            json['notes']?.toString(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Legacy alias
// ─────────────────────────────────────────────────────────────────────────────
typedef TestResultModel = TestResultListModel;
