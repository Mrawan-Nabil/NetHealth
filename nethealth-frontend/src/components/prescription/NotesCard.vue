<template>
  <div :class="isDark ? 'bg-[#1E293B] border-[#334155] shadow-lg shadow-black/20' : 'bg-white border-[#E5E7EB] shadow-sm'" class="rounded-lg p-6 border transition-all duration-300">
    <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold mb-4">
      Doctor Notes & Lifestyle Advice
    </h3>
    
    <ul class="space-y-3">
      <li 
        v-for="(note, index) in notes" 
        :key="index"
        class="flex items-start gap-3"
      >
        <div class="flex-shrink-0 w-5 h-5 rounded-full bg-[#14B8A6]/10 flex items-center justify-center mt-0.5">
          <svg class="w-3 h-3 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"/>
          </svg>
        </div>
        <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm leading-relaxed">
          {{ note }}
        </span>
      </li>
    </ul>
  </div>
</template>

<script setup>
defineProps({
  notes: {
    type: Array,
    required: true
  },
  isDark: {
    type: Boolean,
    default: false
  }
})
</script>
