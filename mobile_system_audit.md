# NetHealth Mobile — System Audit Report
**Date:** April 26, 2026  
**Scope:** `nethealth_mobile/` only (backend read-only for contract reference)

---

## 1. Architecture Verification

The intended data flow is correctly implemented in the majority of the codebase:

```
Dio (dioProvider) → Repository → FutureProvider / AsyncNotifierProvider → ConsumerWidget (ref.watch)
```

- **`dioProvider`** (`core/network/dio_provider.dart`) — single Dio instance with `InterceptorsWrapper` that injects `Bearer` tokens on every request and calls `authProvider.notifier.forceLogout()` on 401/403. ✅
- **`StandardResponse<T>` / `PaginatedResponse<T>`** wrappers are defined and used consistently across all repositories. ✅
- **Repository pattern** is followed: every feature has a `*Repository` class injected via a `Provider<*Repository>`, and UI widgets only call `ref.watch(someProvider)`. ✅ (with exceptions noted below)
- **`AsyncNotifierProvider`** is used for stateful operations (profile updates, auth). `FutureProvider` / `FutureProvider.family` are used for read-only data. ✅

One structural note: `ApiClient` (`core/network/api_client.dart`) is defined but **never used** — `dioProvider` creates its own Dio instance inline. This is a dead-code artifact, not a runtime bug.

---

## 2. Detected Errors (Critical)

### BUG-01 — `appointments_repository.dart`: Type Error on `FormData` construction (COMPILER ERROR)
**File:** `nethealth_mobile/lib/features/appointments/data/appointments_repository.dart`  
**Severity:** 🔴 Critical — compile-time error, booking with attachment will not build.

```dart
// BROKEN — dataMap is Map<String, String>, cannot hold a MultipartFile
final dataMap = {
  'doctor_id': doctorId,
  ...
};
if (attachment != null) {
  dataMap['attachment'] = await MultipartFile.fromFile(attachment.path); // ❌ Type error
  final formData = FormData.fromMap(dataMap);
```

`dataMap` is inferred as `Map<String, String>` because all other values are strings. Assigning a `MultipartFile` to it is a type mismatch. The `FormData` must be built with a `Map<String, dynamic>` from the start.

---

### BUG-02 — `appointments_repository.dart`: Dead endpoint `getDoctors` / `appointmentDoctor`
**File:** `nethealth_mobile/lib/features/appointments/data/appointments_repository.dart`  
**Severity:** 🔴 Critical — runtime 404 on every call.

The repository has a `getDoctors()` method that calls `ApiEndpoints.patientDoctors` (`/patient/doctors`) and a `getDoctorDetails()` method that calls `ApiEndpoints.appointmentDoctor(id)` (`/patient/appointments/doctor/{id}`). **Neither of these routes exists in `routes/api.php`.**

The correct doctor-listing endpoint is `GET /v1/doctors` (handled by `DoctorApiController`). The `DoctorRepository` (used by `doctorsProvider`) correctly calls `ApiEndpoints.doctors` (`/doctors`). The `AppointmentsRepository.getDoctors()` method is therefore a dead duplicate pointing at a non-existent route.

---

### BUG-03 — `medical_records_repository.dart`: Calls non-existent endpoint
**File:** `nethealth_mobile/lib/features/records/data/medical_records_repository.dart`  
**Severity:** 🔴 Critical — runtime 404.

`getMedicalRecords()` calls `ApiEndpoints.patientMedicalRecords` (`/patient/medical-records`) and `getMedicalRecordDetails()` calls `/patient/medical-records/{id}`. **Neither route exists in `routes/api.php`.** There is no `PatientMedicalRecordApiController` on the backend. The `medicalRecordsRepositoryProvider` is wired up but the underlying endpoint is a dead end.

Additionally, `uploadTestResult()` and `uploadImaging()` POST to `/patient/test-results` and `/patient/imaging` respectively — these are GET-only routes on the backend. There are no upload endpoints defined for patient-initiated uploads.

---

### BUG-04 — `notifications_repository.dart`: Calls non-existent endpoint
**File:** `nethealth_mobile/lib/features/notifications/data/notifications_repository.dart`  
**Severity:** 🔴 Critical — runtime 404.

Both `getNotifications()` (`/patient/notifications`) and `markAsRead()` (`/patient/notifications/{id}/read`) call endpoints that **do not exist** in `routes/api.php`. There is no notifications controller on the backend.

