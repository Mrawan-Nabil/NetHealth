# Inertia Data Registry — Doctor Dashboard

This document catalogs the **exact** prop contracts for every Vue 3 page component in the Doctor Dashboard that uses `Inertia.js`. The Laravel backend **must** supply these exact prop names, shapes, and types when rendering each component via `Inertia::render()`. Missing or mis-typed props will cause runtime errors or blank panels in the UI.

---

## Modified Components & Expected Props

### 1. `DoctorDashboard/Index.vue` — Home Dashboard

> **Route:** `GET /doctor/dashboard` → `Inertia::render('DoctorDashboard/Index', [...])`

---

#### `doctor` (`Object`, **required**)
The authenticated doctor's display profile. Populated from the `users` table with the eager-loaded `clinic` relationship.

| Key | Type | Description |
|---|---|---|
| `id` | `int` | Doctor's user ID |
| `name` | `string` | Short display name, e.g. `"Dr. Ahmed"` |
| `fullName` | `string` | Full name as stored in DB |
| `handle` | `string` | Username prefixed with `@`, e.g. `"@dr.ahmed"` |
| `avatar` | `string\|null` | Public URL to the avatar image — **may be null** |
| `clinic.name` | `string\|null` | Name of the associated clinic via `clinic_id` FK |
| `clinic.address` | `string\|null` | Clinic address |

---

#### `stats` (`Object`, **required**)
Aggregated counts for the four KPI cards rendered on the home screen.

| Key | Type | Description |
|---|---|---|
| `upcomingAppointments` | `int` | Appointments scheduled for today and beyond |
| `pendingTestReviews` | `int` | Lab/imaging reviews awaiting doctor action |
| `totalPatients` | `int` | Lifetime distinct patient count for this doctor |
| `completedThisWeek` | `int` | Appointments marked `completed` in the current ISO week |

---

#### `todaySchedule` (`Array`, default `[]`)
Appointments scheduled for today, ordered ascending by time.

Each item:
```php
[
    'id'              => 1,
    'patientName'     => 'Sarah Johnson',
    'appointmentType' => 'In-Clinic Visit',
    'description'     => 'Follow-up for Hypertension',
    'time'            => '10:00 AM',
    'status'          => 'Waiting',   // 'Waiting' | 'Confirmed' | 'Completed'
    'avatar'          => null,        // string|null
]
```

---

#### `upcomingAppointments` (`Array`, default `[]`)
Future appointments (after today). Shown in the "Upcoming Appointments" section card.

Each item:
```php
[
    'id'       => 2,
    'initials' => 'SJ',
    'name'     => 'Sarah Johnson',
    'type'     => 'Follow-Up',
    'date'     => 'Apr 22',
    'time'     => '11:00 AM',
    'status'   => 'Confirmed',
]
```

---

#### `pendingReviews` (`Array`, default `[]`)
Lab and imaging files awaiting the doctor's review. The UI badge count is `pendingReviews.length` — do **not** pass a separate count integer.

Each item:
```php
[
    'id'         => 3,
    'reportType' => 'CBC',              // e.g. 'CBC', 'X-Ray', 'MRI'
    'patientName'=> 'Robert Chen',
    'category'   => 'Lab Test',         // 'Lab Test' | 'Imaging'
    'timeAgo'    => '2 hours ago',
]
```

---

#### `recentPatients` (`Array`, default `[]`)
The last 5 patients who had an appointment with this doctor.

Each item:
```php
[
    'id'        => 4,
    'name'      => 'Emily Davis',
    'lastVisit' => 'Apr 18, 2026',
    'note'      => 'Diabetes follow-up',
    'avatar'    => null,   // string|null
]
```

---

#### `schedule` (`Object`, default — see below)
The doctor's weekly availability configuration. Shared between the Home dashboard and the Profile page. If not set, use the default below.

```php
[
    'days' => [
        ['name' => 'Monday',    'enabled' => true,  'from' => '09:00 AM', 'to' => '05:00 PM'],
        ['name' => 'Tuesday',   'enabled' => true,  'from' => '09:00 AM', 'to' => '05:00 PM'],
        ['name' => 'Wednesday', 'enabled' => false, 'from' => '',         'to' => ''],
        ['name' => 'Thursday',  'enabled' => true,  'from' => '09:00 AM', 'to' => '05:00 PM'],
        ['name' => 'Friday',    'enabled' => true,  'from' => '09:00 AM', 'to' => '02:00 PM'],
        ['name' => 'Saturday',  'enabled' => false, 'from' => '',         'to' => ''],
        ['name' => 'Sunday',    'enabled' => false, 'from' => '',         'to' => ''],
    ],
    'duration'          => '30 min',
    'breakBetweenSlots' => '5 min',
    'selectedPreset'    => null,    // 'morning' | 'evening' | null
    'appointmentTypes'  => [
        'inClinic'  => true,
        'followUp'  => true,
        'labReview' => true,
    ],
    'labReviewOptions' => [
        'acceptLabTests'   => true,
        'acceptXrayImages' => true,
    ],
]
```

