import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useDashboardStore = defineStore('dashboard', () => {
  // State
  const isDark = ref(false)
  const user = ref({
    name: 'Ahmed Yahia',
    username: '@y7ia007',
    avatar: 'https://i.pravatar.cc/150?img=12',
    email: 'ahmed.yahia@example.com',
    phone: '(555) 123-4567',
    role: 'patient'
  })

  const appointments = ref([])
  const prescriptions = ref([])
  const testResults = ref([])
  const imagingRecords = ref([])
  const visitHistory = ref([])
  const notifications = ref([])
  const doctors = ref([])

  const loading = ref({
    appointments: false,
    prescriptions: false,
    testResults: false,
    imagingRecords: false,
    visitHistory: false,
    notifications: false,
    doctors: false
  })

  const errors = ref({
    appointments: null,
    prescriptions: null,
    testResults: null,
    imagingRecords: null,
    visitHistory: null,
    notifications: null,
    doctors: null
  })

  // Computed
  const upcomingAppointments = computed(() => {
    return appointments.value.filter(apt => apt.status === 'Scheduled')
  })

  const completedAppointments = computed(() => {
    return appointments.value.filter(apt => apt.status === 'Completed')
  })

  const cancelledAppointments = computed(() => {
    return appointments.value.filter(apt => apt.status === 'Cancelled')
  })

  const activePrescriptions = computed(() => {
    return prescriptions.value.filter(p => p.status === 'active')
  })

  const unreadNotifications = computed(() => {
    return notifications.value.filter(n => !n.read)
  })

  const todayNotifications = computed(() => {
    return notifications.value.filter(n => n.date === 'today')
  })

  const yesterdayNotifications = computed(() => {
    return notifications.value.filter(n => n.date === 'yesterday')
  })

  // Actions
  const toggleTheme = () => {
    isDark.value = !isDark.value
    localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
  }

  const setTheme = (theme) => {
    isDark.value = theme === 'dark'
    localStorage.setItem('theme', theme)
  }

  const initializeTheme = () => {
    const savedTheme = localStorage.getItem('theme')
    if (savedTheme) {
      isDark.value = savedTheme === 'dark'
    }
  }

  const fetchAppointments = async () => {
    loading.value.appointments = true
    errors.value.appointments = null
    
    try {
      await new Promise(resolve => setTimeout(resolve, 500))
      appointments.value = generateMockAppointments()
    } catch (error) {
      errors.value.appointments = 'Failed to load appointments'
      console.error('Error fetching appointments:', error)
    } finally {
      loading.value.appointments = false
    }
  }

  const fetchPrescriptions = async () => {
    loading.value.prescriptions = true
    errors.value.prescriptions = null
    
    try {
      await new Promise(resolve => setTimeout(resolve, 500))
      prescriptions.value = generateMockPrescriptions()
    } catch (error) {
      errors.value.prescriptions = 'Failed to load prescriptions'
      console.error('Error fetching prescriptions:', error)
    } finally {
      loading.value.prescriptions = false
    }
  }

  const fetchTestResults = async () => {
    loading.value.testResults = true
    errors.value.testResults = null
    
    try {
      await new Promise(resolve => setTimeout(resolve, 500))
      testResults.value = generateMockTestResults()
    } catch (error) {
      errors.value.testResults = 'Failed to load test results'
      console.error('Error fetching test results:', error)
    } finally {
      loading.value.testResults = false
    }
  }

  const fetchImagingRecords = async () => {
    loading.value.imagingRecords = true
    errors.value.imagingRecords = null
    
    try {
      await new Promise(resolve => setTimeout(resolve, 500))
      imagingRecords.value = generateMockImagingRecords()
    } catch (error) {
      errors.value.imagingRecords = 'Failed to load imaging records'
      console.error('Error fetching imaging records:', error)
    } finally {
      loading.value.imagingRecords = false
    }
  }

  const fetchVisitHistory = async () => {
    loading.value.visitHistory = true
    errors.value.visitHistory = null
    
    try {
      await new Promise(resolve => setTimeout(resolve, 500))
      visitHistory.value = generateMockVisitHistory()
    } catch (error) {
      errors.value.visitHistory = 'Failed to load visit history'
      console.error('Error fetching visit history:', error)
    } finally {
      loading.value.visitHistory = false
    }
  }

  const fetchNotifications = async () => {
    loading.value.notifications = true
    errors.value.notifications = null
    
    try {
      await new Promise(resolve => setTimeout(resolve, 500))
      notifications.value = generateMockNotifications()
    } catch (error) {
      errors.value.notifications = 'Failed to load notifications'
      console.error('Error fetching notifications:', error)
    } finally {
      loading.value.notifications = false
    }
  }

  const fetchDoctors = async () => {
    loading.value.doctors = true
    errors.value.doctors = null
    
    try {
      await new Promise(resolve => setTimeout(resolve, 500))
      doctors.value = generateMockDoctors()
    } catch (error) {
      errors.value.doctors = 'Failed to load doctors'
      console.error('Error fetching doctors:', error)
    } finally {
      loading.value.doctors = false
    }
  }

  const addAppointment = (appointment) => {
    appointments.value.unshift({
      ...appointment,
      id: Date.now()
    })
  }

  const updateAppointment = (id, updates) => {
    const index = appointments.value.findIndex(apt => apt.id === id)
    if (index !== -1) {
      appointments.value[index] = { ...appointments.value[index], ...updates }
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
    const notification = notifications.value.find(n => n.id === id)
    if (notification) {
      notification.read = true
    }
  }

  const markAllNotificationsAsRead = () => {
    notifications.value.forEach(n => n.read = true)
  }

  const clearAllNotifications = () => {
    notifications.value = []
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
    isDark,
    user,
    appointments,
    prescriptions,
    testResults,
    imagingRecords,
    visitHistory,
    notifications,
    doctors,
    loading,
    errors,
    
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
})

// Mock Data Generators
function generateMockAppointments() {
  return [
    {
      id: 1,
      doctorName: 'Dr/ Ayman Fathy',
      specialty: 'Neurology',
      doctorAvatar: 'https://i.pravatar.cc/150?img=33',
      status: 'Completed',
      dateTime: 'Thu, Feb 27, 2025 — 11:00 AM',
      clinicAddress: '80 Park Avenue Health Center, Floor 3, New York, NY',
      reports: [
        { name: 'EKG_REPORT.pdf' },
        { name: 'BLOODWORK.PDF' }
      ]
    },
    {
      id: 2,
      doctorName: 'Dr/ Ayman Fathy',
      specialty: 'Cardiology Specialist',
      doctorAvatar: 'https://i.pravatar.cc/150?img=33',
      status: 'Scheduled',
      dateTime: 'Thu, Feb 27, 2025 — 11:00 AM',
      clinicAddress: '80 Park Avenue Health Center, Floor 3, New York, NY',
      visitType: 'FOLLOW-UP VISIT'
    },
    {
      id: 3,
      doctorName: 'Dr/ Ayman Fathy',
      specialty: 'Cardiology Specialist',
      doctorAvatar: 'https://i.pravatar.cc/150?img=33',
      status: 'Cancelled',
      dateTime: 'Thu, Feb 27, 2025 — 11:00 AM',
      clinicAddress: '80 Park Avenue Health Center, Floor 3, New York, NY',
      cancelledBy: 'Doctor',
      reason: 'DOCTOR UNAVAILABLE'
    }
  ]
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
      diagnosis: 'Stage 2 Hypertension with mild left ventricular hypertrophy',
      medicines: [
        'Lisinopril 10mg — Once daily',
        'Amlodipine 5mg — Before bed',
        'Aspirin 81mg — Once daily'
      ]
    }
  ]
}

