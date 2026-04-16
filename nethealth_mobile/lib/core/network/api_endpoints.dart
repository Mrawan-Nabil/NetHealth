class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const login  = '/auth/login';
  static const logout = '/auth/logout';
  static const me     = '/auth/me';

  // Doctors — top-level (not under /patient)
  static const doctors = '/doctors';

  // Patient
  static const patientProfile       = '/patient/profile';
  static const patientDashboard     = '/patient/dashboard';
  static const patientDoctors       = '/patient/doctors';
  static const patientAppointments  = '/patient/appointments';
  static const patientMedicalRecords= '/patient/medical-records';
  static const patientPrescriptions = '/patient/prescriptions';
  static const patientTestResults   = '/patient/test-results';
  static const patientImaging       = '/patient/imaging';
  static const patientVisitHistory  = '/patient/visit-history';
  static const patientNotifications = '/patient/notifications';

  static String prescriptionDetail(String id)    => '/patient/prescriptions/$id';
  static String testResultDetail(String id)      => '/patient/test-results/$id';
  static String imagingDetail(String id)         => '/patient/imaging/$id';
  static String appointmentDoctor(String id)     => '/patient/appointments/doctor/$id';
  static String appointmentReschedule(String id) => '/patient/appointments/$id/reschedule';
  static String appointmentDelete(String id)     => '/patient/appointments/$id';
  static String notificationRead(String id)      => '/patient/notifications/$id/read';
}
