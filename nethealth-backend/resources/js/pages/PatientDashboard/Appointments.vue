<script setup>
import { computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useDashboard } from '@/composables/useDashboard.js'
import CancelledAppointmentCard from '../components/appointments/CancelledAppointmentCard.vue'
import CompletedAppointmentCard from '../components/appointments/CompletedAppointmentCard.vue'
import ScheduledAppointmentCard from '../components/appointments/ScheduledAppointmentCard.vue'
import Sidebar from '../components/dashboard/Sidebar.vue'
import TopNavbar from '../components/dashboard/TopNavbar.vue'

const router = useRouter()
const { state, fetchAppointments, setTheme, cancelAppointment } = useDashboard()

// Computed properties
const isDark = computed(() => state.isDark)
const activeTab = computed({
    get: () => state.activeAppointmentTab || 'completed',
    set: (value) => { state.activeAppointmentTab = value }
})
const appointments = computed(() => state.appointments)
const loading = computed(() => state.loading.appointments)

const filteredAppointments = computed(() => {
    const statusMap = {
        'completed': 'Completed',
        'scheduled': 'Scheduled',
        'cancelled': 'Cancelled'
    }
    return appointments.value.filter(apt => apt.status === statusMap[activeTab.value])
})

// Methods
const toggleTheme = (theme) => {
    setTheme(theme)
}

const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('authToken')
        router.push('/login')
    }
}

const handleNewAppointment = () => {
    router.push('/appointments/create')
}

const handleViewPrescription = (appointment) => {
    console.log('View prescription:', appointment)
    router.push(`/prescription/${appointment.id}`)
}

const handleViewReport = (appointment) => {
    console.log('View report:', appointment)
    alert('Viewing report for ' + appointment.doctorName)
}

const handleUploadTestResults = (appointment) => {
    console.log('Upload test results:', appointment)
    alert('Upload test results for ' + appointment.doctorName)
}

const handleUploadImaging = (appointment) => {
    console.log('Upload imaging:', appointment)
    alert('Upload imaging for ' + appointment.doctorName)
}

const handleReschedule = (appointment) => {
    console.log('Reschedule:', appointment)
    alert('Reschedule appointment with ' + appointment.doctorName)
}

const handleCancelAppointment = (appointment) => {
    if (confirm('Are you sure you want to cancel this appointment?')) {
        cancelAppointment(appointment.id, 'Patient requested cancellation')
        alert('Appointment cancelled')
    }
}

