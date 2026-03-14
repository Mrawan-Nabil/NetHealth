<template>
  <div :class="isDark ? 'bg-[#1E293B] border-[#334155] shadow-lg shadow-black/20' : 'bg-white border-[#E5E7EB] shadow-sm'" class="rounded-lg p-6 border transition-all duration-300">
    <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold mb-4">
      Diagnosis
    </h3>
    
    <div class="space-y-3">
      <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-medium">
        {{ diagnosis.title }}
      </p>
      <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm leading-relaxed">
        {{ diagnosis.description }}
      </p>
    </div>
  </div>
</template>

<script setup>
defineProps({
  diagnosis: {
    type: Object,
    required: true
  },
  isDark: {
    type: Boolean,
    default: false
  }
})
</script>
