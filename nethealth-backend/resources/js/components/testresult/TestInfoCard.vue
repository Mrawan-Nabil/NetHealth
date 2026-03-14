<template>
  <div :class="isDark ? 'bg-[#1E293B] border-[#334155] shadow-lg shadow-black/20' : 'bg-white border-[#E5E7EB] shadow-sm'" class="rounded-lg p-6 border transition-all duration-300">
    <div class="flex items-start justify-between gap-6">
      <!-- Left Side: Test Info -->
      <div class="flex items-start gap-4 flex-1">
        <div :class="isDark ? 'bg-[#14B8A6]/10' : 'bg-teal-50'" class="w-16 h-16 rounded-lg flex items-center justify-center flex-shrink-0">
          <svg class="w-8 h-8 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
          </svg>
        </div>
        
        <div class="flex-1">
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs font-medium uppercase mb-1">
            Test Name
          </p>
          <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-xl font-bold mb-4">
            {{ testInfo.name }}
          </h3>
          
          <div class="space-y-2">
            <div>
              <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs font-medium uppercase mb-1">
                Laboratory
              </p>
              <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-medium">
                {{ testInfo.lab }}
              </p>
            </div>
            
            <div>
              <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs font-medium uppercase mb-1">
                Test Date
              </p>
              <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-medium">
                {{ formatDate(testInfo.date) }}
              </p>
            </div>
          </div>
        </div>
      </div>

      <!-- Right Side: Status -->
      <div>
        <span 
          :class="isDark ? 'bg-emerald-500/10 text-[#22C55E]' : 'bg-emerald-100 text-emerald-600'"
          class="inline-block px-3 py-1 rounded-full text-xs font-medium uppercase"
        >
          {{ testInfo.status }}
        </span>
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
