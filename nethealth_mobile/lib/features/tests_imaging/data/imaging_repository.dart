import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/models/paginated_response.dart';
import '../../../core/network/models/standard_response.dart';
import '../../../shared/models/imaging_model.dart';
import '../../../core/utils/app_error.dart';

class ImagingRepository {
  final Dio _dio;

  ImagingRepository(this._dio);

  /// GET /patient/imaging
  Future<PaginatedResponse<ImagingListModel>> getImaging({
    int perPage = 50,
    int? page,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.patientImaging,
        queryParameters: {
          'per_page': perPage,
          if (page != null) 'page': page,
        },
      );
      return PaginatedResponse<ImagingListModel>.fromJson(
        response.data,
        (json) => ImagingListModel.fromJson(json),
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// GET /patient/imaging/{id}
  Future<ImagingDetailModel> getImagingDetails(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.imagingDetail(id));
      final wrapper = StandardResponse<ImagingDetailModel>.fromJson(
        response.data,
        (json) => ImagingDetailModel.fromJson(json),
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
