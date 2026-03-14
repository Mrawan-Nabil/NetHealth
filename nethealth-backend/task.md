# Patient Dashboard Sprint - Task List

Following the Vertical Slice methodology, this board tracks the full-stack implementation of the Patient Dashboard experience based on the verified UI screens and the current database schema.

## Module 1: Home Dashboard

### [TASK-101] - Home Dashboard Layout & Stats
* **Objective:** Build the main dashboard overview showing quick statistics, AI assistant CTA, and the patient's next appointment card.
* **Backend Checklist:**
  * [ ] Controller: Add `DashboardController@index` to aggregate data.
  * [ ] Models: Fetch [Appointment](file:///c:/Users/mrawan/Herd/NetHealth/nethealth-backend/app/Models/Appointment.php#10-48) (upcoming), `Prescription` (latest active), `MedicalRecord` (pending tests).
  * [ ] Routes: Create `GET /dashboard`.
* **Frontend Checklist:**
  * [ ] Vue Components: `Pages/Dashboard/Home.vue`, `StatsCard.vue`, `NextAppointmentCard.vue`.
  * [ ] Inertia State: Access aggregated counts and next appointment object via `$page.props`.
  * [ ] Tailwind UI: Responsive grid layout matching the "Welcome back, [Name]" screenshot with teal (`#14B8A6`) gradient banner for the CTA.
* **Dependencies:** None.

### [TASK-102] - Health Overview & Recent Activity
* **Objective:** Display patient's health info (blood type, allergies) and a chronological activity timeline on the dashboard.
* **Backend Checklist:**
  * [ ] Models: Fetch from existing [Patient](file:///c:/Users/mrawan/Herd/NetHealth/nethealth-backend/app/Models/Patient.php#9-43) model (`blood_type`, `allergies`, `chronic_conditions`).
  * [ ] Controller: Combine latest activities (Appointments, Test Results, Prescriptions) into a unified timeline collection or use `spatie/laravel-activitylog` if installed. Pass to `DashboardController@index`.
* **Frontend Checklist:**
  * [ ] Vue Components: `HealthOverviewCard.vue` and `RecentActivityTimeline.vue`.
  * [ ] Tailwind UI: Sidebar sections, timeline bullet styling with distinct colors (green, blue, purple).
* **Dependencies:** TASK-101.

## Module 2: Profile Management

### [TASK-201] - Profile Personal & Emergency Info Update
* **Objective:** Allow patients to update basic info, upload an avatar, and set emergency contacts.
* **Backend Checklist:**
  * [ ] Migrations: Add `avatar` column to the existing `users` table.
  * [ ] Models: Update `User` fillable fields. Cast `avatar` as string/url.
  * [ ] Form Requests: Create `UpdateProfileRequest`.
  * [ ] Controller: `ProfileController@update` handling text fields and file upload for avatar (storage disk).
  * [ ] Routes: `PUT /profile`, `POST /profile/avatar` (if handled separately).
* **Frontend Checklist:**
  * [ ] Vue Components: `Pages/Profile/Edit.vue`, `AvatarUpload.vue`.
  * [ ] Inertia State: `useForm` for all personal fields and emergency contact (mapping to existing `emergency_contact_name` and `phone` on [Patient](file:///c:/Users/mrawan/Herd/NetHealth/nethealth-backend/app/Models/Patient.php#9-43)). Support multipart file upload.
  * [ ] Tailwind UI: Fieldsets for Personal Information and Emergency Contact. Validation error states.
* **Dependencies:** None.

### [TASK-202] - Profile Password Update
* **Objective:** Secure interface for changing user password.
* **Backend Checklist:**
  * [ ] Form Requests: `UpdatePasswordRequest` to validate current password format.
  * [ ] Controller: `ProfileController@updatePassword` using `Hash::make`.
  * [ ] Routes: `PUT /profile/password`.
* **Frontend Checklist:**
  * [ ] Vue Components: `UpdatePasswordForm.vue`.
  * [ ] Inertia State: `useForm` with current, new, and confirm password fields.
  * [ ] Tailwind UI: Secure input fields with show/hide eye toggle UI.
* **Dependencies:** TASK-201.

## Module 3: Appointment Booking Flow

### [TASK-301] - Doctor Search & Specialty Filter
* **Objective:** Display a searchable, filterable list of doctors.
* **Backend Checklist:**
  * [ ] Controller: `DoctorController@index` or dedicated search controller.
  * [ ] Models/Queries: Search `Doctor` by name/specialty, paginate results. Eager load user profile details.
  * [ ] Routes: `GET /doctors` with query params (search, specialty).
* **Frontend Checklist:**
  * [ ] Vue Components: `Pages/Doctors/Index.vue`, `DoctorCard.vue`, `SpecialtyFilter.vue`.
  * [ ] Inertia State: Watched query refs updating Inertia router, `preserveState: true`.
  * [ ] Tailwind UI: Search bar with icon, scrollable pills for horizontal specialties, card grid.
* **Dependencies:** None.

### [TASK-302] - Doctor Profile & Availability Slots
* **Objective:** Show doctor specifics (fee, experience) and interactive available time slots.
* **Backend Checklist:**
  * [ ] Migrations/Models: Need explicit system to track available schedules (e.g. `DoctorSchedule` model linked to `Doctor`).
  * [ ] Controller: `DoctorController@show` returning doctor info, `consultation_fee`, `specialty`, and an availability matrix.
  * [ ] Routes: `GET /doctors/{doctor}`.
* **Frontend Checklist:**
  * [ ] Vue Components: `Pages/Doctors/Show.vue`, `AvailabilityCalendar.vue`, `TimeSlotSelector.vue`.
  * [ ] Inertia State: Selection state tracking the chosen `date`, `time_slot`, and `appointment_type`.
  * [ ] Tailwind UI: Day tabs, selectable slot buttons (teal active state).
* **Dependencies:** TASK-301.

### [TASK-303] - Appointment Confirmation Modal & Uploads
* **Objective:** Multi-step modal confirming booking, accepting medical files, and showing success summary.
* **Backend Checklist:**
  * [ ] Migrations/Models: Ensure `medical_attachments` can link correctly when an appointment is booked (perhaps create a "draft" `medical_record` or directly link attachment to `appointment_id`).
  * [ ] Form Requests: `StoreAppointmentBookingRequest` (validates slots, patient info, and files <= 10MB).
  * [ ] Controller: `AppointmentController@store` logic encapsulated in DB Transaction.
  * [ ] Routes: `POST /appointments`.
* **Frontend Checklist:**
  * [ ] Vue Components: `ConfirmBookingModal.vue`, `SuccessSummaryModal.vue`, `DragDropUploader.vue`.
  * [ ] Inertia State: `useForm` holding booking fundamentals + array of `FileList`.
  * [ ] Tailwind UI: Modal backdrop, file drag-and-drop dotted zone, success checkmark animation.
* **Dependencies:** TASK-302.

## Module 4: Appointments Management

### [TASK-401] - Appointments List (Scheduled, Completed, Cancelled)
* **Objective:** Tabbed view of all patient appointments.
* **Backend Checklist:**
  * [ ] Controller: `AppointmentController@index` grouping by status (`Scheduled`, `Completed`, `Cancelled`).
  * [ ] Models: Scopes for the mapped `AppointmentStatus` ENUMs. Eager load `Doctor`.
  * [ ] Routes: `GET /appointments`.
* **Frontend Checklist:**
  * [ ] Vue Components: `Pages/Appointments/Index.vue`, `AppointmentCard.vue`, `StatusTabs.vue`.
  * [ ] Inertia State: Navigation between tabs updating URL query `status` param.
  * [ ] Tailwind UI: Status pills (teal/gray/red), dynamic action buttons layout per status.
* **Dependencies:** TASK-303.

### [TASK-402] - Appointment Actions (Reschedule, Cancel, Upload)
* **Objective:** Implement actions inside the Scheduled appointments tab view.
* **Backend Checklist:**
  * [ ] Form Requests: `RescheduleAppointmentRequest`, `UploadTestResultRequest`.
  * [ ] Controller: `AppointmentController@update` for rescheduling, `AppointmentController@cancel`, `MedicalAttachmentController@store` for inline uploads.
  * [ ] Routes: `PUT /appointments/{appointment}/reschedule`, `PUT /appointments/{appointment}/cancel`, `POST /appointments/{appointment}/upload`.
* **Frontend Checklist:**
  * [ ] Vue Components: `RescheduleModal.vue`, `UploadActionModal.vue`.
  * [ ] Inertia State: Async post requests, updating local state on success without full reload.
  * [ ] Tailwind UI: Ghost buttons for actions, solid confirm buttons inside modals.
* **Dependencies:** TASK-401.

## Module 5: Medical Records

### [TASK-501] - Prescriptions View
* **Objective:** List active prescriptions and display detailed prescription view with medicines table.
* **Backend Checklist:**
  * [ ] Models: Enhance `Prescription` and `PrescriptionItem` to return unified JSON.
  * [ ] Controller: `MedicalRecordController@prescriptions` (index) and `@showPrescription` (detail).
  * [ ] Routes: `GET /medical-records/prescriptions`, `GET /medical-records/prescriptions/{prescription}`.
* **Frontend Checklist:**
  * [ ] Vue Components: `Pages/MedicalRecords/Prescriptions.vue`, `PrescriptionDetailCard.vue`.
  * [ ] Inertia State: Prop mapping for lists and specific details.
  * [ ] Tailwind UI: Data tables for dosage/frequency, status badges.
* **Dependencies:** None.

### [TASK-502] - Test Results & Imaging Gallery
* **Objective:** Grid view for lab test results and imaging.
* **Backend Checklist:**
  * [ ] Migrations: Add `type` column or ENUM to `medical_attachments` to distinguish 'imaging' from 'test_results'.
  * [ ] Controller: `MedicalRecordController@imaging`, `MedicalRecordController@tests`.
  * [ ] Routes: `GET /medical-records/imaging`, `GET /medical-records/tests`.
* **Frontend Checklist:**
  * [ ] Vue Components: `Pages/MedicalRecords/Tests.vue`, `Pages/MedicalRecords/Imaging.vue`, `RecordGridItem.vue`.
  * [ ] Tailwind UI: Card components showing file size (MB format), upload date, and physician context with "VERIFIED" / "PENDING" tags.
* **Dependencies:** TASK-501.

### [TASK-503] - Advanced Document Reader (DICOM/PDF)
* **Objective:** In-app viewer for full imaging reports (e.g., Chest CT).
* **Backend Checklist:**
  * [ ] Controller: Endpoints to stream secure files (to avoid public disk exposures).
* **Frontend Checklist:**
  * [ ] Vue Components: `AdvancedViewer.vue` integrating a JS library for DICOM (like `cornerstone.js`) or generic PDF (`pdf.js`).
  * [ ] Tailwind UI: Dark mode viewer frame over standard layout, zoom/pan control toolbar, side panel for reading physician interpretation notes.
* **Dependencies:** TASK-502.

## Module 6: Notifications Center

### [TASK-601] - Notifications Implementation
* **Objective:** Provide chronological alerts with mark as read capabilities.
* **Backend Checklist:**
  * [ ] Migrations: Add `notifications` table (run `php artisan notifications:table`).
  * [ ] Controller: `NotificationController@index`, `@markAsRead`, `@clearAll`.
  * [ ] Routes: `GET /notifications`, `POST /notifications/read`, `DELETE /notifications/clear`.
* **Frontend Checklist:**
  * [ ] Vue Components: `Pages/Notifications/Index.vue`, `NotificationItem.vue`.
  * [ ] Inertia State: Expose unread counts to `$page.props` to show global badge in sidebar navigation.
  * [ ] Tailwind UI: Date grouping (Today, Yesterday), styled items by type with unread indicator dot.
* **Dependencies:** None.
