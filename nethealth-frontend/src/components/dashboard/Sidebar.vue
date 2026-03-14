<template>
  <aside :class="isDark ? 'bg-[#111827] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="w-64 h-screen flex flex-col fixed left-0 top-0 border-r transition-all duration-300">
    <!-- Logo -->
    <div class="p-6 pb-4 flex items-center gap-3">
      <div class="w-12 h-12 bg-gradient-to-br from-[#14B8A6] to-[#0D9488] rounded-xl flex items-center justify-center shadow-lg">
        <svg class="w-7 h-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
        </svg>
      </div>
      <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-xl font-bold">NetHealth</span>
    </div>

    <!-- Search -->
    <div class="px-6 mb-6">
      <div class="relative">
        <svg class="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-[#6B7280]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
        </svg>
        <input 
          type="text" 
          placeholder="Search" 
          :class="isDark ? 'bg-[#1E293B] text-[#F8FAFC] placeholder-[#94A3B8] border-[#334155]' : 'bg-[#F8FAFC] text-[#111827] placeholder-[#6B7280] border-[#E5E7EB]'"
          class="w-full pl-9 pr-4 py-2.5 rounded-lg border focus:outline-none focus:ring-2 focus:ring-[#14B8A6]/20 focus:border-[#14B8A6] transition-all duration-200 text-sm"
        />
      </div>
    </div>

    <!-- Navigation -->
    <nav class="flex-1 px-6 overflow-y-auto">
      <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs font-semibold uppercase tracking-wide mb-4 px-3">General</p>
      <ul class="space-y-1">
        <li v-for="item in menuItems" :key="item.name">
          <component
            :is="item.name === 'Logout' ? 'button' : 'router-link'"
            :to="item.name !== 'Logout' ? item.path : undefined"
            @click="item.name === 'Logout' ? handleLogout() : null"
            :class="[
              item.name !== 'Logout' && isActive(item.path) 
                ? isDark ? 'bg-[#14B8A6]/10 text-[#2DD4BF] border-[#14B8A6]/20' : 'bg-[#14B8A6]/10 text-[#14B8A6] border-[#14B8A6]/20'
                : isDark ? 'text-[#94A3B8] hover:bg-[#1E293B] hover:text-[#F8FAFC]' : 'text-[#6B7280] hover:bg-[#F8FAFC] hover:text-[#111827]',
              item.name === 'Logout' ? isDark ? 'text-[#EF4444] hover:bg-red-500/10' : 'text-[#EF4444] hover:bg-red-50 hover:text-[#DC2626]' : ''
            ]"
            class="flex items-center gap-3 px-3 py-2.5 rounded-lg transition-all duration-200 w-full text-left border border-transparent"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" v-html="item.iconPath"></svg>
            <span class="font-medium text-sm">{{ item.name }}</span>
          </component>
        </li>
      </ul>
    </nav>

    <!-- Theme Toggle -->
    <div :class="isDark ? 'border-[#334155]' : 'border-[#E5E7EB]'" class="p-6 border-t">
      <div :class="isDark ? 'bg-[#1E293B]' : 'bg-[#F8FAFC]'" class="flex items-center rounded-lg p-1">
        <button 
          @click="setTheme('light')"
          :class="!isDark ? 'bg-white shadow-sm text-[#111827]' : 'text-[#94A3B8] hover:bg-[#334155]'"
          class="flex-1 flex items-center justify-center gap-2 py-2 rounded-md transition-all duration-200"
        >
          <svg class="w-4 h-4" :class="!isDark ? 'text-[#F59E0B]' : 'text-[#94A3B8]'" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"/>
          </svg>
          <span class="text-xs font-medium">Light</span>
        </button>
        <button 
          @click="setTheme('dark')"
          :class="isDark ? 'bg-[#14B8A6] shadow-lg text-white' : 'text-[#6B7280] hover:bg-gray-200'"
          class="flex-1 flex items-center justify-center gap-2 py-2 rounded-md transition-all duration-200"
        >
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"/>
          </svg>
          <span class="text-xs font-medium">Dark</span>
        </button>
      </div>
    </div>
  </aside>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'

const props = defineProps({
  isDark: Boolean
})

const emit = defineEmits(['toggle-theme', 'logout'])

const router = useRouter()
const route = useRoute()

// Menu items with SVG paths instead of component objects
const menuItems = [
  { 
    name: 'Home', 
    path: '/dashboard', 
    iconPath: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>'
  },
  { 
    name: 'Profile', 
    path: '/profile', 
    iconPath: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>'
  },
  { 
    name: 'Medical Record', 
    path: '/medical-records', 
    iconPath: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>'
  },
  { 
    name: 'Appointments', 
    path: '/appointments', 
    iconPath: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>'
  },
  { 
    name: 'Notification', 
    path: '/notifications', 
    iconPath: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>'
  },
  { 
    name: 'Logout', 
    path: '', 
    iconPath: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>'
  }
]

const isActive = (path) => {
  if (!path || path === '') return false
  
  // Dashboard/Home
  if (path === '/dashboard') {
    return route.path === '/dashboard' || route.path === '/'
  }
  
  // Medical Records - includes all medical record sub-pages
  if (path === '/medical-records') {
    return route.path.startsWith('/medical-records') || 
           route.path.startsWith('/prescription/') ||
           route.path.startsWith('/test-results') ||
           route.path.startsWith('/imaging') ||
           route.path.startsWith('/visit-history')
  }
  
  // Appointments - includes create appointment and doctor profile
  if (path === '/appointments') {
    return route.path.startsWith('/appointments') || 
           route.path.startsWith('/doctor/')
  }
  
  // Notifications
  if (path === '/notifications') {
    return route.path === '/notifications'
  }
  
  // Profile
  if (path === '/profile') {
    return route.path === '/profile'
  }
  
  return route.path.startsWith(path)
}

const setTheme = (theme) => {
  emit('toggle-theme', theme)
}

const handleLogout = () => {
  emit('logout')
}
</script>
