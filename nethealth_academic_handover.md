# NetHealth — Academic Handover & Defense Preparation Document

> **Project:** NetHealth — Healthcare Management Platform  
> **Stack:** Flutter (Dart) · Laravel 11 (PHP) · Laravel Sanctum · Riverpod · Dio  
> **Prepared for:** Academic Project Defense  
> **Date:** May 2026

---

## Task 1 — Architectural Overview & File Structure

### 1.1 High-Level ASCII Tree

```
NetHealth/
├── nethealth_mobile/            # Flutter cross-platform mobile app
│   ├── lib/
│   │   ├── main.dart            # App entry point; ProviderScope root
│   │   ├── core/                # App-wide, feature-agnostic infrastructure
│   │   │   ├── constants/
│   │   │   │   ├── app_constants.dart
│   │   │   │   └── route_names.dart
│   │   │   ├── network/
│   │   │   │   ├── api_client.dart       # Dio factory + interceptor chain
│   │   │   │   ├── api_endpoints.dart    # Centralised URL constants
│   │   │   │   ├── dio_provider.dart     # Riverpod Provider<Dio>
│   │   │   │   └── models/
│   │   │   │       ├── standard_response.dart
│   │   │   │       ├── paginated_response.dart
│   │   │   │       └── pagination_meta.dart
│   │   │   ├── router/
│   │   │   │   └── app_router.dart       # GoRouter + auth-guard redirect
│   │   │   ├── theme/
│   │   │   │   ├── app_colors.dart
│   │   │   │   ├── app_text_styles.dart
│   │   │   │   ├── app_theme.dart
│   │   │   │   └── theme_provider.dart
│   │   │   └── utils/
│   │   │       ├── app_error.dart        # Sealed error hierarchy
│   │   │       ├── result.dart           # Result<T,E> monad
│   │   │       ├── secure_storage_service.dart
│   │   │       └── file_picker_util.dart
│   │   ├── features/            # Feature-First vertical slices
│   │   │   ├── auth/
│   │   │   │   ├── data/
│   │   │   │   │   ├── auth_repository.dart        # Abstract interface
│   │   │   │   │   ├── remote_auth_repository.dart # Live implementation
│   │   │   │   │   └── mock_auth_repository.dart   # Test/dev stub
│   │   │   │   ├── providers/
│   │   │   │   │   └── auth_provider.dart           # AuthNotifier (AsyncNotifier)
│   │   │   │   └── ui/
│   │   │   │       ├── splash_screen.dart
│   │   │   │       ├── onboarding_screen.dart
│   │   │   │       ├── select_role_screen.dart
│   │   │   │       ├── login_screen.dart
│   │   │   │       ├── registration_screen.dart
│   │   │   │       ├── success_screen.dart
│   │   │   │       ├── pending_approval_screen.dart
│   │   │   │       └── account_suspended_screen.dart
│   │   │   ├── home/
│   │   │   │   ├── data/
│   │   │   │   ├── providers/
│   │   │   │   └── ui/
│   │   │   │       ├── home_shell.dart       # StatefulShellRoute scaffold + bottom nav
│   │   │   │       └── dashboard_screen.dart
│   │   │   ├── appointments/
│   │   │   │   ├── data/
│   │   │   │   │   ├── appointments_repository.dart
│   │   │   │   │   └── doctor_repository.dart
│   │   │   │   ├── providers/
│   │   │   │   │   └── appointments_provider.dart
│   │   │   │   └── ui/
│   │   │   │       ├── appointments_screen.dart
│   │   │   │       ├── appointment_detail_screen.dart
│   │   │   │       ├── find_specialist_screen.dart
│   │   │   │       ├── doctor_selection_screen.dart
│   │   │   │       ├── doctor_details_screen.dart
│   │   │   │       └── booking_modals.dart
│   │   │   ├── profile/
│   │   │   │   ├── data/
│   │   │   │   │   └── profile_repository.dart
│   │   │   │   ├── providers/
│   │   │   │   │   └── profile_provider.dart  # ProfileNotifier (AsyncNotifier)
│   │   │   │   └── ui/
│   │   │   │       ├── profile_screen.dart
│   │   │   │       └── edit_profile_screen.dart
│   │   │   ├── records/
│   │   │   │   ├── data/
│   │   │   │   │   ├── medical_records_repository.dart
│   │   │   │   │   └── visit_history_repository.dart
│   │   │   │   ├── providers/
│   │   │   │   │   ├── medical_records_provider.dart
│   │   │   │   │   └── visit_history_provider.dart
│   │   │   │   └── ui/
│   │   │   │       ├── records_screen.dart
│   │   │   │       ├── medical_record_detail_screen.dart
│   │   │   │       └── visit_history_screen.dart
│   │   │   ├── prescriptions/
│   │   │   │   ├── data/ · providers/
│   │   │   │   └── ui/
│   │   │   │       ├── prescriptions_screen.dart
│   │   │   │       └── prescription_details_screen.dart
│   │   │   ├── tests_imaging/
│   │   │   │   ├── data/ · providers/
│   │   │   │   └── ui/
│   │   │   │       ├── test_results_screen.dart
│   │   │   │       ├── test_result_detail_screen.dart
│   │   │   │       ├── imaging_list_screen.dart
│   │   │   │       └── image_viewer_screen.dart
│   │   │   └── notifications/
│   │   │       └── ui/
│   │   │           └── notifications_screen.dart
│   │   └── shared/              # Cross-feature reusable code
│   │       ├── models/          # 14 Dart data-model classes
│   │       ├── widgets/         # 7 reusable NH-prefixed widgets
│   │       └── ui/
│   ├── assets/
│   │   ├── images/
│   │   └── icons/
│   └── pubspec.yaml
└── nethealth-backend/           # Laravel 11 REST API
    ├── app/
    │   ├── Http/
    │   │   ├── Controllers/Api/
    │   │   │   ├── AuthController.php
    │   │   │   └── Patient/        # 8 patient API controllers
    │   │   ├── Middleware/
    │   │   └── Requests/           # Form-request validators
    │   ├── Models/                 # 14 Eloquent models
    │   └── Enums / Traits / Rules
    ├── routes/
    │   ├── api.php                 # All REST routes (versioned /api/v1)
    │   └── web.php                 # Inertia admin panel routes
    └── database/                  # Migrations + Seeders
```

