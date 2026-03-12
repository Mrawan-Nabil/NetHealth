# NetHealth Dashboard - Component Map

## Visual Layout Structure

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          TopNavbar.vue                                   │
│  ┌──────┐  Last viewed 10 mins ago  [Share] 🔔(3) 👤 Ahmed Yahia ▼     │
│  │ Home │                                                                 │
└─┴──────┴─────────────────────────────────────────────────────────────────┘
┌──────────┐┌──────────────────────────────────────────────────────────────┐
│          ││                                                               │
│ Sidebar  ││  Welcome back, Ahmed 👋                                      │
│   .vue   ││  Here's your health overview for today                       │
│          ││                                                               │
│ 🏥       │├───────────────────────────────────────────────────────────────┤
│NetHealth ││                                                               │
│          ││  📅 Book a New Appointment                    [Book Now]     │
│ 🔍Search ││  Schedule a consultation with your preferred doctor...       │
│          ││  ⏰ Available 24/7  ✓ Verified Doctors                       │
│ General  ││                                                               │
│ 🏠 Home  │├───────────────────────────────────────────────────────────────┤
│ 👤Profile││                                                               │
│ 📄Record ││  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐       │
│ 📅Appts  ││  │    3     │ │    1     │ │    2     │ │Need Help?│       │
│ 🔔Notify ││  │Upcoming  │ │Latest    │ │Pending   │ │Ask our AI│       │
│ 🚪Logout ││  │Appts     │ │Prescrip. │ │Tests     │ │Assistant │       │
│          ││  └──────────┘ └──────────┘ └──────────┘ └──────────┘       │
│          ││   StatsCard    StatsCard    StatsCard    Help Card          │
│          │├───────────────────────────────────────────────────────────────┤
│          ││                                                               │
│ ☀️ Light ││  ┌─────────────────────────┐  ┌──────────────────────────┐ │
│ 🌙 Dark  ││  │ Next Appointment        │  │ Health Overview          │ │
│          ││  │ ┌──┐                    │  │ Blood Type:         A+   │ │
└──────────┘│  │ │👤│ Dr. Sarah Johnson  │  │ Allergies:     Penicillin│ │
            │  │ └──┘ Cardiologist       │  │ Conditions:  Hypertension│ │
            │  │      Tomorrow, 2:30 PM  │  │ Primary Doctor:          │ │
            │  │      City Medical Center│  │ 👤 Dr. Sarah Johnson     │ │
            │  │      [Confirmed]        │  └──────────────────────────┘ │
            │  │ [View Details][Resched.]│   HealthOverview.vue           │
            │  └─────────────────────────┘                                │
            │   AppointmentCard.vue      ┌──────────────────────────┐    │
            │                            │ Recent Activity          │    │
            │  ┌─────────────────────────┐│ ● Appointment confirmed │    │
            │  │ Recent Medical Records  ││   2 hours ago           │    │
            │  │ ┌─────────────────────┐ ││ ● Test result uploaded  │    │
            │  │ │📄 Latest Prescription│ ││   1 day ago             │    │
            │  │ │   Dr. Michael Chen   │ ││ ● Prescription updated  │    │
            │  │ │   Jan 20, 2025 [Act.]│ │└──────────────────────────┘    │
            │  │ └─────────────────────┘ │ ActivityTimeline.vue           │
            │  │ ┌─────────────────────┐ │                                │
            │  │ │🧪 Blood Test Results│ │                                │
            │  │ │   Lab Services      │ │                                │
            │  │ │   Jan 18, 2025 [Avl]│ │                                │
            │  │ └─────────────────────┘ │                                │
            │  │ ┌─────────────────────┐ │                                │
            │  │ │📋 Visit Summary     │ │                                │
            │  │ │   Dr. Sarah Johnson │ │                                │
            │  │ │   Jan 15, 2025 [Cmp]│ │                                │
            │  │ └─────────────────────┘ │                                │
            │  │  MedicalRecordItem.vue  │                                │
            │  └─────────────────────────┘                                │
            │                                                               │
            └───────────────────────────────────────────────────────────────┘
