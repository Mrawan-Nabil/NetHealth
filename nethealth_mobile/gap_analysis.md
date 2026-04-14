# NetHealth Flutter — Comprehensive Gap Analysis Report

> **Date:** April 14, 2026  
> **Analyst:** Senior Flutter Architect  
> **Method:** Full `lib/` scan × API Blueprint × UI Screenshots  
> **Legend:** `[ ]` = Missing/Incomplete · `[x]` = Present · **Bold** = Critical Architectural Blocker

---

## Layer 1 — Data & Model Layer

### 1.1 Missing Domain Models
The `lib/shared/models/` directory contains only **2 files** (`auth_user.dart`, `enums.dart`). Every domain model for patient data is completely absent. There are no Dart classes for any of the following API resources:

- [ ] **`AppointmentModel` — MISSING ENTIRELY.** No model for the `AppointmentResource` JSON shape (fields: `id`, `appointment_time`, `status`, `appointment_type`, `visit_reason`, nested `doctor`, nested `clinic`).
- [ ] **`AppointmentDetailModel` — MISSING ENTIRELY.** Extended version with nested `medical_record`.
- [ ] **`DoctorSummaryModel` — MISSING ENTIRELY.** Fields: `id`, `full_name`, `specialty`, `avatar_url`, `consultation_fee`, `clinic_name`, `experience`, `qualifications`.
- [ ] **`DoctorDetailModel` — MISSING ENTIRELY.** Extended version including `professional_title`, `medical_license`, `syndicate_id`.
- [ ] **`ClinicModel` — MISSING ENTIRELY.** Fields: `name`, `address`.
- [ ] **`DashboardModel` — MISSING ENTIRELY.** Composite model for `health_overview`, `stats`, `next_appointment`, `recent_records`.
- [ ] **`MedicalRecordModel` — MISSING ENTIRELY.** Fields: `id`, `record_status`, `diagnosis_notes`, `created_at`, nested `doctor`, nested `appointment`, `diagnoses_count`, `attachments_count`.
- [ ] **`PrescriptionModel` — MISSING ENTIRELY.** Summary card shape: `id`, `prescription_status`, `created_at`, `expires_at`, `diagnosis_notes`, `medicines` (list of names), nested `doctor`.
- [ ] **`PrescriptionDetailModel` — MISSING ENTIRELY.** Full detail shape including nested `patient`, `diagnosis`, and `medicines` (list of `PrescriptionItemModel`).
- [ ] **`PrescriptionItemModel` — MISSING ENTIRELY.** Fields: `name`, `category`, `dosage`, `frequency`, `duration_days`, `instructions`.
- [ ] **`MedicineModel` — MISSING ENTIRELY.** Fields: `name`, `category`.
- [ ] **`TestResultModel` — MISSING ENTIRELY.** Fields: `id`, `name`, `category`, `test_result_status`, `uploaded_at`. Detail variant adds `file_url`, `mime_type`, `notes`.
- [ ] **`ImagingModel` (summary) — MISSING ENTIRELY.** Fields: `id`, `title`, `modality`, `test_result_status`, `scan_date`, `physician_name`, `clinic_name`, `file_format`.
- [ ] **`ImagingDetailModel` — MISSING ENTIRELY.** Adds `file_info` (format, size_bytes, size_human, mime_type), `image_url`, `physician_interpretation`.
- [ ] **`PatientProfileModel` — MISSING ENTIRELY.** Full profile shape: `full_name`, `email`, `phone`, `national_id`, `birth_date`, `gender`, `governorate`, `blood_type`, `allergies`, `chronic_conditions`, `emergency_contact` (nested object with `name`, `phone`, `relationship`).
- [ ] **`PaginatedResponse<T>` wrapper — MISSING ENTIRELY.** No generic wrapper to parse the `{ data: [...], meta: { current_page, last_page, per_page, total } }` envelope. This is a **critical blocker** for all list endpoints.

### 1.2 Existing Model Deficiencies

