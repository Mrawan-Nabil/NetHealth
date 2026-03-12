# Interactive Dashboard - Quick Reference

## 🚀 Quick Start

```bash
# Install dependencies
npm install

# Start mock API server
node mock-server.js

# Start development server (in another terminal)
npm run dev

# Open browser
http://localhost:5173/dashboard
```

## 📁 Key Files

### Main Dashboard
- `src/views/DashboardInteractive.vue` - Main interactive dashboard

### Interactive Components
- `src/components/dashboard/AppointmentDetailsModal.vue`
- `src/components/dashboard/RescheduleModal.vue`
- `src/components/dashboard/ChatWidget.vue`
- `src/components/dashboard/NotificationDropdown.vue`
- `src/components/dashboard/UserDropdown.vue`

### Updated Components
- `src/components/dashboard/Sidebar.vue`
- `src/components/dashboard/TopNavbar.vue`
- `src/components/dashboard/StatsCard.vue`
- `src/components/dashboard/AppointmentCard.vue`
- `src/components/dashboard/MedicalRecordItem.vue`
- `src/components/dashboard/HealthOverview.vue`
- `src/components/dashboard/ActivityTimeline.vue`

## 🎯 Interactive Features

### 1. Dark Mode
**Location**: Sidebar bottom  
**Action**: Click "Light" or "Dark" button  
**Persistence**: Saved to localStorage  

### 2. Appointment Details Modal
**Trigger**: Click "View Details" on appointment card  
**Features**: Full appointment info, reschedule, cancel  
**Close**: Click X, click outside, or ESC key  

### 3. Reschedule Modal
**Trigger**: Click "Reschedule" button  
**Features**: Date picker, time slots, reason  
**Validation**: Requires date and time  

### 4. Chat Widget
**Trigger**: Click "Ask Now" in Need Help card  
**Features**: Real-time chat, quick actions, typing indicator  
**Position**: Fixed bottom-right  

### 5. Notification Dropdown
**Trigger**: Click notification bell  
**Features**: Unread badge, mark as read, navigate  
**Close**: Click outside  

### 6. User Dropdown
**Trigger**: Click user profile  
**Features**: Profile, Settings, Help, Logout  
**Close**: Click outside  

## 🔄 State Management

### Reactive State
```javascript
const dashboardData = ref(null)           // Main data
const loading = ref(true)                 // Loading state
const error = ref(null)                   // Error state
const isDark = ref(false)                 // Theme
const notifications = ref([])             // Notifications
const showAppointmentDetails = ref(false) // Modal state
const showRescheduleModal = ref(false)    // Modal state
const showChatWidget = ref(false)         // Widget state
const selectedAppointment = ref(null)     // Selected item
```

### Key Methods
```javascript
fetchDashboardData()          // Fetch from API
toggleTheme(theme)            // Switch theme
handleBookAppointment()       // Navigate to create
openAppointmentDetails(apt)   // Open details modal
openRescheduleModal(apt)      // Open reschedule modal
openChatWidget()              // Open chat
markNotificationAsRead(id)    // Mark notification
handleLogout()                // Logout with confirm
```

## 🎨 Component Props

### Sidebar
```vue
<Sidebar 
  :is-dark="isDark"
  @toggle-theme="toggleTheme"
  @logout="handleLogout"
/>
```

### TopNavbar
```vue
<TopNavbar 
  :user="user"
  :notifications="notifications"
  :is-dark="isDark"
  @mark-read="markNotificationAsRead"
  @mark-all-read="markAllNotificationsAsRead"
  @notification-click="handleNotificationClick"
  @logout="handleLogout"
/>
```

### StatsCard
```vue
<StatsCard 
  :value="3"
  label="Upcoming Appointments"
  icon="calendar"
  :is-dark="isDark"
  @click="handleStatsClick"
/>
```

### AppointmentCard
```vue
<AppointmentCard 
  :appointment="appointment"
  :is-dark="isDark"
  @view-details="openAppointmentDetails"
  @reschedule="openRescheduleModal"
/>
```

## 🛣️ Routes

```javascript
/                        → Home (landing page)
/dashboard               → Interactive Dashboard
/profile                 → User Profile
/medical-records         → Medical Records
/appointments            → Appointments List
/appointments/create     → Book New Appointment
/notifications           → All Notifications
/login                   → Login Page
```

