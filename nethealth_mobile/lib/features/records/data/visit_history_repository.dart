import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/models/paginated_response.dart';
import '../../../shared/models/visit_history_model.dart';
import '../../../core/utils/app_error.dart';

class VisitHistoryRepository {
  final Dio _dio;

  VisitHistoryRepository(this._dio);

  /// GET /patient/visit-history
  Future<PaginatedResponse<VisitHistoryModel>> getVisitHistory({
    int perPage = 50,
    int? page,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.patientVisitHistory,
        queryParameters: {
          'per_page': perPage,
          if (page != null) 'page': page,
        },
      );
      return PaginatedResponse<VisitHistoryModel>.fromJson(
        response.data,
        (json) => VisitHistoryModel.fromJson(json),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw const UnauthorizedError();
      throw UnknownError(e.message ?? 'Unknown error');
    }
  }
}
