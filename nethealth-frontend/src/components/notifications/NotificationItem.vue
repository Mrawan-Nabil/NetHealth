<template>
  <div 
    :class="[
      'flex items-start gap-4 p-4 rounded-lg transition-all duration-300',
      isDark ? 'bg-[#1E293B] hover:bg-[#334155]' : 'bg-white hover:bg-gray-50',
      !notification.read && 'border-l-2 border-[#14B8A6]'
    ]"
  >
    <!-- Icon -->
    <div 
      class="w-10 h-10 rounded-lg flex items-center justify-center flex-shrink-0"
      :style="{ backgroundColor: getIconBg(notification.type) }"
    >
      <div v-html="getIcon(notification.type)"></div>
    </div>

    <!-- Content -->
    <div class="flex-1 min-w-0">
      <!-- Title -->
      <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold mb-1">
        {{ notification.title }}
      </h3>
      
      <!-- Description -->
      <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm mb-2 leading-relaxed">
        {{ notification.description }}
      </p>

      <!-- Footer: Time and Badge -->
      <div class="flex items-center gap-3">
        <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-xs">
          {{ notification.time }}
        </span>
        <span 
          class="text-[10px] font-semibold uppercase px-2 py-0.5 rounded"
          :style="{ 
            backgroundColor: getBadgeBg(notification.type),
            color: getBadgeColor(notification.type)
          }"
        >
          {{ notification.badge }}
        </span>
      </div>
    </div>

    <!-- Unread Indicator -->
    <div v-if="!notification.read" class="w-2 h-2 bg-[#14B8A6] rounded-full flex-shrink-0 mt-2"></div>
  </div>
</template>

<script setup>
const props = defineProps({
  notification: {
    type: Object,
    required: true
  },
  isDark: {
    type: Boolean,
    default: false
  }
})

const getIconBg = (type) => {
  const colors = {
    'appointment': '#DBEAFE',
    'prescription': '#D1FAE5',
    'lab': '#F3E8FF',
    'message': '#FED7AA'
  }
  return colors[type] || '#F3F4F6'
}

const getIcon = (type) => {
  const icons = {
    'appointment': '<svg class="w-5 h-5 text-[#3B82F6]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>',
    'prescription': '<svg class="w-5 h-5 text-[#10B981]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>',
    'lab': '<svg class="w-5 h-5 text-[#A855F7]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"/></svg>',
    'message': '<svg class="w-5 h-5 text-[#F97316]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>'
  }
  return icons[type] || icons['message']
}

const getBadgeBg = (type) => {
  const colors = {
    'appointment': '#DBEAFE',
    'prescription': '#D1FAE5',
    'lab': '#F3E8FF',
    'message': '#FED7AA'
  }
  return colors[type] || '#F3F4F6'
}

const getBadgeColor = (type) => {
  const colors = {
    'appointment': '#1E40AF',
    'prescription': '#065F46',
    'lab': '#7C3AED',
    'message': '#C2410C'
  }
  return colors[type] || '#4B5563'
}
</script>
