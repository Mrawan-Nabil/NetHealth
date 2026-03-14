# Patient Dashboard Integration Checklist
*A comprehensive guide to refactoring the Vue 3 SPA into the Laravel 11/Inertia architecture.*

## 1. File Structure & Conventions

- [ ] **Relocate Pages & Components**
  - **What:** The frontend's `pages/` and `components/` directories are currently lowercase.
  - **Why:** Inertia and Laravel typically expect a standard capitalized structure (`resources/js/Pages/` and `resources/js/Components/`) for autowiring and conventions.
  - **Fix:** Rename `pages` to `Pages` and `components` to `Components`. Move the specific dashboard pages (e.g., `PatientDashboard/`) directly into `Pages/`.
- [ ] **Remove Standalone Vue Router**
  - **What:** The `routes/` directory inside `resources/js/` and any standalone routing setups.
  - **Why:** In an Inertia app, the backend (Laravel) handles all routing. The frontend router conflicts with Inertia's request lifecycle.
  - **Fix:** Delete `resources/js/routes/`. Remove any `createRouter` initialization from `resources/js/app.ts` or standalone configuration files.

## 2. Vue to Inertia Feature Conversions

- [ ] **Replace `vue-router` Hooks (`useRoute`, `useRouter`)**
  - **What:** Files like `VisitHistory.vue`, `TestResults.vue`, `Appointments.vue`, `Dashboard.vue`, `Sidebar.vue`, etc., import and use `vue-router`.
  - **Why:** Inertia provides its own routing mechanism. `vue-router` methods like `router.push()` will break the Inertia lifecycle and perform full page reloads or fail completely.
  - **Fix:** Replace `import { useRouter, useRoute } from 'vue-router'` with `import { router, usePage } from '@inertiajs/vue3'`. Change `router.push()` to `router.visit()` or `router.get()`. Replace `route.params` with data passed via `defineProps()`.
- [ ] **Replace `<RouterLink>` with `<Link>`**
  - **What:** Any navigational links within the components (e.g. Sidebar, Navbar) using standard Vue Router navigation.
  - **Why:** Inertia requires its own `<Link>` component to intercept clicks and make XHR requests instead of full page reloads.
  - **Fix:** Import `import { Link } from '@inertiajs/vue3'` and replace all `<router-link to="...">` or raw `<a>` tags (that point to internal pages) with `<Link href="...">`. Provide Laravel route paths instead of Vue paths.
- [ ] **Convert Client-Side Data Fetching (State & API)**
  - **What:** Hardcoded API fetches simulating backend delays (e.g., `fetchAppointments()`, `fetchPrescriptions()`) inside `stores/dashboard.js` and `composables/useDashboard.js`, called on `onMounted` in pages like `VisitHistory.vue` and `MedicalRecords.vue`.
  - **Why:** Inertia eliminates the need for initial client-side loading states. The backend should eagerly load this data and pass it directly to the page component upon rendering.
  - **Fix:** Remove the `onMounted` API calls and mock data generators. Update the Vue page components to accept this data passively using `defineProps({ appointments: Array, ... })`.
- [ ] **Assess Global Stores for Form Submissions**
  - **What:** Form submissions in pages and modals (e.g., `CreateAppointment.vue`, `ConfirmAppointmentModal.vue`).
  - **Why:** Form handling without Inertia requires manual CSRF passing and manual error mapping.
  - **Fix:** Use Inertia's `useForm` helper (`import { useForm } from '@inertiajs/vue3'`) to handle form state, submissions, loading spinners, and backend validation errors automatically.
- [ ] **Verify Asset Paths**
  - **What:** Image assets dynamically bound to `:src` (e.g. `netHealthLogo` bindings).
  - **Why:** Standalone Vite setups sometimes treat relative paths differently than Laravel's tightly coupled Vite plugin.
  - **Fix:** Ensure static assets are either placed in the `public/` folder and referenced with absolute paths (e.g., `/images/logo.png`) or properly imported via Vite aliases (e.g., `import logo from '@/assets/logo.png'`).

## 3. Backend Routing & Controllers

- [ ] **Create Missing Dashboard Endpoints**
  - **What:** `routes/web.php` only has `/dashboard` and `/profile`. It is missing routes for the dashboard sub-pages (`Appointments`, `VisitHistory`, `MedicalRecords`, `ImagingRecords`, `TestResults`, `DoctorProfile`, etc.).
  - **Why:** The frontend expects these distinct views to exist, but the Laravel backend isn't exposing endpoints for them.
  - **Fix:** Add routes in `routes/web.php` mapped to corresponding controller methods. E.g., `Route::get('/patient/appointments', [PatientDashboardController::class, 'appointments'])->name('patient.appointments');`
- [ ] **Setup `Inertia::render` in Controllers**
  - **What:** The backend controllers must render the specific sub-pages.
  - **Why:** The backend must trigger the component render and pass the required database models as props.
  - **Fix:** In your controller methods, fetch the required database records (e.g., `Appointment::where(...)`) and return them via `return Inertia::render('PatientDashboard/Appointments', ['appointments' => $appointments]);`.
- [ ] **Ensure Proper Middleware Application**
  - **What:** Patient dashboard route security.
  - **Why:** Security and role-based access control must be enforced centrally at the router level.
  - **Fix:** Ensure all new patient-specific routes are wrapped in an `auth` middleware group, and potentially a role-specific middleware (e.g., `active` or `role:patient`) as seen in your existing setup.