---

### 2. `DoctorDashboard/Profile.vue` — Profile Settings

> **Route:** `GET /doctor/profile` → `Inertia::render('DoctorDashboard/Profile', [...])`
> **Form POST:** `PATCH /doctor/profile` (handled by `useForm.patch()`)

---

#### `doctor` (`Object`, **required**)
Full profile for pre-populating the `useForm` fields and the read-only clinic display.

| Key | Type | Notes |
|---|---|---|
| `id` | `int` | — |
| `name` | `string` | Short display name |
| `fullName` | `string` | Full name |
| `handle` | `string` | `@username` |
| `avatar` | `string\|null` | Avatar URL, **may be null** |
| `firstName` | `string` | Pre-fills `form.firstName` |
| `secondName` | `string` | Pre-fills `form.secondName` |
| `email` | `string` | Pre-fills `form.email` |
| `phone` | `string` | Pre-fills `form.phone` |
| `nationalId` | `string` | Pre-fills `form.nationalId` |
| `dob` | `string` | ISO date string, e.g. `"1985-06-14"` |
| `gender` | `string` | `"male"` \| `"female"` \| `"na"` |
| `address` | `string` | Pre-fills `form.address` |
| `specialty` | `string` | Pre-fills `form.specialty` |
| `experience` | `string` | Years, e.g. `"12"` |
| `consultationFee` | `string` | Decimal string, e.g. `"150.00"` |
| `about` | `string` | Bio text for the "About & Experience" card |
| `clinic.name` | `string\|null` | **Read-only** — from `doctor->clinic->name` |
| `clinic.address` | `string\|null` | **Read-only** — from `doctor->clinic->address` |

> ⚠️ **Important:** `clinic.name` and `clinic.address` are **not** writable form fields. They are bound as `:model-value` with `:disabled="true"`. The clinic assignment is managed through the `clinic_id` FK on the `users` table, not through the profile form.

---

#### `schedule` (`Object`, default same shape as Index.vue)
Same structure as the `schedule` prop in `Index.vue`. This populates the "Working Schedule" mini-card and feeds the `EditScheduleModal`.

---

#### `useForm` fields (not a prop — for backend PATCH validation reference)
When the user clicks **Save Changes**, `form.patch('/doctor/profile')` sends:

```php
// Expected request body for DoctorProfileController@update:
[
    'firstName'       => 'string|required',
    'secondName'      => 'string|required',
    'email'           => 'email|required|unique:users,email,{id}',
    'countryCode'     => 'string',
    'phone'           => 'string',
    'nationalId'      => 'string',
    'dob'             => 'date',
    'gender'          => 'in:male,female,na',
    'address'         => 'string',
    'specialty'       => 'string',
    'experience'      => 'string',
    'consultationFee' => 'numeric',
    'about'           => 'string|nullable',
    'currentPassword' => 'string|nullable',
    'newPassword'     => 'string|nullable|min:8',
    'confirmPassword' => 'string|nullable|same:newPassword',
]
```

---

### 3. `DoctorDashboard/Appointments.vue` — Appointments Manager

> **Route:** `GET /doctor/appointments` → `Inertia::render('DoctorDashboard/Appointments', [...])`

---

#### `doctor` (`Object`, **required**)
Same shape as `Index.vue` doctor prop (only `fullName`, `handle`, `avatar` are used in the header).

---

#### `completedAppointments` (`Array`, default `[]`)
Past appointments that have been marked completed.

```php
[
    'id'          => 1,
    'patientName' => 'Sarah Johnson',
    'initials'    => 'SJ',
    'date'        => 'Apr 18, 2026',
    'time'        => '10:00 AM',
    'visitType'   => 'In-Clinic Visit',
    'canEdit'     => true,
]
```

---

#### `upcomingAppointments` (`Array`, default `[]`)
Scheduled future appointments.

```php
[
    'id'          => 2,
    'patientName' => 'Robert Chen',
    'initials'    => 'RC',
    'visitType'   => 'Follow-Up',
    'date'        => 'Apr 22, 2026',
    'time'        => '11:00 AM',
    'status'      => 'Confirmed',   // 'Confirmed' | 'Pending'
    'action'      => 'View Details',
]
```

---

#### `cancelledAppointments` (`Array`, default `[]`)
Appointments that were cancelled.

```php
[
    'id'             => 3,
    'patientName'    => 'Emily Davis',
    'initials'       => 'ED',
    'date'           => 'Apr 20, 2026',
    'time'           => '09:00 AM',
    'cancelledNote'  => 'Patient requested cancellation',
    'reason'         => 'Personal conflict',
]
```

