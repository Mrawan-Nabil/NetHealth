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
        title="Medical Record"
        :user="currentUser"
        :notifications="notifications"
        :is-dark="isDark"
        :show-last-viewed="true"
        :show-share="true"
        last-viewed="10 mins ago"
        @mark-read="handleMarkRead"
        @mark-all-read="handleMarkAllRead"
        @notification-click="handleNotificationClick"
        @logout="handleLogout"
      />

      <!-- Page Content -->
      <main class="p-6">
        <!-- Breadcrumb -->
        <div class="mb-6">
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
            <span class="text-gray-400">Medical Record</span>
            <span class="mx-2">/</span>
            <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="font-medium">Prescription</span>
          </p>
        </div>

        <!-- Tabs Navigation -->
        <TabsNavigation 
          :active-tab="'prescription'"
          :is-dark="isDark"
          @change="handleTabChange"
        />

        <!-- Prescriptions Grid -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <PrescriptionCard
            v-for="prescription in prescriptions"
            :key="prescription.id"
            :prescription="prescription"
            :is-dark="isDark"
            @download="handleDownload"
            @view-details="handleViewDetails"
          />
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted } from 'vue'
import { router, Link } from '@inertiajs/vue3'
import { useDashboard } from '../composables/useDashboard'
import Sidebar from '../components/dashboard/Sidebar.vue'
import TopNavbar from '../components/dashboard/TopNavbar.vue'
import TabsNavigation from '../components/medical/TabsNavigation.vue'
import PrescriptionCard from '../components/medical/PrescriptionCard.vue'

const { state, setTheme } = useDashboard()

// LARAVEL DATA BINDING: Expects Array prescriptions, Array notifications, Object currentUser
const props = defineProps({
  prescriptions: {
    type: Array,
    required: true,
    default: () => []
  },
  notifications: {
    type: Array,
    default: () => []
  },
  currentUser: {
    type: Object,
    required: true,
    default: () => ({})
  }
})

// Computed properties
const isDark = computed(() => state.isDark)
const toggleTheme = (theme) => {
  setTheme(theme)
}

const handleLogout = () => {
  if (confirm('Are you sure you want to logout?')) {
    localStorage.removeItem('authToken')
    router.get('/logout')
  }
}

const handleTabChange = (tabId) => {
  if (tabId === 'test-results') {
    router.get('/test-results')
  } else if (tabId === 'imaging') {
    router.get('/imaging')
  } else if (tabId === 'visit-history') {
    router.get('/visit-history')
  }
}

const handleDownload = (prescription) => {
  console.log('Downloading prescription:', prescription)
  alert(`Downloading prescription from ${prescription.doctor}`)
}

const handleViewDetails = (prescription) => {
  console.log('Viewing details:', prescription)
  router.get(`/prescription/${prescription.id}`)
}

const handleMarkRead = (id) => {
  console.log('Mark notification as read:', id)
}

const handleMarkAllRead = () => {
  console.log('Mark all notifications as read')
}

const handleNotificationClick = (notification) => {
  console.log('Notification clicked:', notification)
  if (notification.link) {
    router.get(notification.link)
  }
}

// Lifecycle
onMounted(() => {
  // Data provided by Inertia Props
})
</script>