### 1.2 Architectural Pattern

The Flutter application follows a **Feature-First (Vertical-Slice) Architecture** combined with the **Repository Pattern** and a strict **Unidirectional Data Flow**.

**Feature-First Organisation** means the codebase is sliced by *domain* (`auth`, `appointments`, `records`, `profile`…) rather than by *file type*. Each feature is a self-contained module with three sub-layers:

| Sub-layer | Folder | Responsibility |
|-----------|--------|----------------|
| **Data** | `feature/data/` | Network calls, raw JSON parsing, `FormData` construction |
| **State** | `feature/providers/` | Business logic, async state lifecycle |
| **Presentation** | `feature/ui/` | Widgets — observe state, dispatch actions, render UI |

**Core** holds cross-cutting concerns (Dio client, router, theme, error types) that no single feature owns. **Shared** holds models and widgets that multiple features reference.

This design enforces separation of concerns: a UI screen never touches `Dio` directly — it only calls methods on a Provider, which delegates to a Repository.

---

## Task 2 — File Typology & UI Breakdown

### 2.1 File Typology

#### `*_repository.dart` — The Data Access Layer (DAL)

A Repository is a plain Dart class that owns a `Dio` instance. Its sole responsibility is **network I/O**: serialising request payloads, executing HTTP verbs, deserialising raw JSON into typed Dart model objects, and mapping transport-level `DioException`s into the app's own `AppError` sealed class. It has no knowledge of Riverpod, Flutter, or UI.

