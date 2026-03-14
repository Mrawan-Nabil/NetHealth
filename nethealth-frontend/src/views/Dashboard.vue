<template>
  <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
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
        :is-dark="isDark"
        :user="dashboardData.user" 
        :notifications="[]"
        :show-last-viewed="true"
        :show-share="false"
        @logout="handleLogout"
      />

      <!-- Loading State -->
      <div v-if="loading" class="p-8">
        <div class="dashboard-grid space-y-8">
          <div :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="h-32 rounded-xl animate-pulse"></div>
          <div :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="h-48 rounded-xl animate-pulse"></div>
          <div class="grid grid-cols-4 gap-6">
            <div v-for="i in 4" :key="i" :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="h-32 rounded-xl animate-pulse"></div>
          </div>
          <div class="grid grid-cols-12 gap-6">
            <div class="col-span-8 space-y-6">
              <div :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="h-64 rounded-xl animate-pulse"></div>
              <div :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="h-80 rounded-xl animate-pulse"></div>
            </div>
            <div class="col-span-4 space-y-6">
              <div :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="h-64 rounded-xl animate-pulse"></div>
              <div :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="h-80 rounded-xl animate-pulse"></div>
            </div>
          </div>
        </div>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="p-8">
        <div class="dashboard-grid">
          <div :class="isDark ? 'bg-[#1E293B] border-[#EF4444]/20' : 'bg-red-50 border-red-200'" class="error-card border rounded-xl p-8 text-center max-w-md mx-auto">
            <div :class="isDark ? 'bg-[#0F172A]' : 'bg-red-100'" class="w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
              <svg class="w-8 h-8 text-[#EF4444]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
            </div>
            <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold mb-2">Failed to Load Dashboard</h3>
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm mb-6 leading-relaxed">{{ error }}</p>
            <button 
              @click="fetchDashboardData"
              class="dashboard-button px-6 py-3 bg-[#EF4444] hover:bg-[#DC2626] text-white rounded-xl font-semibold shadow-lg"
            >
              Try Again
            </button>
          </div>
        </div>
      </div>

      <!-- Dashboard Content -->
      <main v-else-if="dashboardData" class="dashboard-grid p-8 page-enter">
        <!-- Welcome Section -->
        <section class="dashboard-card welcome-card stagger-1">
          <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="container-hover-subtle rounded-xl p-6 border shadow-sm">
            <h2 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-2xl font-bold mb-2">
              Welcome back, {{ dashboardData.user.name }} 👋
            </h2>
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-base leading-relaxed">Here's your health overview for today</p>
          </div>
        </section>

        <!-- Book Appointment Banner -->
        <section class="dashboard-card appointment-banner">
          <div class="bg-gradient-to-br from-[#14B8A6] to-[#0D9488] rounded-xl p-8 text-white relative overflow-hidden shadow-lg">
            <div class="relative z-10 flex items-center justify-between">
              <div class="flex-1">
                <h3 class="text-2xl font-bold mb-3">Book a New Appointment</h3>
                <p class="text-teal-50 mb-6 max-w-lg leading-relaxed">
                  Schedule a consultation with your preferred doctor in just a few steps. 
                  Get instant confirmation and digital prescriptions.
                </p>
                <div class="flex items-center gap-6 text-sm">
                  <div class="flex items-center gap-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <span>Available 24/7</span>
                  </div>
                  <div class="flex items-center gap-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <span>Verified Doctors</span>
                  </div>
                </div>
              </div>
              <div>
                <router-link 
                  to="/appointments"
                  class="dashboard-button inline-flex items-center gap-2 px-6 py-3 bg-white text-[#14B8A6] rounded-xl font-semibold shadow-lg"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                  </svg>
                  Book Now
                </router-link>
                <p class="text-xs text-teal-100 text-center mt-2">Takes less than 2 minutes</p>
              </div>
            </div>
          </div>
        </section>

        <!-- Stats and Help Section -->
        <section class="stats-grid grid grid-cols-4 gap-6 stagger-3">
          <!-- Stats Cards -->
          <div class="dashboard-card">
            <StatsCard 
              :value="dashboardData.stats.appointments" 
              label="Upcoming Appointments"
              icon="calendar"
              :is-dark="isDark"
            />
          </div>
          <div class="dashboard-card">
            <StatsCard 
              :value="dashboardData.stats.prescriptions" 
              label="Latest Prescription"
              icon="prescription"
              :is-dark="isDark"
            />
          </div>
          <div class="dashboard-card">
            <StatsCard 
              :value="dashboardData.stats.pending_tests" 
              label="Pending Test Results"
              icon="test"
              :is-dark="isDark"
            />
          </div>

          <!-- Need Help Card -->
          <div class="dashboard-card">
            <div class="bg-gradient-to-br from-[#3B82F6] to-[#2563EB] rounded-xl p-6 text-white shadow-lg h-full flex flex-col container-hover-subtle">
              <div class="flex items-center gap-2 mb-3">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <h3 class="font-semibold">Need Help?</h3>
              </div>
              <p class="text-sm text-blue-50 mb-4 leading-relaxed flex-1">
                Ask our AI Medical Assistant for quick answers about your health.
              </p>
              <button class="btn-primary w-full px-4 py-2.5 bg-white text-[#3B82F6] rounded-xl text-sm font-semibold">
                Ask Now
              </button>
            </div>
          </div>
        </section>

        <!-- Main Content Grid -->
        <section class="main-content-grid grid grid-cols-12 gap-8">
          <!-- Left Column (8/12) -->
          <div class="col-span-8 space-y-8">
            <!-- Next Appointment -->
            <div class="dashboard-card">
              <AppointmentCard 
                :appointment="dashboardData.nextAppointment" 
                :is-dark="isDark"
              />
            </div>

            <!-- Recent Medical Records -->
            <div class="dashboard-card">
              <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="container-hover-subtle rounded-xl p-6 border shadow-sm">
                <div class="flex items-center justify-between mb-6">
                  <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold">Recent Medical Records</h3>
                  <router-link 
                    to="/medical-records"
                    class="text-sm text-[#14B8A6] hover:text-[#0F9B8E] font-semibold smooth-transition"
                  >
                    View Full Records
                  </router-link>
                </div>
                <div class="space-y-3">
                  <MedicalRecordItem 
                    v-for="(record, index) in dashboardData.recentRecords" 
                    :key="index"
                    :record="record"
                    :is-dark="isDark"
                  />
                </div>
              </div>
            </div>
          </div>

          <!-- Right Column (4/12) -->
          <div class="col-span-4 space-y-8">
            <!-- Health Overview -->
            <div class="dashboard-card">
              <HealthOverview 
                :health-data="dashboardData.healthOverview" 
                :is-dark="isDark"
              />
            </div>

            <!-- Recent Activity -->
            <div class="dashboard-card">
              <ActivityTimeline 
                :activities="formattedActivities" 
                :is-dark="isDark"
              />
            </div>
          </div>
        </section>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import Sidebar from '../components/dashboard/Sidebar.vue'
