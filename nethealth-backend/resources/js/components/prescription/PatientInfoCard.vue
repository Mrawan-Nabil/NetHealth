<template>
  <div :class="isDark ? 'bg-[#1E293B] border-[#334155] shadow-lg shadow-black/20' : 'bg-white border-[#E5E7EB] shadow-sm'" class="rounded-lg p-6 border transition-all duration-300">
    <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold mb-4">
      Patient Information
    </h3>
    
    <div class="grid grid-cols-4 gap-4">
      <div 
        v-for="(info, index) in patientInfo" 
        :key="index"
        :class="isDark ? 'bg-[#334155]/30' : 'bg-teal-50'"
        class="rounded-lg p-4"
      >
        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs font-medium mb-1">
          {{ info.label }}
        </p>
        <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">
          {{ info.value }}
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  patient: {
    type: Object,
    required: true
  },
  isDark: {
    type: Boolean,
    default: false
  }
})

const patientInfo = computed(() => [
  { label: 'Full Name', value: props.patient.name },
  { label: 'Gender', value: props.patient.gender },
  { label: 'Date of Birth', value: props.patient.age },
  { label: 'Patient ID', value: props.patient.id }
])
</script>
