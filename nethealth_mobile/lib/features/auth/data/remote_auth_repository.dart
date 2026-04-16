import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../shared/models/auth_user.dart';
import '../../../core/utils/result.dart';
import '../../../core/utils/app_error.dart';
import '../../../core/utils/secure_storage_service.dart';
import '../../../core/network/api_endpoints.dart';
import 'auth_repository.dart';

class RemoteAuthRepository implements AuthRepository {
  final Dio _dio;
  final _storage = SecureStorageService.instance;

  RemoteAuthRepository(this._dio);

  @override
  Future<Result<AuthUser, AppError>> login(LoginCredentials credentials) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'email':      credentials.email,
          'password':   credentials.password,
          'rememberMe': credentials.rememberMe,
        },
      );

      print('LOGIN RESPONSE: ${response.data}');
      
      final Map<String, dynamic> dataMap;
      if (response.data is Map) {
         dataMap = response.data as Map<String, dynamic>;
      } else if (response.data is String) {
         dataMap = jsonDecode(response.data) as Map<String, dynamic>;
      } else {
         throw Exception('Unexpected response type: ${response.data.runtimeType}');
      }

      // Check if the response is wrapped in a "data" object (Standard Response Envelope)
      final payload = dataMap.containsKey('data') ? dataMap['data'] as Map<String, dynamic> : dataMap;

      final token = payload['token'] as String;
      final user  = AuthUser.fromJson(payload['user'] as Map<String, dynamic>);

      await _storage.writeToken(token);
      await _storage.writeUser(user.toJsonString());

      return Success(user);
    } on DioException catch (e) {
      return Failure(_mapDioError(e));
    } catch (e) {
      return Failure(UnknownError(e.toString()));
    }
  }

  @override
  Future<Result<void, AppError>> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
      await _storage.clearAll();
      return const Success(null);
    } on DioException catch (e) {
      // Clear local storage even if API call fails
      await _storage.clearAll();
      return Failure(_mapDioError(e));
    }
  }

  @override
  Future<Result<AuthUser, AppError>> getMe() async {
    try {
      final response = await _dio.get(ApiEndpoints.me);
      // The API blueprint defines a Standard Response Envelope wraps all calls.
      final user = AuthUser.fromJson(response.data['data'] as Map<String, dynamic>);
      await _storage.writeUser(user.toJsonString()); // Update stored cache
      return Success(user);
    } on DioException catch (e) {
      return Failure(_mapDioError(e));
    } catch (e) {
      return Failure(UnknownError(e.toString()));
    }
  }

  @override
  Future<AuthUser?> getStoredUser() async {
    final json = await _storage.readUser();
    if (json == null) return null;
    try {
      return AuthUser.fromJsonString(json);
    } catch (_) {
      return null;
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
