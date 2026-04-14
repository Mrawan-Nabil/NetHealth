# NetHealth Mobile Redesign Plan

This document outlines the strategy for redesigning the NetHealth web application into a professional, mobile-first Flutter application. The redesign focuses on achieving a clean, modern, and intuitive mobile User Experience (UX), while preserving the brand's visual identity.

## Phase 2: Auth & Home Dashboard

### Web Screen Analysis
- **Auth (Landing & Role Selection):** Web landing page features a large hero section, service highlights, and a role selection modal (Patient, Doctor, Clinic, Pharmacy).
- **Home Dashboard:** Utilizes a standard web layout with a side navigation menu. The main content area displays a welcome banner, summary cards (Upcoming Appointments, Pending Tests), an overview of health statistics, and lists of recent medical records. 

### Mobile Redesign Strategy
- **Navigation:** Replace the sidebar with a standard `BottomNavigationBar` (Home, Appointments, Records, Profile).
- **Auth Flow:** Convert the landing page into a mobile-friendly onboarding carousel (`PageView`). Re-imagine role selection as a clean, full-screen vertical list with large, easily tappable cards.
- **Home Layout:** Use a more compact top `AppBar` displaying the user avatar, greeting, and notification icon. Transform the prominent welcome banner into a beautifully rounded card. 
- **Summary Cards:** Convert the various web summary blocks into a horizontally scrollable sequence of cards (`ListView.builder` with horizontal scroll) to maximize vertical screen space.
- **Lists:** Represent recent medical records and upcoming appointments as vertical lists of stacked cards with clear call-to-action indicators.

### Key Components Needed
- `BottomNavigationBar` / `NavigationDestination`
- `PageView` (for onboarding/auth)
- `SliverAppBar` (for the home header)
- `SingleChildScrollView` + `Column` (for the main dashboard view)
- Custom reusable `Card` widgets

---

## Phase 3: Appointments

### Web Screen Analysis
- **Doctor Browsing:** A grid/list of doctors with varied filters and detailed profile views containing large headers, text blocks, and schedules.
- **Booking Flow:** Calendar views for slot selection, accompanied by wide confirmation modals.
- **Appointment Management:** Uses tabs for Completed, Scheduled, and Cancelled appointments.

### Mobile Redesign Strategy
- **Doctor List:** Implement a vertical list of doctors. Use `ChoiceChip` widgets positioned below the app bar for quick filtering (Specialty, Available Today, etc.).
- **Doctor Profile:** Employ a `CustomScrollView` with a `SliverAppBar` showcasing the doctor's image. Add a persistent `BottomAppBar` with a primary "Book Appointment" floating action button.
- **Booking Flow:** Redesign the scheduling process into a step-by-step wizard or a bottom sheet. Utilize a compact mobile calendar widget and chip-based time slot selection.
- **Appointment Management:** Adopt the `DefaultTabController` paired with a `TabBar` to easily switch between Scheduled, Completed, and Cancelled views.

### Key Components Needed
- `TabBar` and `TabBarView`
- `ListView.builder`
- `FilterChip` / `ChoiceChip`
- `SliverAppBar`
- `TableCalendar` (or similar compact calendar package)
- `FloatingActionButton`

---

## Phase 4: Medical Records & Prescriptions

### Web Screen Analysis
- Displays chronological tables or wide lists of past visits. 
- Detailed views of prescriptions present exhaustive lists of medications, directions, and pharmacy details.

### Mobile Redesign Strategy
- **Records List:** Group records by date or type, potentially using expandable tiles for a cleaner look.
- **Prescription View:** Focus on typography and readability. Display medications using standard `ListTile` components with clear icons. Introduce floating actions for "Share" or "Download PDF".

### Key Components Needed
- `ListView.separated`
- `ExpansionTile`
- `ListTile`
- `IconButton`

---

## Phase 5: Test Results & Imaging

### Web Screen Analysis
- Tabular text layouts for test results indicating Normal/High/Low statuses.
- Large preview areas for medical imaging (e.g., X-Rays) with uploaded files displayed as side-by-side attachments.

### Mobile Redesign Strategy
- **Status Indicators:** Rely heavily on color-coded visual badges (e.g., green for normal, red for high) as primary indicators to aid quick scanning on small screens.
- **Imaging Grid:** Show thumbnails of tests using a grid layout. Tapping a thumbnail should transition into a full-screen, interactive image viewer that supports pinch-to-zoom and panning.

### Key Components Needed
- `GridView.builder`
- `InteractiveViewer` (for image zoom/pan)
- Custom status badges (decorated `Container`)

---

## Phase 6: Profile & Notifications

### Web Screen Analysis
- **Profile:** Elaborate multi-tab settings covering personal info, clinical history, and system configurations.
- **Notifications:** Dropdown panel extending from the top header navigation.

### Mobile Redesign Strategy
- **Profile:** Adopt standard mobile settings architecture—a single scrolling view separated into distinct logical sections (Personal Info, Health, Settings, Logout). Use standard list items with trailing chevron icons (`Icons.chevron_right`).
- **Notifications:** Create a dedicated screen for notifications, accessed via the top app bar bell icon. Utilize dot indicators or badges on list items to delineate unread alerts. 

### Key Components Needed
- `ListTile` + `Switch` (for settings like Dark Mode toggle)
- `Badge` (for unread notifications)
- Section Headers (`Padding` + styling)