- [x] `AuthUser` — Present and well-structured.
- [ ] **`AuthUser.avatar` field is typed as `String?` raw path, NOT a full `avatar_url`.** The API returns a full storage URL (`avatar_url`). The `fromJson` factory maps `json['avatar']` but the blueprint field is `avatar_url`. This will silently null-out every avatar image.
- [ ] `AuthUser` — Missing `phone` field mapping: the API response does not guarantee `phone` in the `/auth/me` or login user object; it is a patient-level field. Parsing it as a top-level user field may always return `''`.
- [x] All enum definitions in `enums.dart` match the Laravel enum values correctly.
- [ ] **`AppointmentType` enum — MISSING FROM `enums.dart`.**  The API defines `physical`, `remote`, `emergency` but no Dart enum exists for this. All appointment type values will be untyped strings.
- [ ] **`Gender` enum includes `other` variant** — The Laravel backend only accepts `male` / `female`. The `other` case will cause a 422 on registration if ever submitted.
- [ ] `BloodType.fromString()` — Uses `.toLowerCase()` before matching against uppercase strings like `'A+'`. Since `'a+'.toLowerCase() == 'a+'`, this works correctly but is unnecessarily defensive for a non-alphabetic character. **Not a blocker, but a code smell.**
- [ ] **`expires_at` for prescriptions** — There is no computed `expiresAt` logic anywhere in the app. The API blueprint calculates it as `created_at + 30 days`. The Flutter app has no model field for this, meaning the "Valid Until" header in the Prescription Details screen is permanently hardcoded to `'Nov 15, 2025'`.
- [ ] `AttachmentType` enum exists but is orphaned — No model uses it.

---

## Layer 2 — Service & Networking Layer

### 2.1 Missing API Service Repositories
The `lib/features/auth/data/` has a `RemoteAuthRepository` for auth only. **There are zero service/repository classes for any patient domain feature.** Every screen below auth is running on hardcoded mock data.

- [ ] **`DashboardRepository` / `DashboardService` — MISSING ENTIRELY.** No call to `GET /api/v1/patient/dashboard`.
- [ ] **`AppointmentRepository` — MISSING ENTIRELY.** No calls to:
  - `GET /api/v1/patient/appointments` (with `?status=` filter)
  - `GET /api/v1/patient/appointments/{id}`
  - `POST /api/v1/patient/appointments` (book)
  - `DELETE /api/v1/patient/appointments/{id}/cancel`
- [ ] **`DoctorRepository` — MISSING ENTIRELY.** No calls to:
  - `GET /api/v1/patient/doctors`
  - `GET /api/v1/patient/doctors/{id}`
- [ ] **`MedicalRecordRepository` — MISSING ENTIRELY.** No calls to:
  - `GET /api/v1/patient/medical-records`
  - `GET /api/v1/patient/medical-records/{id}`
- [ ] **`PrescriptionRepository` — MISSING ENTIRELY.** No calls to:
  - `GET /api/v1/patient/prescriptions`
  - `GET /api/v1/patient/prescriptions/{id}`
- [ ] **`TestResultRepository` — MISSING ENTIRELY.** No calls to:
  - `GET /api/v1/patient/test-results`
  - `GET /api/v1/patient/test-results/{id}`
- [ ] **`ImagingRepository` — MISSING ENTIRELY.** No calls to:
  - `GET /api/v1/patient/imaging`
  - `GET /api/v1/patient/imaging/{id}`
- [ ] **`VisitHistoryRepository` — MISSING ENTIRELY.** No call to `GET /api/v1/patient/visit-history`.
- [ ] **`ProfileRepository` — MISSING ENTIRELY.** No calls to:
  - `GET /api/v1/patient/profile`
  - `PATCH /api/v1/patient/profile`
  - `POST /api/v1/patient/profile/password`
  - `POST /api/v1/patient/profile/avatar`

### 2.2 API Endpoint Configuration Errors

