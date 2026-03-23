# Inertia Data Registry

This document catalogs the expected data props for each Vue 3 component in the Patient Dashboard that has been refactored to use Inertia.js. The Laravel backend must provide these exact prop names and data types when rendering each corresponding component via `Inertia::render()`.

## Modified Components & Expected Props

### 1. `VisitHistory.vue`
- **`visits`** (`Array`): An array of objects representing the patient's past visits (e.g., date, doctor, hospital, diagnosis).

### 2. `Appointments.vue`
- **`appointments`** (`Array`): An array of objects representing the patient's appointments (includes doctor name, time, status, type, etc.).

### 3. `MedicalRecords.vue`
- **`prescriptions`** (`Array`): An array of medication prescriptions for the patient.
- **`notifications`** (`Array`): An array of recent user notifications.
- **`currentUser`** (`Object`): The currently authenticated user object (name, email, avatar).

### 4. `TestResults.vue`
- **`testResults`** (`Array`): A list of lab or diagnostic test results (test name, date, provider, status).

### 5. `ImagingRecords.vue`
- **`imagingRecords`** (`Array`): An array of imaging scans (X-rays, MRIs) belonging to the patient along with file links and metadata.
- **`notifications`** (`Array`): Recent notifications.
- **`currentUser`** (`Object`): The currently authenticated user.

### 6. `DashboardInteractive.vue`
- **`dashboardData`** (`Object`): An aggregate object containing a high-level overview such as `stats` object, `healthOverview`, `nextAppointment` object, `recentRecords` array, and `activity` list.
- **`notifications`** (`Array`): An array of notification objects (appointment reminders, new test results).

### 7. `Notifications.vue`
- **`notifications`** (`Array`): An array of all notifications with their types, dates ('today', 'yesterday'), read status, and message.

### 8. `Profile.vue`
- **`profileData`** (`Object`): Detailed personal user info including ID, name, email, phone, gender, and date of birth.
- **`emergencyContact`** (`Object`): The emergency contact details, including relationship and phone number.

### 9. `CreateAppointment.vue`
- **`doctors`** (`Array`): Filterable list of available doctors with specializations, rating, reviews, and price.
- **`specialties`** (`Array`): Array of available medical specialties with their icon SVGs.

### 10. Detail Pages (TestResultDetails, PrescriptionDetails, ImagingDetail, DoctorProfile)
*Note: Pending complete finalization, these typically expect singular objects corresponding to the specific ID fetched from the database:*
- **`testResult`** / **`prescription`** / **`imagingRecord`** / **`doctor`** (`Object`): Contains detailed information for the specific scanned item.

---

### Implementation Notes for Backend
*   **Remove local API calls**: Ensure components do not trigger `axios` to fetch lists upon mounting, as they now extract them eagerly from `props`.
*   **Route Setup**: All read routes should correspond to `Route::get` ending with `Inertia::render('PatientDashboard/ComponentName', ['propName' => $data])`.
*   **Logout handling**: Action buttons now correctly dispatch a POST request using `@inertiajs` router via `router.post('/logout')` which seamlessly maps to the standard Laravel authenticated session lifecycle.



# Required Backend Updates
Your existing or upcoming Laravel Controllers need to inject specific props directly into `Inertia::render()` so these rewritten Vue components can accept them instantly on page load.

### 1. Patient Dashboard Controller & Routes

**Route Mapping (in `routes/web.php`):**
```php
Route::middleware(['auth', 'role:patient'])->group(function () {
    Route::get('/dashboard', [PatientDashboardController::class, 'index'])->name('patient.dashboard');
    Route::get('/appointments', [AppointmentController::class, 'index'])->name('patient.appointments');
    Route::get('/appointments/create', [AppointmentController::class, 'create'])->name('patient.appointments.create');
    Route::get('/medical-records', [MedicalRecordController::class, 'index'])->name('patient.records');
    Route::get('/test-results', [TestResultController::class, 'index'])->name('patient.tests');
    Route::get('/imaging', [ImagingController::class, 'index'])->name('patient.imaging');
    Route::get('/visit-history', [VisitHistoryController::class, 'index'])->name('patient.visits');
    Route::get('/notifications', [NotificationController::class, 'index'])->name('patient.notifications');
    Route::get('/profile', [PatientProfileController::class, 'show'])->name('patient.profile');
});
```

### 2. Required Controller Updates

**`PatientDashboardController` (`index` method):**
- **Passes:** `dashboardData` (Object), `notifications` (Array).
- **Explanation:** Needs to aggregate upcoming appointments, user health overview (allergies, blood type), recent activity timeline, and top-level numeric stats.

**`AppointmentController` (`index` and `create` methods):**
- **Passes (`index`):** `appointments` (Array).
- **Passes (`create`):** `doctors` (Array with nested specialty), `specialties` (Array of objects to populate visual buttons).
- **Explanation:** The frontend filter handles array filtering locally for now, so you need to pass a collection of all valid searchable doctors to the View if you intend to keep client-side searching.

**`MedicalRecordController` (`index` method):**
- **Passes:** `prescriptions` (Array), `notifications` (Array), `currentUser` (Object).
- **Explanation:** Replaced the previous dummy composables, should pull a query builder result mapping the patient's authenticated `id` to their respective medical prescriptions.

**`TestResultController` (`index` method):**
- **Passes:** `testResults` (Array).
- **Explanation:** Maps any completed lab result records directly into the grid array.

**`ImagingController` (`index` method):**
- **Passes:** `imagingRecords` (Array), `notifications` (Array), `currentUser` (Object).
- **Explanation:** Passes any radiology/scan records assigned to the user profile.

**`VisitHistoryController` (`index` method):**
- **Passes:** `visits` (Array).
- **Explanation:** Feeds the timeline history of the patient.

**`NotificationController` (`index` method):**
- **Passes:** `notifications` (Array).
- **Explanation:** Specifically categorized by the date wrapper property, the frontend groups them logically.

**`PatientProfileController` (`show` method):**
- **Passes:** `profileData` (Object), `emergencyContact` (Object).
- **Explanation:** Resolves the `auth()->user()` schema details dynamically along with their emergency contact relational model.

The frontend is now structurally sound and ready to receive real database data! Let me know if you'd like me to sweep through the final Detail views (like `ImagingDetail.vue` or `PrescriptionDetails.vue`) or process the remaining Tailwind styling lint warnings.
