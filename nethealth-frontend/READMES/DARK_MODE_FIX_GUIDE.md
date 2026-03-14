# Dark Mode Fix Guide

## Issue
The notification bell icons and username text in the navbar don't adapt to dark mode on several pages.

## Pages That Need Fixing

The following pages need their navbar elements updated for proper dark mode support:

1. ✅ Appointments.vue - FIXED
2. ✅ Notifications.vue - FIXED  
3. ✅ Profile.vue - FIXED
4. ✅ VisitHistory.vue - FIXED
5. ❌ TestResults.vue - NEEDS FIX
6. ❌ TestResultDetails.vue - NEEDS FIX
7. ❌ MedicalRecords.vue - NEEDS FIX
8. ❌ PrescriptionDetails.vue - NEEDS FIX
9. ❌ ImagingRecords.vue - NEEDS FIX
10. ❌ ImagingDetail.vue - NEEDS FIX
11. ❌ CreateAppointment.vue - NEEDS FIX
12. ❌ DoctorProfile.vue - NEEDS FIX

## Fix Required

For each page listed above, replace the notification bell and username sections in the navbar.

### Find This (Notification Bell):
```vue
<!-- Notification Bell -->
<button class="relative p-2 hover:bg-gray-100 rounded-lg transition-colors">
  <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
```

### Replace With:
```vue
<!-- Notification Bell -->
<button :class="isDark ? 'hover:bg-[#1E293B]' : 'hover:bg-gray-100'" class="relative p-2 rounded-lg transition-colors">
  <svg :class="isDark ? 'text-[#94A3B8]' : 'text-gray-600'" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
```

### Find This (Username):
```vue
<span class="text-xs text-gray-500">@y7ia007</span>
```

### Replace With:
```vue
<span :class="isDark ? 'text-[#94A3B8]' : 'text-gray-500'" class="text-xs">@y7ia007</span>
```

## Automated Fix Commands

Run these commands one by one to fix all pages:

### 1. Fix TestResults.vue
```bash
# Close the file in your editor first, then run this command
```

### 2. Fix TestResultDetails.vue
```bash
# Close the file in your editor first, then run this command
```

### 3. Fix MedicalRecords.vue
```bash
# Close the file in your editor first, then run this command
```

### 4. Fix PrescriptionDetails.vue
```bash
# Close the file in your editor first, then run this command
```

### 5. Fix ImagingRecords.vue
```bash
# Close the file in your editor first, then run this command
```

### 6. Fix ImagingDetail.vue
```bash
# Close the file in your editor first, then run this command
```

### 7. Fix CreateAppointment.vue
```bash
# Close the file in your editor first, then run this command
```

### 8. Fix DoctorProfile.vue
```bash
# Close the file in your editor first, then run this command
```

## Manual Fix Steps

If automated commands don't work:

1. Open each file listed above
2. Find the notification bell button (around line 33-37)
3. Replace the button class with: `:class="isDark ? 'hover:bg-[#1E293B]' : 'hover:bg-gray-100'"`
4. Replace the SVG class with: `:class="isDark ? 'text-[#94A3B8]' : 'text-gray-600'"`
5. Find the username span (around line 49)
6. Replace with: `:class="isDark ? 'text-[#94A3B8]' : 'text-gray-500'"`
7. Save the file

## Verification

After fixing all files:

1. Start the development server
2. Navigate to each page
3. Toggle between light and dark mode using the sidebar toggle
4. Verify that:
   - Notification bell icon changes color
   - Username text changes color
   - All elements are visible in both modes

## Expected Result

After applying all fixes:
- ✅ All navbar elements adapt to dark mode
- ✅ Notification bell icon is visible in both modes
- ✅ Username text is readable in both modes
- ✅ Smooth transitions between themes
- ✅ Consistent styling across all pages

## Quick Test

```javascript
// In browser console, test theme toggle:
localStorage.setItem('theme', 'dark')
location.reload()

// Then test light mode:
localStorage.setItem('theme', 'light')
location.reload()
```
