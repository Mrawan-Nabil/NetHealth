<template>
  <div :class="isDark ? 'bg-[#1E293B] border-[#334155] shadow-lg shadow-black/20' : 'bg-white border-[#E5E7EB] shadow-sm'" class="rounded-lg p-6 border transition-all duration-300">
    <div class="flex items-center gap-8">
      <!-- Icon -->
      <div :class="isDark ? 'bg-[#14B8A6]/10' : 'bg-teal-50'" class="w-16 h-16 rounded-lg flex items-center justify-center flex-shrink-0">
        <svg class="w-8 h-8 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
        </svg>
      </div>
      
      <!-- Test Name -->
      <div class="flex-1">
        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs font-medium uppercase mb-1">
          Test Name
        </p>
        <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-bold">
          {{ testInfo.name }}
        </h3>
        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs mt-1">
          Reg ID: #L-0801
        </p>
      </div>
      
      <!-- Laboratory -->
      <div class="flex-1">
        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs font-medium uppercase mb-1">
          Laboratory
        </p>
        <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">
          {{ testInfo.lab }}
        </p>
        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs mt-1">
          Reg ID: #L-0801
        </p>
      </div>
      
      <!-- Doctor -->
      <div class="flex-1">
        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs font-medium uppercase mb-1">
          Doctor
        </p>
        <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">
          Dr. Sarah Mitchell
        </p>
        <p class="text-xs mt-1 text-[#14B8A6]">
          Hematology Specialist
        </p>
      </div>
      
      <!-- Report Info -->
      <div class="flex-1 text-right">
        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs font-medium uppercase mb-1">
          Report Info
        </p>
        <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">
          {{ formatDate(testInfo.date) }}
        </p>
        <div class="flex items-center justify-end gap-2 mt-1">
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs">
            ID: #TR-00021
          </p>
          <span 
            :class="isDark ? 'bg-emerald-500/10 text-[#22C55E]' : 'bg-emerald-100 text-emerald-600'"
            class="inline-block px-2 py-0.5 rounded text-xs font-medium uppercase"
          >
            {{ testInfo.status }}
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  testInfo: {
    type: Object,
    required: true
  },
  isDark: {
    type: Boolean,
    default: false
  }
})

const formatDate = (dateString) => {
  const date = new Date(dateString)
  const options = { year: 'numeric', month: 'short', day: 'numeric' }
  return date.toLocaleDateString('en-US', options)
}
</script>