## 🎭 Animations

### Hover Effects
```css
hover:scale-[1.02]       /* Scale up slightly */
hover:shadow-md          /* Increase shadow */
hover:bg-gray-50         /* Background change */
```

### Click Effects
```css
active:scale-[0.98]      /* Press down effect */
```

### Transitions
```css
transition-all duration-200   /* Smooth transitions */
transition-colors duration-200 /* Color transitions */
```

## 🎨 Dark Mode Classes

### Background
```css
isDark ? 'bg-gray-900' : 'bg-gray-50'      /* Page background */
isDark ? 'bg-gray-800' : 'bg-white'        /* Card background */
isDark ? 'bg-gray-700' : 'bg-gray-100'     /* Secondary background */
```

### Text
```css
isDark ? 'text-white' : 'text-gray-800'    /* Primary text */
isDark ? 'text-gray-400' : 'text-gray-600' /* Secondary text */
isDark ? 'text-gray-500' : 'text-gray-500' /* Tertiary text */
```

### Borders
```css
isDark ? 'border-gray-700' : 'border-gray-200'
```

## 🔔 Event Flow

### Appointment Details
```
User clicks "View Details"
  ↓
@view-details event emitted
  ↓
openAppointmentDetails(appointment)
  ↓
selectedAppointment.value = appointment
showAppointmentDetails.value = true
  ↓
Modal renders
```

### Reschedule
```
User clicks "Reschedule"
  ↓
@reschedule event emitted
  ↓
openRescheduleModal(appointment)
  ↓
selectedAppointment.value = appointment
showRescheduleModal.value = true
  ↓
Modal renders
  ↓
User selects date/time
  ↓
@confirm event emitted
  ↓
handleRescheduleConfirm(data)
  ↓
API call (simulated)
  ↓
fetchDashboardData()
  ↓
UI updates
```

### Theme Toggle
```
User clicks "Dark"
  ↓
@toggle-theme event emitted
  ↓
toggleTheme('dark')
  ↓
isDark.value = true
localStorage.setItem('theme', 'dark')
  ↓
All components re-render with dark classes
```

## 🧪 Testing Checklist

- [ ] Dark mode toggle works
- [ ] Theme persists on refresh
- [ ] Appointment details modal opens
- [ ] Reschedule modal opens
- [ ] Date picker works (min date: today)
- [ ] Time slots are selectable
- [ ] Chat widget opens and responds
- [ ] Notification dropdown opens
- [ ] Mark as read works
- [ ] User dropdown opens
- [ ] Logout shows confirmation
- [ ] Navigation works (all routes)
- [ ] Active state highlights current page
- [ ] Stats cards navigate on click
- [ ] Book Now navigates to create
- [ ] Hover effects work
- [ ] Click effects work
- [ ] Loading skeleton shows
- [ ] Error state shows with retry
- [ ] Click outside closes dropdowns

## 🐛 Common Issues

### Modal not closing
- Check `@close` event is emitted
- Verify click outside handler

### Theme not persisting
- Check localStorage in DevTools
- Verify `onMounted` loads theme

### Navigation not working
- Check route paths match exactly
- Verify Vue Router is configured

### Dropdown stays open
- Check click outside handler
- Verify event listeners are added/removed

## 📚 Documentation Files

- `INTERACTIVE_FEATURES.md` - Complete feature documentation
- `INTERACTIVE_IMPLEMENTATION_SUMMARY.md` - Implementation summary
- `DASHBOARD_README.md` - Original dashboard guide
- `FOLDER_STRUCTURE.md` - Project structure
- `QUICKSTART.md` - Original quick start
- `QUICK_REFERENCE.md` - This file

## 🎉 Summary

The dashboard is fully interactive with:
- ✅ Dark mode with persistence
- ✅ 3 modals (details, reschedule, chat)
- ✅ 2 dropdowns (notifications, user)
- ✅ Vue Router navigation
- ✅ Reactive state management
- ✅ Smooth animations
- ✅ Loading and error states
- ✅ Event-driven architecture
- ✅ Real SaaS application feel

**Ready for production with real API integration!**
