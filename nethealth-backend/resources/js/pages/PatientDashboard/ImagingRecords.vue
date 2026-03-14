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
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-sm">
            <router-link to="/medical-records" class="hover:text-[#14B8A6] transition-colors">Medical Record</router-link>
            <span class="mx-2">/</span>
            <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="font-medium">Imaging</span>
          </p>
        </div>

        <!-- Tabs Navigation -->
        <TabsNavigation 
          :active-tab="'imaging'"
          :is-dark="isDark"
          @change="handleTabChange"
        />

        <!-- Page Header -->
        <div class="mb-6">
          <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-2xl font-bold mb-1">
            Imaging Records
          </h1>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
            View and manage diagnostic imaging reports for the current quarter.
          </p>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="grid grid-cols-2 gap-6">
          <div v-for="i in 4" :key="i" class="animate-pulse">
            <div :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="h-80 rounded-lg"></div>
          </div>
        </div>

        <!-- Error State -->
        <div v-else-if="error" :class="isDark ? 'bg-red-500/10 border-red-500/20' : 'bg-red-50 border-red-200'" class="border rounded-lg p-6 text-center">
          <p :class="isDark ? 'text-red-400' : 'text-red-600'" class="text-sm">{{ error }}</p>
          <button 
            @click="fetchImagingRecords"
            class="mt-4 px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-lg text-sm font-medium transition-colors"
          >
            Try Again
          </button>
        </div>

        <!-- Imaging Records Grid -->
        <div v-else class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <ImagingRecordCard
            v-for="record in imagingRecords"
            :key="record.id"
            :record="record"
            :is-dark="isDark"
            @view-file="handleViewFile"
            @download="handleDownload"
          />
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useDashboard } from '../composables/useDashboard'
import Sidebar from '../components/dashboard/Sidebar.vue'
import TopNavbar from '../components/dashboard/TopNavbar.vue'
import TabsNavigation from '../components/medical/TabsNavigation.vue'
import ImagingRecordCard from '../components/medical/ImagingRecordCard.vue'

const router = useRouter()
const { state, fetchImagingRecords, setTheme } = useDashboard()

// Computed properties
const isDark = computed(() => state.isDark)
const imagingRecords = computed(() => state.imagingRecords)
const loading = computed(() => state.loading.imagingRecords)
const error = computed(() => state.errors.imagingRecords)
const currentUser = computed(() => state.user)
const notifications = computed(() => state.notifications)

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

const handleTabChange = (tabId) => {
  if (tabId === 'prescription') {
    router.push('/medical-records')
  } else if (tabId === 'test-results') {
    router.push('/test-results')
  } else if (tabId === 'imaging') {
    router.push('/imaging')
  } else if (tabId === 'visit-history') {
    router.push('/visit-history')
  }
}

const handleViewFile = (record) => {
  console.log('Viewing file:', record)
  router.push(`/imaging/${record.id}`)
}

const handleDownload = (record) => {
  console.log('Downloading:', record)
  alert(`Downloading ${record.file.name}`)
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
    router.push(notification.link)
  }
}

// Lifecycle
onMounted(() => {
  if (state.imagingRecords.length === 0) {
    fetchImagingRecords()
  }
})
</script>
