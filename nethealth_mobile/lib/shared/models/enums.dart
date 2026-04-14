// Mirrors Laravel PHP enums exactly

enum UserRole {
  patient,
  doctor,
  clinicAdmin,
  pharmacyAdmin,
  admin;

  String get label => switch (this) {
        UserRole.patient      => 'Patient',
        UserRole.doctor       => 'Doctor',
        UserRole.clinicAdmin  => 'Clinic Admin',
        UserRole.pharmacyAdmin=> 'Pharmacy Admin',
        UserRole.admin        => 'Admin',
      };

  static UserRole fromString(String value) => switch (value.toLowerCase()) {
        'patient'       => UserRole.patient,
        'doctor'        => UserRole.doctor,
        'clinic_admin'  => UserRole.clinicAdmin,
        'pharmacy_admin'=> UserRole.pharmacyAdmin,
        'admin'         => UserRole.admin,
        _               => UserRole.patient,
      };
}

enum AccountStatus {
  active,
  suspended,
  pending;

  static AccountStatus fromString(String value) => switch (value.toLowerCase()) {
        'active'    => AccountStatus.active,
        'suspended' => AccountStatus.suspended,
        'pending'   => AccountStatus.pending,
        _           => AccountStatus.pending,
      };
}

enum Gender {
  male,
  female,
  other;

  String get label => switch (this) {
        Gender.male   => 'Male',
        Gender.female => 'Female',
        Gender.other  => 'Other',
      };

  static Gender fromString(String value) => switch (value.toLowerCase()) {
        'male'   => Gender.male,
        'female' => Gender.female,
        _        => Gender.other,
      };
}

enum BloodType {
  aPositive,
  aNegative,
  bPositive,
  bNegative,
  abPositive,
  abNegative,
  oPositive,
  oNegative;

  String get label => switch (this) {
        BloodType.aPositive  => 'A+',
        BloodType.aNegative  => 'A-',
        BloodType.bPositive  => 'B+',
        BloodType.bNegative  => 'B-',
        BloodType.abPositive => 'AB+',
        BloodType.abNegative => 'AB-',
        BloodType.oPositive  => 'O+',
        BloodType.oNegative  => 'O-',
      };

  static BloodType? fromString(String? value) {
    if (value == null) return null;
    return switch (value.toLowerCase().replaceAll(' ', '')) {
      'a+'  => BloodType.aPositive,
      'a-'  => BloodType.aNegative,
      'b+'  => BloodType.bPositive,
      'b-'  => BloodType.bNegative,
      'ab+' => BloodType.abPositive,
      'ab-' => BloodType.abNegative,
      'o+'  => BloodType.oPositive,
      'o-'  => BloodType.oNegative,
      _     => null,
    };
  }
}

enum AttachmentType {
  imaging,
  labResult,
  clinicalDocument,
  prescription;

  static AttachmentType fromString(String value) => switch (value.toLowerCase()) {
        'imaging'           => AttachmentType.imaging,
        'lab_result'        => AttachmentType.labResult,
        'clinical_document' => AttachmentType.clinicalDocument,
        'prescription'      => AttachmentType.prescription,
        _                   => AttachmentType.clinicalDocument,
      };
}

enum PrescriptionStatus {
  pending,
  issued,
  dispensed,
  cancelled;

  String get label => switch (this) {
        PrescriptionStatus.pending   => 'Pending',
        PrescriptionStatus.issued    => 'Issued',
        PrescriptionStatus.dispensed => 'Dispensed',
        PrescriptionStatus.cancelled => 'Cancelled',
      };

  static PrescriptionStatus fromString(String value) => switch (value.toLowerCase()) {
        'pending'   => PrescriptionStatus.pending,
        'issued'    => PrescriptionStatus.issued,
        'dispensed' => PrescriptionStatus.dispensed,
        'cancelled' => PrescriptionStatus.cancelled,
        _           => PrescriptionStatus.pending,
      };
}

enum TestResultStatus {
  pending,
  reviewed;

  String get label => switch (this) {
        TestResultStatus.pending  => 'Pending',
        TestResultStatus.reviewed => 'Reviewed',
      };

  static TestResultStatus fromString(String value) => switch (value.toLowerCase()) {
        'reviewed' => TestResultStatus.reviewed,
        _          => TestResultStatus.pending,
      };
}

enum AppointmentStatus {
  scheduled,
  completed,
  cancelled;

  String get label => switch (this) {
        AppointmentStatus.scheduled => 'Scheduled',
        AppointmentStatus.completed => 'Completed',
        AppointmentStatus.cancelled => 'Cancelled',
      };

  static AppointmentStatus fromString(String value) => switch (value.toLowerCase()) {
        'completed' => AppointmentStatus.completed,
        'cancelled' => AppointmentStatus.cancelled,
        _           => AppointmentStatus.scheduled,
      };
}