---

### 4. `DoctorDashboard/Notifications.vue` — Notifications Center

> **Route:** `GET /doctor/notifications` → `Inertia::render('DoctorDashboard/Notifications', [...])`

---

#### `doctor` (`Object`, **required**)
Same header shape — only `fullName`, `handle`, `avatar` consumed.

---

#### `notifications` (`Array`, default `[]`)
All notifications for this doctor, newest first. The page groups them by `date` into "Today" and "Yesterday" sections automatically.

```php
[
    'id'          => 1,
    'type'        => 'appointment',  // 'appointment'|'prescription'|'lab'|'message'
    'title'       => 'Appointment Confirmed',
    'message'     => 'Sarah Johnson confirmed her cardiology follow-up for 10:00 AM.',
    'description' => 'Sarah Johnson confirmed her cardiology follow-up for 10:00 AM.',
    'time'        => '2 hours ago',
    'badge'       => 'APPOINTMENT',
    'date'        => 'today',        // 'today' | 'yesterday'
    'read'        => false,
]
```

> **Note:** The `type` field drives navigation when the notification is clicked:
> - `appointment` → `/doctor/appointments`
> - `lab` → `/doctor/reviews/files`
> - `prescription` → `/doctor/reviews/medical-record`
> - *anything else* → `/doctor/notifications`

---

### 5. `DoctorDashboard/Reviews.vue` — Patient Reviews List

> **Route:** `GET /doctor/reviews` → `Inertia::render('DoctorDashboard/Reviews', [...])`

---

#### `doctor` (`Object`, **required**)
Same header shape.

---

#### `reviews` (`Array`, default `[]`)
All patient file review entries assigned to this doctor. The UI computes `pendingCount` and `reviewedCount` via `computed()` — do **not** pass separate counts.

```php
[
    'id'          => 1,
    'patientName' => 'Sarah Johnson',
    'initials'    => 'SJ',
    'filesCount'  => 3,
    'date'        => 'Apr 18, 2026',
    'time'        => '10:30 AM',
    'status'      => 'Pending',   // 'Pending' | 'Reviewed'
]
```

---

### 6. `DoctorDashboard/ReviewFiles.vue` — Patient File List

> **Route:** `GET /doctor/reviews/files?patient={id}` → `Inertia::render('DoctorDashboard/ReviewFiles', [...])`

---

#### `doctor` (`Object`, **required**)
Same header shape.

---

#### `patient` (`Object`, **required**)
The specific patient whose files are being listed.

```php
[
    'name'      => 'Sarah Johnson',
    'initials'  => 'SJ',
    'age'       => 34,
    'gender'    => 'Female',
    'patientId' => 'PT-00142',
]
```

---

#### `files` (`Array`, default `[]`)
The medical files attached to this review.

```php
[
    'id'           => 1,
    'category'     => 'Lab Test',      // 'Lab Test' | 'Imaging'
    'title'        => 'Complete Blood Count',
    'date'         => 'Apr 18, 2026',
    'previewImage' => '/storage/previews/cbc-preview.png',
    'buttonText'   => 'View Full Report',
]
```

> **Note:** The `category` field drives the URL passed to `ViewFullFile.vue`:
> `category === 'Lab Test'` → `?type=lab` | otherwise → `?type=imaging`

---

### 7. `DoctorDashboard/ViewFullFile.vue` — Full File Viewer

> **Route:** `GET /doctor/reviews/view-full-file?type={lab|imaging}` → `Inertia::render('DoctorDashboard/ViewFullFile', [...])`

---

#### `doctor` (`Object`, **required**)
Same header shape.

---

#### `fileType` (`String`, default `'imaging'`) — **CRITICAL**
Determines which viewer panel is displayed. This **must** be read from `$request->query('type', 'imaging')` on the backend and passed as an Inertia prop.

> ⚠️ **Do NOT** rely on `window.location.search` to detect the file type in the frontend. The bug has been fixed — the frontend reads exclusively from this prop.

---

#### `imaging` (`Object|null`, default `null`)
Present only when `fileType === 'imaging'`. Pass `null` for lab reports.

```php
[
    'title'       => 'Chest X-Ray',
    'subtitle'    => 'Radiology Department — Apr 18, 2026',
    'metadata'    => [           // Key-value pairs for the FileInfoCard
        'Modality'   => 'X-Ray',
        'Region'     => 'Chest',
        'Doctor'     => 'Dr. Ahmed',
        'Date'       => 'Apr 18, 2026',
        'Accession'  => 'ACC-00281',
    ],
    'pages'       => 2,
    'currentPage' => 1,
    'thumbnails'  => [
        '/storage/imaging/xray-thumb-1.png',
        '/storage/imaging/xray-thumb-2.png',
    ],
]
```

