<template>
  <div 
    :class="isDark ? 'bg-[#1E293B] border-[#334155] shadow-lg shadow-black/20' : 'bg-white border-[#E5E7EB] shadow-sm'"
    class="rounded-xl p-6 border transition-all duration-300 hover:shadow-xl hover:-translate-y-1 animate-fade-in-up card-interactive group"
  >
    <!-- Header: Test Name & Status -->
    <div class="flex items-start justify-between mb-4">
      <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold pr-4 transition-colors duration-300">
        {{ testResult.name }}
      </h3>
      <div class="transition-transform duration-300 group-hover:scale-110">
        <StatusBadge :status="testResult.status" :is-dark="isDark" />
      </div>
    </div>

    <!-- Laboratory Info -->
    <div class="space-y-2 mb-6">
      <div class="flex items-center gap-2 transition-all duration-300 group-hover:translate-x-1">
        <svg class="w-4 h-4 text-[#14B8A6] transition-transform duration-300 group-hover:rotate-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
        </svg>
        <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm transition-colors duration-300">
          {{ testResult.lab }}
        </span>
      </div>
      
      <div class="flex items-center gap-2 transition-all duration-300 group-hover:translate-x-1">
        <svg class="w-4 h-4 text-[#14B8A6] transition-transform duration-300 group-hover:rotate-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
        </svg>
        <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm transition-colors duration-300">
          {{ formatDate(testResult.date) }}
        </span>
      </div>
    </div>

    <!-- Action Button -->
    <div class="flex justify-end">
      <button
        @click="handleViewReport"
        :disabled="isDisabled"
        :class="[
          'px-6 py-2 rounded-full text-sm font-medium transition-all duration-300 hover:scale-105 active:scale-95',
          isDisabled
            ? isDark 
              ? 'bg-[#334155] text-[#94A3B8] cursor-not-allowed' 
              : 'bg-gray-200 text-gray-400 cursor-not-allowed'
            : isDark
              ? 'bg-[#14B8A6] hover:bg-[#2DD4BF] text-white shadow-lg shadow-teal-500/20 hover:shadow-xl hover:shadow-teal-500/30'
              : 'bg-[#14B8A6] hover:bg-[#0D9488] text-white hover:shadow-lg'
        ]"
      >
        <span class="flex items-center gap-2">
          <svg v-if="!isDisabled" class="w-4 h-4 transition-transform duration-300 group-hover:translate-x-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
          </svg>
          <svg v-else class="w-4 h-4 animate-spin" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
          </svg>
          {{ buttonText }}
        </span>
      </button>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import StatusBadge from './StatusBadge.vue'

const props = defineProps({
  testResult: {
    type: Object,
    required: true
  },
  isDark: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['view-report'])

const isDisabled = computed(() => {
  return props.testResult.status.toLowerCase() === 'pending'
})

const buttonText = computed(() => {
  return isDisabled.value ? 'Processing...' : 'View Report'
})

const formatDate = (dateString) => {
  const date = new Date(dateString)
  const options = { year: 'numeric', month: 'short', day: 'numeric' }
  return date.toLocaleDateString('en-US', options)
}

const handleViewReport = () => {
  if (!isDisabled.value) {
    emit('view-report', props.testResult)
  }
}
</script>
