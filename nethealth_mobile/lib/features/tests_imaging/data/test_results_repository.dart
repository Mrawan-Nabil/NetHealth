import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/models/paginated_response.dart';
import '../../../core/network/models/standard_response.dart';
import '../../../shared/models/test_result_model.dart';
import '../../../core/utils/app_error.dart';

class TestResultsRepository {
  final Dio _dio;

  TestResultsRepository(this._dio);

  /// GET /patient/test-results
  Future<PaginatedResponse<TestResultListModel>> getTestResults({
    int perPage = 50,
    int? page,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.patientTestResults,
        queryParameters: {
          'per_page': perPage,
          if (page != null) 'page': page,
        },
      );
      return PaginatedResponse<TestResultListModel>.fromJson(
        response.data,
        (json) => TestResultListModel.fromJson(json),
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// GET /patient/test-results/{id}
  Future<TestResultDetailModel> getTestResultDetails(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.testResultDetail(id));
      final wrapper = StandardResponse<TestResultDetailModel>.fromJson(
        response.data,
        (json) => TestResultDetailModel.fromJson(json),
      );
      return wrapper.data;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  AppError _mapDioError(DioException e) {
    if (e.response?.statusCode == 401) return const UnauthorizedError();
    return UnknownError(e.message ?? 'Unknown error');
  }
}
