# Medical Records / Prescription Page

## Overview
A complete Vue 3 implementation of the Medical Records dashboard with Prescription management, matching the provided screenshot design.

## Features

### ✅ Page Structure
- **Top Navbar**: Medical Record title with breadcrumb navigation
- **Tabs Navigation**: Prescription, Test Results, Imaging, Visit History
- **Prescription Cards Grid**: 2-column responsive layout
- **Dark Mode Support**: Elegant dark theme with smooth transitions
- **Responsive Design**: Mobile-friendly layout

### ✅ Components Created

#### 1. **TabsNavigation.vue** (`src/components/medical/TabsNavigation.vue`)
- Horizontal tabs with icons
- Active tab highlighting with teal color (#14B8A6)
- Bottom border indicator
- Smooth transitions

#### 2. **PrescriptionCard.vue** (`src/components/medical/PrescriptionCard.vue`)
- Doctor name and specialty
- Date issued and expiration date
- Status badge (Active/Expired)
- Diagnosis section
- Medicines list with expand/collapse
- Download and View Details buttons
- Hover animations
- Dark mode support

#### 3. **MedicalRecords.vue** (`src/views/MedicalRecords.vue`)
- Main page layout
- Sidebar integration
- Top navbar with user profile
- Breadcrumb navigation
- Tab switching functionality
- Loading and error states
- API integration ready

## Color Palette

### Light Mode
- Background: `#F8FAFC`
- Card Background: `#FFFFFF`
- Border: `#E5E7EB`
- Primary Text: `#111827`
- Secondary Text: `#6B7280`
- Accent (Teal): `#14B8A6`
- Active Badge: `bg-emerald-100 text-emerald-600`
- Expired Badge: `bg-gray-100 text-gray-500`

### Dark Mode
- Background: `#0F172A`
- Card Background: `#1E293B`
- Border: `#334155`
- Primary Text: `#F8FAFC`
- Secondary Text: `#94A3B8`
- Accent (Teal): `#14B8A6` with hover `#2DD4BF`

## API Integration

### Endpoint
```javascript
GET /api/prescriptions
```

### Response Format
```javascript
[
  {
    id: 1,
    doctor: "Dr. Sarah Mitchell",
    specialty: "Cardiology",
    date: "Feb 14, 2025",
    expires: "Aug 14, 2025",
    status: "active", // or "expired"
    diagnosis: "Stage 2 Hypertension with mild left ventricular hypertrophy...",
    medicines: [
      "Lisinopril 10mg — Once daily",
      "Amlodipine 5mg — Before bed",
      "Aspirin 81mg — Once daily"
    ]
  }
]
```

### Usage
The page currently uses dummy data. To connect to a real API:

1. Uncomment the API call in `MedicalRecords.vue`:
```javascript
const response = await axios.get('/api/prescriptions')
prescriptions.value = response.data
```

2. Configure your API base URL in `src/services/api.js`

## File Structure
```
src/
├── components/
│   └── medical/
│       ├── TabsNavigation.vue      # Tabs component
│       └── PrescriptionCard.vue    # Prescription card component
├── views/
│   └── MedicalRecords.vue          # Main page
└── router/
    └── index.js                     # Route: /medical-records
```

## Usage

### Navigate to Medical Records
```javascript
// From any component
router.push('/medical-records')

// Or use router-link
<router-link to="/medical-records">Medical Records</router-link>
```

### Access from Sidebar
The "Medical Record" menu item in the sidebar already links to this page.

## Features Implemented

### ✅ Prescription Cards
- Doctor information display
- Status badges (Active/Expired)
- Diagnosis section
- Medicines list with expand/collapse
- Download button (outline style)
- View Details button (primary teal)
- Hover animations

### ✅ Tabs Navigation
- 4 tabs: Prescription, Test Results, Imaging, Visit History
- Active tab indicator (teal underline)
- Icon support for each tab
- Smooth transitions

### ✅ Responsive Design
- 2-column grid on desktop
- 1-column on mobile
- Proper spacing and padding
- Mobile-friendly buttons

### ✅ Dark Mode
- Elegant dark theme
- Smooth transitions (300ms)
- Proper contrast ratios
- Glowing effects on interactive elements

### ✅ Loading & Error States
- Skeleton loaders while fetching
- Error message with retry button
- Graceful fallback to dummy data

## Customization

### Change Active Tab Color
Edit `TabsNavigation.vue`:
```javascript
activeTab === tab.id
  ? 'border-[#14B8A6] text-[#14B8A6]'  // Change these colors
  : 'border-transparent text-[#6B7280]'
```

### Modify Card Layout
Edit `PrescriptionCard.vue` padding and spacing:
```html
<div class="rounded-lg p-6 space-y-4">  <!-- Adjust p-6 and space-y-4 -->
```

### Add More Tabs
Edit `tabs` array in `TabsNavigation.vue`:
```javascript
const tabs = [
  // ... existing tabs
  {
    id: 'new-tab',
    label: 'New Tab',
    icon: { template: `<svg>...</svg>` }
  }
]
```

## Testing

### Test with Dummy Data
The page works out of the box with dummy data. Just navigate to `/medical-records`.

### Test API Integration
1. Start your backend server
2. Update API endpoint in the fetch function
3. Verify response format matches expected structure

## Browser Support
- Chrome/Edge (latest)
- Firefox (latest)
- Safari (latest)
- Mobile browsers

## Dependencies
- Vue 3
- Vue Router
- Axios
- Tailwind CSS

## Notes
- All components use Vue 3 Composition API
- Smooth transitions on all interactive elements
- Accessible keyboard navigation
- Semantic HTML structure
- Optimized for performance
