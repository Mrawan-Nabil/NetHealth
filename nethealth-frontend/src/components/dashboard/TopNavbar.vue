<template>
  <nav :class="isDark ? 'bg-[#111827] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="px-8 py-4 flex items-center justify-between border-b transition-all duration-300 shadow-sm">
    <div class="flex items-center gap-6">
      <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-xl font-semibold">{{ title }}</h1>
    </div>

    <div class="flex items-center gap-4">
      <!-- Last Viewed -->
      <div v-if="showLastViewed" :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="flex items-center gap-2 text-xs">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        <span>Last viewed {{ lastViewed }}</span>
      </div>

      <!-- Share Button -->
      <button v-if="showShare" :class="isDark ? 'bg-[#14B8A6] hover:bg-[#2DD4BF] shadow-lg shadow-teal-500/20' : 'bg-[#111827] hover:bg-black'" class="px-4 py-2 text-white rounded-lg text-sm font-medium transition-all duration-300">
        Share
      </button>

      <!-- Notification Dropdown -->
      <NotificationDropdown 
        :is-dark="isDark"
        :notifications="notifications"
        @mark-read="handleMarkRead"
        @mark-all-read="handleMarkAllRead"
        @click="handleNotificationClick"
      />

      <!-- User Dropdown -->
      <UserDropdown 
        :is-dark="isDark"
        :user="user"
        @logout="handleLogout"
      />
    </div>
  </nav>
</template>

<script setup>
import NotificationDropdown from './NotificationDropdown.vue'
import UserDropdown from './UserDropdown.vue'

defineProps({
  title: {
    type: String,
    default: 'Dashboard'
  },
  user: {
    type: Object,
    required: true
  },
  lastViewed: {
    type: String,
    default: '10 mins ago'
  },
  showLastViewed: {
    type: Boolean,
    default: true
  },
  showShare: {
    type: Boolean,
    default: true
  },
  notifications: {
    type: Array,
    default: () => []
  },
  isDark: Boolean
})

const emit = defineEmits(['mark-read', 'mark-all-read', 'notification-click', 'logout'])

const handleMarkRead = (id) => {
  emit('mark-read', id)
}

const handleMarkAllRead = () => {
  emit('mark-all-read')
}

const handleNotificationClick = (notification) => {
  emit('notification-click', notification)
}

const handleLogout = () => {
  emit('logout')
}
</script>