- [ ] **`ApiEndpoints.login` points to `/api/login` — WRONG.** Blueprint requires `/api/v1/auth/login`. This will 404 against the production backend.
- [ ] **`ApiEndpoints.logout` points to `/api/logout` — WRONG.** Must be `/api/v1/auth/logout`.
- [ ] **All `ApiEndpoints.*` patient paths are missing the `/v1/` prefix** (e.g., `/api/patient/dashboard` → should be `/api/v1/patient/dashboard`). This will cause 404s on every endpoint.
- [ ] **`GET /api/v1/auth/me` endpoint — MISSING from `ApiEndpoints`.** There is no `authMe` constant and no code that calls this endpoint on app startup. The app restores user from local `SecureStorage` only; if the token is revoked server-side, the app will never know.
- [ ] **`GET /api/v1/patient/medical-records` — MISSING from `ApiEndpoints`.** Only `patientTestResults` and `patientImaging` exist, but not `patientMedicalRecords`.
- [ ] **`ApiEndpoints.appointmentDoctor(id)` generates wrong URL.** It produces `/api/patient/appointments/doctor/{id}` but the blueprint endpoint is `/api/v1/patient/doctors/{id}`.
- [ ] **No `POST /api/v1/auth/register/patient` endpoint defined** in `ApiEndpoints`. Registration form exists but `RemoteAuthRepository` does not implement `register()`. Currently, registration is likely mock-only or broken.

### 2.3 Standard Response Envelope Handling

- [ ] **The Standard Response Envelope (`status`, `message`, `data`, `meta`) is NOT parsed anywhere.** `RemoteAuthRepository.login()` directly accesses `response.data['token']` and `response.data['user']` — which is correct for the auth response shape. But for all other endpoints, there is no generic envelope parser that extracts `response.data['data']` before passing to a `fromJson` factory.
- [ ] **Paginated response `meta` object is never parsed.** No `current_page`, `last_page`, `per_page`, or `total` is read from any API response.

### 2.4 Error Handling Gaps

- [x] `_ErrorInterceptor` correctly clears token on 401.
- [x] `_mapDioError()` correctly maps 401 → `UnauthorizedError`, 422 → `ValidationError`, 5xx → `ServerError`, timeout → `NetworkError`.
- [ ] **`403` (Suspended account) is NOT handled.** The blueprint mandates returning a 403 with `"Your account has been suspended."` for suspended users. The current `_mapDioError` has no case for `403` — it will fall through to `UnknownError` silently, with no "account suspended" UI state.
- [ ] **`404` (Not Found) is NOT handled** in `_mapDioError()`. `NotFoundError` class exists in `app_error.dart` but is never instantiated.
- [ ] **`AccountStatus.pending` redirect is not enforced post-login.** Login response returns `account_status`, `AuthUser` model stores it, but **the router never checks `user.accountStatus == AccountStatus.pending` to redirect to a "Pending Approval" waiting screen.** A pending user will land directly on the dashboard.
- [ ] **`AccountStatus.suspended` redirect is not enforced.** Since 403 is unhandled, a suspended user's login attempt will show an unhandled error, not a clear "Account Suspended" message.
- [ ] **No `rememberMe` field in the API blueprint.** `RemoteAuthRepository.login()` sends `rememberMe: credentials.rememberMe` in the POST body, but the API blueprint doesn't include this field. This is dead weight in the request payload.

---

## Layer 3 — UI/UX & Structural Layer

### 3.1 Navigation & Shell Structure

- [x] Bottom navigation with 5 tabs (Home, Appointments, Records, Rx, Profile) is correctly implemented via `StatefulShellRoute.indexedStack`.
- [ ] **Notifications tab is MISSING from bottom navigation.** The `HomeShell` has 5 tabs but `NotificationsScreen` exists as a standalone screen with no bottom nav entry. The UI screenshots show notifications accessed via a bell icon in the dashboard AppBar — the bell tap currently calls `() {}` (no-op).
- [ ] **The notification bell on the Dashboard AppBar — tap handler is `() {}` (dead).** Must navigate to `NotificationsScreen`.
- [ ] **No "Pending Account" / waiting screen exists.** Nothing for `AccountStatus.pending` users.
- [ ] **No "Account Suspended" screen exists.** Nothing for the 403 suspended state.

