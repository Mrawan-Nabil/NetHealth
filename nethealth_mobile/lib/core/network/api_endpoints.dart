class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const login  = '/api/login';
  static const logout = '/api/logout';

  // Patient
  static const patientProfile       = '/api/patient/profile';
  static const patientDashboard     = '/api/patient/dashboard';
  static const patientAppointments  = '/api/patient/appointments';
  static const patientPrescriptions = '/api/patient/prescriptions';
  static const patientTestResults   = '/api/patient/test-results';
  static const patientImaging       = '/api/patient/imaging';
  static const patientVisitHistory  = '/api/patient/visit-history';
  static const patientNotifications = '/api/patient/notifications';

  static String prescriptionDetail(String id) => '/api/patient/prescriptions/$id';
  static String testResultDetail(String id)   => '/api/patient/test-results/$id';
  static String imagingDetail(String id)      => '/api/patient/imaging/$id';
  static String appointmentDoctor(String id)  => '/api/patient/appointments/doctor/$id';
}
