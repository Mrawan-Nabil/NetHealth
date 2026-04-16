import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/models/paginated_response.dart';
import '../../../core/network/models/standard_response.dart';
import '../../../shared/models/medical_record_model.dart';
import '../../../core/utils/app_error.dart';

class MedicalRecordsRepository {
  final Dio _dio;

  MedicalRecordsRepository(this._dio);

  Future<PaginatedResponse<MedicalRecordModel>> getMedicalRecords({
    int perPage = 15,
    int? page,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.patientMedicalRecords,
        queryParameters: {
          'per_page': perPage,
          if (page != null) 'page': page,
        },
      );
      return PaginatedResponse<MedicalRecordModel>.fromJson(
        response.data,
        (json) => MedicalRecordModel.fromJson(json),
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<MedicalRecordModel> getMedicalRecordDetails(String id) async {
    try {
      final response = await _dio.get('${ApiEndpoints.patientMedicalRecords}/$id');
      final wrapper = StandardResponse<MedicalRecordModel>.fromJson(
        response.data,
        (json) => MedicalRecordModel.fromJson(json),
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
