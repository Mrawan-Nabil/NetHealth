# 🏥 NetHealth — Flutter REST API Blueprint
> **Architect:** Senior Backend Analysis & Design  
> **Date:** April 2026  
> **Stack:** Laravel 11 · Sanctum Token Auth · `JsonResource` API Resources  
> **Base URL:** `https://your-domain.com/api/v1`

---

## 📋 Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Standard Response Envelope](#standard-response-envelope)
3. [API Resources Directory](#api-resources-directory)
4. [🔐 Authentication API](#-authentication-api)
5. [🏠 Dashboard API](#-dashboard-api)
6. [📅 Appointments API](#-appointments-api)
7. [🗂️ Medical Records API](#-medical-records-api)
8. [💊 Prescriptions API](#-prescriptions-api)
9. [🧪 Test Results API](#-test-results-api)
10. [🩻 Imaging API](#-imaging-api)
11. [📆 Visit History API](#-visit-history-api)
12. [👤 Profile API](#-profile-api)
13. [Middleware & Route Registration](#middleware--route-registration)

---

## Architecture Overview

The web app uses **Inertia.js** (session-based, stateful). The Flutter app will use **Sanctum token-based auth** (stateless). The strategy is:

- All API endpoints live under `/api/v1/` and use the dedicated `api` guard.
- All controllers go in `app/Http/Controllers/Api/Patient/`.
- All response formatting is handled exclusively by **Laravel API Resources** (`JsonResource`) — controllers must **never** return raw eloquent models or hand-rolled arrays.
- A common `ApiResponse` trait will wrap all responses in a consistent envelope.

### Key Enum Values (for Flutter's reference)
| Enum | Values |
|---|---|
| `AppointmentStatus` | `scheduled`, `completed`, `cancelled` |
| `AppointmentType` | `physical`, `remote`, `emergency` |
| `AttachmentType` | `imaging`, `lab_result`, `clinical_document`, `prescription` |
| `TestResultStatus` | `pending`, `reviewed` |
| `PrescriptionStatus` | `pending`, `issued`, `dispensed`, `cancelled` |
| `AccountStatus` | `active`, `suspended`, `pending` |
| `BloodType` | `A+`, `A-`, `B+`, `B-`, `AB+`, `AB-`, `O+`, `O-` |

---

## Standard Response Envelope

Every API response — success or error — **must** follow this shape so Flutter can parse it predictably.

**Success (200/201):**
```json
{
  "status": "success",
  "message": "Data retrieved successfully.",
  "data": { ... }
}
```

**Paginated Collection:**
```json
{
  "status": "success",
  "message": "Appointments retrieved.",
  "data": [ ... ],
  "meta": {
    "current_page": 1,
    "last_page": 4,
    "per_page": 15,
    "total": 52
  }
}
```

**Validation Error (422):**
```json
{
  "status": "error",
  "message": "The given data was invalid.",
  "errors": {
    "email": ["The email field is required."]
  }
}
```

**Auth Error (401):**
```json
{
  "status": "error",
  "message": "Unauthenticated."
}
```

**Not Found (404):**
```json
{
  "status": "error",
  "message": "Resource not found."
}
```

> **Implementation:** Create `app/Traits/ApiResponse.php` with `successResponse()`, `errorResponse()`, and `paginatedResponse()` helper methods. Use it in `app/Http/Controllers/Api/ApiController.php` (the shared base for all API controllers).

---

## API Resources Directory

Create the following `JsonResource` files. This is the complete scaffolding list.

```
app/Http/Resources/
├── Api/
│   ├── UserResource.php
│   ├── DoctorSummaryResource.php       # Lightweight: name, specialty, avatar
│   ├── DoctorDetailResource.php        # Full profile for booking page
│   ├── AppointmentResource.php
│   ├── AppointmentDetailResource.php   # With nested doctor, clinic, medical record
│   ├── ClinicResource.php
│   ├── MedicalRecordResource.php
│   ├── MedicalAttachmentResource.php   # Shared base for attachments
│   ├── TestResultResource.php
│   ├── ImagingResource.php
│   ├── ImagingSummaryResource.php      # Lightweight for list view
│   ├── PrescriptionResource.php        # Summary card view
│   ├── PrescriptionDetailResource.php  # Full detail with medicines
│   ├── PrescriptionItemResource.php
│   ├── MedicineResource.php
│   ├── PatientProfileResource.php
│   └── DashboardResource.php
```

---

## 🔐 Authentication API

> **Note:** `Api\AuthController` already exists at `app/Http/Controllers/Api/AuthController.php`. It needs to be **extended** with registration, a "me" endpoint, and account-status handling.

---

**`POST /api/v1/auth/login`**
- **Description:** Authenticates a patient and returns a Sanctum bearer token. Checks `account_status` and returns it to Flutter so the app can show a "Pending Approval" screen.
- **Controller Action:** `Api\AuthController@login` *(already exists — extend it)*
- **Auth Required:** No
- **Request Payload:**
  ```json
  {
    "email": "required|email",
    "password": "required|string"
  }
  ```
- **Response Resource:** `UserResource` (embedded in the token response, not a standalone resource response)
- **Implementation Notes:**
  - After successful auth, **also return `account_status`** in the response. The existing controller omits this, causing Flutter to be unaware of pending accounts.
  - Return `"account_status": "pending"` so Flutter can redirect to a waiting screen. Do NOT issue a token for suspended accounts — return `403` with `"message": "Your account has been suspended."`.
  - Token name should remain `'flutter-app'`.
  - **Full expected response shape:**
    ```json
    {
      "status": "success",
      "token": "1|abc...",
      "token_type": "Bearer",
      "user": {
        "id": 1,
        "full_name": "Ahmed Hassan",
        "email": "ahmed@example.com",
        "role": "patient",
        "account_status": "active",
        "avatar_url": "https://..."
      }
    }
    ```

---

**`POST /api/v1/auth/register/patient`**
- **Description:** Registers a new patient account. Mirrors the web `Auth\PatientController@store` flow but returns a token instead of redirecting.
- **Controller Action:** `Api\Auth\PatientRegistrationController@store` *(new)*
- **Auth Required:** No
- **Request Payload:**
  ```json
  {
    "full_name":                   "required|string|max:255",
    "email":                       "required|email|unique:users",
    "password":                    "required|string|min:8|confirmed",
    "phone":                       "required|string",
    "gender":                      "required|in:male,female",
    "birth_date":                  "required|date",
    "governorate":                 "required|string",
    "national_id":                 "required|string|unique:users",
    "blood_type":                  "required|in:A+,A-,B+,B-,AB+,AB-,O+,O-",
    "allergies":                   "nullable|array",
    "chronic_conditions":          "nullable|string",
    "emergency_contact_name":      "nullable|string",
    "emergency_contact_phone":     "nullable|string"
  }
  ```
- **Response Resource:** Same token+user shape as login
- **Implementation Notes:**
  - Reuse the existing `RegistersUsers` trait's `createBaseUser()` method — do not duplicate user creation logic.
  - After creation, the `account_status` will be `pending` (default). Return the token regardless so the Flutter app can make authenticated calls, but the app should detect `account_status: "pending"` and show the waiting screen.
  - Do NOT auto-login via `Auth::login()` (web session). Instead, issue a Sanctum token.

---

**`GET /api/v1/auth/me`**
- **Description:** Returns the currently authenticated user's basic profile. Used by Flutter on app startup to rehydrate the auth state.
- **Controller Action:** `Api\AuthController@me` *(new method)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload:** None (uses Bearer token from header)
- **Response Resource:** `UserResource`
- **Implementation Notes:**
  - Load `user->patient` relationship.
  - Return the full `UserResource` including `account_status`, `role`, and `avatar_url`.

---

**`POST /api/v1/auth/logout`**
- **Description:** Revokes the current Sanctum token. The existing controller method is already correct.
- **Controller Action:** `Api\AuthController@logout` *(already exists — no changes needed)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload:** None
- **Response Resource:** None (simple status message)
- **Implementation Notes:** Already implemented. Just wire it up in `routes/api.php`.

---

## 🏠 Dashboard API

**`GET /api/v1/patient/dashboard`**
- **Description:** Returns all data needed to render the patient's main dashboard home screen in a single request — health overview, stats counters, next appointment, and recent records.
- **Controller Action:** `Api\Patient\DashboardApiController@index` *(new)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload:** None
- **Response Resource:** `DashboardResource`
- **Implementation Notes:**
  - This is a direct translation of `Patient\DashboardController@index`.
  - The `DashboardResource` should return a flat, typed object (not a collection):
    ```json
    {
      "health_overview": {
        "blood_type": "A+",
        "allergies": ["Penicillin"],
        "chronic_conditions": "Hypertension",
        "primary_doctor": {
          "full_name": "Dr. Sara Kamel",
          "specialty": "Cardiologist",
          "avatar_url": "https://..."
        }
      },
      "stats": {
        "upcoming_appointments": 2,
        "active_prescriptions": 1,
        "pending_tests": 3
      },
      "next_appointment": { ... },
      "recent_records": [ ... ]
    }
    ```
  - **Critical:** `next_appointment` must use ISO 8601 datetime (`"2026-05-10T10:00:00Z"`), NOT pre-formatted strings like `"May 10, 2026 - 10:00 AM"`. Let the Flutter app format it.
  - `recent_records` — return `appointment_id`, `doctor_full_name`, `appointment_time` (ISO 8601), and `status`.
  - Guard against the case where `$user->patient` is `null` — return a `404` with `"message": "Patient profile not found. Please complete your setup."`.

---

## 📅 Appointments API

**`GET /api/v1/patient/appointments`**
- **Description:** Returns the patient's full appointment list, optionally filtered by status. Supports pagination.
- **Controller Action:** `Api\Patient\AppointmentApiController@index` *(new)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload (Query Parameters):**
  ```
  status   nullable|in:scheduled,completed,cancelled   (e.g., ?status=scheduled)
  per_page nullable|integer|min:5|max:50               (default: 15)
  page     nullable|integer
  ```
- **Response Resource:** `AppointmentResource::collection()` (paginated)
- **Implementation Notes:**
  - Replaces the mapping logic in `Patient\AppointmentController@index`.
  - `AppointmentResource` must include: `id`, `appointment_time` (ISO 8601), `status` (raw enum value), `appointment_type`, `visit_reason`, nested `doctor` (name, specialty, avatar_url), nested `clinic` (name, address).
  - **Remove** the web-only camelCase keys (`doctorName`, `doctorAvatar`, `clinicAddress`) — use `snake_case` throughout the API.
  - **Avatar URL:** Use `asset('storage/' . $doctor->user->avatar)` if avatar exists, otherwise return the `ui-avatars.com` fallback URL. This logic belongs **inside `DoctorSummaryResource`** so it's reused everywhere.
  - `cancelled_by` and `reason` columns don't exist yet — return `null` for both, do not hardcode strings.
  - Eager load: `['doctor.user', 'clinic', 'medicalRecord']`

---

**`GET /api/v1/patient/appointments/{id}`**
- **Description:** Returns the full details of a single appointment, including its linked medical record summary.
- **Controller Action:** `Api\Patient\AppointmentApiController@show` *(new)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload:** None (ID is in path)
- **Response Resource:** `AppointmentDetailResource`
- **Implementation Notes:**
  - Authorize that `$appointment->patient_id === $request->user()->patient->user_id` before returning, else abort 403.
  - Eager load: `['doctor.user', 'clinic', 'medicalRecord.diagnoses', 'medicalRecord.prescriptions', 'medicalRecord.attachments']`

---

**`GET /api/v1/patient/doctors`**
- **Description:** Returns a searchable list of all available doctors for the "Book Appointment" screen.
- **Controller Action:** `Api\Patient\AppointmentApiController@getDoctors` *(new)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload (Query Parameters):**
  ```
  specialty  nullable|string   (filter by specialty, e.g. ?specialty=Cardiology)
  search     nullable|string   (search by doctor name)
  per_page   nullable|integer  (default: 20)
  ```
- **Response Resource:** `DoctorSummaryResource::collection()` (paginated)
- **Implementation Notes:**
  - Replaces `AppointmentController@create` doctor listing logic.
  - `DoctorSummaryResource` exposes: `id` (which is `user_id`), `full_name` (with "Dr." prefix), `specialty`, `avatar_url`, `consultation_fee`, `clinic_name`, `experience`, `qualifications`.
  - **Remove** the `rand()` calls for `rating` and `reviews` — these are placeholders; do not send fake data to a mobile app. Omit these fields entirely until real ratings exist.
  - The clinic is inferred via the doctor's most recent appointment's clinic. Annotate this in code as a TODO to add a `doctor_clinic` pivot table.

---

**`GET /api/v1/patient/doctors/{id}`**
- **Description:** Returns the full profile of a single doctor for the booking/profile page.
- **Controller Action:** `Api\Patient\AppointmentApiController@showDoctor` *(new)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload:** None
- **Response Resource:** `DoctorDetailResource`
- **Implementation Notes:**
  - `DoctorDetailResource` includes everything from `DoctorSummaryResource` plus: `professional_title`, `medical_license`, `syndicate_id`, `experience`, `qualifications`.
  - Again, omit placeholder `rand()` ratings.

---

**`POST /api/v1/patient/appointments`**
- **Description:** Books a new appointment. The logic is identical to the web `store` method.
- **Controller Action:** `Api\Patient\AppointmentApiController@store` *(new)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload:**
  ```json
  {
    "doctor_id":        "required|exists:doctors,user_id",
    "appointment_time": "required|date|after:now",
    "appointment_type": "required|in:physical,remote,emergency",
    "visit_reason":     "nullable|string|max:1000"
  }
  ```
- **Response Resource:** `AppointmentResource` (the newly created appointment)
- **Implementation Notes:**
  - Return `201 Created` on success with the new `AppointmentResource`.
  - Note: The web controller uses `'notes'` as the key but the DB column is `visit_reason`. **Use `visit_reason` in the API** to match the model's `$fillable`.
  - `clinic_id` is resolved by finding the doctor's clinic from their latest appointment — document this as a known limitation.

---

**`DELETE /api/v1/patient/appointments/{id}`**
- **Description:** Cancels an appointment. Sets `appointment_status` to `cancelled`. *This does not exist on the web yet — this is a new feature for the mobile app.*
- **Controller Action:** `Api\Patient\AppointmentApiController@cancel` *(new — mobile-first feature)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload:**
  ```json
  {
    "reason": "nullable|string|max:500"
  }
  ```
- **Response Resource:** `AppointmentResource` (updated)
- **Implementation Notes:**
  - Only allow cancellation if `appointment_status === 'scheduled'`. Return `422` with an error message if the appointment is already completed or cancelled.
  - Authorization: Ensure the appointment belongs to the authenticated patient.

---

## 🗂️ Medical Records API

**`GET /api/v1/patient/medical-records`**
- **Description:** Returns a summary list of all the patient's medical records (visits with diagnoses attached).
- **Controller Action:** `Api\Patient\MedicalRecordApiController@index` *(new)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload (Query Parameters):**
  ```
  per_page  nullable|integer (default: 15)
  ```
- **Response Resource:** `MedicalRecordResource::collection()` (paginated)
- **Implementation Notes:**
  - The web `MedicalRecordController@index` is a stub — implement the actual query here.
  - Query: `MedicalRecord::with(['appointment.clinic', 'doctor.user', 'diagnoses', 'attachments'])->where('patient_id', $patient->user_id)->orderBy('created_at', 'desc')->paginate()`
  - `MedicalRecordResource` exposes: `id`, `record_status`, `diagnosis_notes`, `created_at` (ISO 8601), nested `doctor` summary, nested `appointment` (date, type, clinic), `diagnoses_count`, `attachments_count`.

---

**`GET /api/v1/patient/medical-records/{id}`**
- **Description:** Returns the full detail of a single medical record including all diagnoses, attachments, and prescriptions.
- **Controller Action:** `Api\Patient\MedicalRecordApiController@show` *(new)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload:** None
- **Response Resource:** `MedicalRecordResource` (full, with nested resources)
- **Implementation Notes:**
  - Authorization: `$record->patient_id === $request->user()->patient->user_id`, else 403.
  - Eager load: `['appointment.clinic', 'doctor.user', 'diagnoses', 'attachments', 'prescriptions.items.medicine']`

---

## 💊 Prescriptions API

**`GET /api/v1/patient/prescriptions`**
- **Description:** Returns a paginated list of all the patient's prescriptions — maps to `PrescriptionController@index`.
- **Controller Action:** `Api\Patient\PrescriptionApiController@index` *(new)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload (Query Parameters):**
  ```
  status    nullable|in:pending,issued,dispensed,cancelled
  per_page  nullable|integer (default: 15)
  ```
- **Response Resource:** `PrescriptionResource::collection()` (paginated)
- **Implementation Notes:**
  - `PrescriptionResource` (summary card) exposes: `id`, `prescription_status`, `created_at` (ISO 8601), `expires_at` (ISO 8601, `created_at + 30 days`), `diagnosis_notes`, `medicines` (flat array of medicine names), nested `doctor` summary.
  - **Do NOT** return `$prescription->medicalRecord->doctor->user->full_name` inline. Use `DoctorSummaryResource` nested within `PrescriptionResource`.
  - Eagerly load: `['medicalRecord.doctor.user', 'items.medicine']`

---

**`GET /api/v1/patient/prescriptions/{id}`**
- **Description:** Returns the full detail of a single prescription including all medicines, dosage, and doctor info — maps to `PrescriptionController@show`.
- **Controller Action:** `Api\Patient\PrescriptionApiController@show` *(new)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload:** None
- **Response Resource:** `PrescriptionDetailResource`
- **Implementation Notes:**
  - Authorization: Check `$prescription->medicalRecord->patient_id === $patient->user_id`, else 403.
  - `PrescriptionDetailResource` exposes:
    - `id`, `generated_date` (ISO 8601), `prescription_status`, `notes` (as array, split on `\n`)
    - Nested `doctor`: `full_name`, `specialty`, `medical_license`, `syndicate_id`, `phone`, `account_status`, `clinic_address`, `avatar_url`
    - Nested `patient`: `full_name`, `gender`, `age`, `patient_id_string` (e.g., `#PT-00000001`)
    - Nested `diagnosis`: `title` (from `diagnosis_title`), `description` (from `diagnosis_notes`)
    - `medicines` → `PrescriptionItemResource::collection()`: `name`, `category`, `dosage`, `frequency`, `duration_days`, `instructions` (from `notes`)
  - Eagerly load: `['medicalRecord.doctor.user', 'medicalRecord.patient.user', 'medicalRecord.appointment.clinic', 'items.medicine']`

---

## 🧪 Test Results API

**`GET /api/v1/patient/test-results`**
- **Description:** Returns a paginated list of lab result attachments for the patient — maps to `TestResultController@index`.
- **Controller Action:** `Api\Patient\TestResultApiController@index` *(new)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload (Query Parameters):**
  ```
  status    nullable|in:pending,reviewed
  per_page  nullable|integer (default: 15)
  ```
- **Response Resource:** `TestResultResource::collection()` (paginated)
- **Implementation Notes:**
  - Filter: `attachment_type = 'lab_result'` — this is already how the web controller works.
  - `TestResultResource` exposes: `id`, `name` (from `attachment_name`), `category` (formatted, e.g., `"Lab Result"`), `test_result_status` (raw enum value: `"pending"` or `"reviewed"`), `uploaded_at` (ISO 8601).
  - **Do NOT map `"reviewed"` to `"VERIFIED"` in the API** — that is a web UI concern. Return the raw enum value. Let Flutter decide how to display it.
  - Eager load: `['medicalRecord']`

---

**`GET /api/v1/patient/test-results/{id}`**
- **Description:** Returns the full detail of a single lab result attachment, including the file URL — maps to `TestResultController@show`.
- **Controller Action:** `Api\Patient\TestResultApiController@show` *(new)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload:** None
- **Response Resource:** `TestResultResource` (with `file_url` and `mime_type` included)
- **Implementation Notes:**
  - Authorization: `$attachment->medicalRecord->patient_id === $patient->user_id`, else 403.
  - `file_url`: Use `Storage::disk('public')->url($attachment->file_path)`. Use this instead of `asset()` for consistency and testability.
  - `mime_type`: Return the raw MIME string (e.g., `"application/pdf"`, `"image/jpeg"`). Flutter's file viewer will handle rendering.
  - Include `notes` field.

---

## 🩻 Imaging API

**`GET /api/v1/patient/imaging`**
- **Description:** Returns a paginated list of imaging attachments (MRI, CT, X-Ray, etc.) — maps to `ImagingController@index`.
- **Controller Action:** `Api\Patient\ImagingApiController@index` *(new)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload (Query Parameters):**
  ```
  per_page  nullable|integer (default: 15)
  ```
- **Response Resource:** `ImagingSummaryResource::collection()` (paginated)
- **Implementation Notes:**
  - Filter: `attachment_type = 'imaging'`.
  - `ImagingSummaryResource` exposes: `id`, `title` (from `attachment_name`), `modality` (the extracted imaging type: `"MRI"`, `"CT Scan"`, `"X-Ray"`, etc.), `test_result_status`, `scan_date` (ISO 8601 from `uploaded_at`), `physician_name`, `clinic_name`, `file_format` (e.g., `"DICOM"`, `"PDF"`, `"JPG"`).
  - **Move `extractImagingModality()` logic into the `ImagingSummaryResource`** — it currently lives as a private controller method, which is the wrong layer. Resources are the correct place for display-logic transformations.
  - **Move `getFileFormat()` logic into `MedicalAttachmentResource`** as a computed property.
  - Eager load: `['medicalRecord.doctor.user', 'medicalRecord.appointment.clinic']`

---

**`GET /api/v1/patient/imaging/{id}`**
- **Description:** Returns the full detail of a single imaging scan, including the file URL for display in the Flutter image viewer — maps to `ImagingController@show`.
- **Controller Action:** `Api\Patient\ImagingApiController@show` *(new)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload:** None
- **Response Resource:** `ImagingResource` (full detail)
- **Implementation Notes:**
  - Authorization: `$attachment->medicalRecord->patient_id === $patient->user_id`, else 403.
  - `ImagingResource` (full detail) exposes:
    - `id`, `title`, `modality`, `scan_date` (ISO 8601), `test_result_status`
    - `file_info`: `{ "format": "DICOM", "size_bytes": 1024000, "size_human": "1.0 MB", "mime_type": "..." }`
    - `image_url`: `Storage::disk('public')->url($attachment->file_path)` — return the real Laravel storage URL. **Do not have a hardcoded fallback for fake factory data**; if the file doesn't exist, return `null` and let Flutter show a placeholder.
    - `physician_interpretation`: `{ "text": "...", "author": "Dr. Sara Kamel, Radiologist" }`
    - Physician info: `full_name`, `professional_title`
    - Radiology center: `clinic_name`
  - **Remove the hard-coded `placehold.co` fallback** — the web controller had this for fake seeder data. Don't leak this into a production API.
  - **`size_bytes`** is more useful to Flutter than `"1.0 MB"` (which is a display concern). Include both for convenience.

---

## 📆 Visit History API

**`GET /api/v1/patient/visit-history`**
- **Description:** Returns the patient's full chronological visit history (all appointments regardless of status) — maps to `VisitHistoryController@index`.
- **Controller Action:** `Api\Patient\VisitHistoryApiController@index` *(new)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload (Query Parameters):**
  ```
  status    nullable|in:scheduled,completed,cancelled
  per_page  nullable|integer (default: 20)
  ```
- **Response Resource:** `AppointmentResource::collection()` (paginated)
- **Implementation Notes:**
  - Reuse `AppointmentResource` — the visit history data structure is identical to the appointments list.
  - **Do NOT include `avatarBg`/`avatarColor` theme fields** — these are web UI concerns (CSS color generation). Flutter has its own theming. Strip them from the resource.
  - **Do NOT include `doctorInitials`** — Flutter can compute initials client-side from `full_name`.
  - Eager load: `['doctor.user', 'clinic']`

---

## 👤 Profile API

**`GET /api/v1/patient/profile`**
- **Description:** Returns the authenticated patient's full profile data — maps to `ProfileController@show`.
- **Controller Action:** `Api\Patient\ProfileApiController@index` *(new)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload:** None
- **Response Resource:** `PatientProfileResource`
- **Implementation Notes:**
  - `PatientProfileResource` exposes a flat profile object matching the web's `profileData` shape, but with improvements:
    - **Return `full_name` as a single field** instead of `first_name`/`last_name` split — that split was a web-form concern. Flutter can split locally if needed.
    - `birth_date`: ISO 8601 date string (`"1990-05-15"`), not pre-formatted.
    - `gender`: Raw enum value (`"male"` or `"female"`).
    - `avatar_url`: Full storage URL (use `Storage::disk('public')->url()`), or the `ui-avatars.com` fallback if `avatar` is null.
    - `blood_type`: Raw enum value (e.g., `"A+"`).
    - `allergies`: Array (already cast in the model).
    - Emergency contact nested object: `{ "name": "...", "phone": "...", "relationship": "..." }`.
  - Eagerly load: `['patient']`

---

**`PATCH /api/v1/patient/profile`**
- **Description:** Updates the patient's profile information — maps to `ProfileController@update`.
- **Controller Action:** `Api\Patient\ProfileApiController@update` *(new)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload:**
  ```json
  {
    "full_name":                      "nullable|string|max:255",
    "email":                          "nullable|email|unique:users,email,{user_id}",
    "phone":                          "nullable|string",
    "national_id":                    "nullable|string",
    "birth_date":                     "nullable|date",
    "gender":                         "nullable|in:male,female",
    "governorate":                    "nullable|string",
    "emergency_contact_name":         "nullable|string",
    "emergency_contact_phone":        "nullable|string",
    "emergency_contact_relationship": "nullable|string"
  }
  ```
- **Response Resource:** `PatientProfileResource` (the updated profile)
- **Implementation Notes:**
  - Use `sometimes` validation so Flutter can send partial updates (only changed fields).
  - The web controller uses separate `first_name`/`last_name` fields — **the API uses `full_name` directly**.
  - Apply the password change logic from the web controller (see below endpoint).
  - Return the updated `PatientProfileResource` on success.

---

**`POST /api/v1/patient/profile/password`**
- **Description:** Changes the patient's password. Separated from profile update for clarity and security.
- **Controller Action:** `Api\Patient\ProfileApiController@changePassword` *(new)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload:**
  ```json
  {
    "current_password": "required|string",
    "password":         "required|string|min:8|confirmed",
    "password_confirmation": "required|string"
  }
  ```
- **Response Resource:** None (simple success message)
- **Implementation Notes:**
  - Use `Hash::check($request->current_password, $user->password)` to verify the old password, return `422` with `"current_password": ["Current password is incorrect."]` on failure.

---

**`POST /api/v1/patient/profile/avatar`**
- **Description:** Uploads and replaces the patient's profile avatar — maps to `ProfileController@updateAvatar`.
- **Controller Action:** `Api\Patient\ProfileApiController@updateAvatar` *(new)*
- **Auth Required:** Yes (Sanctum)
- **Request Payload:** `multipart/form-data`
  ```
  avatar: required|image|mimes:jpeg,png,jpg,webp,gif|max:20480
  ```
- **Response Resource:** None — return JSON with the new `avatar_url`
  ```json
  {
    "status": "success",
    "message": "Avatar updated successfully.",
    "data": {
      "avatar_url": "https://your-domain.com/storage/avatars/abc123.jpg"
    }
  }
  ```
- **Implementation Notes:**
  - The existing `ProfileController@updateAvatar` logic is correct. **Adapt it 1:1** — delete old file, store new file, update `users.avatar`.
  - Return the new full `avatar_url` so Flutter can immediately update the app state without a second GET request.

---

## Middleware & Route Registration

### `routes/api.php`

```php
<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\Auth\PatientRegistrationController;
use App\Http\Controllers\Api\Patient\AppointmentApiController;
use App\Http\Controllers\Api\Patient\DashboardApiController;
use App\Http\Controllers\Api\Patient\ImagingApiController;
use App\Http\Controllers\Api\Patient\MedicalRecordApiController;
use App\Http\Controllers\Api\Patient\PrescriptionApiController;
use App\Http\Controllers\Api\Patient\ProfileApiController;
use App\Http\Controllers\Api\Patient\TestResultApiController;
use App\Http\Controllers\Api\Patient\VisitHistoryApiController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {

    // =============================================
    // PUBLIC ROUTES (No auth required)
    // =============================================
    Route::prefix('auth')->group(function () {
        Route::post('/login', [AuthController::class, 'login']);
        Route::post('/register/patient', [PatientRegistrationController::class, 'store']);
    });

    // =============================================
    // PROTECTED ROUTES (Sanctum token required)
    // =============================================
    Route::middleware(['auth:sanctum'])->group(function () {

        // Auth
        Route::get('/auth/me', [AuthController::class, 'me']);
        Route::post('/auth/logout', [AuthController::class, 'logout']);

        // Patient-only routes
        Route::middleware(['role:patient'])->prefix('patient')->group(function () {

            // Dashboard
            Route::get('/dashboard', [DashboardApiController::class, 'index']);

            // Appointments & Doctor Search
            Route::get('/doctors', [AppointmentApiController::class, 'getDoctors']);
            Route::get('/doctors/{id}', [AppointmentApiController::class, 'showDoctor']);
            Route::apiResource('appointments', AppointmentApiController::class)
                ->only(['index', 'show', 'store']);
            Route::delete('/appointments/{id}/cancel', [AppointmentApiController::class, 'cancel']);

            // Medical Records
            Route::apiResource('medical-records', MedicalRecordApiController::class)
                ->only(['index', 'show']);

            // Prescriptions
            Route::apiResource('prescriptions', PrescriptionApiController::class)
                ->only(['index', 'show']);

            // Test Results
            Route::apiResource('test-results', TestResultApiController::class)
                ->only(['index', 'show']);

            // Imaging
            Route::apiResource('imaging', ImagingApiController::class)
                ->only(['index', 'show']);

            // Visit History
            Route::get('/visit-history', [VisitHistoryApiController::class, 'index']);

            // Profile
            Route::get('/profile', [ProfileApiController::class, 'index']);
            Route::patch('/profile', [ProfileApiController::class, 'update']);
            Route::post('/profile/avatar', [ProfileApiController::class, 'updateAvatar']);
            Route::post('/profile/password', [ProfileApiController::class, 'changePassword']);
        });
    });
});
```

### Required Middleware

Ensure the existing `role` middleware is compatible with Sanctum's `auth:sanctum` guard. The existing web `role` middleware checks `auth()->user()->role` — verify it does not call `Auth::guard('web')` explicitly, or create an API-safe version.

Also ensure `app/Http/Middleware/Authenticate.php` redirects non-authenticated API requests to a JSON error response (not a login redirect):

```php
// app/Http/Middleware/Authenticate.php
protected function redirectTo(Request $request): ?string
{
    return $request->expectsJson() ? null : route('login');
}
```

---

## Summary: New Files to Create

| Type | Path | Notes |
|---|---|---|
| Controller | `Api/AuthController.php` | Extend existing — add `me()` |
| Controller | `Api/Auth/PatientRegistrationController.php` | New |
| Controller | `Api/Patient/DashboardApiController.php` | New |
| Controller | `Api/Patient/AppointmentApiController.php` | New |
| Controller | `Api/Patient/MedicalRecordApiController.php` | New |
| Controller | `Api/Patient/PrescriptionApiController.php` | New |
| Controller | `Api/Patient/TestResultApiController.php` | New |
| Controller | `Api/Patient/ImagingApiController.php` | New |
| Controller | `Api/Patient/VisitHistoryApiController.php` | New |
| Controller | `Api/Patient/ProfileApiController.php` | New |
| Resource | `Resources/Api/UserResource.php` | New |
| Resource | `Resources/Api/DoctorSummaryResource.php` | New |
| Resource | `Resources/Api/DoctorDetailResource.php` | New |
| Resource | `Resources/Api/AppointmentResource.php` | New |
| Resource | `Resources/Api/AppointmentDetailResource.php` | New |
| Resource | `Resources/Api/ClinicResource.php` | New |
| Resource | `Resources/Api/MedicalRecordResource.php` | New |
| Resource | `Resources/Api/MedicalAttachmentResource.php` | New |
| Resource | `Resources/Api/TestResultResource.php` | New |
| Resource | `Resources/Api/ImagingSummaryResource.php` | New |
| Resource | `Resources/Api/ImagingResource.php` | New |
| Resource | `Resources/Api/PrescriptionResource.php` | New |
| Resource | `Resources/Api/PrescriptionDetailResource.php` | New |
| Resource | `Resources/Api/PrescriptionItemResource.php` | New |
| Resource | `Resources/Api/MedicineResource.php` | New |
| Resource | `Resources/Api/PatientProfileResource.php` | New |
| Resource | `Resources/Api/DashboardResource.php` | New |
| Trait | `Traits/ApiResponse.php` | New — shared response helpers |
| Routes | `routes/api.php` | Extend existing |
