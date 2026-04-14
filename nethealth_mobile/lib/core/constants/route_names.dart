class RouteNames {
  RouteNames._();

  static const splash       = 'splash';
  static const onboarding   = 'onboarding';
  static const login        = 'login';
  static const selectRole   = 'select-role';
  static const home         = 'home';
  static const dashboard    = 'dashboard';
  static const appointments = 'appointments';
  static const records      = 'records';
  static const prescriptions= 'prescriptions';
  static const profile      = 'profile';
  static const editProfile  = 'edit-profile';
  static const register     = 'register';
  static const registerSuccess = 'register-success';
  static const findSpecialist = 'find-specialist';
  static const doctorDetails = 'doctor-details';
  static const prescriptionDetails = 'prescription-details';
  static const testResults  = 'test-results';
  static const imageViewer  = 'image-viewer';
}

class RoutePaths {
  RoutePaths._();

  static const splash       = '/splash';
  static const onboarding   = '/onboarding';
  static const login        = '/login';
  static const selectRole   = '/select-role';
  static const home         = '/home';
  static const dashboard    = '/home/dashboard';
  static const appointments = '/home/appointments';
  static const records      = '/home/records';
  static const prescriptions= '/home/prescriptions';
  static const profile      = '/home/profile';
  static const editProfile  = '/home/profile/edit';
  static const register     = '/register/:role';
  static const registerSuccess = '/register-success';
  static const findSpecialist = '/home/appointments/find-specialist';
  static const doctorDetails = '/home/appointments/doctor-details';
  static const prescriptionDetails = '/home/prescriptions/details';
  static const testResults  = '/home/records/test-results';
  static const imageViewer  = '/home/records/image-viewer';
}
