import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/models/paginated_response.dart';
import '../../../core/network/models/standard_response.dart';
import '../../../shared/models/notification_model.dart';
import '../../../core/utils/app_error.dart';

class NotificationsRepository {
  final Dio _dio;

  NotificationsRepository(this._dio);

  Future<PaginatedResponse<NotificationModel>> getNotifications({
    int perPage = 20,
    int? page,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.patientNotifications,
        queryParameters: {
          'per_page': perPage,
          if (page != null) 'page': page,
        },
      );
      return PaginatedResponse<NotificationModel>.fromJson(
        response.data,
        (json) => NotificationModel.fromJson(json),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw const UnauthorizedError();
      throw UnknownError(e.message ?? 'Unknown error');
    }
  }

  Future<NotificationModel> markAsRead(String id) async {
    try {
      final response = await _dio.patch(ApiEndpoints.notificationRead(id));
      final wrapper = StandardResponse<NotificationModel>.fromJson(
        response.data,
        (json) => NotificationModel.fromJson(json),
      );
      return wrapper.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw const UnauthorizedError();
      throw UnknownError(e.message ?? 'Unknown error');
    }
  }
}
