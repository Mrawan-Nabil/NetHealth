<template>
  <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="dashboard-layout min-h-screen transition-colors duration-300">
    <!-- Sidebar -->
    <Sidebar 
      :is-dark="isDark"
      @toggle-theme="toggleTheme"
      @logout="handleLogout"
    />

    <!-- Main Content -->
    <div class="ml-64">
      <!-- Top Navbar -->
      <TopNavbar 
        v-if="dashboardData"
        title="Dashboard"
        :user="dashboardData.user" 
        :notifications="notifications"
        :is-dark="isDark"
        @mark-read="markNotificationAsRead"
        @mark-all-read="markAllNotificationsAsRead"
        @notification-click="handleNotificationClick"
        @logout="handleLogout"
      />

      <!-- Loading State -->
      <div v-if="loading" class="p-8">
        <div class="animate-pulse space-y-6">
          <div class="bg-gray-200 h-48 rounded-xl"></div>
          <div class="grid grid-cols-3 gap-6">
            <div class="bg-gray-200 h-32 rounded-xl"></div>
            <div class="bg-gray-200 h-32 rounded-xl"></div>
            <div class="bg-gray-200 h-32 rounded-xl"></div>
          </div>
        </div>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="p-8">
        <div class="bg-red-50 border-red-200 border rounded-xl p-6 text-center">
          <svg class="text-red-500 w-12 h-12 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
          </svg>
          <h3 class="text-red-800 text-lg font-semibold mb-2">Failed to Load Dashboard</h3>
          <p class="text-red-600 text-sm mb-4">{{ error }}</p>
          <button 
            @click="fetchDashboardData"
            class="bg-red-600 hover:bg-red-700 px-4 py-2 text-white rounded-lg text-sm font-medium transition-all hover:scale-105"
          >
            Try Again
          </button>
        </div>
      </div>

      <!-- Dashboard Content -->
      <main v-else-if="dashboardData" class="p-6 space-y-4">
        <!-- Welcome Section -->
        <div :class="isDark ? 'bg-[#1E293B] border-[#334155] shadow-lg shadow-black/20' : 'bg-white border-[#E5E7EB] shadow-sm'" class="rounded-lg p-5 border transition-all duration-300">
          <h2 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-xl font-bold mb-1">
            Welcome back, {{ dashboardData.user.name }} 👋
          </h2>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">Here's your health overview for today</p>
        </div>

        <!-- Book Appointment Banner -->
        <div class="bg-gradient-to-r from-[#14B8A6] to-[#0D9488] rounded-lg p-6 text-white relative overflow-hidden shadow-lg transition-all duration-300 hover:shadow-xl">
          <div class="relative z-10 flex items-center justify-between">
            <div class="flex-1">
              <h3 class="text-xl font-bold mb-2">Book a New Appointment</h3>
              <p class="text-white/90 mb-3 text-sm max-w-md">
                Schedule a consultation with your preferred doctor in just a few steps. Get instant confirmation and digital prescriptions.
              </p>
              <div class="flex items-center gap-4 text-xs">
                <div class="flex items-center gap-1.5">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                  </svg>
                  <span>Available 24/7</span>
                </div>
                <div class="flex items-center gap-1.5">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                  </svg>
                  <span>Verified Doctors</span>
                </div>
              </div>
            </div>
            <div class="flex flex-col items-end">
              <button 
                @click="handleBookAppointment"
                class="px-5 py-2 bg-white text-[#14B8A6] rounded-lg font-semibold hover:bg-gray-50 transition-all duration-300 flex items-center gap-2 shadow-md text-sm"
              >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                </svg>
                Book Now
              </button>
              <p class="text-xs text-white/80 mt-1.5 uppercase tracking-wide">Takes less than 2 minutes</p>
            </div>
          </div>
        </div>

        <!-- Stats and Help Section -->
        <div class="grid grid-cols-4 gap-4">
          <!-- Stats Cards -->
          <div>
            <StatsCard 
              :value="dashboardData.stats.appointments" 
              label="Upcoming Appointments"
              icon="calendar"
              :is-dark="isDark"
              @click="handleStatsClick"
            />
          </div>
          <div>
            <StatsCard 
              :value="dashboardData.stats.prescriptions" 
              label="Latest Prescription"
              icon="prescription"
              :is-dark="isDark"
              @click="handleStatsClick"
            />
          </div>
          <div>
            <StatsCard 
              :value="dashboardData.stats.pending_tests" 
              label="Pending Test Results"
              icon="test"
              :is-dark="isDark"
              @click="handleStatsClick"
            />
          </div>

          <!-- Need Help Card -->
          <div>
            <div 
              @click="openChatWidget"
              class="bg-gradient-to-br from-[#14B8A6] to-[#0D9488] rounded-lg p-4 text-white cursor-pointer transition-all duration-300 hover:shadow-lg shadow-md"
            >
              <div class="flex items-center gap-2 mb-2">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 5.636l-3.536 3.536m0 5.656l3.536 3.536M9.172 9.172L5.636 5.636m3.536 9.192l-3.536 3.536M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-5 0a4 4 0 11-8 0 4 4 0 018 0z"/>
                </svg>
                <h3 class="font-semibold text-sm">Need Help?</h3>
              </div>
              <p class="text-xs text-white/90 mb-3 leading-relaxed">
                Ask our AI Medical Assistant for quick answers about your health.
              </p>
              <button class="w-full px-3 py-1.5 bg-white text-[#14B8A6] rounded-lg text-xs font-medium hover:bg-gray-50 transition-colors duration-300">
                Ask Now
              </button>
            </div>
          </div>
        </div>

        <!-- Main Content Grid -->
        <div class="grid grid-cols-3 gap-4">
          <!-- Left Column (2/3) -->
          <div class="col-span-2 space-y-4">
            <!-- Next Appointment -->
            <AppointmentCard 
              :appointment="dashboardData.nextAppointment"
              :is-dark="isDark"
              @view-details="openAppointmentDetails"
              @reschedule="openRescheduleModal"
            />

            <!-- Recent Medical Records -->
            <div :class="isDark ? 'bg-[#1E293B] border-[#334155] shadow-lg shadow-black/20' : 'bg-white border-[#E5E7EB] shadow-sm'" class="rounded-lg p-5 border transition-all duration-300">
              <div class="flex items-center justify-between mb-4">
                <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">Recent Medical Records</h3>
                <router-link 
                  to="/medical-records"
                  :class="isDark ? 'text-[#2DD4BF] hover:text-[#14B8A6]' : 'text-[#14B8A6] hover:text-[#0D9488]'"
                  class="text-xs font-medium transition-colors"
                >
                  View Full Records
                </router-link>
              </div>
              <div class="space-y-2">
                <MedicalRecordItem 
                  v-for="(record, index) in dashboardData.recentRecords" 
                  :key="index"
                  :record="record"
                  :is-dark="isDark"
                />
              </div>
            </div>
          </div>

          <!-- Right Column (1/3) -->
          <div class="space-y-4">
            <!-- Health Overview -->
            <HealthOverview 
              :health-data="dashboardData.healthOverview"
              :is-dark="isDark"
            />

            <!-- Recent Activity -->
            <ActivityTimeline 
              :activities="formattedActivities"
              :is-dark="isDark"
            />
          </div>
        </div>
      </main>
    </div>

    <!-- Modals -->
    <AppointmentDetailsModal
      :is-open="showAppointmentDetails"
      :appointment="selectedAppointment"
      @close="showAppointmentDetails = false"
      @reschedule="openRescheduleModal"
      @cancel="handleCancelAppointment"
    />

    <RescheduleModal
      :is-open="showRescheduleModal"
      :appointment="selectedAppointment"
      @close="showRescheduleModal = false"
      @confirm="handleRescheduleConfirm"
    />

    <ChatWidget
      :is-open="showChatWidget"
      @close="showChatWidget = false"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import Sidebar from '../components/dashboard/Sidebar.vue'