---

#### `lab` (`Object|null`, default `null`)
Present only when `fileType === 'lab'`. Pass `null` for imaging files.

```php
[
    'title'    => 'Complete Blood Count (CBC)',
    'subtitle' => 'Clinical Laboratory — Apr 18, 2026',
    'summary'  => [
        'testName'   => 'Complete Blood Count',
        'laboratory' => 'NetHealth Clinical Lab',
        'regId'      => 'LAB-00391',
        'doctor'     => 'Dr. Ahmed Hassan',
        'specialty'  => 'Internal Medicine',
        'reportDate' => 'Apr 18, 2026',
        'reportId'   => 'RPT-00741',
    ],
    'rows' => [
        [
            'parameter' => 'Hemoglobin',
            'result'    => '13.5',
            'unit'      => 'g/dL',
            'range'     => '12.0 - 17.5',
            'status'    => 'Normal',   // 'Normal' | 'High' | 'Low'
        ],
        // ...more rows
    ],
]
```

---

### 8. `DoctorDashboard/MedicalRecord.vue` — Full Medical Record

> **Route:** `GET /doctor/reviews/medical-record?patient={id}` → `Inertia::render('DoctorDashboard/MedicalRecord', [...])`

---

#### `doctor` (`Object`, **required**)
Same header shape.

---

#### `patient` (`Object`, **required**)
Full patient profile for the "Profile" tab.

```php
[
    'name'      => 'Sarah Johnson',
    'initials'  => 'SJ',
    'id'        => 'PT-00142',
    'dob'       => 'June 14, 1991',
    'email'     => 'sarah@example.com',
    'gender'    => 'Female',
    'age'       => '34',
    'phone'     => '+20 100 123 4567',
    'bloodType' => 'A+',
    'notes'     => 'Patient has a known penicillin allergy. Prefers morning appointments.',
]
```

---

#### `testResults` (`Array`, default `[]`)
Lab test entries for the "Test Results" tab. The UI derives `Reviewed`/`Pending` filter pill counts via `computed()`.

```php
[
    'title'  => 'Complete Blood Count',
    'lab'    => 'NetHealth Clinical Lab',
    'date'   => 'Apr 18, 2026',
    'status' => 'Pending',   // 'Reviewed' | 'Pending'
]
```

---

#### `imaging` (`Array`, default `[]`)
Imaging entries for the "Imaging" tab. Filter pills group by `modality`.

```php
[
    'title'    => 'Chest X-Ray',
    'region'   => 'Chest',
    'doctor'   => 'Dr. Ahmed',
    'date'     => 'Apr 18, 2026',
    'modality' => 'X-ray',   // 'X-ray' | 'CT Scan' | 'Ultrasound'
]
```

---

#### `prescriptions` (`Array`, default `[]`)
Prescription records for the "Prescriptions" tab.

```php
[
    'doctor'    => 'Dr. Ahmed Hassan',
    'visitType' => 'In-Clinic Visit',
    'date'      => 'Apr 18, 2026',
    'condition' => 'Type 2 Diabetes',
    'medicines' => ['Metformin 500mg', 'Atorvastatin 20mg'],
    'status'    => 'Active',   // 'Active' | 'Expired'
]
```

---

#### `visits` (`Array`, default `[]`)
Visit history entries for the "Visit History" tab.

```php
[
    'visitType'          => 'In-Clinic Visit',
    'date'               => 'Apr 18, 2026',
    'time'               => '10:00 AM',
    'title'              => 'Cardiology Follow-up',
    'summary'            => 'Blood pressure stable. Continue current medication.',
    'status'             => 'Completed',   // 'Completed' | 'Cancelled'
    'prescriptionNote'   => 'Metformin 500mg prescribed',   // optional
    'hasPrescription'    => true,          // optional
]
```

---

### Implementation Notes for Backend

- **No local API calls.** The frontend components no longer call `axios` or `fetch` to load data. All data must arrive as Inertia props on the initial page render. Components that previously used `ref([...])` with hardcoded mocks now use `defineProps({ ... })` with backend data.

- **`doctor` prop is shared.** Every page requires the `doctor` prop for the `TopHeader` and `AppSidebar`. Extract this into a shared base method (e.g., `DoctorDashboardController::getDoctorProp()`) to avoid duplication.

- **Eager-load the `clinic` relationship.** The `clinic.name` and `clinic.address` fields are rendered directly from `doctor.clinic`. Always call `$doctor->load('clinic')` before passing to Inertia. If the doctor has no clinic assigned, `clinic` will be `null` — the frontend handles this safely with `?.` operators.

- **`fileType` prop is required.** The `ViewFullFile.vue` page reads `fileType` exclusively from its Inertia prop. The route closure **must** pass `'fileType' => $request->query('type', 'imaging')`.

