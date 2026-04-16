class StandardResponse<T> {
  final String status;
  final String message;
  final T data;

  StandardResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  /// Factory constructor to parse standard response envelope from JSON.
  /// [fromJsonT] is a callback that instructs how to parse the generic `data` field.
  factory StandardResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return StandardResponse<T>(
      status: json['status'] as String? ?? 'success',
      message: json['message'] as String? ?? '',
      data: fromJsonT(json['data']),
    );
  }
}