```

## Component Breakdown

### 1. Sidebar.vue (Left - Fixed)
```
┌──────────────┐
│ 🏥 NetHealth │ ← Logo
├──────────────┤
│ 🔍 Search    │ ← Search Input
├──────────────┤
│ General      │ ← Section Label
│ 🏠 Home      │ ← Active
│ 👤 Profile   │
│ 📄 Record    │
│ 📅 Appts     │
│ 🔔 Notify    │
│ 🚪 Logout    │ ← Red color
├──────────────┤
│ ☀️ 🌙       │ ← Theme Toggle
└──────────────┘
```

### 2. TopNavbar.vue (Top - Full Width)
```
┌────────────────────────────────────────────────────────────┐
│ Home  │  ⏰ Last viewed 10 mins ago  [Share] 🔔(3) 👤 User ▼│
└────────────────────────────────────────────────────────────┘
```

### 3. Welcome Section
```
┌──────────────────────────────────────────┐
│ Welcome back, Ahmed 👋                   │
│ Here's your health overview for today    │
└──────────────────────────────────────────┘
```

### 4. Book Appointment Banner (Gradient)
```
┌────────────────────────────────────────────────────┐
│ 📅 Book a New Appointment          [Book Now]     │
│ Schedule a consultation with your preferred doctor │
│ ⏰ Available 24/7  ✓ Verified Doctors             │
└────────────────────────────────────────────────────┘
```

### 5. Stats Row (4 Cards)
```
┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
│    3     │ │    1     │ │    2     │ │Need Help?│
│ 📅       │ │ 📄       │ │ 🧪       │ │ 💬       │
│Upcoming  │ │Latest    │ │Pending   │ │Ask our AI│
│Appts     │ │Prescrip. │ │Tests     │ │Assistant │
└──────────┘ └──────────┘ └──────────┘ └──────────┘
StatsCard    StatsCard    StatsCard    Help Card
```

### 6. Main Content Grid (2/3 + 1/3)

#### Left Column (2/3 width)

**AppointmentCard.vue**
```
┌─────────────────────────────────────┐
│ Next Appointment                    │
│ ┌──┐                                │
│ │👤│ Dr. Sarah Johnson              │
│ └──┘ Cardiologist                   │
│      Tomorrow, 2:30 PM              │
│      City Medical Center            │
│      [Confirmed]                    │
│ [View Details] [Reschedule]         │
└─────────────────────────────────────┘
```

**Recent Medical Records**
```
┌─────────────────────────────────────┐
│ Recent Medical Records  [View Full] │
│ ┌─────────────────────────────────┐ │
│ │ 📄 Latest Prescription  [Active]│ │
│ │    Dr. Michael Chen • Jan 20    │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ 🧪 Blood Test Results [Availabl]│ │
│ │    Lab Services • Jan 18        │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ 📋 Visit Summary    [Completed] │ │
│ │    Dr. Sarah Johnson • Jan 15   │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

#### Right Column (1/3 width)

**HealthOverview.vue**
```
┌─────────────────────────────┐
│ Health Overview             │
│ Blood Type:            A+   │
│ Allergies:        Penicillin│
│ Conditions:     Hypertension│
│ Primary Doctor:             │
│ ┌──┐                        │
│ │👤│ Dr. Sarah Johnson      │
│ └──┘ Cardiologist           │
└─────────────────────────────┘
```

**ActivityTimeline.vue**
```
┌─────────────────────────────┐
│ Recent Activity             │
│ ● Appointment confirmed     │
│ │ 2 hours ago               │
│ ● Test result uploaded      │
│ │ 1 day ago                 │
│ ● Prescription updated      │
│   3 days ago                │
└─────────────────────────────┘
```

## Component Props Flow

```
Dashboard.vue (Parent)
│
├─ dashboardData (from API)
│  │
│  ├─→ TopNavbar
│  │   ├─ user: { name, username, avatar }
│  │   ├─ lastViewed: "10 mins ago"
│  │   └─ notificationCount: 3
│  │
│  ├─→ StatsCard (x3)
│  │   ├─ value: stats.appointments
│  │   ├─ label: "Upcoming Appointments"
│  │   └─ icon: "calendar"
│  │
│  ├─→ AppointmentCard
│  │   └─ appointment: nextAppointment
│  │
│  ├─→ MedicalRecordItem (x3)
│  │   └─ record: recentRecords[i]
│  │
│  ├─→ HealthOverview
│  │   └─ healthData: healthOverview
│  │
│  └─→ ActivityTimeline
│      └─ activities: formattedActivities
│
└─ Sidebar (no props)
```

## Color Coding

### Status Badges
- 🟢 **Green** (Confirmed, Active, Completed)
- 🟡 **Yellow** (Pending)
- 🔵 **Blue** (Available)
- 🔴 **Red** (Cancelled)

### Icon Backgrounds
- 🔵 **Blue** - Calendar/Appointments
- 🟠 **Orange** - Prescriptions
- 🟣 **Purple** - Tests/Labs
- 🟢 **Green** - Documents/Summaries

### Theme Colors
- **Primary**: Teal/Green (#14B8A6)
- **Background**: White/Gray-50
- **Text**: Gray-800 (primary), Gray-600 (secondary)
- **Borders**: Gray-200

## Responsive Breakpoints

```
Desktop (>1024px)
├─ Sidebar: Fixed 256px
├─ Main: Remaining width
└─ Grid: 3 columns (2/3 + 1/3)

Tablet (768px - 1024px)
├─ Sidebar: Fixed 256px
├─ Main: Remaining width
└─ Grid: 2 columns (1/1 + 1/1)

Mobile (<768px)
├─ Sidebar: Hidden/Drawer
├─ Main: Full width
└─ Grid: 1 column (stacked)
```

## State Indicators

### Loading State
```
┌─────────────────────┐
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  │ ← Skeleton
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  │
└─────────────────────┘
```

### Error State
```
┌─────────────────────┐
│      ⚠️ Error       │
│ Failed to load data │
│   [Try Again]       │
└─────────────────────┘
```

### Empty State
```
┌─────────────────────┐
│  No appointments    │
│      scheduled      │
└─────────────────────┘
```

## Interaction Points

1. **Sidebar**
   - Click menu items → Navigate
   - Toggle theme → Switch light/dark
   - Search input → Filter/search

2. **Top Navbar**
   - Share button → Share dashboard
   - Notification bell → View notifications
   - User profile → Open dropdown

3. **Book Appointment**
   - Book Now button → Open booking modal

4. **Stats Cards**
   - Click card → Navigate to detail view

5. **Appointment Card**
   - View Details → Show appointment details
   - Reschedule → Open reschedule modal

6. **Medical Records**
   - Click record → View full record
   - View Full Records → Navigate to records page

7. **Need Help**
   - Ask Now → Open AI assistant

---

This visual map helps understand the layout structure and component relationships in the NetHealth Dashboard.