- **Do not pass pre-computed counts.** The `reviews` stat cards (`pendingCount`, `reviewedCount`) and the `pendingReviews` badge count are computed on the frontend from the raw arrays. Only pass the full arrays.

- **Date formatting.** Pass human-readable date strings (e.g. `"Apr 18, 2026"`) directly. The Vue components do not parse ISO timestamps — format using Laravel's `Carbon::format('M d, Y')` before passing.

- **Route Setup.** All read routes should use `Route::get` and return `Inertia::render('DoctorDashboard/{PageName}', [...])`. All mutation routes (profile update, schedule save) should use `Route::patch`.

---

# Required Backend Updates

Your existing or upcoming Laravel controllers need to inject these specific props directly into `Inertia::render()` so the rewritten Vue components accept them instantly on page load.

---

### 1. Route Map (`routes/web.php`)

```php
use App\Http\Controllers\Doctor\DoctorDashboardController;
use App\Http\Controllers\Doctor\DoctorProfileController;
use App\Http\Controllers\Doctor\DoctorAppointmentController;
use App\Http\Controllers\Doctor\DoctorNotificationController;
use App\Http\Controllers\Doctor\DoctorReviewController;

Route::middleware(['auth', 'role:doctor'])->prefix('doctor')->name('doctor.')->group(function () {

    // Home dashboard
    Route::get('/dashboard',    [DoctorDashboardController::class, 'index'])   ->name('dashboard');

    // Profile (view + update)
    Route::get('/profile',      [DoctorProfileController::class, 'show'])      ->name('profile');
    Route::patch('/profile',    [DoctorProfileController::class, 'update'])    ->name('profile.update');

    // Appointments
    Route::get('/appointments', [DoctorAppointmentController::class, 'index']) ->name('appointments');

    // Notifications
    Route::get('/notifications',[DoctorNotificationController::class, 'index'])->name('notifications');

    // Reviews list
    Route::get('/reviews',      [DoctorReviewController::class, 'index'])      ->name('reviews');

    // Review files for a specific patient
    Route::get('/reviews/files',[DoctorReviewController::class, 'files'])      ->name('reviews.files');

    // Full file viewer (lab or imaging)
    Route::get('/reviews/view-full-file', [DoctorReviewController::class, 'viewFullFile'])->name('reviews.view');

    // Patient medical record
    Route::get('/reviews/medical-record', [DoctorReviewController::class, 'medicalRecord'])->name('reviews.record');

});
```

---

### 2. `DoctorDashboardController` (`index` method)

**File:** `app/Http/Controllers/Doctor/DoctorDashboardController.php`

**Passes:** `doctor`, `stats`, `todaySchedule`, `upcomingAppointments`, `pendingReviews`, `recentPatients`, `schedule`

```php
public function index(): Response
{
    $doctor = Auth::user()->load('clinic');
    $today  = Carbon::today();
    $week   = [Carbon::now()->startOfWeek(), Carbon::now()->endOfWeek()];

    return Inertia::render('DoctorDashboard/Index', [
        'doctor' => $this->buildDoctorProp($doctor),

        'stats' => [
            'upcomingAppointments' => Appointment::where('doctor_id', $doctor->id)
                                        ->whereDate('scheduled_at', '>=', $today)
                                        ->where('status', '!=', 'cancelled')
                                        ->count(),
            'pendingTestReviews'   => MedicalReview::where('doctor_id', $doctor->id)
                                        ->where('status', 'pending')
                                        ->count(),
            'totalPatients'        => Appointment::where('doctor_id', $doctor->id)
                                        ->distinct('patient_id')
                                        ->count('patient_id'),
            'completedThisWeek'    => Appointment::where('doctor_id', $doctor->id)
                                        ->where('status', 'completed')
                                        ->whereBetween('scheduled_at', $week)
                                        ->count(),
        ],

        'todaySchedule' => Appointment::with('patient')
            ->where('doctor_id', $doctor->id)
            ->whereDate('scheduled_at', $today)
            ->orderBy('scheduled_at')
            ->get()
            ->map(fn($a) => [
                'id'              => $a->id,
                'patientName'     => $a->patient->full_name,
                'appointmentType' => $a->type,
                'description'     => $a->notes ?? '',
                'time'            => Carbon::parse($a->scheduled_at)->format('h:i A'),
                'status'          => ucfirst($a->status),
                'avatar'          => $a->patient->avatar_url,
            ]),

        'upcomingAppointments' => Appointment::with('patient')
            ->where('doctor_id', $doctor->id)
            ->whereDate('scheduled_at', '>', $today)
            ->where('status', '!=', 'cancelled')
            ->orderBy('scheduled_at')
            ->limit(5)
            ->get()
            ->map(fn($a) => [
                'id'       => $a->id,
                'initials' => $a->patient->initials,
                'name'     => $a->patient->full_name,
                'type'     => $a->type,
                'date'     => Carbon::parse($a->scheduled_at)->format('M d'),
                'time'     => Carbon::parse($a->scheduled_at)->format('h:i A'),
                'status'   => 'Confirmed',
            ]),

        'pendingReviews' => MedicalReview::with('patient')
            ->where('doctor_id', $doctor->id)
            ->where('status', 'pending')
            ->latest()
            ->limit(5)
            ->get()
            ->map(fn($r) => [
                'id'          => $r->id,
                'reportType'  => $r->report_type,
                'patientName' => $r->patient->full_name,
                'category'    => $r->category,
                'timeAgo'     => $r->created_at->diffForHumans(),
            ]),

        'recentPatients' => Appointment::with('patient')
            ->where('doctor_id', $doctor->id)
            ->where('status', 'completed')
            ->latest('scheduled_at')
            ->get()
            ->unique('patient_id')
            ->take(5)
            ->map(fn($a) => [
                'id'        => $a->patient->id,
                'name'      => $a->patient->full_name,
                'lastVisit' => Carbon::parse($a->scheduled_at)->format('M d, Y'),
                'note'      => $a->notes ?? 'No notes',
                'avatar'    => $a->patient->avatar_url,
            ]),

        'schedule' => $this->buildScheduleProp($doctor),
    ]);
}
```

