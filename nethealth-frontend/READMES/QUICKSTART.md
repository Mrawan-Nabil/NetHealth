# NetHealth Dashboard - Quick Start Guide

## 🚀 Get Started in 3 Steps

### Step 1: Install Dependencies
```bash
npm install
```

### Step 2: Set Up Environment
```bash
# Copy the example environment file
cp .env.example .env

# The default configuration works out of the box
# VITE_API_BASE_URL=http://localhost:3000
```

### Step 3: Run the Application

#### Option A: With Mock API (Recommended for Testing)
```bash
# Terminal 1: Start mock API server
node mock-server.js

# Terminal 2: Start frontend
npm run dev
```

#### Option B: With Real API
```bash
# Update .env with your API URL
# VITE_API_BASE_URL=https://your-api.com

# Start frontend
npm run dev
```

### Access the Dashboard
Open your browser and navigate to:
```
http://localhost:5173/dashboard
```

## 📁 What Was Created

### Components (7 files)
- `Sidebar.vue` - Navigation sidebar
- `TopNavbar.vue` - Top navigation bar
- `StatsCard.vue` - Statistics cards
- `AppointmentCard.vue` - Appointment display
- `MedicalRecordItem.vue` - Medical records
- `HealthOverview.vue` - Health information
- `ActivityTimeline.vue` - Activity feed

### Pages (1 file)
- `Dashboard.vue` - Main dashboard page

### Services (1 file)
- `api.js` - API integration layer

### Configuration (4 files)
- `.env.example` - Environment template
- `mock-server.js` - Development API server
- Documentation files

## 🎨 Features Included

✅ Responsive layout with sidebar navigation  
✅ User-specific data from API  
✅ Statistics cards (appointments, prescriptions, tests)  
✅ Next appointment card with actions  
✅ Recent medical records list  
✅ Health overview panel  
✅ Activity timeline  
✅ Loading and error states  
✅ Light/Dark mode toggle  
✅ Notification system  

## 🔧 Customization

### Change Theme Colors
Edit Tailwind classes in components:
```vue
<!-- Change from teal to blue -->
<div class="bg-blue-500">  <!-- was: bg-teal-500 -->
```

### Modify API Endpoint
Update `.env`:
```env
VITE_API_BASE_URL=https://your-api-url.com
```

### Add New Components
```bash
# Create new component
touch src/components/dashboard/YourComponent.vue

# Import in Dashboard.vue
import YourComponent from '../components/dashboard/YourComponent.vue'
```

## 📊 API Response Format

Your backend should return this structure:

```json
{
  "user": {
    "name": "User Name",
    "username": "@username",
    "avatar": "/path/to/avatar.jpg"
  },
  "stats": {
    "appointments": 3,
    "prescriptions": 1,
    "pending_tests": 2
  },
  "nextAppointment": {
    "doctor": "Dr. Name",
    "specialty": "Specialty",
    "time": "Tomorrow, 2:30 PM",
    "location": "Location",
    "status": "Confirmed",
    "avatar": "/path/to/doctor-avatar.jpg"
  },
  "healthOverview": {
    "bloodType": "A+",
    "allergies": "None",
    "conditions": "None",
    "primaryDoctor": "Dr. Name"
  },
  "recentRecords": [
    {
      "title": "Record Title",
      "doctor": "Dr. Name",
      "date": "Jan 20, 2025",
      "status": "Active"
    }
  ],
  "activity": [
    "Activity 1",
    "Activity 2"
  ]
}
```

## 🐛 Troubleshooting

### Mock server not starting
```bash
# Install dependencies first
npm install express cors

# Then run
node mock-server.js
```

### Port already in use
```bash
# Change port in mock-server.js
const PORT = 3001  # Use different port

# Update .env
VITE_API_BASE_URL=http://localhost:3001
```

### Dashboard shows error
1. Check if mock server is running
2. Verify API URL in `.env`
3. Check browser console for errors
4. Dashboard will show dummy data as fallback

### Styling not working
```bash
# Ensure Tailwind is configured
# Check vite.config.js includes:
import tailwindcss from '@tailwindcss/vite'
```

## 📚 Documentation

- `DASHBOARD_README.md` - Complete dashboard documentation
- `MOCK_SERVER_README.md` - Mock API server guide
- `FOLDER_STRUCTURE.md` - Project structure overview

## 🔐 Adding Authentication

To add authentication to the dashboard:

1. Update `src/services/api.js`:
```javascript
headers: {
  'Authorization': `Bearer ${getAuthToken()}`
}
```

2. Add route guard in `src/router/index.js`:
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

## 🚢 Deployment

### Build for Production
```bash
npm run build
```

### Preview Production Build
```bash
npm run preview
```

### Deploy to Vercel/Netlify
```bash
# Vercel
vercel

# Netlify
netlify deploy --prod
```

## 💡 Next Steps

1. ✅ Dashboard is ready to use
2. Connect to your real API
3. Add authentication
4. Customize styling
5. Add more features as needed

## 🆘 Need Help?

- Check the documentation files
- Review component code for examples
- Test with mock server first
- Verify API response format matches expected structure

---

**Happy Coding! 🎉**
