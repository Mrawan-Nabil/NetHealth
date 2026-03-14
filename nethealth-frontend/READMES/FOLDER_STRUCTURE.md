# NetHealth Dashboard - Complete Folder Structure

## Project Overview
```
nethealth-frontend/
├── public/                          # Static assets
│   └── logo2.png                    # Application logo
│
├── src/                             # Source code
│   ├── assets/                      # Images and static files
│   │   ├── back.webp
│   │   ├── doc.jpg
│   │   ├── done.jpg
│   │   ├── dooone.jpg
│   │   ├── hh.jpeg
│   │   ├── logo.png
│   │   ├── logo3.png
│   │   └── male-surgeon-using-digital-tablet-operation-room.jpg
│   │
│   ├── components/                  # Vue components
│   │   ├── base/                    # Base/reusable components
│   │   │   ├── BaseInput.vue        # Input component
│   │   │   ├── BaseSelect.vue       # Select dropdown component
│   │   │   └── PhoneInput.vue       # Phone number input
│   │   │
│   │   ├── dashboard/               # Dashboard-specific components
│   │   │   ├── Sidebar.vue          # Left navigation sidebar
│   │   │   ├── TopNavbar.vue        # Top navigation bar
│   │   │   ├── StatsCard.vue        # Statistics display card
│   │   │   ├── AppointmentCard.vue  # Next appointment card
│   │   │   ├── MedicalRecordItem.vue # Medical record list item
│   │   │   ├── HealthOverview.vue   # Health information card
│   │   │   └── ActivityTimeline.vue # Recent activity timeline
│   │   │
│   │   ├── landing/                 # Landing page components
│   │   │   ├── DoctorsSection.vue
│   │   │   ├── FeaturesSection.vue
│   │   │   ├── Footer.vue
│   │   │   ├── HeroSection.vue
│   │   │   ├── HowItWorksSection.vue
│   │   │   ├── Navbar.vue
│   │   │   └── ProvidersSection.vue
│   │   │
│   │   └── MultiStepForm.vue        # Multi-step form component
│   │
│   ├── layouts/                     # Layout components
│   │   └── AuthLayout.vue           # Authentication layout
│   │
│   ├── router/                      # Vue Router configuration
│   │   └── index.js                 # Route definitions
│   │
│   ├── services/                    # API and service layer
│   │   └── api.js                   # Dashboard API service
│   │
│   ├── views/                       # Page components
│   │   ├── Dashboard.vue            # Main dashboard page (NEW)
│   │   ├── Home.vue                 # Landing/home page
│   │   ├── Login.vue                # Login page
│   │   ├── RegisterClinic.vue       # Clinic registration
│   │   ├── RegisterDoctor.vue       # Doctor registration
│   │   ├── RegisterPatient.vue      # Patient registration
│   │   ├── RegisterPharmacy.vue     # Pharmacy registration
│   │   └── RegisterRole.vue         # Role selection page
│   │
│   ├── App.vue                      # Root component
│   ├── main.js                      # Application entry point
│   └── style.css                    # Global styles
│
├── .gitignore                       # Git ignore rules
├── .env.example                     # Environment variables template
├── index.html                       # HTML entry point
├── package.json                     # NPM dependencies
├── package-lock.json                # NPM lock file
├── vite.config.js                   # Vite configuration
├── mock-server.js                   # Mock API server (NEW)
├── DASHBOARD_README.md              # Dashboard documentation (NEW)
├── MOCK_SERVER_README.md            # Mock server guide (NEW)
├── FOLDER_STRUCTURE.md              # This file (NEW)
└── README.md                        # Project README
```

## New Files Created

### Dashboard Components (7 files)
1. `src/components/dashboard/Sidebar.vue` - Navigation sidebar with menu and theme toggle
2. `src/components/dashboard/TopNavbar.vue` - Top navigation with user profile
3. `src/components/dashboard/StatsCard.vue` - Reusable statistics card
4. `src/components/dashboard/AppointmentCard.vue` - Next appointment display
5. `src/components/dashboard/MedicalRecordItem.vue` - Medical record list item
6. `src/components/dashboard/HealthOverview.vue` - Health information card
7. `src/components/dashboard/ActivityTimeline.vue` - Activity feed timeline

