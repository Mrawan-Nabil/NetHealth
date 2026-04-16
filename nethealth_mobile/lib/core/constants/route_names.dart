// ─────────────────────────────────────────────────────────────────────────────
// RouteNames — named route identifiers used with context.pushNamed / goNamed
// RouteNames  — do NOT include path parameters (e.g. ':id') in these strings.
// ─────────────────────────────────────────────────────────────────────────────

class RouteNames {
  RouteNames._();

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const splash            = 'splash';
  static const onboarding        = 'onboarding';
  static const login             = 'login';
  static const selectRole        = 'select-role';
  static const register          = 'register';
  static const registerSuccess   = 'register-success';
  static const pendingApproval   = 'pending-approval';
  static const accountSuspended  = 'account-suspended';

  // ── Home Shell ────────────────────────────────────────────────────────────
  static const home              = 'home';
  static const dashboard         = 'dashboard';

  // ── Appointments ──────────────────────────────────────────────────────────
  static const appointments      = 'appointments';
  static const appointmentDetail = 'appointment-detail';
  static const findSpecialist    = 'find-specialist';
  static const doctorDetails     = 'doctor-details';
  static const doctorSelection   = 'doctor-selection';
  static const bookingForm       = 'booking-form';

  // ── Records ───────────────────────────────────────────────────────────────
  static const records           = 'records';
  static const medicalRecordDetail = 'medical-record-detail';
  static const visitHistory      = 'visit-history';

  // ── Test Results ──────────────────────────────────────────────────────────
  static const testResults       = 'test-results';
  static const testResultDetail  = 'test-result-detail';

  // ── Imaging ───────────────────────────────────────────────────────────────
  static const imagingList       = 'imaging';
  static const imageViewer       = 'image-viewer';

  // ── Prescriptions ─────────────────────────────────────────────────────────
  static const prescriptions     = 'prescriptions';
  static const prescriptionDetails = 'prescription-details';

  // ── Profile ───────────────────────────────────────────────────────────────
  static const profile           = 'profile';
  static const editProfile       = 'edit-profile';

  // ── Misc ──────────────────────────────────────────────────────────────────
  static const notifications     = 'notifications';
}

// ─────────────────────────────────────────────────────────────────────────────
// RoutePaths — full absolute paths.
// For routes that require an :id path parameter, the constant shows the
// template path (for documentation). Use pushNamed + pathParameters to navigate.
// ─────────────────────────────────────────────────────────────────────────────

class RoutePaths {
  RoutePaths._();

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const splash            = '/splash';
  static const onboarding        = '/onboarding';
  static const login             = '/login';
  static const selectRole        = '/select-role';
  static const register          = '/register/:role';
  static const registerSuccess   = '/register-success';
  static const pendingApproval   = '/pending-approval';
  static const accountSuspended  = '/account-suspended';

  // ── Home Shell ────────────────────────────────────────────────────────────
  static const home              = '/home';
  static const dashboard         = '/home/dashboard';

  // ── Appointments ──────────────────────────────────────────────────────────
  static const appointments      = '/home/appointments';
  static const appointmentDetail = '/home/appointments/detail/:id';
  static const findSpecialist    = '/home/appointments/find-specialist';
  static const doctorDetails     = '/home/appointments/doctor-details/:id';
  static const doctorSelection   = '/home/appointments/doctor-selection';
  static const bookingForm       = '/home/appointments/booking-form';
  // ── Records ───────────────────────────────────────────────────────────────
  static const records           = '/home/records';
  static const medicalRecordDetail = '/home/records/detail/:id';
  static const visitHistory      = '/home/records/visit-history';

  // ── Test Results ──────────────────────────────────────────────────────────
  static const testResults       = '/home/records/test-results';
  static const testResultDetail  = '/home/records/test-results/detail/:id';

  // ── Imaging ───────────────────────────────────────────────────────────────
  static const imagingList       = '/home/records/imaging';
  static const imageViewer       = '/home/records/image-viewer/:id';

  // ── Prescriptions — detail is now a sub-route under Records ────────────────
  static const prescriptions     = '/home/prescriptions'; // kept for legacy pushes
  static const prescriptionDetails = '/home/records/prescription-details/:id';

  // ── Profile ───────────────────────────────────────────────────────────────
  static const profile           = '/home/profile';
  static const editProfile       = '/home/profile/edit';

  // ── Misc ──────────────────────────────────────────────────────────────────
  static const notifications     = '/home/notifications';
}