### 3.2 Dashboard Screen (`dashboard_screen.dart`)

- [ ] **Entire dashboard is hardcoded mock data.** `_buildSummaryCards` shows hardcoded `'Tomorrow, 10:00 AM'` / `'Dr. Ayman Fathy'`. `_buildHealthOverview` shows `'O+'`, `'72 kg'`, `'178 cm'`.  `_buildRecentActivityList` is an inline hardcoded list. None of this is bound to any API provider.
- [ ] **"Good Morning" greeting is hardcoded.** Should be time-of-day-aware (Good Morning/Afternoon/Evening).
- [ ] **Dashboard `stats` section is missing.** The blueprint returns `upcoming_appointments`, `active_prescriptions`, `pending_tests` counters. The dashboard shows only 2 summary cards (Next Appointment, Test Results) but `active_prescriptions` counter has no card.
- [ ] **`next_appointment` data is not bound to API.** The "Next Appointment" card date/doctor is hardcoded.
- [ ] **"Find Specialist" button on dashboard banner navigates to `() {}`.** Must call `context.goNamed(RouteNames.findSpecialist)`.
- [ ] **"See All" on Recent Activity navigates to `() {}`.** Must navigate to Appointments or Records screen.
- [ ] **Health Overview pills `Weight` and `Height`** — These fields do NOT exist in the API blueprint's `PatientProfileResource`. The backend does not return these fields. These UI pills will have no data source and should be removed or redesigned.
- [ ] **Dashboard `health_overview.primary_doctor` block is absent from the UI.** The blueprint returns the patient's primary doctor (name, specialty, avatar) but the current Health Overview section shows only static icons.
- [ ] **Dashboard `health_overview.chronic_conditions` field is absent.** The blueprint includes this but no UI widget exists for it.
- [ ] **Avatar image in AppBar uses initials (first char of name only).** Should use `user.initials` (which correctly computes 2-letter initials) and also support `CachedNetworkImage` when `avatar_url` is available.

### 3.3 Appointments Screen (`appointments_screen.dart`)

- [x] TabBar with Completed / Scheduled / Cancelled tabs is present.
- [ ] **Tab content is hardcoded mock data.** `_buildAppointmentsList` uses an `itemCount` integer, not an API-bound list.
- [ ] **No API provider wires data to tabs.** Each tab must call `GET /api/v1/patient/appointments?status=completed|scheduled|cancelled`.
- [ ] **FAB "Book Appointment" tap handler is `() {}`.** Must navigate to `FindSpecialistScreen`.
- [ ] **Appointment card "Reschedule" button is `() {}`.** Reschedule is a new feature not yet in the blueprint; at minimum it should navigate to a booking flow.
- [ ] **Appointment cancel button calls `() {}`.** Must call `DELETE /api/v1/patient/appointments/{id}/cancel` with confirmation dialog.
- [ ] **`doctor` avatar uses hardcoded `pravatar.cc` URL**, not the `avatar_url` from the API.
- [ ] **Appointment detail screen is MISSING ENTIRELY.** Tapping an appointment card has no `onTap`. The API blueprint has `GET /api/v1/patient/appointments/{id}` and the UI screenshots show a full "Appointment Details" modal/screen with nested medical record, diagnosis, prescriptions. No such screen exists.
- [ ] **`visit_reason` / `appointment_type` fields are not displayed** in the appointment card.
- [ ] **`cancelled_by` / `reason` fields are not displayed** in the Cancelled tab.

### 3.4 Records Screen (`records_screen.dart`)