*Example:* `AppointmentsRepository.bookAppointment()` — builds a `FormData` payload, conditionally attaches a `MultipartFile`, and fires a `POST` request. It returns either a typed model or throws an `AppError`.

#### `*_provider.dart` — The State Management Layer

A provider file wires together Riverpod primitives. It may contain:

- A **`Provider<Repository>`** that exposes a repository instance to the DI graph.  
- A **`FutureProvider`** for simple read-only async data (e.g., `appointmentsProvider`, `visitHistoryProvider`).  
- An **`AsyncNotifier`** subclass for stateful, write-capable logic (e.g., `AuthNotifier`, `ProfileNotifier`). The `AsyncNotifier` exposes mutable actions (`login()`, `logout()`, `updateProfile()`) and owns the `AsyncValue<T>` state that the UI subscribes to.

The critical principle: providers *mediate* between repositories and the UI. They hold no HTTP code and no widget references.

#### `*_model.dart` — The Data Transfer Object (DTO)

A model is an **immutable Dart class** that represents a domain entity. Each model implements:

- `factory Model.fromJson(Map<String, dynamic>)` — safe deserialisaton with null-coalescing and type checks.
- `toJson()` / `toJsonString()` — serialisation (used when caching to `FlutterSecureStorage`).
- Optionally `copyWith()` for creating modified copies without mutation.

Models have zero dependency on Flutter, Dio, or Riverpod. The `enums.dart` file in `shared/models/` mirrors the PHP-side Laravel enums exactly, ensuring the client and server speak the same value vocabulary.

### 2.2 UI Screen Breakdown

#### Feature: Auth

| Screen | Role | Provider |
|--------|------|----------|
| `splash_screen.dart` | Displays the logo while `authProvider` resolves; GoRouter redirects automatically once state is known | `authProvider` |
| `onboarding_screen.dart` | Three-page marketing carousel for first-time users; entry point to registration and login flows | None |
| `select_role_screen.dart` | Lets the user choose their account type (`Patient`, `Doctor`, `Clinic`, `Pharmacy`) before proceeding to the role-specific registration form | None |
| `login_screen.dart` | Email/password form that calls `AuthNotifier.login()`; renders inline validation errors from the `ValidationError` type | `authProvider` (AsyncNotifier) |
| `registration_screen.dart` | Multi-step registration form that adapts its field set based on the role path parameter; fires a role-specific POST to the backend | `authProvider` |
| `success_screen.dart` | Shown after successful registration; informs the user their account is pending admin approval | None |
| `pending_approval_screen.dart` | Holding screen for users whose `account_status == pending`; GoRouter redirects here automatically from any protected route | `authProvider` |
| `account_suspended_screen.dart` | Holding screen for users whose `account_status == suspended`; provides a contact-support prompt | `authProvider` |

#### Feature: Home

| Screen | Role | Provider |
|--------|------|----------|
| `home_shell.dart` | The `StatefulShellRoute` scaffold that renders the persistent bottom navigation bar across five tabs (Dashboard, Appointments, Records, Notifications, Profile) | `routerProvider` |
| `dashboard_screen.dart` | Rich home page presenting upcoming appointments, recent prescriptions, and health-record summaries pulled from the patient dashboard endpoint | Dashboard-specific `FutureProvider` |

#### Feature: Appointments

| Screen | Role | Provider |
|--------|------|----------|
| `appointments_screen.dart` | Lists the patient's own appointments with status-based tab filtering (Scheduled / Completed / Cancelled) and exposes booking/cancel actions | `appointmentsProvider` |
| `find_specialist_screen.dart` | Searchable, filterable list of all available doctors by specialty; the entry point of the booking flow | `appointmentsRepositoryProvider` |
| `doctor_selection_screen.dart` | Intermediate screen in the booking wizard for confirming the chosen doctor | `doctorRepositoryProvider` |
| `doctor_details_screen.dart` | Detailed doctor profile (bio, qualifications, clinics, available slots) and the primary `Book Appointment` action entry point | `appointmentsRepositoryProvider` |
| `booking_modals.dart` | Bottom-sheet modal wizard that collects appointment type, date/time slot, optional visit reason, and an optional file attachment before submitting | `appointmentsRepositoryProvider` |
| `appointment_detail_screen.dart` | Read-only detail view of a single appointment; provides Reschedule and Cancel actions | `appointmentDetailProvider` (FutureProvider.family) |

