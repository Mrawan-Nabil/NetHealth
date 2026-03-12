# Start Dashboard - Quick Guide

## What I Fixed

The dashboard wasn't working due to:
1. **Router configuration error** - `scrollBehavior` was inside the auth route instead of router config
2. **Logout button issue** - Using router-link with '#' path caused errors
3. **Path validation** - isActive function needed to handle empty paths

All issues are now fixed! ✅

## Start the Dashboard

### Option 1: With Mock API (Recommended)

**Terminal 1 - Start Mock API:**
```bash
node mock-server.js
```

**Terminal 2 - Start Frontend:**
```bash
npm run dev
```

**Browser:**
```
http://localhost:5173/dashboard
```

### Option 2: Without Mock API (Uses Dummy Data)

**Terminal:**
```bash
npm run dev
```

**Browser:**
```
http://localhost:5173/dashboard
```

The dashboard will automatically fall back to dummy data if the API is not available.

## What You Should See

When you open `http://localhost:5173/dashboard`, you'll see:

1. **Sidebar (Left)**
   - NetHealth logo
   - Search bar
   - Navigation menu (Home, Profile, Medical Record, Appointments, Notification, Logout)
   - Light/Dark theme toggle at bottom

2. **Top Bar**
   - "Home" title
   - "Last viewed 10 mins ago"
   - Share button
   - Notification bell with badge
   - User profile with dropdown

3. **Main Content**
   - Welcome message: "Welcome back, Ahmed 👋"
   - Green "Book a New Appointment" banner
   - 4 cards: 3 stats + 1 "Need Help?" card
   - Next appointment card with doctor info
   - Recent medical records list
   - Health overview panel (right side)
   - Recent activity timeline (right side)

## Test Interactive Features

### 1. Dark Mode
- Click "Dark" button in sidebar
- Everything should turn dark
- Refresh page - theme should persist

### 2. Navigation
- Click any sidebar menu item
- Should navigate to that page
- Active item should be highlighted

### 3. Modals
- Click "View Details" on appointment → Modal opens
- Click "Reschedule" → Reschedule modal opens
- Click "Ask Now" → Chat widget opens

### 4. Dropdowns
- Click notification bell → Dropdown opens
- Click user profile → Menu opens
- Click outside → Closes

## Troubleshooting

### Dashboard shows blank page
- Check browser console (F12) for errors
- Make sure you're going to `/dashboard` not `/`
- Try clearing browser cache

### "Cannot find module" errors
```bash
npm install
```

### Port already in use
```bash
# Kill process on port 5173
npx kill-port 5173

# Or use different port
npm run dev -- --port 3000
```

### Still not working?
1. Stop the dev server (Ctrl+C)
2. Clear node_modules: `rm -rf node_modules`
3. Reinstall: `npm install`
4. Start again: `npm run dev`

## Verify Installation

Run these commands to verify everything is set up:

```bash
# Check Node version (should be 16+)
node --version

# Check if all dependencies are installed
npm list vue vue-router

# Check if files exist
ls src/views/DashboardInteractive.vue
ls src/components/dashboard/
```

## Expected Console Output

When you run `npm run dev`, you should see:
```
VITE v8.x.x  ready in xxx ms

➜  Local:   http://localhost:5173/
➜  Network: use --host to expose
```

No errors should appear!

## Success Checklist

- [ ] Dev server starts without errors
- [ ] Browser opens to dashboard
- [ ] All components render
- [ ] No red errors in browser console
- [ ] Can click and interact with elements
- [ ] Dark mode toggle works
- [ ] Navigation works

If all checked, the dashboard is working! 🎉

## Need More Help?

Check these files:
- `TEST_DASHBOARD.md` - Detailed testing guide
- `INTERACTIVE_FEATURES.md` - All features documentation
- `QUICK_REFERENCE.md` - Quick reference guide

The dashboard is fully functional and ready to use!
