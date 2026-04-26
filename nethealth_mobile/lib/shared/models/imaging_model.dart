import 'enums.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ImagingListModel — matches GET /patient/imaging list item shape
// ─────────────────────────────────────────────────────────────────────────────

class ImagingListModel {
  final int id;
  final String title;
  final String type;          // MRI / X-Ray / CT Scan / Ultrasound / Imaging
  final TestResultStatus testResultStatus;
  final String hospital;
  final String physician;
  final String scanDate;
  final ImagingFileInfo file;

  ImagingListModel({
    required this.id,
    required this.title,
    required this.type,
    required this.testResultStatus,
    required this.hospital,
    required this.physician,
    required this.scanDate,
    required this.file,
  });

  factory ImagingListModel.fromJson(Map<String, dynamic> json) {
    return ImagingListModel(
      id:               int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title:            json['title']?.toString() ?? 'Diagnostic Scan',
      type:             json['type']?.toString() ?? 'Imaging',
      testResultStatus: TestResultStatus.fromString(
          json['test_result_status']?.toString() ?? 'pending'),
      hospital:         json['hospital']?.toString() ?? 'NetHealth Central',
      physician:        json['physician']?.toString() ?? 'Unknown',
      scanDate:         json['scan_date']?.toString() ?? 'N/A',
      file: ImagingFileInfo.fromJson(
          json['file'] is Map<String, dynamic> ? json['file'] : {}),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ImagingDetailModel — matches GET /patient/imaging/{id} shape
// ─────────────────────────────────────────────────────────────────────────────

class ImagingDetailModel {
  final int id;
  final String title;
  final String type;
  final TestResultStatus testResultStatus;
  final ImagingFileInfoDetail? fileInfo;
  final ImagingNotes? notes;
  final List<ImagingImage> images;

  ImagingDetailModel({
    required this.id,
    required this.title,
    required this.type,
    required this.testResultStatus,
    this.fileInfo,
    this.notes,
    this.images = const [],
  });

  factory ImagingDetailModel.fromJson(Map<String, dynamic> json) {
    return ImagingDetailModel(
      id:               int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title:            json['title']?.toString() ?? 'Diagnostic Scan',
      type:             json['type']?.toString() ?? 'Imaging',
      testResultStatus: TestResultStatus.fromString(
          json['test_result_status']?.toString() ?? 'pending'),
      fileInfo: json['file_info'] is Map<String, dynamic>
          ? ImagingFileInfoDetail.fromJson(json['file_info'])
          : null,
      notes: json['notes'] is Map<String, dynamic>
          ? ImagingNotes.fromJson(json['notes'])
          : null,
      images: (json['images'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => ImagingImage.fromJson(e))
              .toList() ??
          [],
    );
  }

  String? get primaryImageUrl => images.isNotEmpty ? images.first.url : null;
}

// ── Support classes ───────────────────────────────────────────────────────────

class ImagingFileInfo {
  final String name;
  final String format;
  final String size;

  ImagingFileInfo({required this.name, required this.format, required this.size});

  factory ImagingFileInfo.fromJson(Map<String, dynamic> json) {
    return ImagingFileInfo(
      name:   json['name']?.toString() ?? '',
      format: json['format']?.toString() ?? 'FILE',
      size:   json['size']?.toString() ?? 'Unknown',
    );
  }
}

class ImagingFileInfoDetail {
  final String type;
  final String size;
  final String physician;
  final String radiologyCenter;
  final String scanDate;
  final String format;

  ImagingFileInfoDetail({
    required this.type,
    required this.size,
    required this.physician,
    required this.radiologyCenter,
    required this.scanDate,
    required this.format,
  });

  factory ImagingFileInfoDetail.fromJson(Map<String, dynamic> json) {
    return ImagingFileInfoDetail(
      type:            json['type']?.toString() ?? 'Imaging',
      size:            json['size']?.toString() ?? 'Unknown',
      physician:       json['physician']?.toString() ?? 'Unknown',
      radiologyCenter: json['radiology_center']?.toString() ?? 'NetHealth Central',
      scanDate:        json['scan_date']?.toString() ?? 'N/A',
      format:          json['format']?.toString() ?? 'FILE',
    );
  }
}

class ImagingNotes {
  final String physicianInterpretation;
  final String author;

  ImagingNotes({required this.physicianInterpretation, required this.author});

  factory ImagingNotes.fromJson(Map<String, dynamic> json) {
    final interp = json['physician_interpretation'];
    if (interp is Map<String, dynamic>) {
      return ImagingNotes(
        physicianInterpretation: interp['text']?.toString() ?? '',
        author:                  interp['author']?.toString() ?? '',
      );
    }
    return ImagingNotes(physicianInterpretation: '', author: '');
  }
}

class ImagingImage {
  final int id;
  final String url;
  final bool active;

  ImagingImage({required this.id, required this.url, required this.active});

  factory ImagingImage.fromJson(Map<String, dynamic> json) {
    return ImagingImage(
      id:     int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      url:    json['url']?.toString() ?? '',
      active: json['active'] == true,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Legacy model alias — kept so existing code doesn't break
// ─────────────────────────────────────────────────────────────────────────────
typedef ImagingModel = ImagingListModel;