---

### BUG-05 — `AuthUser` model: `avatar` field vs. `avatar_url` from API
**File:** `nethealth_mobile/lib/shared/models/auth_user.dart`  
**Severity:** 🟠 High — avatar never displays correctly from auth state.

`UserResource.php` returns `avatar_url` (a fully-resolved URL). `AuthUser.fromJson()` reads `json['avatar']` (the raw storage path). The field name mismatch means `AuthUser.avatar` is always `null` after login. The `_TopBar` in `dashboard_screen.dart` falls back to `user?.avatar` which will always be null, so the avatar only works when `profileProvider` has loaded.

```php
// Backend sends:
'avatar_url' => asset('storage/' . $this->avatar)

// Flutter reads:
avatar: json['avatar']?.toString(), // ❌ should be 'avatar_url'
```

---

### BUG-06 — `profile_provider.dart`: Incorrect `rethrow` usage
**File:** `nethealth_mobile/lib/features/profile/providers/profile_provider.dart`  
**Severity:** 🟠 High — stack trace is lost, making error diagnosis impossible.

```dart
// In _fetchProfile():
} catch (e, st) {
  throw e; // ❌ loses stack trace — should be `rethrow`
}
```
The unused `st` variable is also flagged by the analyzer.

---

### BUG-07 — `booking_modals.dart`: Confirm button does NOT call the API
**File:** `nethealth_mobile/lib/features/appointments/ui/booking_modals.dart`  
**Severity:** 🔴 Critical — the `showConfirmAppointmentSheet` modal is a fully disconnected mock.

The "Confirm Booking →" button in `_ConfirmSheetBody` calls `showBookingSuccessDialog()` directly without making any API call. The form fields are pre-filled with hardcoded mock data (`'Ahmed Mohamed'`, `'+20 100 234 5678'`). This modal is never used by the live booking flow (which correctly uses `_PatientInfoModal` inside `doctor_details_screen.dart`), but it remains in the codebase and is a source of confusion.

---

### BUG-08 — `booking_modals.dart` success dialog: Hardcoded mock file list
**File:** `nethealth_mobile/lib/features/appointments/ui/booking_modals.dart`  
**Severity:** 🟡 Medium — misleading UI.

`_SuccessDialog` always renders two hardcoded "uploaded files" (`ECG_REPORT_2025.PDF`, `BLOOD_WORK_OCT.PDF`) regardless of what the user actually uploaded.

---

### BUG-09 — `AppointmentModel`: Missing `doctor_id` / `patient_id` fields from API response
**File:** `nethealth_mobile/lib/shared/models/appointment_model.dart`  
**Severity:** 🟡 Medium — data loss on deserialization.

`PatientAppointmentApiController` returns the raw Eloquent model for `store()` and `show()`, which includes `doctor_id`, `patient_id`, `clinic_id`, and `cancelled_at`. `AppointmentModel` does not map `doctor_id`, `patient_id`, or `clinic_id` as top-level fields. While the nested `doctor` and `clinic` objects cover most use cases, the `clinic_id` is needed for the booking guard in `_PatientInfoModal` and is currently read from `doctor.clinic?.id` — which can be null if the doctor's clinic relation isn't loaded in the appointment response.

---

### BUG-10 — `DoctorSummaryModel` inside `AppointmentModel`: `full_name` field mismatch
**File:** `nethealth_mobile/lib/shared/models/doctor_model.dart`  
**Severity:** 🟠 High — doctor name shows as "Unknown Doctor" in appointment cards.

`PatientAppointmentApiController` returns appointments with a nested `doctor` object that is the raw Eloquent `Doctor` model with a `user` relation. The shape is:
```json
{ "doctor": { "user_id": 1, "specialty": "...", "user": { "full_name": "..." } } }
```
`DoctorSummaryModel.fromJson()` checks for `full_name` at the top level first, then falls back to `json['user']['full_name']`. The fallback works, but `id` is read as `json['id'] ?? json['user_id']` — the nested doctor object has `user_id` as its PK, not `id`. This means `doctor.id` resolves to `user_id` correctly, but only because of the fallback. The `avatarUrl` fallback reads `json['user']['avatar']` (raw path) instead of `json['user']['avatar_url']` (resolved URL), so doctor avatars in appointment cards will be broken.

---

## 3. Leftover Mock Data