#### Feature: Records

| Screen | Role | Provider |
|--------|------|----------|
| `records_screen.dart` | Tabbed hub for all patient health data: Medical Records, Prescriptions, Test Results, and Imaging; acts as a navigation launcher | `medicalRecordsRepositoryProvider`, `visitHistoryProvider` |
| `medical_record_detail_screen.dart` | Full detail view of a single medical record including doctor, appointment, diagnosis notes, and record status | `medicalRecordsRepositoryProvider` |
| `visit_history_screen.dart` | Chronological list of all past clinical visits with doctor name and date | `visitHistoryProvider` |

#### Feature: Profile

| Screen | Role | Provider |
|--------|------|----------|
| `profile_screen.dart` | Displays the authenticated patient's full profile, avatar, and account settings; provides navigation to edit/password/logout | `profileProvider`, `authProvider` |
| `edit_profile_screen.dart` | Form for updating demographics (name, phone, DOB, gender, blood type, address); also supports avatar upload via `image_picker` | `profileProvider` (AsyncNotifier) |

#### Feature: Tests & Imaging

| Screen | Role | Provider |
|--------|------|----------|
| `test_results_screen.dart` | Lists all lab test results with status badges (Pending / Reviewed) | `FutureProvider` → `PatientTestResultApiController` |
| `test_result_detail_screen.dart` | Detailed view of a single test result including lab name, reference range, and attached files | `FutureProvider.family` |
| `imaging_list_screen.dart` | Grid of radiology/imaging studies with thumbnail previews | `FutureProvider` |
| `image_viewer_screen.dart` | Full-screen DICOM/image viewer for a selected imaging study | `FutureProvider.family` |

#### Feature: Prescriptions

| Screen | Role | Provider |
|--------|------|----------|
| `prescriptions_screen.dart` | Lists all prescriptions with status chips; navigates to detail | `FutureProvider` |
| `prescription_details_screen.dart` | Full prescription detail with medicine list, dosage, issuing doctor, and dispensing status | `FutureProvider.family` |

---

## Task 3 — Core Concepts & Defense Preparation

### 3.1 State Management: Riverpod `AsyncNotifier` vs `setState`

**The problem with `setState`:** Flutter's built-in `setState` couples business logic to the widget lifecycle. State is owned by a `StatefulWidget` subtree, making it impossible to share across distant parts of the widget tree without prop-drilling or `InheritedWidget` boilerplate. Furthermore, `setState` has no native concept of loading/error/data states for asynchronous operations, forcing developers to manually manage boolean flags (`isLoading`, `hasError`, `errorMessage`) which is error-prone.

**Why Riverpod's `AsyncNotifier`:** Riverpod was selected for its compile-time safety, testability, and its `AsyncValue<T>` abstraction. `AsyncValue<T>` is a discriminated union type that models exactly three mutually exclusive states: `AsyncLoading`, `AsyncData<T>`, and `AsyncError`. This eliminates the need for manual flag management.

The `AsyncNotifier` class separates *state* (the `AsyncValue`) from *logic* (the `build()` method and action methods like `login()`, `updateProfile()`). The UI subscribes to the notifier declaratively using `ref.watch()`, and the framework rebuilds only the affected subtree when state transitions occur.

```dart
// AuthNotifier — simplified state transitions
class AuthNotifier extends AsyncNotifier<AuthUser?> {
  @override
  Future<AuthUser?> build() async =>
      ref.read(authRepositoryProvider).getStoredUser();

  Future<void> login(LoginCredentials credentials) async {
    state = const AsyncLoading();                      // 1. Trigger loading UI
    final result = await ref.read(authRepositoryProvider).login(credentials);
    state = result is Success ? AsyncData(result.data) // 2a. Success
          : AsyncError(result.error, StackTrace.current); // 2b. Error
  }
}
```

