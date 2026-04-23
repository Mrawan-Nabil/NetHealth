<script setup>
import { ref, computed } from 'vue';

defineProps({
    isOpen: Boolean,
    isDark: Boolean,
    appointment: Object,
});

const emit = defineEmits(['close', 'confirm']);

const selectedDate = ref('');
const selectedTime = ref('');
const reason = ref('');

const minDate = computed(() => {
    const today = new Date();
    return today.toISOString().split('T')[0];
});

const availableTimes = ['09:00 AM', '10:00 AM', '11:00 AM', '02:00 PM', '03:00 PM', '04:00 PM', '05:00 PM', '06:00 PM', '07:00 PM'];

const close = () => {
    selectedDate.value = '';
    selectedTime.value = '';
    reason.value = '';
    emit('close');
};

const handleConfirm = () => {
    if (selectedDate.value && selectedTime.value) {
        emit('confirm', {
            date: selectedDate.value,
            time: selectedTime.value,
            reason: reason.value,
        });
        close();
    }
};
</script>

<template>
    <Teleport to="body">
        <Transition name="modal">
            <div v-if="isOpen" class="fixed inset-0 z-50 flex items-center justify-center p-4" @click.self="close">
                <div class="absolute inset-0 bg-black/50 backdrop-blur-sm"></div>

                <div class="relative w-full max-w-md rounded-2xl shadow-2xl" :class="isDark ? 'border border-[#334155] bg-[#1E293B]' : 'bg-white'">
                    <div
                        class="flex items-center justify-between rounded-t-2xl border-b px-6 py-4"
                        :class="isDark ? 'border-[#334155]' : 'border-gray-200'"
                    >
                        <h2 class="text-xl font-bold" :class="isDark ? 'text-[#F1F5F9]' : 'text-gray-800'">Reschedule Appointment</h2>
                        <button @click="close" class="rounded-lg p-2 transition-colors" :class="isDark ? 'hover:bg-[#334155]' : 'hover:bg-gray-100'">
                            <svg
                                class="h-5 w-5"
                                :class="isDark ? 'text-[#94A3B8]' : 'text-gray-500'"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                            </svg>
                        </button>
                    </div>

                    <div class="space-y-4 p-6">
                        <div>
                            <label class="mb-2 block text-sm font-medium" :class="isDark ? 'text-[#F1F5F9]' : 'text-gray-700'"> Select Date </label>
                            <input
                                v-model="selectedDate"
                                type="date"
                                :min="minDate"
                                class="w-full rounded-lg border px-4 py-3 focus:ring-2 focus:outline-none"
                                :class="
                                    isDark
                                        ? 'border-[#334155] bg-[#0F172A] text-[#F1F5F9] [color-scheme:dark] focus:ring-[#14B8A6]'
                                        : 'border-gray-300 bg-white text-gray-900 focus:ring-teal-500'
                                "
                            />
                        </div>

                        <div>
                            <label class="mb-2 block text-sm font-medium" :class="isDark ? 'text-[#F1F5F9]' : 'text-gray-700'"> Select Time </label>
                            <div class="grid grid-cols-3 gap-2">
                                <button
                                    v-for="time in availableTimes"
                                    :key="time"
                                    @click="selectedTime = time"
                                    class="rounded-lg px-4 py-2 text-sm font-medium transition-colors"
                                    :class="
                                        selectedTime === time
                                            ? isDark
                                                ? 'bg-[#14B8A6] text-white'
                                                : 'bg-teal-500 text-white'
                                            : isDark
                                              ? 'bg-[#334155] text-[#94A3B8] hover:bg-[#475569] hover:text-[#F1F5F9]'
                                              : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                                    "
                                >
                                    {{ time }}
                                </button>
                            </div>
                        </div>

                        <div>
                            <label class="mb-2 block text-sm font-medium" :class="isDark ? 'text-[#F1F5F9]' : 'text-gray-700'">
                                Reason (Optional)
                            </label>
                            <textarea
                                v-model="reason"
                                rows="3"
                                placeholder="Why are you rescheduling?"
                                class="w-full resize-none rounded-lg border px-4 py-3 focus:ring-2 focus:outline-none"
                                :class="
                                    isDark
                                        ? 'border-[#334155] bg-[#0F172A] text-[#F1F5F9] placeholder-[#475569] focus:ring-[#14B8A6]'
                                        : 'border-gray-300 bg-white text-gray-900 placeholder-gray-400 focus:ring-teal-500'
                                "
                            ></textarea>
                        </div>

                        <div class="flex gap-3 pt-4">
                            <button
                                @click="close"
                                class="flex-1 rounded-lg border px-4 py-3 font-medium transition-colors"
                                :class="
                                    isDark
                                        ? 'border-[#334155] bg-transparent text-[#94A3B8] hover:bg-[#334155] hover:text-[#F1F5F9]'
                                        : 'border-gray-300 bg-white text-gray-700 hover:bg-gray-50'
                                "
                            >
                                Cancel
                            </button>
                            <button
                                @click="handleConfirm"
                                :disabled="!selectedDate || !selectedTime"
                                class="flex-1 rounded-lg px-4 py-3 font-medium transition-colors"
                                :class="
                                    !selectedDate || !selectedTime
                                        ? isDark
                                            ? 'cursor-not-allowed bg-[#334155] text-[#475569]'
                                            : 'cursor-not-allowed bg-gray-300 text-white'
                                        : isDark
                                          ? 'bg-[#14B8A6] text-white hover:bg-[#0D9488]'
                                          : 'bg-teal-500 text-white hover:bg-teal-600'
                                "
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