// Lifecycle
onMounted(() => {
    if (state.appointments.length === 0) {
        fetchAppointments()
    }
})
</script>

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
        title="Appointments"
        :is-dark="isDark"
        :user="{ name: 'Ahmed Yahia', username: '@y7ia007', avatar: 'https://i.pravatar.cc/150?img=12' }"
        :notifications="[]"
        :show-last-viewed="true"
        :show-share="true"
        @logout="handleLogout"
      />

      <!-- Page Content -->
      <main class="p-6">
        <!-- Breadcrumb -->
        <div class="mb-6">
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-sm">
            <span class="text-gray-400">Appointments</span>
            <span class="mx-2">/</span>
            <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="font-medium">{{ activeTab === 'completed' ? 'Completed' : activeTab === 'scheduled' ? 'Scheduled' : 'Cancelled' }}</span>
          </p>
        </div>

        <!-- Tabs -->
        <div :class="isDark ? 'border-[#334155]' : 'border-[#E5E7EB]'" class="border-b mb-6">
          <div class="flex gap-8">
            <button
              @click="activeTab = 'completed'"
              :class="[
                'pb-4 px-2 border-b-2 transition-all duration-300 text-sm font-medium',
                activeTab === 'completed'
                  ? 'border-[#14B8A6] text-[#14B8A6]'
                  : isDark
                    ? 'border-transparent text-[#94A3B8] hover:text-[#F8FAFC]'
                    : 'border-transparent text-[#6B7280] hover:text-[#111827]'
              ]"
            >
              Completed
            </button>
            <button
              @click="activeTab = 'scheduled'"
              :class="[
                'pb-4 px-2 border-b-2 transition-all duration-300 text-sm font-medium',
                activeTab === 'scheduled'
                  ? 'border-[#14B8A6] text-[#14B8A6]'
                  : isDark
                    ? 'border-transparent text-[#94A3B8] hover:text-[#F8FAFC]'
                    : 'border-transparent text-[#6B7280] hover:text-[#111827]'
              ]"
            >
              Scheduled
            </button>
            <button
              @click="activeTab = 'cancelled'"
              :class="[
                'pb-4 px-2 border-b-2 transition-all duration-300 text-sm font-medium',
                activeTab === 'cancelled'
                  ? 'border-[#14B8A6] text-[#14B8A6]'
                  : isDark
                    ? 'border-transparent text-[#94A3B8] hover:text-[#F8FAFC]'
                    : 'border-transparent text-[#6B7280] hover:text-[#111827]'
              ]"
            >
              Cancelled
            </button>
          </div>
        </div>

        <!-- Page Header -->
        <div class="flex items-start justify-between mb-6">
          <div>
            <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-2xl font-bold mb-1">
              {{ activeTab === 'completed' ? 'Completed Appointments' : activeTab === 'scheduled' ? 'Scheduled Appointments' : 'Cancelled Appointments' }}
            </h1>
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
              {{ activeTab === 'completed' ? 'Review details from your past visits and download medical documentation.' : activeTab === 'scheduled' ? 'View and manage your upcoming appointments.' : 'Review cancelled appointments.' }}
            </p>
          </div>

          <button
            @click="handleNewAppointment"
            class="px-4 py-2 bg-[#14B8A6] hover:bg-[#0F9B8E] text-white rounded-lg text-sm font-semibold transition-colors flex items-center gap-2"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
            </svg>
            New Appointment
          </button>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div v-for="i in 6" :key="i" class="animate-pulse">
            <div :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="h-96 rounded-xl"></div>
          </div>
        </div>

        <!-- Appointments Grid -->
        <div v-else>
          <!-- Completed & Scheduled: 2-column grid -->
          <div v-if="activeTab !== 'cancelled'" class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <!-- Completed Appointments -->
            <CompletedAppointmentCard
              :v-if="activeTab === 'completed'"
              v-for="appointment in filteredAppointments"
              :key="appointment.id"
              :appointment="appointment"
              :is-dark="isDark"
              @view-prescription="handleViewPrescription"
              @view-report="handleViewReport"
            />

            <!-- Scheduled Appointments -->
            <ScheduledAppointmentCard
              :v-if="activeTab === 'scheduled'"
              v-for="appointment in filteredAppointments"
              :key="appointment.id"
              :appointment="appointment"
              :is-dark="isDark"
              @upload-test-results="handleUploadTestResults"
              @upload-imaging="handleUploadImaging"
              @reschedule="handleReschedule"
              @cancel="handleCancelAppointment"
            />
          </div>

          <!-- Cancelled: Single column -->
          <div v-else class="space-y-4">
            <CancelledAppointmentCard
              v-for="appointment in filteredAppointments"
              :key="appointment.id"
              :appointment="appointment"
              :is-dark="isDark"
              @reschedule="handleReschedule"
            />
          </div>
        </div>

        <!-- Empty State -->
        <div v-if="!loading && filteredAppointments.length === 0" :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="border rounded-lg p-12 text-center">
          <svg class="w-16 h-16 mx-auto mb-4" :class="isDark ? 'text-[#94A3B8]' : 'text-gray-400'" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
          </svg>
          <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold mb-2">No Appointments Found</h3>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">You don't have any {{ activeTab }} appointments yet.</p>
        </div>
      </main>
    </div>
  </div>
</template>