Compared to competing solutions: **Provider** (the predecessor package) lacks code generation and has a less type-safe API. **BLoC/Cubit** introduces significant boilerplate (Events, States, Streams). **GetX** couples routing, state, and DI into a single opinionated framework, making unit testing harder. Riverpod occupies the ideal middle ground: minimal boilerplate, maximum testability, and full Dart type-safety.

### 3.2 Networking & Interceptors: Dio with Sanctum Tokens

The backend is secured using **Laravel Sanctum**, which issues opaque Bearer tokens upon login. These tokens must be attached to every subsequent request as an `Authorization: Bearer <token>` HTTP header.

Rather than repeating this in every repository method, the `dioProvider` configures Dio with an **`InterceptorsWrapper`** — a middleware pipeline that executes code before and after every request/response cycle globally.

**`_AuthInterceptor` (request phase):** Before any HTTP request is dispatched, the interceptor's `onRequest` callback is invoked. It reads the token from `FlutterSecureStorage` (an AES-encrypted keychain) and injects it into the request headers. This is entirely transparent to the repositories.

**`_ErrorInterceptor` (error phase):** When the server returns an `HTTP 401 Unauthorized`, it means the user's session has expired or the token was revoked. The interceptor's `onError` callback fires, calls `SecureStorageService.instance.clearAll()` to delete the stale token, and then calls `ref.read(authProvider.notifier).forceLogout()` — which sets the Riverpod auth state to `AsyncData(null)`. The `GoRouter`'s `refreshListenable` (`_AuthStateListenable`) detects this state change and automatically redirects the user to the onboarding screen. The entire session expiry flow is handled without a single line of UI code.

```
Request → _AuthInterceptor.onRequest() → [inject Bearer token] → Server
Server  → 401 Unauthorized → _ErrorInterceptor.onError()
        → clearAll() + forceLogout() → GoRouter redirect → /onboarding
```

**Timeout handling:** `connectTimeout` and `receiveTimeout` are both configured to 15 seconds. A `DioExceptionType.connectionTimeout` is caught in the repository's `_mapDioError()` method and translated to `NetworkError`, which the UI renders as a user-friendly message.

### 3.3 Data Serialisation: JSON → Dart Objects

The Laravel backend wraps all API responses in a consistent **Standard Response Envelope**:

```json
// Single object
{ "status": "success", "message": "...", "data": { ... } }

// Paginated list
{ "status": "success", "message": "...", "data": [ ... ], "meta": { "total": 42, ... } }
```

Two generic Dart classes handle these patterns uniformly:

- **`StandardResponse<T>`**: Wraps a single object. Its `fromJson` factory accepts a `T Function(dynamic json)` callback, making it reusable with any model type.
- **`PaginatedResponse<T>`**: Wraps a list plus a `PaginationMeta` object. Used for all list endpoints.

Each model implements a hand-written `factory Model.fromJson()` with **defensive null-coalescing** (using the `??` operator and explicit `toString()` coercions). This is a deliberate choice over code generation libraries like `freezed`/`json_serializable` in the models layer, because it gives full control over edge-case parsing (e.g., the backend may return an `id` as either an `int` or a `String` — the `AuthUser.fromJson` handles both explicitly).

The `enums.dart` file mirrors all PHP-side Laravel Enums as Dart enums with a `fromString()` factory, ensuring that a value like `"appointment_type": "physical"` from the API is safely deserialized to `AppointmentType.physical` in Dart, with a safe fallback if an unexpected value arrives.

### 3.4 Multipart File Uploads: `FormData` with Dio

Standard HTTP requests send data as `application/json`. File uploads require `multipart/form-data` encoding, which bundles text fields and binary file parts into a single request body with MIME boundaries. Dio's `FormData` class handles this encoding automatically.