---

### 3. `DoctorProfileController` (`show` + `update` methods)

**File:** `app/Http/Controllers/Doctor/DoctorProfileController.php`

**`show` passes:** `doctor`, `schedule`
**`update` validates and redirects back with Inertia.**

```php
public function show(): Response
{
    $doctor = Auth::user()->load('clinic');

    return Inertia::render('DoctorDashboard/Profile', [
        'doctor'   => [
            'id'              => $doctor->id,
            'name'            => 'Dr. ' . $doctor->first_name,
            'fullName'        => $doctor->full_name,
            'handle'          => '@' . $doctor->username,
            'avatar'          => $doctor->avatar_url,
            'firstName'       => $doctor->first_name,
            'secondName'      => $doctor->last_name,
            'email'           => $doctor->email,
            'phone'           => $doctor->phone,
            'nationalId'      => $doctor->national_id,
            'dob'             => $doctor->date_of_birth,
            'gender'          => $doctor->gender,
            'address'         => $doctor->address,
            'specialty'       => $doctor->specialty,
            'experience'      => (string) $doctor->experience_years,
            'consultationFee' => (string) $doctor->consultation_fee,
            'about'           => $doctor->bio,
            // Read-only — from the direct clinic FK relationship:
            'clinic' => $doctor->clinic ? [
                'name'    => $doctor->clinic->name,
                'address' => $doctor->clinic->address,
            ] : null,
        ],
        'schedule' => $this->buildScheduleProp($doctor),
    ]);
}

public function update(Request $request): RedirectResponse
{
    $doctor = Auth::user();

    $validated = $request->validate([
        'firstName'       => 'required|string|max:255',
        'secondName'      => 'required|string|max:255',
        'email'           => "required|email|unique:users,email,{$doctor->id}",
        'phone'           => 'nullable|string',
        'nationalId'      => 'nullable|string',
        'dob'             => 'nullable|date',
        'gender'          => 'nullable|in:male,female,na',
        'address'         => 'nullable|string',
        'specialty'       => 'nullable|string',
        'experience'      => 'nullable|string',
        'consultationFee' => 'nullable|numeric',
        'about'           => 'nullable|string',
        'currentPassword' => 'nullable|string',
        'newPassword'     => 'nullable|string|min:8|confirmed',
    ]);

    $doctor->update([
        'first_name'       => $validated['firstName'],
        'last_name'        => $validated['secondName'],
        'email'            => $validated['email'],
        'phone'            => $validated['phone'] ?? $doctor->phone,
        'national_id'      => $validated['nationalId'] ?? $doctor->national_id,
        'date_of_birth'    => $validated['dob'] ?? $doctor->date_of_birth,
        'gender'           => $validated['gender'] ?? $doctor->gender,
        'address'          => $validated['address'] ?? $doctor->address,
        'specialty'        => $validated['specialty'] ?? $doctor->specialty,
        'experience_years' => $validated['experience'] ?? $doctor->experience_years,
        'consultation_fee' => $validated['consultationFee'] ?? $doctor->consultation_fee,
        'bio'              => $validated['about'] ?? $doctor->bio,
    ]);

    // Handle optional password change
    if (!empty($validated['newPassword'])) {
        $doctor->update(['password' => bcrypt($validated['newPassword'])]);
    }

    return redirect()->back();
}
```

---

### 4. `DoctorAppointmentController` (`index` method)

**File:** `app/Http/Controllers/Doctor/DoctorAppointmentController.php`

