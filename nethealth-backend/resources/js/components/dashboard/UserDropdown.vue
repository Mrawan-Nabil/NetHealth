<template>
  <div class="relative" ref="dropdownRef">
    <button 
      @click="toggleDropdown"
      :class="isDark ? 'hover:bg-[#1E293B]' : 'hover:bg-[#F8FAFC]'"
      class="flex items-center gap-3 px-3 py-2 rounded-lg transition-all duration-200 hover:shadow-sm"
    >
      <img 
        :src="user.avatar || 'https://i.pravatar.cc/150?img=12'" 
        :alt="user.name"
        class="w-9 h-9 rounded-full object-cover ring-2 ring-gray-100 transition-all duration-200"
        :class="isDark ? 'ring-gray-700' : 'ring-gray-100'"
      />
      <div class="flex flex-col text-left">
        <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">{{ user.name }}</span>
        <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs">{{ user.username }}</span>
      </div>
      <svg 
        :class="[isOpen ? 'rotate-180' : '', isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]']"
        class="w-4 h-4 transition-all duration-200"
        fill="none" 
        stroke="currentColor" 
        viewBox="0 0 24 24"
      >
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
      </svg>
    </button>

    <Transition name="dropdown">
      <div v-if="isOpen" :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="absolute right-0 mt-2 w-64 rounded-xl shadow-lg border overflow-hidden z-50">
        <!-- User Info -->
        <div :class="isDark ? 'bg-[#111827] border-[#334155]' : 'bg-[#F8FAFC] border-[#E5E7EB]'" class="px-6 py-4 border-b">
          <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">{{ user.name }}</p>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs">{{ user.email || user.username }}</p>
        </div>

        <!-- Menu Items -->
        <div class="py-2">
          <button
            @click="handleProfile"
            :class="isDark ? 'hover:bg-[#334155]/50' : 'hover:bg-[#F8FAFC]'"
            class="w-full px-6 py-3 flex items-center gap-3 transition-all duration-200 text-left"
          >
            <svg :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
            </svg>
            <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-medium">Profile</span>
          </button>

          <button
            @click="handleSettings"
            :class="isDark ? 'hover:bg-[#334155]/50' : 'hover:bg-[#F8FAFC]'"
            class="w-full px-6 py-3 flex items-center gap-3 transition-all duration-200 text-left"
          >
            <svg :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/>
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
            </svg>
            <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-medium">Settings</span>
          </button>

          <button
            @click="handleHelp"
            :class="isDark ? 'hover:bg-[#334155]/50' : 'hover:bg-[#F8FAFC]'"
            class="w-full px-6 py-3 flex items-center gap-3 transition-all duration-200 text-left"
          >
            <svg :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-medium">Help & Support</span>
          </button>
        </div>

        <!-- Logout -->
        <div :class="isDark ? 'border-[#334155]' : 'border-[#E5E7EB]'" class="border-t py-2">
          <button
            @click="handleLogout"
            class="w-full px-6 py-3 flex items-center gap-3 hover:bg-[#EF4444]/10 transition-all duration-200 text-left"
          >
            <svg class="w-5 h-5 text-[#EF4444]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
            </svg>
            <span class="text-sm font-medium text-[#EF4444]">Logout</span>
          </button>
        </div>
      </div>
    </Transition>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'

const props = defineProps({
  user: {
    type: Object,
    required: true
  },
  isDark: Boolean
})

const emit = defineEmits(['logout'])

const router = useRouter()
const isOpen = ref(false)
const dropdownRef = ref(null)

const toggleDropdown = () => {
  isOpen.value = !isOpen.value
}

const handleProfile = () => {
  isOpen.value = false
  router.push('/profile')
}

const handleSettings = () => {
  isOpen.value = false
  router.push('/settings')
}

const handleHelp = () => {
  isOpen.value = false
  // Open help modal or navigate to help page
}

const handleLogout = () => {
  isOpen.value = false
  emit('logout')
  router.push('/login')
}

const handleClickOutside = (event) => {
  if (dropdownRef.value && !dropdownRef.value.contains(event.target)) {
    isOpen.value = false
  }
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>

<style scoped>
.dropdown-enter-active,
.dropdown-leave-active {
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}

.dropdown-enter-from,
.dropdown-leave-to {
  opacity: 0;
  transform: translateY(-8px) scale(0.95);
}
</style>