The implementation follows a **conditional FormData pattern** in the repositories:

```dart
// From AppointmentsRepository.bookAppointment()
final Map<String, dynamic> dataMap = {
  'doctor_id': doctorId,
  'appointment_type': appointmentType,
  // ... other text fields
};

if (attachment != null) {
  // Binary file → MultipartFile reads the file from disk asynchronously
  dataMap['attachment'] = await MultipartFile.fromFile(attachment.path);
  // FormData wraps the map, setting Content-Type: multipart/form-data
  await _dio.post(endpoint, data: FormData.fromMap(dataMap));
} else {
  // No file → send as plain JSON, more efficient
  await _dio.post(endpoint, data: dataMap);
}
```

`MultipartFile.fromFile()` is an `async` call that reads the file from the filesystem before the request is dispatched. The file path is obtained upstream from either `image_picker` (camera/gallery) or `file_picker` (document browser), both of which return a platform-native file path. The `Content-Type` header is automatically set to `multipart/form-data` by Dio when the data argument is a `FormData` instance — the developer does not need to set it manually.

This pattern is applied in three places: **Appointment booking** (optional document), **Profile avatar update**, and **Medical record file uploads** (test results and imaging).

---

## Task 4 — Anticipated Professor Questions & Answers

---

**Q1: Why did you choose to separate the Repository from the Provider/Notifier? Isn't it extra complexity?**

**A:** The separation enforces the **Single Responsibility Principle**. The repository's only job is data access — it knows how to speak HTTP and translate raw JSON. The notifier's only job is state management — it knows when to show a loading spinner and how to handle errors for the UI. If we later need to swap the backend (e.g., use GraphQL instead of REST), we only rewrite the repository. The notifier, the UI, and all tests remain unchanged. Additionally, repositories can be independently unit-tested by mocking `Dio`, while notifiers can be tested using `ProviderContainer` without any HTTP layer at all.

---

**Q2: What happens if the API fails mid-request? How does the UI respond?**

**A:** Failures are modelled explicitly using the `sealed class AppError` hierarchy: `UnauthorizedError`, `ValidationError`, `ServerError`, `NetworkError`, and `UnknownError`. In the repository, every `DioException` is caught and mapped to one of these typed errors. The notifier catches the thrown `AppError` and transitions state to `AsyncError(error, stackTrace)`. In the UI, every `FutureProvider` or `AsyncNotifier` is consumed using `when(data: ..., loading: ..., error: ...)`. The `error` callback renders a contextual message derived from the `AppError` type — not a raw exception string. The user sees "No internet connection." for a timeout, or "Session expired." for a 401, rather than a crash or a technical stack trace.

---

**Q3: How did you prevent UI freezing during file uploads?**

**A:** Dart's concurrency model is single-threaded with an event loop, but `async/await` ensures I/O operations are non-blocking. `MultipartFile.fromFile()` and `_dio.post()` are both `Future`-based, meaning the Dart VM suspends the coroutine and yields control back to the UI event loop while waiting for I/O. The Flutter rendering pipeline continues to execute at 60fps throughout. The UI displays a loading state (`AsyncLoading`) via the notifier state transition, which renders a `CircularProgressIndicator`, giving the user visual feedback. No isolates were needed because file I/O in Dart is already asynchronous at the platform channel level.

---

**Q4: How is authentication state persisted across app restarts?**

**A:** Upon successful login, two pieces of data are written to `FlutterSecureStorage`: the **Bearer token** (under the `tokenKey` constant) and a **JSON-serialised `AuthUser`** object (under the `userKey` constant). On Android, `FlutterSecureStorage` uses `EncryptedSharedPreferences` (AES-256 via the AndroidX Security library). On iOS, it uses the system Keychain. When the app launches, `AuthNotifier.build()` is called automatically by Riverpod. It calls `RemoteAuthRepository.getStoredUser()`, which reads the cached user JSON from secure storage and deserialises it. If found, the user is considered authenticated instantly without an extra network round-trip. The `GoRouter` reads this state and routes the user directly to the dashboard.

