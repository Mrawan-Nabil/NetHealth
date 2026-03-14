<template>
  <Teleport to="body">
    <Transition name="modal">
      <div v-if="isOpen" class="fixed inset-0 z-50 flex items-center justify-center p-4" @click.self="close">
        <div class="absolute inset-0 bg-black/50 backdrop-blur-sm"></div>
        
        <div class="relative bg-white rounded-2xl shadow-2xl max-w-md w-full">
          <!-- Header -->
          <div class="border-b border-gray-200 px-6 py-4 flex items-center justify-between rounded-t-2xl">
            <h2 class="text-xl font-bold text-gray-800">Reschedule Appointment</h2>
            <button @click="close" class="p-2 hover:bg-gray-100 rounded-lg transition-colors">
              <svg class="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
              </svg>
            </button>
          </div>

          <!-- Content -->
          <div class="p-6 space-y-4">
            <!-- Date Picker -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Select Date</label>
              <input 
                v-model="selectedDate"
                type="date"
                :min="minDate"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-teal-500"
              />
            </div>

            <!-- Time Picker -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Select Time</label>
              <div class="grid grid-cols-3 gap-2">
                <button
                  v-for="time in availableTimes"
                  :key="time"
                  @click="selectedTime = time"
                  :class="selectedTime === time ? 'bg-teal-500 text-white' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'"
                  class="px-4 py-2 rounded-lg text-sm font-medium transition-colors"
                >
                  {{ time }}
                </button>
              </div>
            </div>

            <!-- Reason -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Reason (Optional)</label>
              <textarea 
                v-model="reason"
                rows="3"
                placeholder="Why are you rescheduling?"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-teal-500 resize-none"
              ></textarea>
            </div>

            <!-- Actions -->
            <div class="flex gap-3 pt-4">
              <button 
                @click="close"
                class="flex-1 px-4 py-3 border border-gray-300 text-gray-700 rounded-lg font-medium hover:bg-gray-50 transition-colors"
              >
                Cancel
              </button>
              <button 
                @click="handleConfirm"
                :disabled="!selectedDate || !selectedTime"
                :class="selectedDate && selectedTime ? 'bg-teal-500 hover:bg-teal-600' : 'bg-gray-300 cursor-not-allowed'"
                class="flex-1 px-4 py-3 text-white rounded-lg font-medium transition-colors"
              >
                Confirm
              </button>
            </div>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup>
import { ref, computed } from 'vue'

const props = defineProps({
  isOpen: Boolean,
  appointment: Object
})

const emit = defineEmits(['close', 'confirm'])

const selectedDate = ref('')
const selectedTime = ref('')
const reason = ref('')

const minDate = computed(() => {
  const today = new Date()
  return today.toISOString().split('T')[0]
})

const availableTimes = [
  '09:00 AM', '10:00 AM', '11:00 AM',
  '02:00 PM', '03:00 PM', '04:00 PM',
  '05:00 PM', '06:00 PM', '07:00 PM'
]

const close = () => {
  selectedDate.value = ''
  selectedTime.value = ''
  reason.value = ''
  emit('close')
}

const handleConfirm = () => {
  if (selectedDate.value && selectedTime.value) {
    emit('confirm', {
      date: selectedDate.value,
      time: selectedTime.value,
      reason: reason.value
    })
    close()
  }
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
