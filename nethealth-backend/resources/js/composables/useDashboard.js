import { computed, reactive } from 'vue'

// Global state (shared across all components)
const state = reactive({
  isDark: false,
  activeAppointmentTab: 'completed',
  user: {
    name: 'Ahmed Yahia',
    username: '@y7ia007',
    avatar: 'https://i.pravatar.cc/150?img=12',
    email: 'ahmed.yahia@example.com',
    phone: '(555) 123-4567',
    role: 'patient'
  },
  appointments: [],
  prescriptions: [],
  testResults: [],
  imagingRecords: [],
  visitHistory: [],
  notifications: [],
  doctors: [],
  loading: {
    appointments: false,
    prescriptions: false,
    testResults: false,
    imagingRecords: false,
    visitHistory: false,
    notifications: false,
    doctors: false
  },
  errors: {
    appointments: null,
    prescriptions: null,
    testResults: null,
    imagingRecords: null,
    visitHistory: null,
    notifications: null,
    doctors: null
  }
})

export function useDashboard() {
  // Computed properties
  const upcomingAppointments = computed(() => {
    return state.appointments.filter(apt => apt.status === 'Scheduled')
  })

  const completedAppointments = computed(() => {
    return state.appointments.filter(apt => apt.status === 'Completed')
  })

  const cancelledAppointments = computed(() => {
    return state.appointments.filter(apt => apt.status === 'Cancelled')
  })

  const activePrescriptions = computed(() => {
    return state.prescriptions.filter(p => p.status === 'active')
  })

  const unreadNotifications = computed(() => {
    return state.notifications.filter(n => !n.read)
  })

  const todayNotifications = computed(() => {
    return state.notifications.filter(n => n.date === 'today')
  })

  const yesterdayNotifications = computed(() => {
    return state.notifications.filter(n => n.date === 'yesterday')
  })

  // Actions
  const toggleTheme = () => {
    state.isDark = !state.isDark
    localStorage.setItem('theme', state.isDark ? 'dark' : 'light')
  }

  const setTheme = (theme) => {
    state.isDark = theme === 'dark'
    localStorage.setItem('theme', theme)
  }

  const initializeTheme = () => {
    const savedTheme = localStorage.getItem('theme')
    if (savedTheme) {
      state.isDark = savedTheme === 'dark'
    }
  }

  const fetchAppointments = async () => {
    state.loading.appointments = true
    state.errors.appointments = null

    try {
      await new Promise(resolve => setTimeout(resolve, 500))
      state.appointments = generateMockAppointments()
    } catch (error) {
      state.errors.appointments = 'Failed to load appointments'
      console.error('Error fetching appointments:', error)
    } finally {
      state.loading.appointments = false
    }
  }

  const fetchPrescriptions = async () => {
    state.loading.prescriptions = true
    state.errors.prescriptions = null

    try {
      await new Promise(resolve => setTimeout(resolve, 500))
      state.prescriptions = generateMockPrescriptions()
    } catch (error) {
      state.errors.prescriptions = 'Failed to load prescriptions'
      console.error('Error fetching prescriptions:', error)
    } finally {
      state.loading.prescriptions = false
    }
  }

  const fetchTestResults = async () => {
    state.loading.testResults = true
    state.errors.testResults = null

    try {
      await new Promise(resolve => setTimeout(resolve, 500))
      state.testResults = generateMockTestResults()
    } catch (error) {
      state.errors.testResults = 'Failed to load test results'
      console.error('Error fetching test results:', error)
    } finally {
      state.loading.testResults = false
    }
  }

  const fetchImagingRecords = async () => {
    state.loading.imagingRecords = true
    state.errors.imagingRecords = null

    try {
      await new Promise(resolve => setTimeout(resolve, 500))
      state.imagingRecords = generateMockImagingRecords()
    } catch (error) {
      state.errors.imagingRecords = 'Failed to load imaging records'
      console.error('Error fetching imaging records:', error)
    } finally {
      state.loading.imagingRecords = false
    }
  }

  const fetchVisitHistory = async () => {
    state.loading.visitHistory = true
    state.errors.visitHistory = null

    try {
      await new Promise(resolve => setTimeout(resolve, 500))
      state.visitHistory = generateMockVisitHistory()
    } catch (error) {
      state.errors.visitHistory = 'Failed to load visit history'
      console.error('Error fetching visit history:', error)
    } finally {
      state.loading.visitHistory = false
    }
  }

  const fetchNotifications = async () => {
    state.loading.notifications = true
    state.errors.notifications = null

    try {
      await new Promise(resolve => setTimeout(resolve, 500))
      state.notifications = generateMockNotifications()
    } catch (error) {
      state.errors.notifications = 'Failed to load notifications'
      console.error('Error fetching notifications:', error)
    } finally {
      state.loading.notifications = false
    }
  }

  const fetchDoctors = async () => {
    state.loading.doctors = true
    state.errors.doctors = null

    try {
      await new Promise(resolve => setTimeout(resolve, 500))
      state.doctors = generateMockDoctors()
    } catch (error) {
      state.errors.doctors = 'Failed to load doctors'
      console.error('Error fetching doctors:', error)
    } finally {
      state.loading.doctors = false
    }
  }

  const addAppointment = (appointment) => {
    state.appointments.unshift({
      ...appointment,
      id: Date.now()
    })
  }

  const updateAppointment = (id, updates) => {
    const index = state.appointments.findIndex(apt => apt.id === id)
    if (index !== -1) {
      state.appointments[index] = { ...state.appointments[index], ...updates }
    }
  }

  const cancelAppointment = (id, reason) => {
    updateAppointment(id, {
      status: 'Cancelled',
      cancelledBy: 'Patient',
      reason: reason
    })
  }

  const markNotificationAsRead = (id) => {
    const notification = state.notifications.find(n => n.id === id)
    if (notification) {
      notification.read = true
    }
  }

  const markAllNotificationsAsRead = () => {
    state.notifications.forEach(n => n.read = true)
  }

  const clearAllNotifications = () => {
    state.notifications = []
  }

  const initializeStore = async () => {
    initializeTheme()
    await Promise.all([
      fetchAppointments(),
      fetchPrescriptions(),
      fetchTestResults(),
      fetchImagingRecords(),
      fetchVisitHistory(),
      fetchNotifications(),
      fetchDoctors()
    ])
  }

  return {
    // State
    state,

    // Computed
    upcomingAppointments,
    completedAppointments,
    cancelledAppointments,
    activePrescriptions,
    unreadNotifications,
    todayNotifications,
    yesterdayNotifications,

    // Actions
    toggleTheme,
    setTheme,
    initializeTheme,
    fetchAppointments,
    fetchPrescriptions,
    fetchTestResults,
    fetchImagingRecords,
    fetchVisitHistory,
    fetchNotifications,
    fetchDoctors,
    addAppointment,
    updateAppointment,
    cancelAppointment,
    markNotificationAsRead,
    markAllNotificationsAsRead,
    clearAllNotifications,
    initializeStore
  }
}

