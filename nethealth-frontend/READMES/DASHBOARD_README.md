# NetHealth Dashboard - Implementation Guide

## Overview
Modern responsive medical dashboard UI built with Vue 3 (Composition API) and Tailwind CSS. The dashboard displays user-specific health data fetched from an API endpoint.

## Project Structure

```
src/
├── components/
│   └── dashboard/
│       ├── Sidebar.vue              # Left sidebar with navigation
│       ├── TopNavbar.vue            # Top navigation bar
│       ├── StatsCard.vue            # Statistics display cards
│       ├── AppointmentCard.vue      # Next appointment card
│       ├── MedicalRecordItem.vue    # Medical record list item
│       ├── HealthOverview.vue       # Health information card
│       └── ActivityTimeline.vue     # Recent activity timeline
├── views/
│   └── Dashboard.vue                # Main dashboard page
├── services/
│   └── api.js                       # API service layer
└── router/
    └── index.js                     # Router configuration
```

## Features

### 1. Sidebar Navigation
- NetHealth logo
- Search input
- Navigation menu (Home, Profile, Medical Record, Appointments, Notification, Logout)
- Light/Dark mode toggle

### 2. Top Navbar
- Page title
- Last viewed timestamp
- Share button
- Notification bell with badge
- User profile dropdown

### 3. Welcome Section
- Personalized greeting with user name
- Health overview subtitle

### 4. Book Appointment Banner
- Call-to-action card with gradient background
- Features: Available 24/7, Verified Doctors
- Book Now button

### 5. Statistics Cards
- Upcoming Appointments count
- Latest Prescription count
- Pending Test Results count
- Need Help AI assistant card

### 6. Next Appointment Card
- Doctor information with avatar
- Appointment time and location
- Status badge (Confirmed/Pending/Cancelled)
- View Details and Reschedule buttons

### 7. Recent Medical Records
- List of recent records with icons
- Status badges
- Doctor and date information

### 8. Health Overview
- Blood Type
- Allergies
- Chronic Conditions
- Primary Doctor information

### 9. Recent Activity Timeline
- Activity feed with color-coded indicators
- Timestamps for each activity

## API Integration

### Endpoint
```
GET /api/dashboard
```

### Expected Response Format
```json
{
  "user": {
    "name": "Ahmed Yahia",
    "username": "@y7ia007",
    "avatar": "/avatar.jpg"
  },
  "stats": {
    "appointments": 3,
    "prescriptions": 1,
    "pending_tests": 2
  },
  "nextAppointment": {
    "doctor": "Dr. Sarah Johnson",
    "specialty": "Cardiologist",
    "time": "Tomorrow, 2:30 PM",
    "location": "City Medical Center",
    "status": "Confirmed",
    "avatar": "/doctor-avatar.jpg"
  },
  "healthOverview": {
    "bloodType": "A+",
    "allergies": "Penicillin",
    "conditions": "Hypertension",
    "primaryDoctor": "Dr. Sarah Johnson",
    "primaryDoctorSpecialty": "Cardiologist",
    "primaryDoctorAvatar": "/doctor-avatar.jpg"
  },
  "recentRecords": [
    {
      "title": "Latest Prescription",
      "doctor": "Dr. Michael Chen",
      "date": "Jan 20, 2025",
      "status": "Active"
    },
    {
      "title": "Blood Test Results",
      "doctor": "Lab Services",
      "date": "Jan 18, 2025",
      "status": "Available"
    },
    {
      "title": "Visit Summary",
      "doctor": "Dr. Sarah Johnson",
      "date": "Jan 15, 2025",
      "status": "Completed"
    }
  ],
  "activity": [
    "Appointment confirmed",
    "Test result uploaded",
    "Prescription updated"
  ]
}
```

## Setup Instructions

### 1. Environment Variables
Create a `.env` file in the project root:

```env
VITE_API_BASE_URL=http://localhost:3000
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Run Development Server
```bash
npm run dev
```

### 4. Access Dashboard
Navigate to: `http://localhost:5173/dashboard`

## Component Usage

### Using Dashboard Components

```vue
<template>
  <Dashboard />
</template>

<script setup>
import Dashboard from '@/views/Dashboard.vue'
</script>
```

### Using Individual Components

```vue
<template>
  <StatsCard 
    :value="3" 
    label="Upcoming Appointments"
    icon="calendar"
  />
</template>

<script setup>
import StatsCard from '@/components/dashboard/StatsCard.vue'
</script>
```

## Customization

### Colors
The dashboard uses a teal/green theme. To customize:

1. Update Tailwind colors in `tailwind.config.js`
2. Modify gradient classes in components (e.g., `from-teal-500 to-teal-600`)

### API Endpoint
Update the API base URL in `.env` or `src/services/api.js`

### Dummy Data
The dashboard includes fallback dummy data for development. To disable:

```javascript
// In Dashboard.vue, remove the fallback in catch block
catch (err) {
  console.error('Error fetching dashboard data:', err)
  error.value = err.message
  // Remove this line to disable dummy data:
  // dashboardData.value = getDummyData()
}
```

## Responsive Design

The dashboard is fully responsive:
- Desktop: Full layout with sidebar
- Tablet: Adjusted grid layouts
- Mobile: Stacked layout (requires additional media queries)

## Loading States

The dashboard includes:
- Loading skeleton while fetching data
- Error state with retry button
- Empty states for missing data

## Authentication

To add authentication:

1. Update `src/services/api.js` to include auth tokens
2. Add route guards in `src/router/index.js`
3. Implement login/logout functionality

Example route guard:
```javascript
router.beforeEach((to, from, next) => {
  const isAuthenticated = checkAuth()
  if (to.name === 'Dashboard' && !isAuthenticated) {
    next({ name: 'Login' })
  } else {
    next()
  }
})
```

## Performance Optimization

- Components use `v-if` for conditional rendering
- Computed properties for derived data
- Lazy loading for route components
- Image optimization recommended for avatars

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## Troubleshooting

### API Connection Issues
- Check CORS settings on backend
- Verify API endpoint URL
- Check browser console for errors

### Styling Issues
- Ensure Tailwind CSS is properly configured
- Check for conflicting CSS
- Verify Tailwind classes are being purged correctly

### Component Not Rendering
- Check console for Vue warnings
- Verify all props are passed correctly
- Ensure components are properly imported

## Future Enhancements

- [ ] Dark mode implementation
- [ ] Real-time notifications
- [ ] Advanced filtering for medical records
- [ ] Export health data functionality
- [ ] Mobile app version
- [ ] Accessibility improvements (ARIA labels, keyboard navigation)

## License

MIT License - See LICENSE file for details
