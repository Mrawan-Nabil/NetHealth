# Global Uploads Audit Report

This report outlines the file upload integrations that have been implemented on the Flutter client, but currently **lack corresponding backend support** in the Laravel API. The mobile team has prepared the `FormData` payloads and UI state management, but the backend must be updated to accept and process these files.

## 1. Appointment Booking Attachments
**Flutter UI Location:** `AppointmentsScreen` (Booking Modals) & `DoctorDetailsScreen`
**Trigger:** Patient books an appointment and attaches medical records/reports.
**Current Flutter Implementation:** Uses `FormData` to wrap the standard booking payload.
**Missing Backend Feature:**
The `PatientAppointmentApiController::store` method validates the following:
```php
$request->validate([
    'doctor_id' => 'required|exists:users,id',
    'clinic_id' => 'required|exists:clinics,id',
    'appointment_time' => 'required|date',
    'appointment_type' => 'required|string',
    'visit_reason' => 'nullable|string',
    // ...
]);
```
**Action Required:**
- Update `PatientAppointmentApiController::store` validation to accept an `attachment` field (e.g., `mimes:pdf,jpg,png,doc,docx|max:10240`).
- Process the uploaded file, store it in the `public/attachments` disk, and link it to the newly created `Appointment` record.

## 2. Test Results Uploads
**Flutter UI Location:** `AppointmentsScreen` -> "Upload Test Results" button.
**Trigger:** Patient uploads a standalone test result document.
**Current Flutter Implementation:** Uses `FormData` with a single `file` key sent via `POST` to `/patient/test-results`.
**Missing Backend Feature:**
The `PatientTestResultApiController` only contains `index` and `show` methods.
**Action Required:**
- Create a `store` method in `PatientTestResultApiController`.
- Accept a file field named `file`.
- Create a new `MedicalAttachment` record with `attachment_type` set to `Lab_Result`, linked to the patient.

## 3. Imaging Uploads
**Flutter UI Location:** `AppointmentsScreen` -> "Upload Imaging" button.
**Trigger:** Patient uploads standalone imaging files (X-rays, MRIs).
**Current Flutter Implementation:** Uses `FormData` with a single `file` key sent via `POST` to `/patient/imaging`.
**Missing Backend Feature:**
The `PatientImagingApiController` only contains `index` and `show` methods.
**Action Required:**
- Create a `store` method in `PatientImagingApiController`.
- Accept a file field named `file` (optionally support DICOM or image formats).
- Create a new `MedicalAttachment` record with `attachment_type` set to `Imaging` (or equivalent), linked to the patient.

---
**Note for Backend Team:** Once these endpoints are implemented and tested in Laravel, the Flutter mobile app will automatically begin sending the multipart files successfully. No further mobile changes are required.