// Mock Data Generators
function generateMockAppointments() {
  const appointments = []

  // Completed
  for (let i = 1; i <= 6; i++) {
    appointments.push({
      id: i,
      doctorName: 'Dr/ Ayman Fathy',
      specialty: 'Neurology',
      doctorAvatar: 'https://i.pravatar.cc/150?img=33',
      status: 'Completed',
      dateTime: 'Thu, Feb 27, 2025 — 11:00 AM',
      clinicAddress: '80 Park Avenue Health Center, Floor 3, New York, NY',
      reports: i % 2 === 0 ? null : [
        { name: 'EKG_REPORT.pdf' },
        { name: 'BLOODWORK.PDF' }
      ]
    })
  }

  // Scheduled
  for (let i = 7; i <= 12; i++) {
    appointments.push({
      id: i,
      doctorName: 'Dr/ Ayman Fathy',
      specialty: 'Cardiology Specialist',
      doctorAvatar: 'https://i.pravatar.cc/150?img=33',
      status: 'Scheduled',
      dateTime: 'Thu, Feb 27, 2025 — 11:00 AM',
      clinicAddress: '80 Park Avenue Health Center, Floor 3, New York, NY',
      visitType: 'FOLLOW-UP VISIT'
    })
  }

  // Cancelled
  for (let i = 13; i <= 16; i++) {
    appointments.push({
      id: i,
      doctorName: 'Dr/ Ayman Fathy',
      specialty: 'Cardiology Specialist',
      doctorAvatar: 'https://i.pravatar.cc/150?img=33',
      status: 'Cancelled',
      dateTime: 'Thu, Feb 27, 2025 — 11:00 AM',
      clinicAddress: '80 Park Avenue Health Center, Floor 3, New York, NY',
      cancelledBy: i % 2 === 0 ? 'Patient' : 'Doctor',
      reason: i % 2 === 0 ? 'NO LONGER NEEDED' : 'DOCTOR UNAVAILABLE'
    })
  }

  return appointments
}

