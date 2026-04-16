# NetHealth — Flutter to Backend Handover Report
**Date:** April 2026
**To:** Laravel Backend Team

## 🏗️ Frontend Architecture Overview

The Flutter mobile application has successfully transitioned its foundational network and data layers to strictly consume the Laravel REST API. 

Here is how our client is handling the API:
- **HTTP Client:** We use **Dio** for all API requests. The base URL is currently set to `http://10.0.2.2/api/v1` for local Android emulator testing.
- **Authentication:** We use **Sanctum token-based auth**. Upon login or registration, the Flutter app securely stores the `token` in `SecureStorage`. A global Dio interceptor automatically injects `Authorization: Bearer <token>` into the header of every request. 
- **Session Expiration:** If the server ever returns a `401 Unauthorized`, our Dio interceptor automatically clears local storage and updates the Riverpod state to instantly boot the user back to the login screen.
- **Response Wrappers:** We've built generic wrappers that enforce strict mapping of Laravel's output envelope. All endpoints must return:
  - `StandardResponse<T>`: Mapping `status`, `message`, and the inner `data` payload.
  - `PaginatedResponse<T>`: Additionally mapping the `meta` nested object to safely extract `current_page`, `last_page`, `per_page`, and `total` for list views like Visit History and Medical Records.

## 🗺️ Configured Endpoint Map

Our Flutter Repositories are fully configured to consume the following routes out of the box based on the API Blueprint:

**Auth:**
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/register/patient`
- `GET /api/v1/auth/me`
- `POST /api/v1/auth/logout`

**Patient & Dashboard:**
- `GET /api/v1/patient/dashboard`
- `GET /api/v1/patient/profile`
- `PATCH /api/v1/patient/profile`
- `POST /api/v1/patient/profile/password`
- `POST /api/v1/patient/profile/avatar`

**Appointments & Doctors:**
- `GET /api/v1/patient/doctors` (Searchable)
- `GET /api/v1/patient/doctors/{id}`
- `GET /api/v1/patient/appointments`
- `GET /api/v1/patient/appointments/{id}`
- `POST /api/v1/patient/appointments`
- `DELETE /api/v1/patient/appointments/{id}/cancel`

**Medical Records & Diagnostics:**
- `GET /api/v1/patient/medical-records`
- `GET /api/v1/patient/medical-records/{id}`
- `GET /api/v1/patient/prescriptions`
- `GET /api/v1/patient/prescriptions/{id}`
- `GET /api/v1/patient/test-results`
- `GET /api/v1/patient/test-results/{id}`
- `GET /api/v1/patient/imaging`
- `GET /api/v1/patient/imaging/{id}`
- `GET /api/v1/patient/visit-history`

## ⚠️ Action Items & Blueprint Discrepancies

While syncing our API models with the agreed-upon Blueprint, we found 3 critical discrepancies that need your input or backend implementation before we can proceed in those specific flows:

1. **Missing Notifications Endpoint:** 
   We have a "Notifications" tab in the mobile app, but there is no `/api/v1/patient/notifications` listed in the blueprint. Can you add an endpoint that returns a standard paginated list of user notifications, including an `is_read` flag?

2. **Rescheduling Appointments Workflow:** 
   Our app features a "Reschedule" button for upcoming appointments. Does the backend support a `PATCH /api/v1/patient/appointments/{id}` endpoint to directly update the `appointment_time`, or should the mobile app handle rescheduling by stringing together a `DELETE .../cancel` followed by a new `POST` request to book a new appointment entirely?

3. **Test Results Data Structure:** 
   Can you confirm that `GET /api/v1/patient/test-results/{id}` specifically returns an attachment document (via the `file_url` mapping), rather than returning an array of raw numerical lab data metrics (like hemoglobin levels)? Our Flutter UI is currently built around rendering a PDF/Image viewer for these reports.

Please let us know how you'd like to proceed with these discrepancies!
