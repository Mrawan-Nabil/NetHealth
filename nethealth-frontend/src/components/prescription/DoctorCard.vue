<template>
  <div :class="isDark ? 'bg-[#1E293B] border-[#334155] shadow-lg shadow-black/20' : 'bg-white border-[#E5E7EB] shadow-sm'" class="rounded-lg p-6 border transition-all duration-300">
    <div class="flex items-start justify-between gap-6">
      <!-- Left Side: Doctor Info -->
      <div class="flex items-start gap-4 flex-1">
        <img 
          :src="doctor.avatar || 'https://i.pravatar.cc/150?img=33'" 
          :alt="doctor.name"
          class="w-20 h-20 rounded-full object-cover ring-4"
          :class="isDark ? 'ring-[#334155]' : 'ring-gray-100'"
        />
        <div class="flex-1">
          <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-xl font-bold mb-2">
            {{ doctor.name }}
          </h3>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm mb-3">
            {{ doctor.credentials }}
          </p>
          <div class="space-y-1">
            <div class="flex items-center gap-2">
              <svg class="w-4 h-4 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
              </svg>
              <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
                License #: {{ doctor.license }}
              </span>
            </div>
            <div class="flex items-center gap-2">
              <svg class="w-4 h-4 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
              </svg>
              <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
                Phone: {{ doctor.phone }}
              </span>
            </div>
          </div>
        </div>
      </div>

      <!-- Right Side: Status & Clinic -->
      <div class="space-y-4">
        <span 
          :class="isDark ? 'bg-emerald-500/10 text-[#22C55E]' : 'bg-emerald-100 text-emerald-600'"
          class="inline-block px-3 py-1 rounded-full text-xs font-medium uppercase"
        >
          {{ doctor.status }}
        </span>
        
        <div :class="isDark ? 'bg-[#334155]/30' : 'bg-teal-50'" class="rounded-lg p-4 min-w-[280px]">
          <h4 :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs font-semibold uppercase mb-2">
            Clinic Address
          </h4>
          <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm leading-relaxed">
            {{ doctor.clinicAddress }}
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  doctor: {
    type: Object,
    required: true
  },
  isDark: {
    type: Boolean,
    default: false
  }
})
</script>