function generateMockPrescriptions() {
  return [
    {
      id: 1,
      doctor: 'Dr. Sarah Mitchell',
      specialty: 'Cardiology',
      date: 'Feb 14, 2025',
      expires: 'Aug 14, 2025',
      status: 'active',
      diagnosis: 'Stage 2 Hypertension with mild left ventricular hypertrophy requiring long-term antihypertensive management.',
      medicines: [
        'Lisinopril 10mg — Once daily',
        'Amlodipine 5mg — Before bed',
        'Aspirin 81mg — Once daily',
        'Atorvastatin 20mg — At bedtime'
      ]
    },
    {
      id: 2,
      doctor: 'Dr. Sarah Mitchell',
      specialty: 'Cardiology',
      date: 'Feb 14, 2025',
      expires: 'Aug 14, 2025',
      status: 'expired',
      diagnosis: 'Stage 2 Hypertension with mild left ventricular hypertrophy requiring long-term antihypertensive management.',
      medicines: [
        'Lisinopril 10mg — Once daily',
        'Amlodipine 5mg — Before bed'
      ]
    },
    {
      id: 3,
      doctor: 'Dr. Sarah Mitchell',
      specialty: 'Cardiology',
      date: 'Feb 14, 2025',
      expires: 'Aug 14, 2025',
      status: 'expired',
      diagnosis: 'Stage 2 Hypertension with mild left ventricular hypertrophy requiring long-term antihypertensive management.',
      medicines: [
        'Lisinopril 10mg — Once daily',
        'Amlodipine 5mg — Before bed'
      ]
    },
    {
      id: 4,
      doctor: 'Dr. Sarah Mitchell',
      specialty: 'Cardiology',
      date: 'Feb 14, 2025',
      expires: 'Aug 14, 2025',
      status: 'active',
      diagnosis: 'Stage 2 Hypertension with mild left ventricular hypertrophy requiring long-term antihypertensive management.',
      medicines: [
        'Lisinopril 10mg — Once daily',
        'Amlodipine 5mg — Before bed'
      ]
    }
  ]
}

function generateMockTestResults() {
  return [
    {
      id: 1,
      name: 'Full Blood Count (FBC)',
      testName: 'Full Blood Count (FBC)',
      lab: 'City General Laboratory',
      laboratory: 'City General Laboratory',
      date: '2025-10-24',
      status: 'AVAILABLE',
      patient: {
        name: 'Ahmed Yahia',
        gender: 'Male',
        age: 34,
        id: 'PT-00041782'
      },
      results: [
        { parameter: 'Hemoglobin', value: '14.2', unit: 'g/dL', range: '13.5-17.5', status: 'normal' },
        { parameter: 'White Blood Cells', value: '7.8', unit: 'x10⁹/L', range: '4.0-11.0', status: 'normal' },
        { parameter: 'Platelets', value: '220', unit: 'x10⁹/L', range: '150-450', status: 'normal' },
        { parameter: 'Red Blood Cells', value: '4.9', unit: 'x10¹²/L', range: '4.5-5.9', status: 'normal' }
      ]
    },
    {
      id: 2,
      name: 'Lipid Profile',
      testName: 'Lipid Profile',
      lab: 'Downtown Medical Center',
      laboratory: 'Downtown Medical Center',
      date: '2025-10-22',
      status: 'AVAILABLE'
    },
    {
      id: 3,
      name: 'HBA1C Diabetes Screening',
      testName: 'HBA1C Diabetes Screening',
      lab: 'City General Laboratory',
      laboratory: 'City General Laboratory',
      date: '2025-10-28',
      status: 'PENDING'
    },
    {
      id: 4,
      name: 'Vitamin D (25-Hydroxy)',
      testName: 'Vitamin D (25-Hydroxy)',
      lab: 'Evergreen Health Lab',
      laboratory: 'Evergreen Health Lab',
      date: '2025-09-15',
      status: 'AVAILABLE'
    },
    {
      id: 5,
      name: 'Thyroid Stimulating Hormone (TSH)',
      testName: 'Thyroid Stimulating Hormone (TSH)',
      lab: 'City General Laboratory',
      laboratory: 'City General Laboratory',
      date: '2025-08-04',
      status: 'AVAILABLE'
    },
    {
      id: 6,
      name: 'Vitamin D (25-Hydroxy)',
      testName: 'Vitamin D (25-Hydroxy)',
      lab: 'Evergreen Health Lab',
      laboratory: 'Evergreen Health Lab',
      date: '2025-09-15',
      status: 'AVAILABLE'
    }
  ]
}

