<template>
  <div 
    :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'"
    class="border rounded-xl p-5 transition-all duration-300"
  >
    <!-- Header: Doctor Info -->
    <div class="flex items-center gap-3 mb-4">
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
      <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm mb-2">
        {{ appointment.clinicAddress }}
      </p>
      
      <!-- Status Badges -->
      <div class="flex items-center gap-3">
        <span class="flex items-center gap-1.5 text-xs font-semibold text-[#10B981]">
          <span class="w-1.5 h-1.5 bg-[#10B981] rounded-full"></span>
          SCHEDULED
        </span>
        <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs font-medium">
          {{ appointment.visitType }}
        </span>
      </div>
    </div>

    <!-- Action Buttons -->
    <div class="grid grid-cols-2 gap-3 mb-3">
      <button 
        @click="$emit('upload-test-results', appointment)"
        class="px-4 py-2.5 bg-[#14B8A6] hover:bg-[#0F9B8E] text-white rounded-lg text-sm font-semibold transition-colors flex items-center justify-center gap-2"
      >
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"/>
        </svg>
        Upload Test Results
      </button>
      <button 
        @click="$emit('upload-imaging', appointment)"
        class="px-4 py-2.5 bg-[#14B8A6] hover:bg-[#0F9B8E] text-white rounded-lg text-sm font-semibold transition-colors flex items-center justify-center gap-2"
      >
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/>
        </svg>
        Upload Imaging
      </button>
    </div>

    <!-- Secondary Actions -->
    <div class="flex items-center justify-between">
      <button 
        @click="$emit('reschedule', appointment)"
        :class="isDark ? 'border-[#334155] text-[#94A3B8] hover:bg-[#334155]' : 'border-[#D1D5DB] text-[#6B7280] hover:bg-[#F9FAFB]'"
        class="px-4 py-2 border rounded-lg text-sm font-medium transition-colors flex items-center gap-2"
      >
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
        </svg>
        Reschedule
      </button>
      <button 
        @click="$emit('cancel', appointment)"
        :class="isDark ? 'text-[#94A3B8] hover:text-red-400' : 'text-[#9CA3AF] hover:text-red-600'"
        class="text-sm font-medium transition-colors"
      >
        Cancel Appointment
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

defineEmits(['upload-test-results', 'upload-imaging', 'reschedule', 'cancel'])
</script>
