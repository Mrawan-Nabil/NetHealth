import 'pagination_meta.dart';

class PaginatedResponse<T> {
  final String status;
  final String message;
  final List<T> data;
  final PaginationMeta meta;

  PaginatedResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.meta,
  });

  /// Factory constructor to parse paginated lists from the JSON envelope.
  /// [fromJsonT] parses individual items inside the data array.
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    return PaginatedResponse<T>(
      status: json['status'] as String? ?? 'success',
      message: json['message'] as String? ?? '',
      data: dataList.map((item) => fromJsonT(item)).toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>? ?? {}),
    );
  }
}
