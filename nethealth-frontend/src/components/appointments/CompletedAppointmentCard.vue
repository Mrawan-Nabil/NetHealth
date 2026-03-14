<template>
  <div 
    :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'"
    class="border rounded-xl p-5 transition-all duration-300"
  >
    <!-- Header: Doctor Info & Status -->
    <div class="flex items-start justify-between mb-4">
      <div class="flex items-center gap-3">
        <img 
          :src="appointment.doctorAvatar" 
          alt="Doctor"
          class="w-12 h-12 rounded-full object-cover"
        />
        <div>
          <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold">
            {{ appointment.doctorName }}
          </h3>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
            {{ appointment.specialty }}
          </p>
        </div>
      </div>
      <span class="px-3 py-1 bg-[#D1FAE5] text-[#065F46] rounded-full text-xs font-semibold">
        {{ appointment.status }}
      </span>
    </div>

    <!-- Date & Time -->
    <div class="mb-3">
      <h4 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold mb-1">
        Date & Time
      </h4>
      <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
        {{ appointment.dateTime }}
      </p>
    </div>

    <!-- Clinic Address -->
    <div class="mb-4">
      <h4 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold mb-1">
        Clinic Address
      </h4>
      <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
        {{ appointment.clinicAddress }}
      </p>
    </div>

    <!-- Reports & X-rays Section -->
    <div 
      :class="isDark ? 'bg-[#0F766E]/10 border-[#14B8A6]/20' : 'bg-[#CCFBF1] border-[#14B8A6]/30'"
      class="border rounded-lg p-3 mb-4"
    >
      <div class="flex items-center gap-2 mb-2">
        <svg class="w-4 h-4 text-[#F97316]" fill="currentColor" viewBox="0 0 20 20">
          <path d="M2 6a2 2 0 012-2h5l2 2h5a2 2 0 012 2v6a2 2 0 01-2 2H4a2 2 0 01-2-2V6z"/>
        </svg>
        <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">
          Reports & X-rays
        </span>
      </div>

      <!-- Files -->
      <div v-if="appointment.reports && appointment.reports.length > 0" class="space-y-2">
        <div 
          v-for="report in appointment.reports" 
          :key="report.name"
          :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'"
          class="flex items-center gap-2 px-3 py-2 border rounded-lg"
        >
          <svg class="w-4 h-4 text-[#EF4444]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"/>
          </svg>
          <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-xs font-medium flex-1">
            {{ report.name }}
          </span>
        </div>
      </div>

      <!-- No Reports -->
      <div v-else class="flex items-center gap-2">
        <svg class="w-4 h-4" :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"/>
        </svg>
        <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs">
          No reports uploaded
        </span>
      </div>
    </div>

    <!-- Action Buttons -->
    <div class="grid grid-cols-2 gap-3">
      <button 
        @click="$emit('view-prescription', appointment)"
        class="px-4 py-2.5 bg-[#14B8A6] hover:bg-[#0F9B8E] text-white rounded-lg text-sm font-semibold transition-colors flex items-center justify-center gap-2"
      >
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
        </svg>
        Prescription
      </button>
      <button 
        @click="$emit('view-report', appointment)"
        :disabled="!appointment.reports || appointment.reports.length === 0"
        :class="[
          'px-4 py-2.5 rounded-lg text-sm font-semibold transition-colors flex items-center justify-center gap-2',
          appointment.reports && appointment.reports.length > 0
            ? 'bg-[#14B8A6] hover:bg-[#0F9B8E] text-white'
            : isDark 
              ? 'bg-[#334155] text-[#94A3B8] cursor-not-allowed'
              : 'bg-[#F3F4F6] text-[#9CA3AF] cursor-not-allowed'
        ]"
      >
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
        </svg>
        View Report
      </button>
    </div>
  </div>
</template>

<script setup>
defineProps({
  appointment: {
    type: Object,
    required: true
  },
  isDark: {
    type: Boolean,
    default: false
  }
})

defineEmits(['view-prescription', 'view-report'])
</script>
