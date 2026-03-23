# Patient Dashboard Integration Checklist

## 1. File Structure & Conventions

- [ ] **Task Name:** Relocate Pages & Components directories
  - **The Problem:** The frontend's `pages/` and `components/` directories are currently lowercase and mixed with standard Inertia setup.
  - **The Solution:** Rename `pages` to `Pages` and `components` to `Components` to match standard Laravel/Inertia autowiring and conventions. Move the specific dashboard pages directly into `Pages/`.
  - **Files to Edit:** 
    - `resources/js/pages/*`
    - `resources/js/components/*`

- [ ] **Task Name:** Remove Standalone Vue Router
  - **The Problem:** The project still contains Vue router configuration which conflicts directly with how Inertia.js manages page visits and SPA state from the backend.
  - **The Solution:** Delete any standalone Vue router setup files and ensure `resources/js/app.ts` does not contain any `createRouter` initialization. Route definitions belong entirely in Laravel.
  - **Files to Edit:** 
    - `resources/js/routes/*`
    - `resources/js/app.ts`

## 2. Vue to Inertia Feature Conversions
    
- [ ] **Task Name:** Replace vue-router hooks (`useRouter`, `useRoute`)
  - **The Problem:** Multiple components import and use `vue-router` methods like `router.push()` which break the Inertia lifecycle and cause full page reloads or routing failures.
  - **The Solution:** Import `router` and `usePage` from `@inertiajs/vue3` instead. Change `router.push()` to `router.visit()` or `router.get()`. Replace `route.params` with proper Laravel-passed props via `defineProps()`.
  - **Files to Edit:** 
    - `resources/js/pages/PatientDashboard/VisitHistory.vue`
    - `resources/js/pages/PatientDashboard/TestResults.vue`
    - `resources/js/pages/PatientDashboard/TestResultDetails.vue`
    - `resources/js/pages/PatientDashboard/Profile.vue`
    - `resources/js/pages/PatientDashboard/PrescriptionDetails.vue`
    - `resources/js/pages/PatientDashboard/Notifications.vue`
    - `resources/js/pages/PatientDashboard/MedicalRecords.vue`
    - `resources/js/pages/PatientDashboard/ImagingRecords.vue`
    - `resources/js/pages/PatientDashboard/ImagingDetail.vue`
    - `resources/js/pages/PatientDashboard/DoctorProfile.vue`
    - `resources/js/pages/PatientDashboard/DashboardInteractive.vue`
    - `resources/js/pages/PatientDashboard/Dashboard.vue`
    - `resources/js/pages/PatientDashboard/CreateAppointment.vue`
    - `resources/js/pages/PatientDashboard/Appointments.vue`
    - `resources/js/components/dashboard/UserDropdown.vue`
    - `resources/js/components/dashboard/Sidebar.vue`

- [ ] **Task Name:** Replace `<RouterLink>` with Inertia `<Link>`
  - **The Problem:** Vue Components that handle navigation use standard Vue Router `<router-link>` tags which do not intercept requests correctly in an Inertia setup.
  - **The Solution:** Import `Link` from `@inertiajs/vue3` and replace all `<router-link to="...">` instances with `<Link href="...">`, using actual Laravel route paths.
  - **Files to Edit:** 
    - `resources/js/components/dashboard/Sidebar.vue`
    - `resources/js/components/landing/Navbar.vue`
    - `resources/js/pages/PatientDashboard/*` (Any that contain navigation links)

- [ ] **Task Name:** Refactor Client-Side Data Fetching (`onMounted` & State)
  - **The Problem:** The frontend is heavily relying on `onMounted` lifecycle hooks and hardcoded mock data calls inside `stores/dashboard.js` and `composables/useDashboard.js` to simulate data loading.
  - **The Solution:** Remove the `onMounted` data fetch calls. Inertia completely eliminates initial loading states by eagerly loading data before rendering. The backend should pass data directly to components via `defineProps()`.
  - **Files to Edit:** 
    - `resources/js/stores/dashboard.js`
    - `resources/js/composables/useDashboard.js`
    - `resources/js/pages/PatientDashboard/VisitHistory.vue`
    - `resources/js/pages/PatientDashboard/TestResults.vue`
    - `resources/js/pages/PatientDashboard/TestResultDetails.vue`
    - `resources/js/pages/PatientDashboard/Profile.vue`
    - `resources/js/pages/PatientDashboard/PrescriptionDetails.vue`
    - `resources/js/pages/PatientDashboard/Notifications.vue`
    - `resources/js/pages/PatientDashboard/MedicalRecords.vue`
    - `resources/js/pages/PatientDashboard/ImagingRecords.vue`
    - `resources/js/pages/PatientDashboard/ImagingDetail.vue`
    - `resources/js/pages/PatientDashboard/DoctorProfile.vue`
    - `resources/js/pages/PatientDashboard/DashboardInteractive.vue`
    - `resources/js/pages/PatientDashboard/Dashboard.vue`
    - `resources/js/pages/PatientDashboard/CreateAppointment.vue`
    - `resources/js/pages/PatientDashboard/Appointments.vue`

- [ ] **Task Name:** Verify Asset Paths
  - **The Problem:** Image assets are dynamically bound (`:src="netHealthLogo"` or `src="https://..."`) and some files might use relative paths that break when compiled by Vite in the Laravel context.
  - **The Solution:** Ensure static assets are either placed correctly in Laravel's `public/` directory and referenced absolutely (e.g., `/images/logo.png`), or imported directly via Vite aliases in the components. Remove hardcoded `https://i.pravatar.cc` mocks where dynamic model data should exist.
  - **Files to Edit:** 
    - `resources/js/pages/PatientDashboard/Profile.vue`
    - `resources/js/pages/PatientDashboard/DoctorProfile.vue`
    - `resources/js/pages/Dashboards/PatientDashboard.vue`
    - `resources/js/components/landing/*`
    - `resources/js/components/dashboard/*`
    - `resources/js/components/appointments/*`
    - `resources/js/components/prescription/*`

## 3. Routing & Backend Audit

- [ ] **Task Name:** Create Missing Dashboard Endpoints
  - **The Problem:** The `routes/web.php` explicitly defines `/dashboard` and `/profile`, but entirely lacks endpoints for the nested dashboard navigation views (`Appointments`, `MedicalRecords`, `ImagingRecords`, `TestResults`, etc.).
  - **The Solution:** Map out the exact dashboard routes needed in `routes/web.php` and assign them to specific controller methods. Example: `Route::get('/patient/appointments', [PatientDashboardController::class, 'appointments'])->name('patient.appointments');`
  - **Files to Edit:** 
    - `routes/web.php`

- [ ] **Task Name:** Setup `Inertia::render` in Controllers
  - **The Problem:** For the new frontend pages to render at all, the backend has to physically call them and pass data. 
  - **The Solution:** For each new route added from the previous task, create a corresponding method in standard Laravel controllers that fetches the data from the DB, processes it, and returns `return Inertia::render('PatientDashboard/YourComponent', ['data' => $data]);`.
  - **Files to Edit:** 
    - `app/Http/Controllers/DashBoard/DashboardController.php`
    - `app/Http/Controllers/Auth/PatientController.php` (or a dedicated `PatientDashboardController`)
    - `routes/web.php`
  
- [ ] **Task Name:** Ensure Proper Middleware Application
  - **The Problem:** The patient dashboard endpoints need rigorous protection; otherwise unauthenticated users can access sensitive records.
  - **The Solution:** Apply the existing `auth` and `active` middleware groups to all newly created patient sub-routes to guarantee secure access control.
  - **Files to Edit:** 
    - `routes/web.php`
