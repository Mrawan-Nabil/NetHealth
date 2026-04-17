import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/models/paginated_response.dart';
import '../../../core/network/models/standard_response.dart';
import '../../../shared/models/appointment_model.dart';
import '../../../shared/models/doctor_model.dart';
import '../../../core/utils/app_error.dart';

class AppointmentsRepository {
  final Dio _dio;
  AppointmentsRepository(this._dio);

  Future<PaginatedResponse<DoctorSummaryModel>> getDoctors({
    String? specialty,
    String? search,
    int perPage = 20,
    int? page,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.patientDoctors,
        queryParameters: {
          if (specialty != null && specialty.isNotEmpty) 'specialty': specialty,
          if (search != null && search.isNotEmpty) 'search': search,
          'per_page': perPage,
          if (page != null) 'page': page,
        },
      );
      return PaginatedResponse<DoctorSummaryModel>.fromJson(
        response.data,
        (json) => DoctorSummaryModel.fromJson(json),
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<DoctorDetailModel> getDoctorDetails(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.appointmentDoctor(id));
      final wrapper = StandardResponse<DoctorDetailModel>.fromJson(
        response.data,
        (json) => DoctorDetailModel.fromJson(json),
      );
      return wrapper.data;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<PaginatedResponse<AppointmentModel>> getAppointments({
    String? status,
    int perPage = 15,
    int? page,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.patientAppointments,
        queryParameters: {
          if (status != null && status.isNotEmpty) 'status': status,
          'per_page': perPage,
          if (page != null) 'page': page,
        },
      );
      return PaginatedResponse<AppointmentModel>.fromJson(
        response.data,
        (json) => AppointmentModel.fromJson(json),
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<void> bookAppointment({
    required String doctorId,
    required String clinicId,
    required String appointmentType,
    required String appointmentTime, // format: "YYYY-MM-DD HH:MM:SS"
    String? visitReason,
    String? patientName,
    String? patientPhone,
    String? patientEmail,
  }) async {
    try {
      await _dio.post(
        ApiEndpoints.patientAppointments,
        data: {
          'doctor_id': doctorId,
          'clinic_id': clinicId,
          'appointment_type': appointmentType,
          'appointment_time': appointmentTime,
          if (visitReason  != null && visitReason.isNotEmpty)  'visit_reason':  visitReason,
          if (patientName  != null && patientName.isNotEmpty)  'patient_name':  patientName,
          if (patientPhone != null && patientPhone.isNotEmpty) 'patient_phone': patientPhone,
          if (patientEmail != null && patientEmail.isNotEmpty) 'patient_email': patientEmail,
        },
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<AppointmentModel> rescheduleAppointment(String id, String newTime) async {
    try {
      final response = await _dio.patch(
        ApiEndpoints.appointmentReschedule(id),
        data: {'appointment_time': newTime},
      );
      final wrapper = StandardResponse<AppointmentModel>.fromJson(
        response.data,
        (json) => AppointmentModel.fromJson(json),
      );
      return wrapper.data;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<void> cancelAppointment(String id) async {
    try {
      await _dio.delete(ApiEndpoints.appointmentDelete(id));
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  AppError _mapDioError(DioException e) {
    if (e.response?.statusCode == 401) return const UnauthorizedError();
    if (e.response?.statusCode == 422) {
      final errors = (e.response?.data['errors'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, List<String>.from(v as List)));
      return ValidationError(errors ?? {});
    }
    return UnknownError(e.message ?? 'Unknown error');
  }
}