**Passes:** `doctor`, `completedAppointments`, `upcomingAppointments`, `cancelledAppointments`

```php
public function index(): Response
{
    $doctor = Auth::user()->load('clinic');
    $today  = Carbon::today();

    $mapAppointment = fn($a) => [
        'id'          => $a->id,
        'patientName' => $a->patient->full_name,
        'initials'    => $a->patient->initials,
        'visitType'   => $a->type,
        'date'        => Carbon::parse($a->scheduled_at)->format('M d, Y'),
        'time'        => Carbon::parse($a->scheduled_at)->format('h:i A'),
        'status'      => ucfirst($a->status),
        'canEdit'     => true,
        'action'      => 'View Details',
        'cancelledNote' => $a->cancellation_note ?? '',
        'reason'        => $a->cancellation_reason ?? '',
    ];

    return Inertia::render('DoctorDashboard/Appointments', [
        'doctor'              => $this->buildDoctorProp($doctor),
        'completedAppointments' => Appointment::with('patient')
                                    ->where('doctor_id', $doctor->id)
                                    ->where('status', 'completed')
                                    ->latest('scheduled_at')->get()->map($mapAppointment),
        'upcomingAppointments'  => Appointment::with('patient')
                                    ->where('doctor_id', $doctor->id)
                                    ->whereDate('scheduled_at', '>=', $today)
                                    ->where('status', '!=', 'cancelled')
                                    ->orderBy('scheduled_at')->get()->map($mapAppointment),
        'cancelledAppointments' => Appointment::with('patient')
                                    ->where('doctor_id', $doctor->id)
                                    ->where('status', 'cancelled')
                                    ->latest()->get()->map($mapAppointment),
    ]);
}
```

---

### 5. `DoctorNotificationController` (`index` method)

**File:** `app/Http/Controllers/Doctor/DoctorNotificationController.php`

**Passes:** `doctor`, `notifications`

```php
public function index(): Response
{
    $doctor = Auth::user()->load('clinic');
    $today  = Carbon::today();

    $notifications = $doctor->notifications()
        ->latest()
        ->get()
        ->map(fn($n) => [
            'id'          => $n->id,
            'type'        => $n->data['type'] ?? 'info',
            'title'       => $n->data['title'] ?? '',
            'message'     => $n->data['message'] ?? '',
            'description' => $n->data['description'] ?? '',
            'time'        => $n->created_at->diffForHumans(),
            'badge'       => strtoupper($n->data['type'] ?? 'INFO'),
            'date'        => $n->created_at->isToday() ? 'today' : 'yesterday',
            'read'        => !is_null($n->read_at),
        ]);

    return Inertia::render('DoctorDashboard/Notifications', [
        'doctor'        => $this->buildDoctorProp($doctor),
        'notifications' => $notifications,
    ]);
}
```

---

### 6. `DoctorReviewController` (all four methods)

**File:** `app/Http/Controllers/Doctor/DoctorReviewController.php`

#### `index` — Reviews List
```php
public function index(): Response
{
    $doctor  = Auth::user()->load('clinic');
    $reviews = MedicalReview::with('patient')
        ->where('doctor_id', $doctor->id)
        ->latest()
        ->get()
        ->map(fn($r) => [
            'id'          => $r->id,
            'patientName' => $r->patient->full_name,
            'initials'    => $r->patient->initials,
            'filesCount'  => $r->files_count ?? $r->files()->count(),
            'date'        => $r->created_at->format('M d, Y'),
            'time'        => $r->created_at->format('h:i A'),
            'status'      => $r->status === 'pending' ? 'Pending' : 'Reviewed',
        ]);

    return Inertia::render('DoctorDashboard/Reviews', [
        'doctor'  => $this->buildDoctorProp($doctor),
        'reviews' => $reviews,
    ]);
}
```

#### `files` — Patient File List
```php
public function files(Request $request): Response
{
    $doctor  = Auth::user()->load('clinic');
    $patient = User::findOrFail($request->query('patient'));

    $files = MedicalFile::where('patient_id', $patient->id)
        ->get()
        ->map(fn($f) => [
            'id'           => $f->id,
            'category'     => $f->type === 'lab' ? 'Lab Test' : 'Imaging',
            'title'        => $f->title,
            'date'         => $f->created_at->format('M d, Y'),
            'previewImage' => $f->preview_url,
            'buttonText'   => 'View Full Report',
        ]);

    return Inertia::render('DoctorDashboard/ReviewFiles', [
        'doctor'  => $this->buildDoctorProp($doctor),
        'patient' => [
            'name'      => $patient->full_name,
            'initials'  => $patient->initials,
            'age'       => $patient->age,
            'gender'    => ucfirst($patient->gender ?? ''),
            'patientId' => $patient->patient_code,
        ],
        'files' => $files,
    ]);
}
```