import TopNavbar from '../components/dashboard/TopNavbar.vue'
import StatsCard from '../components/dashboard/StatsCard.vue'
import AppointmentCard from '../components/dashboard/AppointmentCard.vue'
import MedicalRecordItem from '../components/dashboard/MedicalRecordItem.vue'
import HealthOverview from '../components/dashboard/HealthOverview.vue'
import ActivityTimeline from '../components/dashboard/ActivityTimeline.vue'
import { dashboardAPI } from '../services/api.js'

const router = useRouter()

const dashboardData = ref(null)
const loading = ref(true)
const error = ref(null)
const isDark = ref(false)

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

const toggleTheme = (theme) => {
  isDark.value = theme === 'dark'
  localStorage.setItem('theme', theme)
}

const handleLogout = () => {
  if (confirm('Are you sure you want to logout?')) {
    localStorage.removeItem('authToken')
    router.push('/login')
  }
}

const fetchDashboardData = async () => {
  loading.value = true
  error.value = null
  
  try {
    // Fetch data from API
    dashboardData.value = await dashboardAPI.getDashboardData()
  } catch (err) {
    console.error('Error fetching dashboard data:', err)
    error.value = err.message
    
    // Use dummy data as fallback for development
    dashboardData.value = getDummyData()
  } finally {
    loading.value = false
  }
}

// Dummy data for development/testing
const getDummyData = () => ({
  user: {
    name: "Ahmed Yahia",
    username: "@y7ia007",
    avatar: "https://i.pravatar.cc/150?img=12"
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
    avatar: "https://i.pravatar.cc/150?img=47"
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

onMounted(() => {
  const savedTheme = localStorage.getItem('theme')
  if (savedTheme) {
    isDark.value = savedTheme === 'dark'
  }
  fetchDashboardData()
})
</script>
