<template>
  <div 
    :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'"
    class="rounded-lg p-6 border transition-all duration-300 hover:shadow-xl hover:-translate-y-1 space-y-4 animate-fade-in-up card-interactive group"
  >
    <!-- Header -->
    <div class="flex items-start justify-between">
      <div class="flex-1">
        <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold mb-1 transition-colors duration-300">
          {{ prescription.doctor }}
        </h3>
        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm transition-colors duration-300">
          {{ prescription.specialty }}
        </p>
        <div :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="flex items-center gap-1 text-xs mt-2 transition-colors duration-300">
          <svg class="w-4 h-4 transition-transform duration-300 group-hover:rotate-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
          </svg>
          <span>{{ prescription.date }} - Expires {{ prescription.expires }}</span>
        </div>
      </div>
      <span 
        :class="statusClass"
        class="px-3 py-1 rounded-full text-xs font-medium uppercase transition-all duration-300 group-hover:scale-110"
      >
        {{ prescription.status }}
      </span>
    </div>

    <!-- Diagnosis -->
    <div class="transition-all duration-300">
      <h4 :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs font-semibold uppercase mb-2 transition-colors duration-300">
        Diagnosis
      </h4>
      <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm leading-relaxed transition-colors duration-300">
        {{ prescription.diagnosis }}
      </p>
    </div>

    <!-- Medicines -->
    <div class="transition-all duration-300">
      <h4 :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs font-semibold uppercase mb-2 transition-colors duration-300">
        Medicines
      </h4>
      <transition-group name="list" tag="ul" class="space-y-1">
        <li 
          v-for="(medicine, index) in displayedMedicines" 
          :key="index"
          :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'"
          class="text-sm flex items-start gap-2 transition-all duration-300"
        >
          <span class="text-[#14B8A6] mt-1 transition-transform duration-300 group-hover:scale-125">•</span>
          <span>{{ medicine }}</span>
        </li>
      </transition-group>
      <button 
        v-if="prescription.medicines.length > 2"
        @click="showAllMedicines = !showAllMedicines"
        class="text-[#14B8A6] hover:text-[#0D9488] text-xs font-medium mt-2 transition-all duration-300 hover:translate-x-1"
      >
        {{ showAllMedicines ? 'Show less' : `+${prescription.medicines.length - 2} more medicines` }}
      </button>
    </div>

    <!-- Actions -->
    <div class="flex items-center justify-end gap-3 pt-2">
      <button 
        @click="$emit('download', prescription)"
        :class="isDark ? 'border-[#334155] text-[#94A3B8] hover:bg-[#334155]' : 'border-[#D1D5DB] text-[#6B7280] hover:bg-gray-50'"
        class="px-4 py-2 border rounded-lg text-sm font-medium transition-all duration-300 flex items-center gap-2 hover:scale-105 active:scale-95 hover:shadow-md"
      >
        <svg class="w-4 h-4 transition-transform duration-300 group-hover:translate-y-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"/>
        </svg>
        Download
      </button>
      <button 
        @click="$emit('view-details', prescription)"
        class="px-4 py-2 bg-[#14B8A6] hover:bg-[#0F9B8E] text-white rounded-lg text-sm font-medium transition-all duration-300 flex items-center gap-2 hover:scale-105 active:scale-95 hover:shadow-lg hover:shadow-teal-500/30"
      >
        View Details
        <svg class="w-4 h-4 transition-transform duration-300 group-hover:translate-x-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
        </svg>
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const props = defineProps({
  prescription: {
    type: Object,
    required: true
  },
  isDark: {
    type: Boolean,
    default: false
  }
})

defineEmits(['download', 'view-details'])

const showAllMedicines = ref(false)

const displayedMedicines = computed(() => {
  if (showAllMedicines.value || props.prescription.medicines.length <= 2) {
    return props.prescription.medicines
  }
  return props.prescription.medicines.slice(0, 2)
})

const statusClass = computed(() => {
  const status = props.prescription.status.toLowerCase()
  if (status === 'active') {
    return props.isDark 
      ? 'bg-emerald-500/10 text-[#22C55E]' 
      : 'bg-emerald-100 text-emerald-600'
  }
  return props.isDark 
    ? 'bg-[#334155] text-[#94A3B8]' 
    : 'bg-gray-100 text-gray-500'
})
</script>

<style scoped>
/* List transition animations */
.list-enter-active,
.list-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.list-enter-from {
  opacity: 0;
  transform: translateX(-10px);
}

.list-leave-to {
  opacity: 0;
  transform: translateX(10px);
}

.list-move {
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
</style>