#### `viewFullFile` — Single File Viewer
```php
public function viewFullFile(Request $request): Response
{
    $doctor   = Auth::user()->load('clinic');
    $type     = $request->query('type', 'imaging');  // ← MUST be passed as prop
    $fileId   = $request->query('file');

    return Inertia::render('DoctorDashboard/ViewFullFile', [
        'doctor'   => $this->buildDoctorProp($doctor),
        'fileType' => $type,
        'imaging'  => $type === 'imaging' ? $this->buildImagingProp($fileId) : null,
        'lab'      => $type === 'lab'     ? $this->buildLabProp($fileId)     : null,
    ]);
}
```

#### `medicalRecord` — Full Patient Record
```php
public function medicalRecord(Request $request): Response
{
    $doctor  = Auth::user()->load('clinic');
    $patient = User::with([
        'testResults', 'imagingRecords', 'prescriptions', 'visits'
    ])->findOrFail($request->query('patient'));

    return Inertia::render('DoctorDashboard/MedicalRecord', [
        'doctor'        => $this->buildDoctorProp($doctor),
        'patient'       => [
            'name'      => $patient->full_name,
            'initials'  => $patient->initials,
            'id'        => $patient->patient_code,
            'dob'       => optional($patient->date_of_birth)->format('F d, Y'),
            'email'     => $patient->email,
            'gender'    => ucfirst($patient->gender ?? ''),
            'age'       => (string) $patient->age,
            'phone'     => $patient->phone,
            'bloodType' => $patient->blood_type,
            'notes'     => $patient->medical_notes,
        ],
        'testResults'   => $patient->testResults->map(fn($r) => [...]),
        'imaging'       => $patient->imagingRecords->map(fn($i) => [...]),
        'prescriptions' => $patient->prescriptions->map(fn($p) => [...]),
        'visits'        => $patient->visits->map(fn($v) => [...]),
    ]);
}
```

---

### 7. Shared Helper — `buildDoctorProp()`

Add this private method to a `DoctorDashboardController` base class or a `HasDoctorProp` trait to avoid repeating the `doctor` shape across all six controllers:

```php
private function buildDoctorProp(User $doctor): array
{
    return [
        'id'       => $doctor->id,
        'name'     => 'Dr. ' . $doctor->first_name,
        'fullName' => $doctor->full_name,
        'handle'   => '@' . $doctor->username,
        'avatar'   => $doctor->avatar_url,
        'clinic'   => $doctor->clinic ? [
            'name'    => $doctor->clinic->name,
            'address' => $doctor->clinic->address,
        ] : null,
    ];
}

private function buildScheduleProp(User $doctor): array
{
    $schedule = $doctor->schedule;   // assumes a 'schedule' JSON column or related model

    return $schedule ?? [
        'days' => [
            ['name' => 'Monday',    'enabled' => true,  'from' => '09:00 AM', 'to' => '05:00 PM'],
            ['name' => 'Tuesday',   'enabled' => true,  'from' => '09:00 AM', 'to' => '05:00 PM'],
            ['name' => 'Wednesday', 'enabled' => false, 'from' => '',         'to' => ''],
            ['name' => 'Thursday',  'enabled' => true,  'from' => '09:00 AM', 'to' => '05:00 PM'],
            ['name' => 'Friday',    'enabled' => true,  'from' => '09:00 AM', 'to' => '02:00 PM'],
            ['name' => 'Saturday',  'enabled' => false, 'from' => '',         'to' => ''],
            ['name' => 'Sunday',    'enabled' => false, 'from' => '',         'to' => ''],
        ],
        'duration'          => '30 min',
        'breakBetweenSlots' => '5 min',
        'selectedPreset'    => null,
        'appointmentTypes'  => ['inClinic' => true, 'followUp' => true, 'labReview' => true],
        'labReviewOptions'  => ['acceptLabTests' => true, 'acceptXrayImages' => true],
    ];
}
```

---

### 8. Eloquent Model Requirements

The following relationships and accessors must exist on the `User` model for the prop builders above to work:

| Accessor / Relationship | Returns | Notes |
|---|---|---|
| `$user->full_name` | `string` | `first_name . ' ' . last_name` |
| `$user->initials` | `string` | First letter of first + last name |
| `$user->age` | `int` | Computed from `date_of_birth` using Carbon |
| `$user->avatar_url` | `string\|null` | Public storage URL or `null` |
| `$user->patient_code` | `string` | e.g. `"PT-00142"` (formatted ID) |
| `$user->clinic()` | `BelongsTo` | `belongsTo(Clinic::class, 'clinic_id')` |
| `$user->notifications()` | `HasMany` | Laravel's built-in notification system |
| `$user->schedule` | `array\|null` | JSON column on `users` table or separate model |