import TopNavbar from '../components/dashboard/TopNavbar.vue'
import StatsCard from '../components/dashboard/StatsCard.vue'
import AppointmentCard from '../components/dashboard/AppointmentCard.vue'
import MedicalRecordItem from '../components/dashboard/MedicalRecordItem.vue'
import HealthOverview from '../components/dashboard/HealthOverview.vue'
import ActivityTimeline from '../components/dashboard/ActivityTimeline.vue'
import AppointmentDetailsModal from '../components/dashboard/AppointmentDetailsModal.vue'
import RescheduleModal from '../components/dashboard/RescheduleModal.vue'
import ChatWidget from '../components/dashboard/ChatWidget.vue'
import { dashboardAPI } from '../services/api.js'

const router = useRouter()

// State
const dashboardData = ref(null)
const loading = ref(true)
const error = ref(null)
const isDark = ref(false)
const notifications = ref([])
const showAppointmentDetails = ref(false)
const showRescheduleModal = ref(false)
const showChatWidget = ref(false)
const selectedAppointment = ref(null)

// Computed
const formattedActivities = computed(() => {
  if (!dashboardData.value?.activity) return []
  
  return dashboardData.value.activity.map((activity, index) => {
    let type = 'default'
    let time = ''
    
    if (activity.toLowerCase().includes('appointment')) {
      type = 'appointment'
      time = '2 hours ago'
    } else if (activity.toLowerCase().includes('test')) {
      type = 'test'
      time = '1 day ago'
    } else if (activity.toLowerCase().includes('prescription')) {
      type = 'prescription'
      time = '3 days ago'
    }
    
    return {
      title: activity,
      type,
      time
    }
  })
})

