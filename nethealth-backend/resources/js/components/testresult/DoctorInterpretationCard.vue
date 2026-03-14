<template>
  <div :class="isDark ? 'bg-[#1E293B] border-[#334155] shadow-lg shadow-black/20' : 'bg-white border-[#E5E7EB] shadow-sm'" class="rounded-lg p-6 border transition-all duration-300">
    <div class="flex items-start gap-3 mb-4">
      <div :class="isDark ? 'bg-[#14B8A6]/10' : 'bg-teal-50'" class="w-10 h-10 rounded-lg flex items-center justify-center flex-shrink-0">
        <svg class="w-5 h-5 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
        </svg>
      </div>
      <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold">
        Doctor's Notes
      </h3>
    </div>
    
    <div :class="isDark ? 'bg-[#334155]/30 border-[#14B8A6]/20' : 'bg-teal-50/50 border-[#14B8A6]/30'" class="border-l-4 border-[#14B8A6] rounded-r-lg p-4 mb-4">
      <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm leading-relaxed italic">
        {{ interpretation }}
      </p>
    </div>
    
    <div v-if="doctor" class="flex items-center gap-3">
      <img 
        :src="doctor.avatar || 'https://i.pravatar.cc/150?img=33'" 
        :alt="doctor.name"
        class="w-10 h-10 rounded-full object-cover"
      />
      <div>
        <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-medium">
          Electronically Signed by {{ doctor.name }}, {{ formatDate(doctor.signedDate) }}
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  interpretation: {
    type: String,
    required: true
  },
  doctor: {
    type: Object,
    default: null
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
