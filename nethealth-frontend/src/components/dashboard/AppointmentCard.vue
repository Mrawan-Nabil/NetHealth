<template>
  <div 
    :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" 
    class="container-hover-subtle rounded-xl p-6 border shadow-sm"
  >
    <div class="flex items-start justify-between mb-6">
      <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold">Next Appointment</h3>
      <span 
        v-if="appointment"
        :class="isDark ? 'bg-[#10B981]/10 text-[#10B981]' : 'bg-[#10B981]/10 text-[#10B981]'"
        class="px-3 py-1 rounded-full text-xs font-semibold"
      >
        {{ appointment.status }}
      </span>
    </div>

    <div v-if="appointment" class="space-y-6">
      <div class="flex items-start gap-4">
        <img 
          :src="appointment.avatar || 'https://i.pravatar.cc/150?img=47'" 
          :alt="appointment.doctor"
          class="w-14 h-14 rounded-full object-cover flex-shrink-0 ring-2 smooth-transition"
          :class="isDark ? 'ring-[#334155]' : 'ring-gray-100'"
        />
        <div class="flex-1 min-w-0">
          <h4 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="font-semibold text-base mb-1">{{ appointment.doctor }}</h4>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm mb-3">{{ appointment.specialty }}</p>
          <div class="space-y-1">
            <div class="flex items-center gap-2">
              <svg :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
              <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">{{ appointment.time }}</p>
            </div>
            <div class="flex items-center gap-2">
              <svg :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
              </svg>
              <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">{{ appointment.location }}</p>
            </div>
          </div>
        </div>
      </div>

      <div class="flex gap-3">
        <button 
          @click="handleViewDetails"
          class="btn-primary flex-1 px-4 py-3 bg-[#14B8A6] hover:bg-[#0F9B8E] text-white rounded-lg text-sm font-medium"
        >
          View Details
        </button>
        <button 
          @click="handleReschedule"
          :class="[
            'btn-secondary flex-1 px-4 py-3 rounded-lg text-sm font-medium border',
            isDark 
              ? 'bg-[#334155] text-[#94A3B8] hover:bg-[#475569] hover:text-[#F8FAFC] border-[#334155]' 
              : 'bg-[#F8FAFC] text-[#6B7280] hover:bg-[#E5E7EB] hover:text-[#111827] border-[#E5E7EB]'
          ]"
        >
          Reschedule
        </button>
      </div>
    </div>

    <div v-else class="text-center py-12">
      <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
        <svg :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
        </svg>
      </div>
      <h4 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="font-semibold mb-1">No upcoming appointments</h4>
      <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">Schedule your next appointment to get started</p>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  appointment: {
    type: Object,
    default: null
  },
  isDark: Boolean
})

const emit = defineEmits(['view-details', 'reschedule'])

const statusClass = computed(() => {
  const status = props.appointment?.status?.toLowerCase()
  const classes = {
    confirmed: 'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400',
    pending: 'bg-yellow-100 text-yellow-700 dark:bg-yellow-900/30 dark:text-yellow-400',
    cancelled: 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400'
  }
  return classes[status] || 'bg-gray-100 text-gray-700'
})

const handleViewDetails = () => {
  emit('view-details', props.appointment)
}

const handleReschedule = () => {
  emit('reschedule', props.appointment)
}
</script>
