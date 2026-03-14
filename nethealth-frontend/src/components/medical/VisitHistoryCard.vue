<template>
  <div 
    :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'"
    class="border rounded-xl p-5 transition-all duration-300 hover:shadow-md"
  >
    <div class="flex items-center justify-between">
      <!-- Left Section: Doctor Info -->
      <div class="flex items-center gap-4">
        <!-- Avatar -->
        <div 
          class="w-12 h-12 rounded-full flex items-center justify-center text-lg font-semibold"
          :style="{ backgroundColor: visit.avatarBg, color: visit.avatarColor }"
        >
          {{ visit.doctorInitials }}
        </div>

        <!-- Doctor Details -->
        <div class="flex flex-col">
          <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold">
            {{ visit.doctorName }}
          </h3>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
            {{ visit.specialty }}
          </p>
        </div>
      </div>

      <!-- Middle Section: Clinic, Date, Time, Type -->
      <div class="flex items-center gap-8">
        <!-- Clinic -->
        <div class="flex flex-col gap-1">
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-[10px] uppercase tracking-wide font-medium">
            CLINIC
          </p>
          <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-medium">
            {{ visit.clinic }}
          </p>
          <span 
            v-if="visit.visitType"
            :class="isDark ? 'bg-[#334155] text-[#94A3B8]' : 'bg-[#F3F4F6] text-[#6B7280]'"
            class="text-[10px] uppercase font-semibold px-2 py-0.5 rounded inline-block w-fit"
          >
            {{ visit.visitType }}
          </span>
        </div>

        <!-- Date -->
        <div class="flex items-center gap-2">
          <svg class="w-4 h-4 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
          </svg>
          <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-medium">
            {{ visit.date }}
          </span>
        </div>

        <!-- Time -->
        <div class="flex items-center gap-2">
          <svg class="w-4 h-4 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
          </svg>
          <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-medium">
            {{ visit.time }}
          </span>
        </div>
      </div>

      <!-- Right Section: Status Badge -->
      <div>
        <span 
          :class="getStatusClass(visit.status)"
          class="px-4 py-1.5 rounded-full text-xs font-semibold inline-flex items-center gap-1.5"
        >
          <span class="w-1.5 h-1.5 rounded-full" :class="getStatusDotClass(visit.status)"></span>
          {{ visit.status }}
        </span>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  visit: {
    type: Object,
    required: true
  },
  isDark: {
    type: Boolean,
    default: false
  }
})

const getStatusClass = (status) => {
  const classes = {
    'Completed': 'bg-[#D1FAE5] text-[#065F46]',
    'Upcoming': 'bg-[#DBEAFE] text-[#1E40AF]',
    'Cancelled': 'bg-[#FEE2E2] text-[#991B1B]'
  }
  return classes[status] || 'bg-gray-100 text-gray-800'
}

const getStatusDotClass = (status) => {
  const classes = {
    'Completed': 'bg-[#10B981]',
    'Upcoming': 'bg-[#3B82F6]',
    'Cancelled': 'bg-[#EF4444]'
  }
  return classes[status] || 'bg-gray-500'
}
</script>