- [ ] **Entire screen is hardcoded mock data.** Uses inline `records` list.
- [ ] **No API provider.** Not bound to `GET /api/v1/patient/medical-records`.
- [ ] **"View Report" button taps `() {}`.** Must navigate to the Medical Record detail view.
- [ ] **Medical Record Detail screen is MISSING ENTIRELY.** The blueprint's `MedicalRecordDetailResource` includes nested diagnoses, prescriptions, and attachments. No detail screen or route exists.
- [ ] **Records screen does not separate Imaging from Lab Results.** The blueprint has distinct `/imaging` and `/test-results` endpoints. The current single Records screen conflates all record types under a flat list without proper sub-navigation.
- [ ] **Imaging screen is MISSING ENTIRELY as a standalone tab/section.** The `RecordsScreen` has no sub-tab or navigation entry for imaging. Only `test_results_screen.dart` exists as a sub-route of Records.
- [ ] **Visit History screen is MISSING ENTIRELY.** No screen, no route, no entry in `ApiEndpoints` for `patientVisitHistory` response binding. The constant `patientVisitHistory` exists in endpoints but no UI consumes it.

### 3.5 Prescriptions Screen (`prescriptions_screen.dart`)

- [ ] **Entirely hardcoded mock data.** Uses inline list with fake `RX-10294`, `RX-89432`.
- [ ] **Status displayed is `'Active'` / `'Completed'` — DOES NOT MATCH the API enum.** API returns `pending`, `issued`, `dispensed`, `cancelled`. There is no `active` or `completed` status in PrescriptionStatus. The status pill coloring logic is fully decoupled from the real enum.
- [ ] **`expires_at` is not displayed** in the prescription list card. Blueprint says this is a key field: `created_at + 30 days`.
- [ ] **`medicines` list (drug names) is not displayed** in the list card. Blueprint says prescriptions should show a flat array of medicine names.
- [ ] **No status filter tab bar.** The UI screenshots show tabs for filtering by prescription status (similar to Appointments tabs). No tab implementation exists.
- [ ] **Prescription navigates by `pushNamed` without passing any ID.** `context.pushNamed(RouteNames.prescriptionDetails)` carries no `extra` or path parameter. The Details screen has no ID to fetch detail data from the API.

### 3.6 Prescription Details Screen (`prescription_details_screen.dart`)

- [ ] **No ID parameter received.** Screen constructor has no `id` field, so it cannot call `GET /api/v1/patient/prescriptions/{id}`.
- [ ] **Entire screen is hardcoded.** `'Valid until: Nov 15, 2025'`, `'Prescribed by Dr. Sara Ahmed'`, medicine list are all static.
- [ ] **Missing fields from `PrescriptionDetailResource`:**
  - [ ] No `diagnosis` section (title + description).
  - [ ] No nested `patient` details card.
  - [ ] No nested doctor details card (medical_license, syndicate_id, clinic_address).
  - [ ] Medicine cards miss `category`, `instructions` fields.
- [ ] **Download button (`Icons.download_rounded`) is `() {}`.** Must implement `url_launcher` or `flutter_pdfview` / `syncfusion_flutter_pdfviewer` to open the prescription file URL.

### 3.7 Test Results Screen (`test_results_screen.dart`)

- [ ] **This screen shows a WRONG data model.** It displays lab values in a table (`Hemoglobin: 13.5 g/dL`, ranges, Normal/High/Low status). This is a **custom-parsed table of numeric test values** — but the API's `TestResultResource` returns **file attachments** (PDFs, images) not parsed numeric data. The entire UI paradigm is wrong.
- [ ] **No link to `GET /api/v1/patient/test-results`.** Fully static.
- [ ] **`test_result_status` (pending/reviewed) pill is absent.** The status pill in the list should show `PENDING` or `REVIEWED` from the API enum, not `Normal/High/Low`.
- [ ] **Missing list screen.** There is no "Test Results List" screen that shows all test result attachments with their names, dates, and statuses before drilling into one. The current screen shows only one result's detail.
- [ ] **Test Result Detail screen is MISSING.** The blueprint's `TestResultResource` detail includes `file_url` and `mime_type` for a PDF/image viewer. No dedicated detail screen with file viewing exists.
- [ ] **Download PDF button calls `() {}`.** Must open `file_url` from API using `url_launcher` or an embedded PDF viewer.

