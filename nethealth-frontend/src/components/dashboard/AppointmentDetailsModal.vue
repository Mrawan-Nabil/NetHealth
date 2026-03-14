<template>
  <Teleport to="body">
    <Transition name="modal">
      <div v-if="isOpen" class="fixed inset-0 z-50 flex items-center justify-center p-4" @click.self="close">
        <div class="absolute inset-0 bg-black/50 backdrop-blur-sm"></div>
        
        <div class="relative bg-white rounded-2xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
          <!-- Header -->
          <div class="sticky top-0 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between rounded-t-2xl">
            <h2 class="text-xl font-bold text-gray-800">Appointment Details</h2>
            <button @click="close" class="p-2 hover:bg-gray-100 rounded-lg transition-colors">
              <svg class="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
              </svg>
            </button>
          </div>

          <!-- Content -->
          <div v-if="appointment" class="p-6 space-y-6">
            <!-- Doctor Info -->
            <div class="flex items-start gap-4 p-4 bg-gray-50 rounded-xl">
              <img 
                :src="appointment.avatar || 'https://i.pravatar.cc/150?img=47'" 
                :alt="appointment.doctor"
                class="w-20 h-20 rounded-full object-cover"
              />
              <div class="flex-1">
                <h3 class="text-lg font-semibold text-gray-800">{{ appointment.doctor }}</h3>
                <p class="text-sm text-gray-600 mb-2">{{ appointment.specialty }}</p>
                <span 
                  :class="statusClass"
                  class="inline-block px-3 py-1 rounded-full text-xs font-medium"
                >
                  {{ appointment.status }}
                </span>
              </div>
            </div>

            <!-- Appointment Details -->
            <div class="space-y-4">
              <div class="flex items-start gap-3">
                <svg class="w-5 h-5 text-teal-500 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                </svg>
                <div>
                  <p class="text-sm font-medium text-gray-700">Date & Time</p>
                  <p class="text-sm text-gray-600">{{ appointment.time }}</p>
                </div>
              </div>

              <div class="flex items-start gap-3">
                <svg class="w-5 h-5 text-teal-500 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
                </svg>
                <div>
                  <p class="text-sm font-medium text-gray-700">Location</p>
                  <p class="text-sm text-gray-600">{{ appointment.location }}</p>
                </div>
              </div>

              <div class="flex items-start gap-3">
                <svg class="w-5 h-5 text-teal-500 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
                <div>
                  <p class="text-sm font-medium text-gray-700">Appointment Type</p>
                  <p class="text-sm text-gray-600">{{ appointment.type || 'General Consultation' }}</p>
                </div>
              </div>

              <div class="flex items-start gap-3">
                <svg class="w-5 h-5 text-teal-500 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <div>
                  <p class="text-sm font-medium text-gray-700">Duration</p>
                  <p class="text-sm text-gray-600">{{ appointment.duration || '30 minutes' }}</p>
                </div>
              </div>
            </div>

            <!-- Notes -->
            <div v-if="appointment.notes" class="p-4 bg-blue-50 rounded-xl">
              <p class="text-sm font-medium text-gray-700 mb-2">Notes</p>
              <p class="text-sm text-gray-600">{{ appointment.notes }}</p>
            </div>

            <!-- Actions -->
            <div class="flex gap-3 pt-4">
              <button 
                @click="handleReschedule"
                class="flex-1 px-4 py-3 bg-teal-500 text-white rounded-lg font-medium hover:bg-teal-600 transition-colors"
              >
                Reschedule
              </button>
              <button 
                @click="handleCancel"
                class="flex-1 px-4 py-3 border border-red-300 text-red-600 rounded-lg font-medium hover:bg-red-50 transition-colors"
              >
                Cancel Appointment
              </button>
            </div>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  isOpen: Boolean,
  appointment: Object
})

const emit = defineEmits(['close', 'reschedule', 'cancel'])

const statusClass = computed(() => {
  const status = props.appointment?.status?.toLowerCase()
  const classes = {
    confirmed: 'bg-green-100 text-green-700',
    pending: 'bg-yellow-100 text-yellow-700',
    cancelled: 'bg-red-100 text-red-700'
  }
  return classes[status] || 'bg-gray-100 text-gray-700'
})

const close = () => emit('close')
const handleReschedule = () => {
  emit('reschedule')
  close()
}
const handleCancel = () => {
  emit('cancel')
  close()
}
</script>

<style scoped>
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.modal-enter-active .relative,
.modal-leave-active .relative {
  transition: transform 0.3s ease;
}

.modal-enter-from .relative,
.modal-leave-to .relative {
  transform: scale(0.95);
}
</style>