| File | Mock Data Description | Bound to Live Provider? |
|---|---|---|
| `find_specialist_screen.dart` | Entire screen uses `_mockDoctors` list (6 hardcoded doctors with `pravatar.cc` avatars, fake ratings, fake fees). Specialty chips filter the mock list. | ❌ No — completely disconnected from `doctorsProvider` |
| `notifications_screen.dart` | Hardcoded list of 3 notifications (`final notifications = [...]`). "Mark all read" button is a no-op. | ❌ No — `NotificationsRepository` exists but is never wired to a provider or this screen |
| `medical_record_detail_screen.dart` | Doctor name hardcoded as `'Dr. Sara Ahmed'`, date as `'Oct 15, 2025  •  City General Hospital'`, diagnosis text is static, prescriptions use `_MockPrescription` widget, attachment is hardcoded. | ❌ No — receives only an `id` param but never fetches from API |
| `booking_modals.dart` (`_ConfirmSheetBody`) | Form pre-filled with `'Ahmed Mohamed'`, `'+20 100 234 5678'`, `'ahmed.m@email.com'`. Confirm button skips API entirely. | ❌ No |
| `booking_modals.dart` (`_SuccessDialog`) | "Uploaded Files" section always shows `ECG_REPORT_2025.PDF` and `BLOOD_WORK_OCT.PDF`. | ❌ No |
| `doctor_selection_screen.dart` | Rating (`4.8`), review count (`120`), clinic name (`'City Medical Center'`), and "Available Today" badge are all hardcoded mock values overlaid on live doctor data. | ⚠️ Partial — doctor list is live, but display fields are fake |
| `dashboard_screen.dart` (`_NextAppointmentCard`) | Uses `appointmentsProvider` (live) but duplicates the "next appointment" logic client-side instead of using `dashboardData.nextAppointment` from `dashboardProvider`. | ⚠️ Partial — data is live but logic is redundant |

---

## 4. Additional Issues (Non-Critical)

- **`ApiClient` dead code** — `core/network/api_client.dart` is fully implemented but never instantiated. `dioProvider` is the actual Dio factory. The `AppConstants.useMock` flag controls a `_LogInterceptor` in `ApiClient` but has no effect since `ApiClient` is unused.
- **`AppConstants.useMock` default is `true`** — `app_constants.dart` defaults `useMock` to `true`. This means the `_LogInterceptor` in `ApiClient` would be active by default if `ApiClient` were ever used. Not a runtime bug, but a dangerous default.
- **`medicalRecordsRepositoryProvider`** is defined in `medical_records_provider.dart` but the provider file only exposes the repository — there are no `FutureProvider`s for medical records list or detail. The `records_screen.dart` never watches a medical records provider (it uses prescriptions, test results, imaging, and visit history tabs instead).
- **`edit_profile_screen.dart`**: The `_Field` widget declares a `maxLines` parameter that is never passed by any caller (analyzer warning).
- **`appointment_detail_screen.dart`**: Unused import of `enums.dart` (analyzer warning).
- **`withOpacity` deprecation** in `notifications_screen.dart` — should use `.withValues(alpha: ...)`.

---

## 5. Next Steps — Proposed Fix Order

### Fix 1: `appointments_repository.dart` — BUG-01 (Type Error)
**Why first:** This is a compile-time error that blocks the entire booking flow. Fix is surgical — change `dataMap` to `Map<String, dynamic>` and restructure the `FormData` branch.

### Fix 2: `find_specialist_screen.dart` — Mock Data Leak (Critical UX)
**Why second:** This is the primary entry point for booking. Users see 6 fake doctors with fake ratings and USD fees instead of the real doctor list. The live `doctorsProvider` already exists and works. This screen needs to be refactored to use `ref.watch(doctorsProvider)` exactly as `doctor_selection_screen.dart` does — or the two screens should be consolidated into one.

### Fix 3: `medical_record_detail_screen.dart` — Full Mock Screen
**Why third:** This screen is reachable from both `appointments_screen.dart` (completed appointment "View Record" button) and `appointment_detail_screen.dart`. It currently shows completely fabricated clinical data. Since the backend `/patient/medical-records` endpoint does not exist yet, the fix involves: (a) confirming with the backend team whether a `PatientMedicalRecordApiController` will be added, or (b) repurposing the screen to display data from the existing `prescriptions` and `test-results` endpoints using the appointment ID as a filter key.