function generateMockImagingRecords() {
  return [
    {
      id: 1,
      title: 'Lumbar Spine MRI',
      type: 'MRI',
      status: 'VERIFIED',
      hospital: 'St. Jude Medical Center',
      physician: 'Dr. Elena Fisher',
      scanDate: 'Sep 08, 2024',
      uploadDate: 'Sep 10, 2024',
      file: {
        name: 'MRI_Lumbar_Spine_Final.pdf',
        format: 'PDF',
        size: '8.7 MB',
        type: 'MRI Scan',
        radiologyCenter: 'St. Jude Medical Center',
        scanDate: 'Sep 08, 2024'
      }
    },
    {
      id: 2,
      title: 'Lumbar Spine MRI',
      type: 'MRI',
      status: 'VERIFIED',
      hospital: 'St. Jude Medical Center',
      physician: 'Dr. Elena Fisher',
      scanDate: 'Sep 08, 2024',
      uploadDate: 'Sep 10, 2024',
      file: {
        name: 'MRI_Lumbar_Spine_Final.pdf',
        format: 'PDF',
        size: '8.7 MB'
      }
    },
    {
      id: 3,
      title: 'Echo Cardiogram',
      type: 'ECHO',
      status: 'PENDING',
      hospital: 'St. Jude Medical Center',
      physician: 'Dr. Elena Fisher',
      scanDate: 'Sep 08, 2024',
      uploadDate: null,
      file: null
    },
    {
      id: 4,
      title: 'Lumbar Spine MRI',
      type: 'MRI',
      status: 'VERIFIED',
      hospital: 'St. Jude Medical Center',
      physician: 'Dr. Elena Fisher',
      scanDate: 'Sep 08, 2024',
      uploadDate: 'Sep 10, 2024',
      file: {
        name: 'MRI_Lumbar_Spine_Final.pdf',
        format: 'PDF',
        size: '8.7 MB'
      }
    }
  ]
}