### 3.8 Image Viewer Screen (`image_viewer_screen.dart`)

- [ ] **Hardcoded Google image URL.** Uses a static `encrypted-tbn0.gstatic.com` URL — must be replaced with `imaging.imageUrl` from the API model.
- [ ] **Title is hardcoded `'Chest X-Ray'`.** Must be bound to `imaging.title`.
- [ ] **No ID parameter received.** Screen cannot call `GET /api/v1/patient/imaging/{id}`.
- [ ] **Missing Imaging list screen.** There is no screen listing all imaging records. The router has `image-viewer` as a child of `records`, but no intermediate "Imaging List" screen before the viewer.
- [ ] **Missing imaging metadata panel.** The UI screenshots show physician interpretation, modality, scan date, and file info in the detail view. None of these exist.
- [ ] **DICOM / PDF fallback not implemented.** If `mime_type` is `application/pdf`, `InteractiveViewer + Image.network` will crash. Need MIME-type-aware rendering (image vs. PDF).
- [ ] **No download/share action button** for the image file.

### 3.9 Profile Screen (`profile_screen.dart`)

- [ ] **Avatar shows mock/initials only; not bound to `avatar_url` from API.** `CachedNetworkImage` is available in `pubspec.yaml` but unused here. The avatar decision logic is `user.role.name == 'doctor'` which is entirely wrong for a patient.
- [ ] **Profile data (email, name only) sourced from auth token cache**, not from `GET /api/v1/patient/profile`. Extended profile fields (phone, birth_date, gender, blood_type, national_id, emergency_contact, governorate, chronic_conditions, allergies) are completely absent.
- [ ] **"Health Information" tile — `() {}` (dead).** Must navigate to a profile detail section or open the `PatientProfileModel` data.
- [ ] **"Notifications" settings tile — `() {}` (dead).**
- [ ] **"Help & Support" tile — `() {}` (dead).**
- [ ] **Dark Mode toggle switch `onChanged: (val) {}` — BROKEN.** The switch cannot actually change the theme. It reads `isDark` from `Theme.of(context)` but has no way to write back. There is no `ThemeMode` Riverpod provider. `ThemeMode.system` is hardcoded in `main.dart`. **This is a critical architectural gap** — no centralized theme state provider exists.
- [ ] **Edit Profile screen is a placeholder** (`"Full implementation coming in Phase 2"`). No `PATCH /api/v1/patient/profile` call is wired.
- [ ] **No avatar upload flow.** Profile camera icon exists but tapping it does nothing. No `POST /api/v1/patient/profile/avatar` exists.
- [ ] **No password change screen/flow.** `POST /api/v1/patient/profile/password` has no UI entry point.

### 3.10 Notifications Screen (`notifications_screen.dart`)

- [ ] **Fully hardcoded.** Uses inline mock list of 3 notifications. Not bound to any backend endpoint.
- [ ] **`GET /api/v1/patient/notifications` endpoint — MISSING from API Blueprint.** `ApiEndpoints.patientNotifications` constant exists in code but this endpoint was never defined in the blueprint. High risk of this returning a 404. This needs to be clarified with the backend team.
- [ ] **"Mark all read" action — `() {}` (dead).**
- [ ] **NotificationsScreen is not accessible from any nav item.** It has no bottom nav tab and the dashboard bell icon is a no-op.

### 3.11 Missing Critical Shared Widgets

