# TopNavbar Updates - Remaining Pages

## ✅ Completed
1. DashboardInteractive.vue
2. CreateAppointment.vue
3. DoctorProfile.vue
4. PrescriptionDetails.vue
5. TestResultDetails.vue
6. ImagingDetail.vue
7. Appointments.vue
8. NotificationDropdown.vue - "View all notifications" now links to /notifications

## 🔄 Remaining Pages to Update

### 1. Notifications.vue
**Import to add:**
```javascript
import TopNavbar from '../components/dashboard/TopNavbar.vue'
```

**Replace navbar with:**
```vue
<TopNavbar 
  title="Notifications"
  :is-dark="isDark"
  :user="{ name: 'Ahmed Yahia', username: '@y7ia007', avatar: 'https://i.pravatar.cc/150?img=12' }"
  :notifications="[]"
  :show-last-viewed="false"
  :show-share="false"
  @logout="handleLogout"
/>
```

### 2. Profile.vue
**Import to add:**
```javascript
import TopNavbar from '../components/dashboard/TopNavbar.vue'
```

**Replace navbar with:**
```vue
<TopNavbar 
  title="Profile"
  :is-dark="isDark"
  :user="{ name: profileData.name, username: '@y7ia007', avatar: profileData.avatar }"
  :notifications="[]"
  :show-last-viewed="false"
  :show-share="false"
  @logout="handleLogout"
/>
```

### 3. VisitHistory.vue
**Import to add:**
```javascript
import TopNavbar from '../components/dashboard/TopNavbar.vue'
```

**Replace navbar with:**
```vue
<TopNavbar 
  title="Visit History"
  :is-dark="isDark"
  :user="{ name: 'Ahmed Yahia', username: '@y7ia007', avatar: 'https://i.pravatar.cc/150?img=12' }"
  :notifications="[]"
  :show-last-viewed="true"
  :show-share="true"
  @logout="handleLogout"
/>
```

### 4. TestResults.vue
**Import to add:**
```javascript
import TopNavbar from '../components/dashboard/TopNavbar.vue'
```

**Replace navbar with:**
```vue
<TopNavbar 
  title="Test Results"
  :is-dark="isDark"
  :user="{ name: 'Ahmed Yahia', username: '@y7ia007', avatar: 'https://i.pravatar.cc/150?img=12' }"
  :notifications="[]"
  :show-last-viewed="true"
  :show-share="true"
  @logout="handleLogout"
/>
```

### 5. MedicalRecords.vue
**Import to add:**
```javascript
import TopNavbar from '../components/dashboard/TopNavbar.vue'
```

**Replace navbar with:**
```vue
<TopNavbar 
  title="Medical Records"
  :is-dark="isDark"
  :user="{ name: 'Ahmed Yahia', username: '@y7ia007', avatar: 'https://i.pravatar.cc/150?img=12' }"
  :notifications="[]"
  :show-last-viewed="true"
  :show-share="true"
  @logout="handleLogout"
/>
```

### 6. ImagingRecords.vue
**Import to add:**
```javascript
import TopNavbar from '../components/dashboard/TopNavbar.vue'
```

**Replace navbar with:**
```vue
<TopNavbar 
  title="Imaging Records"
  :is-dark="isDark"
  :user="{ name: 'Ahmed Yahia', username: '@y7ia007', avatar: 'https://i.pravatar.cc/150?img=12' }"
  :notifications="[]"
  :show-last-viewed="true"
  :show-share="true"
  @logout="handleLogout"
/>
```

## Summary

### What to Replace
Find this pattern in each file:
```vue
<nav :class="isDark ? 'bg-[#111827] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="px-8 py-4 flex items-center justify-between border-b transition-all duration-300 shadow-sm">
  <!-- ... 40+ lines of navbar HTML ... -->
</nav>
```

Replace with:
```vue
<TopNavbar 
  title="[Page Title]"
  :is-dark="isDark"
  :user="{ name: 'Ahmed Yahia', username: '@y7ia007', avatar: 'https://i.pravatar.cc/150?img=12' }"
  :notifications="[]"
  :show-last-viewed="true"
  :show-share="true"
  @logout="handleLogout"
/>
```

## Benefits
- ✅ Consistent navbar across all pages
- ✅ Dynamic page titles
- ✅ Full dark mode support
- ✅ Working notification dropdown with link to notifications page
- ✅ Easy to maintain
- ✅ Reduced code duplication

## Status
- 8/14 pages completed
- 6/14 pages remaining
- NotificationDropdown updated with router link
