import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/models/standard_response.dart';
import '../../../shared/models/patient_profile_model.dart';
import '../../../core/utils/app_error.dart';

class ProfileRepository {
  final Dio _dio;

  ProfileRepository(this._dio);

  Future<PatientProfileModel> getProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.patientProfile);
      final wrapper = StandardResponse<PatientProfileModel>.fromJson(
        response.data,
        (json) => PatientProfileModel.fromJson(json),
      );
      return wrapper.data;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<PatientProfileModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch(
        ApiEndpoints.patientProfile,
        data: data,
      );
      final wrapper = StandardResponse<PatientProfileModel>.fromJson(
        response.data,
        (json) => PatientProfileModel.fromJson(json),
      );
      return wrapper.data;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword, String newPasswordConfirmation) async {
    try {
      await _dio.post(
        '${ApiEndpoints.patientProfile}/password',
        data: {
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': newPasswordConfirmation,
        },
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<String> updateAvatar(File image) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(image.path),
      });
      
      final response = await _dio.post(
        '${ApiEndpoints.patientProfile}/avatar',
        data: formData,
      );
      
      return response.data['data']['avatar_url'] as String;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }
  
  AppError _mapDioError(DioException e) {
    final status = e.response?.statusCode;
    if (status == 401) return const UnauthorizedError();
    if (status == 422) {
      final errors = (e.response?.data['errors'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, List<String>.from(v as List)));
      return ValidationError(errors ?? {});
    }
    if (status != null && status >= 500) return const ServerError();
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NetworkError();
    }
    return UnknownError(e.message ?? 'Unknown error');
  }
}