- [ ] **`StatusPill` widget — MISSING.** Status pills (e.g., `ACTIVE`, `EXPIRED`, `PENDING`, `REVIEWED`, `DISPENSED`) are implemented inline inside each screen with copy-pasted decoration logic. A shared, enum-aware `StatusPill` widget does not exist.
- [ ] **`LoadingStateWidget` / `ErrorStateWidget` — MISSING.** No standardized empty state, error state, or loading shimmer integrated with Riverpod's `AsyncValue`. Each screen would need to handle all three states individually.
- [ ] **File download / view button widget — MISSING.** A shared widget for opening files (PDF viewer, image launcher) with proper MIME-type handling doesn't exist.
- [ ] **`PaginatedListView` — MISSING.** No scrollable list widget that triggers `loadMore()` as the user reaches the bottom, consuming `meta.current_page` / `meta.last_page`.
- [ ] **`DoctorAvatarCard` / `DoctorSummaryTile` — MISSING.** Doctor summary (name, specialty, avatar) is re-implemented inline in Appointments and Dashboard with hardcoded data. A shared widget doesn't exist.

### 3.12 Theme System Gaps

- [x] `AppColors`, `AppTextStyles`, `AppTheme` files exist and define light/dark themes.
- [ ] **`ThemeMode` is hardcoded to `ThemeMode.system` in `main.dart`.** No Riverpod `themeModeProvider` exists to allow user override.
- [ ] **Dark mode toggle in `ProfileScreen` is broken** (see 3.9 above) because there is no state provider to write to.
- [ ] **`withOpacity()` usage flagged as deprecated in Dart 3.3+.** Multiple files use `Colors.black.withOpacity(0.04)` etc. Should migrate to `Colors.black.withValues(alpha: 0.04)` or use `Color.fromRGBO`.

---

## Layer 4 — State Management & Routing

### 4.1 Riverpod State Architecture

- [x] `authProvider` (AsyncNotifier) with login/logout is correctly implemented.
- [x] `dioProvider` and `authRepositoryProvider` wiring is correct.
- [ ] **Zero domain-feature Providers exist.** No `dashboardProvider`, `appointmentsProvider`, `prescriptionsProvider`, `testResultsProvider`, `imagingProvider`, `profileProvider`, `visitHistoryProvider`, `medicalRecordsProvider`. Every feature screen is a stateless widget with hardcoded data — there is no state management below the auth layer at all.
- [ ] **No `ThemeNotifier` / `themeModeProvider`.** Theme preference cannot be persisted or controlled.
- [ ] **No `AccountStatus` redirect logic in `AuthNotifier`.** After a successful login, the notifier doesn't check `user.accountStatus` and dispatch to a pending/suspended screen.

### 4.2 Pagination — Completely Absent

- [ ] **`PaginatedResponse<T>` model — MISSING** (also listed in Layer 1 — this is the root cause).
- [ ] **No pagination state** (`currentPage`, `isLoadingMore`, `hasMore`) exists in any Notifier.
- [ ] **No `loadMore()` method** exists in any provider.
- [ ] **No infinite scroll / load-more trigger** exists in any list screen (Appointments, Prescriptions, Test Results, Imaging, Medical Records all return paginated responses from the API).
- [ ] **`meta.last_page` check** (to know when to stop paginating) is never implemented.

### 4.3 Routing / Navigation Gaps