function generateMockVisitHistory() {
  return [
    {
      id: 1,
      doctorName: 'Dr. James Smith',
      doctorInitials: 'JS',
      specialty: 'Cardiologist',
      avatarBg: '#E0F2FE',
      avatarColor: '#0369A1',
      clinic: "St. Mary's General Hospital",
      date: 'Oct 24, 2023',
      time: '10:30 AM',
      visitType: 'REGULAR CHECK-UP',
      status: 'Completed'
    },
    {
      id: 2,
      doctorName: 'Dr. Linda White',
      doctorInitials: 'LW',
      specialty: 'Dermatologist',
      avatarBg: '#CCFBF1',
      avatarColor: '#0F766E',
      clinic: 'City Wellness Center',
      date: 'Nov 12, 2023',
      time: '02:15 PM',
      visitType: 'FOLLOW-UP',
      status: 'Upcoming'
    },
    {
      id: 3,
      doctorName: 'Dr. Michael Page',
      doctorInitials: 'MP',
      specialty: 'Pediatrician',
      avatarBg: '#DBEAFE',
      avatarColor: '#1E40AF',
      clinic: "Children's Care Hospital",
      date: 'Sep 08, 2023',
      time: '09:00 AM',
      visitType: 'VACCINATION',
      status: 'Completed'
    },
    {
      id: 4,
      doctorName: 'Dr. Robert Shaw',
      doctorInitials: 'RS',
      specialty: 'Orthopedic',
      avatarBg: '#FEE2E2',
      avatarColor: '#991B1B',
      clinic: 'Shaw Ortho Clinic',
      date: 'Aug 20, 2023',
      time: '11:00 AM',
      visitType: 'CONSULTATION',
      status: 'Cancelled'
    },
    {
      id: 5,
      doctorName: 'Dr. Sarah Mitchell',
      doctorInitials: 'SM',
      specialty: 'Cardiologist',
      avatarBg: '#E0F2FE',
      avatarColor: '#0369A1',
      clinic: 'Heart Care Center',
      date: 'Jul 15, 2023',
      time: '03:30 PM',
      visitType: 'FOLLOW-UP',
      status: 'Completed'
    },
    {
      id: 6,
      doctorName: 'Dr. Emily Davis',
      doctorInitials: 'ED',
      specialty: 'Neurologist',
      avatarBg: '#FEF3C7',
      avatarColor: '#92400E',
      clinic: 'Brain & Spine Institute',
      date: 'Dec 05, 2023',
      time: '01:00 PM',
      visitType: 'CONSULTATION',
      status: 'Upcoming'
    },
    {
      id: 7,
      doctorName: 'Dr. Marcus Webb',
      doctorInitials: 'MW',
      specialty: 'General Practitioner',
      avatarBg: '#CCFBF1',
      avatarColor: '#0F766E',
      clinic: 'Family Health Clinic',
      date: 'Jun 10, 2023',
      time: '08:45 AM',
      visitType: 'ANNUAL PHYSICAL',
      status: 'Completed'
    }
  ]
}

function generateMockNotifications() {
  return [
    {
      id: 1,
      type: 'appointment',
      title: 'Appointment Confirmed: Sarah Johnson',
      description: 'The patient has confirmed their follow-up appointment for cardiology next Tuesday at 10:00 AM.',
      time: '2 hours ago',
      badge: 'APPOINTMENT',
      date: 'today',
      read: false
    },
    {
      id: 2,
      type: 'prescription',
      title: 'Prescription Renewal Request: Robert Chen',
      description: 'A request for Lisinopril 20mg renewal has been submitted for your review and digital signature.',
      time: '4 hours ago',
      badge: 'PRESCRIPTION',
      date: 'today',
      read: false
    },
    {
      id: 3,
      type: 'appointment',
      title: 'Follow-Up Scheduled',
      description: 'A follow-up appointment with Dr. Marcus Webb has been scheduled for March 13 at 8:30 AM.',
      time: '5 hours ago',
      badge: 'APPOINTMENT',
      date: 'today',
      read: false
    },
    {
      id: 4,
      type: 'lab',
      title: 'New Lab Results: Metabolic Panel',
      description: 'Comprehensive metabolic panel results are now available for patient Emily Davis.',
      time: 'Yesterday at 3:45 PM',
      badge: 'LAB RESULTS',
      date: 'yesterday',
      read: true
    },
    {
      id: 5,
      type: 'message',
      title: 'Urgent Message: Patient Care Update',
      description: "Nurse Jackson has left an urgent note regarding patient Marcus Thorne's discharge plan.",
      time: 'Yesterday at 11:20 AM',
      badge: 'MESSAGE',
      date: 'yesterday',
      read: true
    }
  ]
}

function generateMockDoctors() {
  const doctors = []
  const specialties = ['cardiology', 'gastritis', 'neurology', 'pulmonology', 'dentistry']

  for (let i = 1; i <= 12; i++) {
    doctors.push({
      id: i,
      name: 'Dr/ Ayman Fathy',
      specialty: 'Cardiology Specialist',
      specialtyId: specialties[i % specialties.length],
      avatar: 'https://i.pravatar.cc/150?img=33',
      hospital: 'City Heart Institute',
      rating: 4.9,
      reviews: 120,
      price: '$115 EXP'
    })
  }

  return doctors
}
