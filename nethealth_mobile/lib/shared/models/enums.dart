// Mirrors Laravel PHP enums exactly

enum UserRole {
  patient('patient'),
  doctor('doctor'),
  clinicAdmin('clinic_admin'),
  pharmacyAdmin('pharmacy_admin'),
  admin('admin');

  final String value;
  const UserRole(this.value);

  String get label => switch (this) {
        UserRole.patient      => 'Patient',
        UserRole.doctor       => 'Doctor',
        UserRole.clinicAdmin  => 'Clinic Admin',
        UserRole.pharmacyAdmin=> 'Pharmacy Admin',
        UserRole.admin        => 'Admin',
      };

  static UserRole fromString(String val) => values.firstWhere(
        (e) => e.value == val.toLowerCase(),
        orElse: () => UserRole.patient,
      );
}

enum AccountStatus {
  active('active'),
  suspended('suspended'),
  pending('pending');

  final String value;
  const AccountStatus(this.value);

  static AccountStatus fromString(String val) => values.firstWhere(
        (e) => e.value == val.toLowerCase(),
        orElse: () => AccountStatus.pending,
      );
}

enum Gender {
  male('male'),
  female('female');

  final String value;
  const Gender(this.value);

  String get label => switch (this) {
        Gender.male   => 'Male',
        Gender.female => 'Female',
      };

  static Gender fromString(String val) => values.firstWhere(
        (e) => e.value == val.toLowerCase(),
        orElse: () => Gender.male, // Default fallback per requirement avoiding other
      );
}

enum BloodType {
  aPositive('A+'),
  aNegative('A-'),
  bPositive('B+'),
  bNegative('B-'),
  abPositive('AB+'),
  abNegative('AB-'),
  oPositive('O+'),
  oNegative('O-');

  final String value;
  const BloodType(this.value);

  String get label => value;

  static BloodType? fromString(String? val) {
    if (val == null) return null;
    try {
      return values.firstWhere((e) => e.value.toLowerCase() == val.toLowerCase().replaceAll(' ', ''));
    } catch (_) {
      return null;
    }
  }
}

enum AttachmentType {
  imaging('imaging'),
  labResult('lab_result'),
  clinicalDocument('clinical_document'),
  prescription('prescription');

  final String value;
  const AttachmentType(this.value);

  static AttachmentType fromString(String val) => values.firstWhere(
        (e) => e.value == val.toLowerCase(),
        orElse: () => AttachmentType.clinicalDocument,
      );
}

enum PrescriptionStatus {
  pending('pending'),
  issued('issued'),
  dispensed('dispensed'),
  cancelled('cancelled');

  final String value;
  const PrescriptionStatus(this.value);

  String get label => switch (this) {
        PrescriptionStatus.pending   => 'Pending',
        PrescriptionStatus.issued    => 'Issued',
        PrescriptionStatus.dispensed => 'Dispensed',
        PrescriptionStatus.cancelled => 'Cancelled',
      };

  static PrescriptionStatus fromString(String val) => values.firstWhere(
        (e) => e.value == val.toLowerCase(),
        orElse: () => PrescriptionStatus.pending,
      );
}

enum TestResultStatus {
  pending('pending'),
  reviewed('reviewed');

  final String value;
  const TestResultStatus(this.value);

  String get label => switch (this) {
        TestResultStatus.pending  => 'Pending',
        TestResultStatus.reviewed => 'Reviewed',
      };

  static TestResultStatus fromString(String val) => values.firstWhere(
        (e) => e.value == val.toLowerCase(),
        orElse: () => TestResultStatus.pending,
      );
}

enum AppointmentStatus {
  scheduled('scheduled'),
  completed('completed'),
  cancelled('cancelled');

  final String value;
  const AppointmentStatus(this.value);

  String get label => switch (this) {
        AppointmentStatus.scheduled => 'Scheduled',
        AppointmentStatus.completed => 'Completed',
        AppointmentStatus.cancelled => 'Cancelled',
      };

  static AppointmentStatus fromString(String val) => values.firstWhere(
        (e) => e.value == val.toLowerCase(),
        orElse: () => AppointmentStatus.scheduled,
      );
}

enum AppointmentType {
  physical('physical'),
  remote('remote'),
  emergency('emergency');

  final String value;
  const AppointmentType(this.value);

  String get label => switch (this) {
        AppointmentType.physical  => 'Physical',
        AppointmentType.remote    => 'Remote',
        AppointmentType.emergency => 'Emergency',
      };

  static AppointmentType fromString(String val) => values.firstWhere(
        (e) => e.value == val.toLowerCase(),
        orElse: () => AppointmentType.physical,
      );
}

enum RecordStatus {
  active('active'),
  closed('closed');

  final String value;
  const RecordStatus(this.value);

  String get label => switch (this) {
        RecordStatus.active => 'Active',
        RecordStatus.closed => 'Closed',
      };

  static RecordStatus fromString(String val) => values.firstWhere(
        (e) => e.value == val.toLowerCase(),
        orElse: () => RecordStatus.active,
      );
}

enum ProfessionalTitle {
  professor('professor'),
  consultant('consultant'),
  specialist('specialist'),
  resident('resident');

  final String value;
  const ProfessionalTitle(this.value);

  String get label => switch (this) {
        ProfessionalTitle.professor  => 'Professor',
        ProfessionalTitle.consultant => 'Consultant',
        ProfessionalTitle.specialist => 'Specialist',
        ProfessionalTitle.resident   => 'Resident',
      };

  static ProfessionalTitle fromString(String val) => values.firstWhere(
        (e) => e.value == val.toLowerCase(),
        orElse: () => ProfessionalTitle.specialist,
      );
}