// Methods
const fetchDashboardData = async () => {
  loading.value = true
  error.value = null
  
  try {
    // Comment out API call to avoid console errors
    // dashboardData.value = await dashboardAPI.getDashboardData()
    
    // Use dummy data directly (no API call)
    dashboardData.value = getDummyData()
    initializeNotifications()
  } catch (err) {
    console.error('Error fetching dashboard data:', err)
    error.value = err.message
    dashboardData.value = getDummyData()
    initializeNotifications()
  } finally {
    loading.value = false
  }
}

const initializeNotifications = () => {
  notifications.value = [
    {
      id: 1,
      type: 'appointment',
      title: 'Appointment Confirmed',
      message: 'Your appointment with Dr. Sarah Johnson is confirmed for tomorrow at 2:30 PM',
      time: '2 hours ago',
      read: false
    },
    {
      id: 2,
      type: 'test',
      title: 'Test Results Available',
      message: 'Your blood test results are now available',
      time: '1 day ago',
      read: false
    },
    {
      id: 3,
      type: 'prescription',
      title: 'Prescription Updated',
      message: 'Dr. Michael Chen has updated your prescription',
      time: '3 days ago',
      read: true
    }
  ]
}

const toggleTheme = (theme) => {
  isDark.value = theme === 'dark'
  localStorage.setItem('theme', theme)
}

const handleBookAppointment = () => {
  router.push('/appointments/create')
}

const handleStatsClick = (data) => {
  console.log('Stats clicked:', data)
  if (data.label.includes('Appointments')) {
    router.push('/appointments')
  } else if (data.label.includes('Prescription')) {
    router.push('/medical-records')
  } else if (data.label.includes('Test')) {
    router.push('/test-results')
  }
}

const openAppointmentDetails = (appointment) => {
  selectedAppointment.value = appointment
  showAppointmentDetails.value = true
}

const openRescheduleModal = (appointment) => {
  selectedAppointment.value = appointment || dashboardData.value.nextAppointment
  showAppointmentDetails.value = false
  showRescheduleModal.value = true
}

const handleRescheduleConfirm = (rescheduleData) => {
  console.log('Rescheduling appointment:', rescheduleData)
  // API call to reschedule
  alert(`Appointment rescheduled to ${rescheduleData.date} at ${rescheduleData.time}`)
  fetchDashboardData()
}

const handleCancelAppointment = () => {
  if (confirm('Are you sure you want to cancel this appointment?')) {
    console.log('Cancelling appointment')
    // API call to cancel
    alert('Appointment cancelled successfully')
    fetchDashboardData()
  }
}