### Views (1 file)
8. `src/views/Dashboard.vue` - Main dashboard page with data fetching

### Services (1 file)
9. `src/services/api.js` - API service layer for dashboard

### Configuration & Documentation (5 files)
10. `.env.example` - Environment variables template
11. `mock-server.js` - Mock API server for development
12. `DASHBOARD_README.md` - Comprehensive dashboard documentation
13. `MOCK_SERVER_README.md` - Mock server setup guide
14. `FOLDER_STRUCTURE.md` - This file

### Modified Files (1 file)
15. `src/router/index.js` - Added dashboard route

## Component Hierarchy

```
Dashboard.vue (Main Page)
├── Sidebar.vue
│   └── Theme Toggle
│
├── TopNavbar.vue
│   ├── User Profile
│   └── Notifications
│
└── Main Content
    ├── Welcome Section
    ├── Book Appointment Banner
    ├── Stats Row
    │   ├── StatsCard (Appointments)
    │   ├── StatsCard (Prescriptions)
    │   ├── StatsCard (Tests)
    │   └── Need Help Card
    │
    ├── Content Grid
    │   ├── Left Column (2/3)
    │   │   ├── AppointmentCard
    │   │   └── Recent Medical Records
    │   │       └── MedicalRecordItem (multiple)
    │   │
    │   └── Right Column (1/3)
    │       ├── HealthOverview
    │       └── ActivityTimeline
```

## Data Flow

```
Dashboard.vue
    ↓
fetchDashboardData()
    ↓
dashboardAPI.getDashboardData()
    ↓
API Request → /api/dashboard
    ↓
Response → dashboardData (reactive ref)
    ↓
Props passed to child components
    ↓
Components render with user-specific data
```

## Key Features by Component

### Sidebar.vue
- Logo and branding
- Search functionality
- Navigation menu
- Active state highlighting
- Light/Dark mode toggle

### TopNavbar.vue
- Page title
- Last viewed timestamp
- Share button
- Notification bell with badge count
- User profile with avatar and dropdown

### StatsCard.vue
- Dynamic icon based on type
- Color-coded backgrounds
- Numeric value display
- Label text

### AppointmentCard.vue
- Doctor information with avatar
- Appointment details (time, location)
- Status badge (Confirmed/Pending/Cancelled)
- Action buttons (View Details, Reschedule)

### MedicalRecordItem.vue
- Record type icon
- Title and metadata
- Doctor and date information
- Status badge

### HealthOverview.vue
- Blood type display
- Allergies information
- Chronic conditions
- Primary doctor card

### ActivityTimeline.vue
- Chronological activity list
- Color-coded indicators
- Timestamps
- Visual timeline connector

## Styling Approach

### Color Scheme
- Primary: Teal/Green (`teal-500`, `teal-600`)
- Secondary: Gray scale
- Accent colors: Blue, Orange, Purple (for icons and badges)

### Layout
- Fixed sidebar (64 units width)
- Main content with left margin
- Responsive grid system
- Card-based design with shadows

### Typography
- Font weights: 400 (normal), 500 (medium), 600 (semibold), 700 (bold)
- Text sizes: xs, sm, base, lg, xl, 2xl
- Color hierarchy: gray-800 (primary), gray-600 (secondary), gray-500 (tertiary)

## State Management

### Dashboard.vue State
```javascript
dashboardData    // ref(null) - Main data object
loading          // ref(true) - Loading state
error            // ref(null) - Error message
formattedActivities // computed - Processed activity data
```

### Component Props
All child components receive data via props (no global state management needed)

## API Integration Points

1. Dashboard data: `GET /api/dashboard`
2. Book appointment: `POST /api/appointments`
3. Future endpoints can be added to `src/services/api.js`

## Development Workflow

1. Start mock server: `node mock-server.js`
2. Start dev server: `npm run dev`
3. Access dashboard: `http://localhost:5173/dashboard`
4. Make changes to components
5. Hot reload updates automatically

## Production Considerations

- Replace mock API with real backend
- Add authentication/authorization
- Implement proper error handling
- Add loading states for all async operations
- Optimize images and assets
- Add analytics tracking
- Implement proper logging
- Add unit and integration tests
