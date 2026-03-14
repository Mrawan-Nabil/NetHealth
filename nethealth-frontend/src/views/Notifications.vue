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
        title="Notifications"
        :is-dark="isDark"
        :user="{ name: 'Ahmed Yahia', username: '@y7ia007', avatar: 'https://i.pravatar.cc/150?img=12' }"
        :notifications="[]"
        :show-last-viewed="false"
        :show-share="false"
        @logout="handleLogout"
      />

      <!-- Page Content -->
      <main class="p-6 max-w-4xl">
        <!-- Page Header -->
        <div class="mb-6">
          <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-2xl font-bold mb-1">
            Notifications
          </h1>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
            Stay updated with your latest healthcare activities and reminders.
          </p>
        </div>

        <!-- Action Buttons -->
        <div class="flex items-center gap-3 mb-6">
          <button 
            @click="markAllAsRead"
            class="px-4 py-2 bg-[#14B8A6] hover:bg-[#0F9B8E] text-white rounded-lg text-sm font-semibold transition-colors flex items-center gap-2"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
            </svg>
            Mark All as Read
          </button>
          <button 
            @click="clearAll"
            :class="isDark ? 'border-red-500/50 text-red-400 hover:bg-red-500/10' : 'border-red-300 text-red-600 hover:bg-red-50'"
            class="px-4 py-2 border rounded-lg text-sm font-semibold transition-colors flex items-center gap-2"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
            </svg>
            Clear All
          </button>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="space-y-4">
          <div v-for="i in 5" :key="i" class="animate-pulse">
            <div :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="h-24 rounded-lg"></div>
          </div>
        </div>

        <!-- Notifications List -->
        <div v-else class="space-y-6">
          <!-- Today Section -->
          <div v-if="todayNotifications.length > 0">
            <h2 :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-xs font-semibold uppercase tracking-wider mb-3">
              Today
            </h2>
            <div class="space-y-2">
              <NotificationItem
                v-for="notification in todayNotifications"
                :key="notification.id"
                :notification="notification"
                :is-dark="isDark"
              />
            </div>
          </div>

          <!-- Yesterday Section -->
          <div v-if="yesterdayNotifications.length > 0">
            <h2 :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-xs font-semibold uppercase tracking-wider mb-3">
              Yesterday
            </h2>
            <div class="space-y-2">
              <NotificationItem
                v-for="notification in yesterdayNotifications"
                :key="notification.id"
                :notification="notification"
                :is-dark="isDark"
              />
            </div>
          </div>

          <!-- Empty State -->
          <div v-if="notifications.length === 0" :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="border rounded-lg p-12 text-center">
            <svg class="w-16 h-16 mx-auto mb-4" :class="isDark ? 'text-[#94A3B8]' : 'text-gray-400'" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>
            </svg>
            <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold mb-2">No Notifications</h3>
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">You're all caught up! Check back later for updates.</p>
          </div>
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
import NotificationItem from '../components/notifications/NotificationItem.vue'

const router = useRouter()
const { 
  state, 
  fetchNotifications, 
  setTheme, 
  markAllNotificationsAsRead, 
  clearAllNotifications 
} = useDashboard()

// Computed properties
const isDark = computed(() => state.isDark)
const notifications = computed(() => state.notifications)
const loading = computed(() => state.loading.notifications)

const todayNotifications = computed(() => {
  return notifications.value.filter(n => n.date === 'today')
})

const yesterdayNotifications = computed(() => {
  return notifications.value.filter(n => n.date === 'yesterday')
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

const markAllAsRead = () => {
  markAllNotificationsAsRead()
}

const clearAll = () => {
  if (confirm('Are you sure you want to clear all notifications?')) {
    clearAllNotifications()
  }
}

// Lifecycle
onMounted(() => {
  if (state.notifications.length === 0) {
    fetchNotifications()
  }
})
</script>
