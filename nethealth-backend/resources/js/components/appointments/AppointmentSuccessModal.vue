<template>
  <!-- Modal Overlay -->
  <div 
    v-if="isOpen"
    class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4"
    @click.self="$emit('close')"
  >
    <!-- Modal Content -->
    <div 
      :class="isDark ? 'bg-[#1E293B]' : 'bg-white'"
      class="rounded-2xl max-w-md w-full shadow-2xl"
    >
      <!-- Body -->
      <div class="p-8 text-center">
        <!-- Success Icon -->
        <div class="w-20 h-20 mx-auto mb-6 bg-[#D1FAE5] rounded-full flex items-center justify-center">
          <svg class="w-10 h-10 text-[#10B981]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
          </svg>
        </div>

        <!-- Title -->
        <h2 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-2xl font-bold mb-3">
          Appointment Booked Successfully
        </h2>

        <!-- Description -->
        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm mb-6">
          Your appointment has been confirmed. The doctor will review your information before the scheduled time.
        </p>

        <!-- Appointment Details Card -->
        <div 
          :class="isDark ? 'bg-[#334155] border-[#475569]' : 'bg-[#F9FAFB] border-[#E5E7EB]'"
          class="border rounded-xl p-4 mb-6"
        >
          <div class="flex items-start gap-4">
            <!-- Doctor Avatar -->
            <img 
              :src="appointment.doctor.avatar" 
              alt="Doctor"
              class="w-14 h-14 rounded-xl object-cover"
            />
            
            <!-- Details -->
            <div class="flex-1 text-left">
              <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold mb-1">
                {{ appointment.doctor.name }}
              </h3>
              <p class="text-[#14B8A6] text-sm font-medium mb-2">
                {{ appointment.doctor.specialty }}
              </p>
              <div class="flex items-center gap-2 text-sm" :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
                </svg>
                <span>Clinic Visit</span>
              </div>
            </div>

            <!-- Date & Time -->
            <div class="text-right">
              <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold mb-1">
                {{ appointment.date }}
              </p>
              <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
                {{ appointment.time }}
              </p>
            </div>
          </div>
        </div>

        <!-- Uploaded Files -->
        <div v-if="uploadedFiles && uploadedFiles.length > 0" class="mb-6">
          <div class="flex items-center gap-2 mb-3">
            <svg class="w-4 h-4" :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"/>
            </svg>
            <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs font-semibold uppercase">
              Uploaded Files
            </span>
          </div>
          
          <div class="grid grid-cols-2 gap-3">
            <div 
              v-for="(file, index) in uploadedFiles"
              :key="index"
              :class="[
                'flex items-center gap-2 p-3 rounded-lg',
                isDark ? 'bg-[#334155]' : 'bg-white border border-[#E5E7EB]'
              ]"
            >
              <!-- File Icon -->
              <div :class="[
                'w-10 h-10 rounded-lg flex items-center justify-center flex-shrink-0',
                file.type === 'pdf' ? 'bg-[#FEE2E2]' : 'bg-[#DBEAFE]'
              ]">
                <svg v-if="file.type === 'pdf'" class="w-5 h-5 text-[#EF4444]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"/>
                </svg>
                <svg v-else class="w-5 h-5 text-[#3B82F6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                </svg>
              </div>
              
              <!-- File Info -->
              <div class="flex-1 min-w-0 text-left">
                <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-xs font-medium truncate">
                  {{ file.name }}
                </p>
                <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-xs">
                  {{ file.size }}
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- Action Buttons -->
        <div class="space-y-3">
          <button 
            @click="handleViewAppointments"
            class="w-full px-6 py-3 bg-[#14B8A6] hover:bg-[#0F9B8E] text-white rounded-lg text-sm font-semibold transition-colors"
          >
            View My Appointments
          </button>
          <button 
            @click="handleBackToDashboard"
            :class="[
              'w-full px-6 py-3 rounded-lg text-sm font-semibold transition-colors',
              isDark 
                ? 'bg-[#334155] text-[#F8FAFC] hover:bg-[#475569]'
                : 'bg-white border-2 border-[#E5E7EB] text-[#111827] hover:bg-[#F9FAFB]'
            ]"
          >
            Back to Dashboard
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  isOpen: {
    type: Boolean,
    required: true
  },
  appointment: {
    type: Object,
    required: true
  },
  uploadedFiles: {
    type: Array,
    default: () => []
  },
  isDark: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['close', 'view-appointments', 'back-to-dashboard'])

const handleViewAppointments = () => {
  emit('view-appointments')
}

const handleBackToDashboard = () => {
  emit('back-to-dashboard')
}
</script>