const openChatWidget = () => {
  showChatWidget.value = true
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

const handleNotificationClick = (notification) => {
  console.log('Notification clicked:', notification)
  // Navigate based on notification type
  if (notification.type === 'appointment') {
    router.push('/appointments')
  } else if (notification.type === 'test') {
    router.push('/test-results')
  } else if (notification.type === 'prescription') {
    router.push('/medical-records')
  }
}

const handleLogout = () => {
  if (confirm('Are you sure you want to logout?')) {
    localStorage.removeItem('authToken')
    router.push('/login')
  }
}

// Dummy data
const getDummyData = () => ({
  user: {
    name: "Ahmed Yahia",
    username: "@y7ia007",
    avatar: "https://i.pravatar.cc/150?img=12",
    email: "ahmed@nethealth.com"
  },
  stats: {
    appointments: 3,
    prescriptions: 1,
    pending_tests: 2
  },
  nextAppointment: {
    doctor: "Dr. Sarah Johnson",
    specialty: "Cardiologist",
    time: "Tomorrow, 2:30 PM",
    location: "City Medical Center",
    status: "Confirmed",
    avatar: "https://i.pravatar.cc/150?img=47",
    type: "General Consultation",
    duration: "30 minutes",
    notes: "Please bring your previous medical records"
  },
  healthOverview: {
    bloodType: "A+",
    allergies: "Penicillin",
    conditions: "Hypertension",
    primaryDoctor: "Dr. Sarah Johnson",
    primaryDoctorSpecialty: "Cardiologist",
    primaryDoctorAvatar: "https://i.pravatar.cc/150?img=47"
  },
  recentRecords: [
    {
      title: "Latest Prescription",
      doctor: "Dr. Michael Chen",
      date: "Jan 20, 2025",
      status: "Active"
    },
    {
      title: "Blood Test Results",
      doctor: "Lab Services",
      date: "Jan 18, 2025",
      status: "Available"
    },
    {
      title: "Visit Summary",
      doctor: "Dr. Sarah Johnson",
      date: "Jan 15, 2025",
      status: "Completed"
    }
  ],
  activity: [
    "Appointment confirmed",
    "Test result uploaded",
    "Prescription updated"
  ]
})

// Lifecycle
onMounted(() => {
  const savedTheme = localStorage.getItem('theme')
  if (savedTheme) {
    isDark.value = savedTheme === 'dark'
  }
  fetchDashboardData()
})

// Watch for theme changes
watch(isDark, (newVal) => {
  if (newVal) {
    document.documentElement.classList.add('dark')
  } else {
    document.documentElement.classList.remove('dark')
  }
})
</script>

<style scoped>
@import '../assets/dashboard-animations.css';

/* Dashboard-specific animations */
.dashboard-layout {
  animation: dashboardFadeIn 0.4s ease-out;
}

@keyframes dashboardFadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

/* Apply dashboard animations to child elements */
.dashboard-layout :deep(.animate-fade-in-up) {
  animation: dashboardCardSlideUp 0.5s ease-out backwards;
}

.dashboard-layout :deep(.stagger-1) {
  animation-delay: 0.1s;
}

.dashboard-layout :deep(.stagger-2) {
  animation-delay: 0.2s;
}

.dashboard-layout :deep(.stagger-3) {
  animation-delay: 0.3s;
}

.dashboard-layout :deep(.stagger-4) {
  animation-delay: 0.4s;
}

/* Dashboard card hover effects */
.dashboard-layout :deep(.hover\:-translate-y-1:hover) {
  transform: translateY(-4px);
}

.dashboard-layout :deep(.hover\:scale-105:hover) {
  transform: scale(1.05);
}

.dashboard-layout :deep(.active\:scale-95:active) {
  transform: scale(0.95);
}

/* Enhanced dashboard card styling */
.dashboard-layout :deep(.bg-white),
.dashboard-layout :deep(.bg-\[#1E293B\]) {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.dashboard-layout :deep(.bg-white:hover),
.dashboard-layout :deep(.bg-\[#1E293B\]:hover) {
  transform: translateY(-2px);
}

/* Dashboard button enhancements */
.dashboard-layout :deep(button) {
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}

.dashboard-layout :deep(button:hover) {
  transform: translateY(-1px);
}

.dashboard-layout :deep(button:active) {
  transform: translateY(0);
}
</style>
