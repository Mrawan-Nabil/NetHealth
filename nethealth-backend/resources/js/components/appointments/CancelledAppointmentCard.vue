<template>
  <div 
    :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'"
    class="border rounded-xl p-5 transition-all duration-300 flex items-start justify-between"
  >
    <!-- Left Section: Doctor Info & Details -->
    <div class="flex items-start gap-4 flex-1">
      <!-- Doctor Avatar -->
      <img 
        :src="appointment.doctorAvatar" 
        alt="Doctor"
        class="w-12 h-12 rounded-full object-cover flex-shrink-0"
      />

      <!-- Doctor & Appointment Details -->
      <div class="flex-1">
        <!-- Doctor Name & Specialty -->
        <div class="mb-3">
          <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold">
            {{ appointment.doctorName }}
          </h3>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
            {{ appointment.specialty }}
          </p>
        </div>

        <!-- Date & Time -->
        <div class="mb-2">
          <h4 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold mb-1">
            Date & Time
          </h4>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
            {{ appointment.dateTime }}
          </p>
        </div>

        <!-- Clinic Address -->
        <div class="mb-3">
          <h4 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold mb-1">
            Clinic Address
          </h4>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
            {{ appointment.clinicAddress }}
          </p>
        </div>

        <!-- Cancelled By -->
        <div class="mb-3">
          <h4 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold mb-1">
            Cancelled By
          </h4>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
            {{ appointment.cancelledBy }}
          </p>
        </div>

        <!-- Status Badges -->
        <div class="flex items-center gap-3">
          <span class="flex items-center gap-1.5 px-2 py-1 bg-[#FEE2E2] text-[#991B1B] rounded text-xs font-semibold">
            <span class="w-1.5 h-1.5 bg-[#EF4444] rounded-full"></span>
            CANCELLED
          </span>
          <span 
            :class="isDark ? 'bg-[#334155] text-[#94A3B8]' : 'bg-[#F3F4F6] text-[#6B7280]'"
            class="px-2 py-1 rounded text-xs font-semibold uppercase"
          >
            {{ appointment.reason }}
          </span>
        </div>
      </div>
    </div>

    <!-- Right Section: Reschedule Button -->
    <button 
      @click="$emit('reschedule', appointment)"
      class="px-4 py-2.5 bg-[#14B8A6] hover:bg-[#0F9B8E] text-white rounded-lg text-sm font-semibold transition-colors flex items-center gap-2 flex-shrink-0"
    >
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
      </svg>
      Reschedule
    </button>
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

defineEmits(['reschedule'])
</script>
