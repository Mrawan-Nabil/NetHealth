import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/models/paginated_response.dart';
import '../../../core/network/models/standard_response.dart';
import '../../../shared/models/prescription_model.dart';
import '../../../core/utils/app_error.dart';

class PrescriptionsRepository {
  final Dio _dio;

  PrescriptionsRepository(this._dio);

  Future<PaginatedResponse<PrescriptionModel>> getPrescriptions({
    String? status,
    int perPage = 15,
    int? page,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.patientPrescriptions,
        queryParameters: {
          if (status != null && status.isNotEmpty) 'status': status,
          'per_page': perPage,
          if (page != null) 'page': page,
        },
      );
      return PaginatedResponse<PrescriptionModel>.fromJson(
        response.data,
        (json) => PrescriptionModel.fromJson(json),
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<PrescriptionDetailModel> getPrescriptionDetails(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.prescriptionDetail(id));
      final wrapper = StandardResponse<PrescriptionDetailModel>.fromJson(
        response.data,
        (json) => PrescriptionDetailModel.fromJson(json),
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
