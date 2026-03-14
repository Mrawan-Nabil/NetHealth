<template>
  <div 
    :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'"
    class="border rounded-xl p-6 transition-all duration-200 hover:shadow-lg hover:shadow-black/5 hover:-translate-y-1 group"
  >
    <!-- Doctor Info -->
    <div class="flex items-start gap-4 mb-5">
      <div class="relative">
        <img 
          :src="doctor.avatar" 
          alt="Doctor"
          class="w-16 h-16 rounded-full object-cover ring-2 ring-gray-100 transition-all duration-200"
          :class="isDark ? 'ring-gray-700' : 'ring-gray-100'"
        />
        <div class="absolute -bottom-1 -right-1 w-5 h-5 bg-green-500 rounded-full ring-2 ring-white flex items-center justify-center">
          <div class="w-2 h-2 bg-white rounded-full"></div>
        </div>
      </div>
      <div class="flex-1">
        <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold mb-1">
          {{ doctor.name }}
        </h3>
        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm mb-3">
          {{ doctor.specialty }}
        </p>
        <div class="flex items-center gap-1">
          <svg class="w-4 h-4 text-[#F59E0B]" fill="currentColor" viewBox="0 0 20 20">
            <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
          </svg>
          <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">
            {{ doctor.rating }}
          </span>
          <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-xs">
            ({{ doctor.reviews }} reviews)
          </span>
        </div>
      </div>
    </div>

    <!-- Hospital -->
    <div class="flex items-center gap-2 mb-4">
      <svg class="w-4 h-4" :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
      </svg>
      <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
        {{ doctor.hospital }}
      </span>
    </div>

    <!-- Availability & Price -->
    <div class="flex items-center justify-between mb-5">
      <span class="flex items-center gap-1.5 text-xs font-medium text-[#10B981]">
        <span class="w-2 h-2 bg-[#10B981] rounded-full"></span>
        AVAILABLE TODAY
      </span>
      <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">
        {{ doctor.price }}
      </span>
    </div>

    <!-- Book Button -->
    <button 
      @click="$emit('book', doctor)"
      class="w-full px-4 py-3 bg-[#14B8A6] hover:bg-[#0F9B8E] text-white rounded-lg font-medium transition-all duration-200 hover:shadow-lg hover:shadow-[#14B8A6]/25 active:scale-[0.98]"
    >
      Book Appointment
    </button>
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

defineEmits(['book'])
</script>
