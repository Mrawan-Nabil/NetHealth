import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/models/paginated_response.dart';
import '../../../shared/models/appointment_model.dart';
import '../../../core/utils/app_error.dart';

class VisitHistoryRepository {
  final Dio _dio;

  VisitHistoryRepository(this._dio);

  Future<PaginatedResponse<AppointmentModel>> getVisitHistory({
    String? status,
    int perPage = 20,
    int? page,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.patientVisitHistory,
        queryParameters: {
          if (status != null && status.isNotEmpty) 'status': status,
          'per_page': perPage,
          if (page != null) 'page': page,
        },
      );
      return PaginatedResponse<AppointmentModel>.fromJson(
        response.data,
        (json) => AppointmentModel.fromJson(json),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw const UnauthorizedError();
      throw UnknownError(e.message ?? 'Unknown error');
    }
  }
}