- [ ] **`doctor-details` route receives no ID parameter.** `GoRoute(path: 'doctor-details')` builds `DoctorDetailsScreen()` with no extra data. The screen cannot fetch `GET /api/v1/patient/doctors/{id}`. The doctor ID must be passed via `GoRouterState.extra` or as a `:id` path parameter.
- [ ] **`prescription-details` route receives no ID parameter.** Same problem — `GoRoute(path: 'details')` builds `PrescriptionDetailsScreen()` with no ID. Cannot fetch `GET /api/v1/patient/prescriptions/{id}`.
- [ ] **`image-viewer` route receives no ID or URL.** Builds `ImageViewerScreen()` with no context about which imaging record to show.
- [ ] **`test-results` route receives no ID.** No detail route for individual test result files.
- [ ] **Appointment Detail route is MISSING.** No `GoRoute` for `/home/appointments/:id` or an appointment detail modal.
- [ ] **Medical Record Detail route is MISSING.** No route for `/home/records/:id`.
- [ ] **Imaging List route is MISSING.** The router jumps directly from Records to `image-viewer`. No intermediate imaging list screen route.
- [ ] **Visit History route is MISSING from the router entirely.** `ApiEndpoints.patientVisitHistory` exists but there is no `GoRoute` for it and no UI screen.
- [ ] **`/register-success` route does not check account status.** After registration, the API returns `account_status: "pending"`. The `SuccessScreen` should display different content (pending approval message) vs. the normal success flow. Currently it's a single hardcoded success message.
- [ ] **Deep-link / URL strategy not configured.** `GoRouter` has no `urlPathStrategy` set. On web this defaults to hash-based routing; on mobile this requires intent-filter configuration in `AndroidManifest.xml` and `Info.plist` which are not documented.
- [ ] **`redirect` in `routerProvider` uses `ref.read(authProvider)` not `ref.watch()`.** Using `read` inside a redirect means the redirect may not re-evaluate reliably when auth state changes. Should use `ref.watch(authProvider)` (or the `refreshListenable` handles it — which it does via `_AuthStateListenable`). This is a minor risk but should be validated.
- [ ] **Route error handler shows raw URI string** (`'Page not found: ${state.uri}'`). Must be replaced with a branded 404 screen.

### 4.4 Token / Session Management

- [x] `SecureStorageService` correctly stores token and user JSON.
- [x] `_ErrorInterceptor` correctly clears token on 401.
- [ ] **No `GET /api/v1/auth/me` call on app startup to validate token freshness.** The app restores user from `SecureStorage` without verifying the token is still valid server-side. If the token was revoked (e.g., by logout on another device), the user sees the app as authenticated until they make an API call that returns 401.
- [ ] **Token refresh / re-authentication flow is absent.** When 401 is received mid-session (interceptor clears token + storage) there is no automatic redirect to login. `_AuthStateListenable` would only redirect if `authProvider` state changes — but the interceptor calls `SecureStorageService.instance.clearAll()` directly without updating `authProvider`. **This means the user stays on the dashboard with cleared credentials until they perform an action that reads `authProvider`.**

---

## Summary Severity Matrix

| Priority | Layer | Gap |
|---|---|---|
| 🔴 P0 — Blocker | Layer 1 | All 15+ domain models are missing |
| 🔴 P0 — Blocker | Layer 2 | All 8 domain repositories are missing |
| 🔴 P0 — Blocker | Layer 2 | API endpoint prefix `/api/v1/` is missing on all routes |
| 🔴 P0 — Blocker | Layer 4 | Auth token invalidation does not update `authProvider` |
| 🔴 P0 — Blocker | Layer 4 | `PaginatedResponse<T>` wrapper is missing |
| 🔴 P0 — Blocker | Layer 3 | `doctor-details`, `prescription-details`, `image-viewer` routes pass no ID |
| 🟠 P1 — High | Layer 3 | All list screens are static mock data |
| 🟠 P1 — High | Layer 3 | `AccountStatus.pending/suspended` has no redirect screen |
| 🟠 P1 — High | Layer 3 | Dark mode toggle has no backing state provider |
| 🟠 P1 — High | Layer 3 | Appointment Detail, Medical Record Detail, Imaging List, Visit History screens are missing |
| 🟡 P2 — Medium | Layer 1 | `AppointmentType` enum missing; `Gender.other` invalid for API |
| 🟡 P2 — Medium | Layer 2 | 403 (suspended) and 404 not caught in `_ErrorInterceptor` |
| 🟡 P2 — Medium | Layer 3 | Test Results screen has wrong data paradigm (numeric table vs. file attachments) |
| 🟡 P2 — Medium | Layer 3 | Shared `StatusPill`, `PaginatedListView`, `ErrorStateWidget` widgets missing |
| 🟢 P3 — Low | Layer 2 | `rememberMe` field sent in login but not in API blueprint |
| 🟢 P3 — Low | Layer 3 | `withOpacity()` deprecation warnings |
| 🟢 P3 — Low | Layer 3 | Dashboard greeting not time-aware |
