import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/models/standard_response.dart';
import '../../../shared/models/dashboard_model.dart';
import '../../../core/utils/app_error.dart';

class DashboardRepository {
  final Dio _dio;

  DashboardRepository(this._dio);

  Future<DashboardModel> getDashboardData() async {
    try {
      final response = await _dio.get(ApiEndpoints.patientDashboard);
      final wrapper = StandardResponse<DashboardModel>.fromJson(
        response.data,
        (json) => DashboardModel.fromJson(json),
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
