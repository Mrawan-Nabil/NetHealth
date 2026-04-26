import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/models/paginated_response.dart';
import '../../../core/network/models/standard_response.dart';
import '../../../shared/models/prescription_model.dart';
import '../../../core/utils/app_error.dart';

class PrescriptionsRepository {
  final Dio _dio;

  PrescriptionsRepository(this._dio);

  /// GET /patient/prescriptions — returns paginated list of PrescriptionListModel
  Future<PaginatedResponse<PrescriptionListModel>> getPrescriptions({
    int perPage = 50,
    int? page,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.patientPrescriptions,
        queryParameters: {
          'per_page': perPage,
          if (page != null) 'page': page,
        },
      );
      return PaginatedResponse<PrescriptionListModel>.fromJson(
        response.data,
        (json) => PrescriptionListModel.fromJson(json),
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// GET /patient/prescriptions/{id} — returns PrescriptionDetailModel
  Future<PrescriptionDetailModel> getPrescriptionDetails(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.prescriptionDetail(id));
      // The detail endpoint uses successResponse() → { status, message, data: {...} }
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
