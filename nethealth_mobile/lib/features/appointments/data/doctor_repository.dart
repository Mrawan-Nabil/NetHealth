import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/utils/app_error.dart';
import '../../../shared/models/doctor_booking_model.dart';

class DoctorRepository {
  final Dio _dio;
  DoctorRepository(this._dio);

  /// Fetches all active doctors from GET /v1/doctors.
  /// Returns the raw list parsed into [DoctorModel].
  Future<List<DoctorModel>> getDoctors() async {
    try {
      final response = await _dio.get(ApiEndpoints.doctors);
      // Response shape: { status, message, data: [ {...}, ... ] }
      final raw = response.data;
      final List<dynamic> list = raw['data'] as List<dynamic>? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map((j) => DoctorModel.fromJson(j))
          .toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  AppError _mapDioError(DioException e) {
    if (e.response?.statusCode == 401) return const UnauthorizedError();
    if (e.response?.statusCode == 422) {
      final errors = (e.response?.data['errors'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, List<String>.from(v as List)));
      return ValidationError(errors ?? {});
    }
    return UnknownError(e.message ?? 'Unknown error');
  }
}