---

**Q5: Why use GoRouter's `redirect` instead of just checking auth state inside each screen?**

**A:** Checking auth state inside individual screens creates scattered, duplicated guard logic and is error-prone — a developer adding a new screen might forget to add the check. GoRouter's `redirect` callback is a **centralised route guard** that intercepts every navigation event before it resolves. The `_AuthStateListenable` bridge calls `notifyListeners()` whenever the Riverpod `authProvider` emits a new state. GoRouter reacts by re-evaluating the `redirect` function. This means session expiry (triggered by the Dio 401 interceptor) automatically redirects the user to `/onboarding` without any screen-level code. Additionally, the router enforces **account-status-based access control**: a `pending` user is redirected to `/pending-approval` from any route, and a `suspended` user is redirected to `/account-suspended`, regardless of which URL they attempt to navigate to.

---

**Q6: What is the `Result<T, E>` type and why was it used instead of try/catch in the auth layer?**

**A:** `Result<T, E>` is a **discriminated union** (sum type) implemented as a sealed class with two subtypes: `Success<T, E>` and `Failure<T, E>`. It is used in the authentication layer specifically (not in the repository layer broadly) to make the return type of `login()` and `getMe()` **explicit about the possibility of failure at the type level**. The caller (`AuthNotifier`) must explicitly handle both cases via pattern matching; it cannot accidentally ignore an error. In contrast, a raw `try/catch` around an `async` method that returns `T` is invisible to the type system — a future caller has no compile-time indication that the call can fail. For simpler repository methods that only the notifier internally handles, `throw AppError` is used for brevity, as the notifier catches it in its own try/catch block.

---

**Q7: How does the app handle role-based access, given the backend supports multiple roles?**

**A:** Role enforcement happens at two levels. On the **backend**, the Laravel route group for patient endpoints is guarded by a custom `role:patient` middleware and an `active` middleware, ensuring that a doctor or clinic admin token cannot access patient resources — the server returns 403 Forbidden. On the **frontend**, the `AuthUser` model carries the user's `role` (as a `UserRole` enum) and `accountStatus` (as an `AccountStatus` enum). The GoRouter `redirect` function reads these values and routes users to role-appropriate screens (e.g., `pending` → `PendingApprovalScreen`, `suspended` → `AccountSuspendedScreen`). The enums in `shared/models/enums.dart` are intentionally written to mirror the Laravel PHP-side enum values exactly, so deserialization is deterministic and safe.

---

## Task 5 — Technology Stack Summary

| Concern | Technology | Version |
|---------|-----------|---------|
| Mobile Framework | Flutter (Dart SDK ≥ 3.3) | Stable |
| State Management | flutter_riverpod + riverpod_annotation | ^2.6.1 |
| Code Generation | riverpod_generator, build_runner | ^2.4.3 |
| HTTP Client | Dio | ^5.7.0 |
| Declarative Routing | go_router | ^14.6.2 |
| Secure Token Storage | flutter_secure_storage | ^9.2.2 |
| JSON Serialisation | json_annotation + json_serializable | ^4.9.0 |
| Immutable Models | freezed_annotation + freezed | ^2.4.4 |
| Image Handling | cached_network_image | ^3.4.1 |
| File Picking | file_picker + image_picker | ^11.0.2 / ^1.2.1 |
| Typography | google_fonts (Inter + Outfit) | ^6.2.1 |
| Shimmer Loading | shimmer | ^3.0.0 |
| Backend Framework | Laravel | 11.x |
| Auth Mechanism | Laravel Sanctum (token-based) | — |
| API Style | RESTful JSON, versioned at `/api/v1` | — |
| Database | MySQL / SQLite (local dev) | — |
| Admin Panel | Inertia.js + Vue 3 | — |

---

*End of NetHealth Academic Handover Document.*
