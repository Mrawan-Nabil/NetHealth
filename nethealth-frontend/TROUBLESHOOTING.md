# Dashboard Troubleshooting Guide

## Issues Fixed

✅ **Router Configuration** - Fixed scrollBehavior placement  
✅ **Sidebar Logout** - Changed from router-link to button  
✅ **Path Validation** - Fixed isActive function  

## Current Status

The dashboard should now work correctly. All syntax errors have been fixed.

## How to Start

```bash
# Terminal 1 (optional - for mock API)
node mock-server.js

# Terminal 2
npm run dev

# Browser
http://localhost:5173/dashboard
```

## Common Issues & Solutions

### 1. Blank Page / White Screen

**Symptoms**: Dashboard shows nothing, blank white page

**Solutions**:
```bash
# Clear browser cache
Ctrl + Shift + Delete (Chrome/Edge)
Cmd + Shift + Delete (Mac)

# Hard refresh
Ctrl + Shift + R (Windows)
Cmd + Shift + R (Mac)

# Check correct URL
http://localhost:5173/dashboard  ✅
http://localhost:5173/           ❌ (this is the landing page)
```

### 2. Module Not Found Errors

**Symptoms**: Console shows "Cannot find module" or "Failed to resolve import"

**Solutions**:
```bash
# Reinstall dependencies
npm install

# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm install

# Check if Vue Router is installed
npm list vue-router
```

### 3. Router Errors

**Symptoms**: "Cannot read property 'path' of undefined" or router warnings

**Solution**: The router has been fixed. Restart dev server:
```bash
# Stop server (Ctrl+C)
# Start again
npm run dev
```

### 4. Component Not Rendering

**Symptoms**: Parts of dashboard missing, components not showing

**Check**:
1. Open browser console (F12)
2. Look for red errors
3. Check Network tab for failed requests

**Solutions**:
```bash
# Verify files exist
ls src/views/DashboardInteractive.vue
ls src/components/dashboard/Sidebar.vue
ls src/components/dashboard/TopNavbar.vue

# Check for syntax errors
npm run build
```

### 5. Dark Mode Not Working

**Symptoms**: Theme toggle doesn't work or doesn't persist

**Solutions**:
- Check if localStorage is enabled in browser
- Try in incognito/private mode
- Clear localStorage: Open console and run `localStorage.clear()`

### 6. Modals Not Opening

**Symptoms**: Click buttons but modals don't appear

**Check**:
- Open browser console for errors
- Check if Teleport is supported (modern browsers only)

**Solution**: Make sure you're using a modern browser (Chrome 90+, Firefox 88+, Safari 14+)

### 7. Navigation Not Working

**Symptoms**: Clicking sidebar items doesn't navigate

**Check**:
- Browser console for router errors
- Make sure you're on `/dashboard` page

**Solution**: Router has been fixed. Restart dev server.

### 8. API Errors

**Symptoms**: "Failed to fetch" or network errors

**This is normal!** The dashboard falls back to dummy data automatically.

**To use mock API**:
```bash
# Terminal 1
node mock-server.js

# Terminal 2
npm run dev
```

### 9. Port Already in Use

**Symptoms**: "Port 5173 is already in use"

**Solutions**:
```bash
# Option 1: Kill the process
npx kill-port 5173

# Option 2: Use different port
npm run dev -- --port 3000

# Option 3: Find and kill manually (Windows)
netstat -ano | findstr :5173
taskkill /PID <PID> /F

# Option 3: Find and kill manually (Mac/Linux)
lsof -ti:5173 | xargs kill -9
```

### 10. Styling Issues

**Symptoms**: Components look broken, no colors, wrong layout

**Solutions**:
```bash
# Check if Tailwind is configured
cat vite.config.js

# Should see:
# import tailwindcss from '@tailwindcss/vite'
# plugins: [vue(), tailwindcss()]

# Restart dev server
npm run dev
```

## Diagnostic Commands

Run these to check your setup:

```bash
# 1. Check Node version (should be 16+)
node --version

# 2. Check npm version
npm --version

# 3. Check if dependencies are installed
npm list vue vue-router

# 4. Check if files exist
ls src/views/DashboardInteractive.vue
ls src/components/dashboard/

# 5. Check for syntax errors
npm run build

# 6. Check router configuration
cat src/router/index.js | grep -A 3 "dashboard"
```

## Browser Console Checks

Open DevTools (F12) and check:

### Console Tab
- ✅ No red errors
- ✅ No warnings about missing modules
- ✅ No router errors

### Network Tab
- ✅ All JS files load successfully (200 status)
- ⚠️ API calls may fail (404) - this is OK, dummy data is used

### Vue DevTools
- ✅ Components tree shows all components
- ✅ Router shows current route
- ✅ No errors in component rendering

## Expected Behavior

### On Page Load
1. Loading skeleton appears briefly
2. Dashboard content loads
3. All sections render:
   - Sidebar
   - Top navbar
   - Welcome section
   - Book appointment banner
   - Stats cards
   - Appointment card
   - Medical records
   - Health overview
   - Activity timeline

### On Interaction
1. Hover effects work (scale, shadow)
2. Click effects work (scale down)
3. Modals open smoothly
4. Dropdowns toggle
5. Navigation changes pages
6. Dark mode toggles theme

## Still Not Working?

### Step 1: Check Browser
- Use Chrome, Firefox, or Edge (latest version)
- Disable browser extensions
- Try incognito/private mode

### Step 2: Clean Install
```bash
# Remove everything
rm -rf node_modules package-lock.json

# Reinstall
npm install

# Start fresh
npm run dev
```

### Step 3: Check File Integrity
```bash
# Verify key files exist and have content
cat src/views/DashboardInteractive.vue | head -20
cat src/components/dashboard/Sidebar.vue | head -20
cat src/router/index.js | head -20
```

### Step 4: Check for Conflicts
```bash
# Make sure no other dev server is running
ps aux | grep node

# Kill all node processes (careful!)
pkill node

# Start again
npm run dev
```

## Get More Information

If you're still having issues, provide:

1. **Error message** from browser console
2. **Node version**: `node --version`
3. **npm version**: `npm --version`
4. **Operating system**: Windows/Mac/Linux
5. **Browser**: Chrome/Firefox/Safari/Edge
6. **What you see**: Screenshot or description
7. **What you expect**: What should happen

## Quick Test

Run this to verify everything:

```bash
# 1. Check files
ls src/views/DashboardInteractive.vue && echo "✅ Dashboard file exists"

# 2. Check dependencies
npm list vue vue-router && echo "✅ Dependencies installed"

# 3. Start server
npm run dev
```

Then open `http://localhost:5173/dashboard` in your browser.

## Success Indicators

When working correctly, you should see:

✅ Dev server starts without errors  
✅ Browser shows dashboard at `/dashboard`  
✅ All components render  
✅ No red errors in console  
✅ Can interact with elements  
✅ Dark mode works  
✅ Navigation works  
✅ Modals open  
✅ Dropdowns work  

If you see all of these, the dashboard is working perfectly! 🎉

## Additional Resources

- `start-dashboard.md` - Quick start guide
- `TEST_DASHBOARD.md` - Testing checklist
- `INTERACTIVE_FEATURES.md` - Feature documentation
- `QUICK_REFERENCE.md` - Quick reference

The dashboard has been fixed and should work now!