function generateMockTestResults() {
  return [
    {
      id: 1,
      testName: 'Complete Blood Count',
      laboratory: 'City General Laboratory',
      date: 'Oct 24, 2025',
      status: 'AVAILABLE',
      results: [
        { parameter: 'Hemoglobin', value: '14.2', unit: 'g/dL', range: '13.5-17.5', status: 'normal' },
        { parameter: 'White Blood Cells', value: '7.8', unit: 'x10⁹/L', range: '4.0-11.0', status: 'normal' }
      ]
    }
  ]
}

function generateMockImagingRecords() {
  return [
    {
      id: 1,
      title: 'Chest CT Scan',
      type: 'CT',
      status: 'VERIFIED',
      hospital: 'St. Jude Medical Center',
      physician: 'Dr. Elena Fisher',
      scanDate: 'Sep 08, 2024',
      uploadDate: 'Sep 10, 2024',
      file: {
        name: 'CT_Chest_Final.pdf',
        format: 'PDF',
        size: '12.4 MB'
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
    }
  ]
}

function generateMockDoctors() {
  return [
    {
      id: 1,
      name: 'Dr/ Ayman Fathy',
      specialty: 'Cardiology Specialist',
      specialtyId: 'cardiology',
      avatar: 'https://i.pravatar.cc/150?img=33',
      hospital: 'City Heart Institute',
      rating: 4.9,
      reviews: 120,
      price: '$115 EXP'
    }
  ]
}
