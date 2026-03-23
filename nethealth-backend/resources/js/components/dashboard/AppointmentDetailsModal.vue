<script setup>
import { computed } from 'vue';

const props = defineProps({
    isOpen: Boolean,
    appointment: Object,
    isDark: Boolean, // Added dark mode prop
});

const emit = defineEmits(['close', 'reschedule', 'cancel']);

const statusClass = computed(() => {
    const status = props.appointment?.appointment_status?.toLowerCase();

    // Adjusted colors slightly to look good in both light and dark modes
    const classes = {
        confirmed: props.isDark ? 'bg-green-500/20 text-green-400' : 'bg-green-100 text-green-700',
        pending: props.isDark ? 'bg-yellow-500/20 text-yellow-400' : 'bg-yellow-100 text-yellow-700',
        cancelled: props.isDark ? 'bg-red-500/20 text-red-400' : 'bg-red-100 text-red-700',
    };
    return classes[status] || (props.isDark ? 'bg-gray-700 text-gray-300' : 'bg-gray-100 text-gray-700');
});

const close = () => emit('close');
const handleReschedule = () => {
    emit('reschedule');
    close();
};
const handleCancel = () => {
    emit('cancel');
    close();
};
</script>

<template>
    <Teleport to="body">
        <Transition name="modal">
            <div v-if="isOpen" class="fixed inset-0 z-50 flex items-center justify-center p-4">
                <div class="absolute inset-0 bg-black/60 backdrop-blur-sm transition-opacity" @click="close"></div>

                <div
                    :class="isDark ? 'bg-[#1E293B] shadow-black/50' : 'bg-white shadow-2xl'"
                    class="relative z-10 max-h-[90vh] w-full max-w-2xl overflow-y-auto rounded-2xl transition-all duration-300"
                >
                    <div
                        :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-gray-200 bg-white'"
                        class="sticky top-0 z-20 flex items-center justify-between rounded-t-2xl border-b px-6 py-4"
                    >
                        <h2 :class="isDark ? 'text-[#F8FAFC]' : 'text-gray-800'" class="text-xl font-bold">Appointment Details</h2>
                        <button
                            type="button"
                            @click="close"
                            :class="isDark ? 'hover:bg-[#334155]' : 'hover:bg-gray-100'"
                            class="rounded-lg p-2 transition-colors"
                        >
                            <svg
                                :class="isDark ? 'text-gray-400' : 'text-gray-500'"
                                class="h-5 w-5"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                            </svg>
                        </button>
                    </div>

                    <div v-if="appointment" class="space-y-6 p-6">
                        <div :class="isDark ? 'bg-[#0F172A]' : 'bg-gray-50'" class="flex items-start gap-4 rounded-xl p-4 transition-colors">
                            <img
                                :src="appointment?.doctor?.user?.avatar || '/images/default-avatar.png'"
                                :alt="appointment?.doctor?.user?.full_name || 'Doctor'"
                                class="h-20 w-20 rounded-full object-cover ring-2 ring-teal-500/20"
                            />
                            <div class="flex-1">
                                <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-gray-800'" class="text-lg font-semibold">
                                    {{ appointment?.doctor?.user?.full_name || 'Not Assigned' }}
                                </h3>
                                <p :class="isDark ? 'text-[#94A3B8]' : 'text-gray-600'" class="mb-2 text-sm">
                                    {{ appointment?.doctor?.specialty || 'General Practice' }}
                                </p>
                                <span :class="statusClass" class="inline-block rounded-full px-3 py-1 text-xs font-medium tracking-wide uppercase">
                                    {{ appointment?.appointment_status || 'Unknown' }}
                                </span>
                            </div>
                        </div>

                        <div class="space-y-4">
                            <div class="flex items-start gap-3">
                                <svg class="mt-0.5 h-5 w-5 text-teal-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
                                    />
                                </svg>
                                <div>
                                    <p :class="isDark ? 'text-gray-300' : 'text-gray-700'" class="text-sm font-medium">Date & Time</p>
                                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-gray-600'" class="text-sm">
                                        {{ appointment?.time || 'Not Scheduled' }}
                                    </p>
                                </div>
                            </div>

                            <div class="flex items-start gap-3">
                                <svg class="mt-0.5 h-5 w-5 text-teal-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"
                                    />
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                                </svg>
                                <div>
                                    <p :class="isDark ? 'text-gray-300' : 'text-gray-700'" class="text-sm font-medium">Location</p>
                                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-gray-600'" class="text-sm">{{ appointment?.location || 'TBD' }}</p>
                                </div>
                            </div>

                            <div class="flex items-start gap-3">
                                <svg class="mt-0.5 h-5 w-5 text-teal-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                                    />
                                </svg>
                                <div>
                                    <p :class="isDark ? 'text-gray-300' : 'text-gray-700'" class="text-sm font-medium">Appointment Type</p>
                                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-gray-600'" class="text-sm">
                                        {{ appointment?.type || 'General Consultation' }}
                                    </p>
                                </div>
                            </div>

                            <div class="flex items-start gap-3">
                                <svg class="mt-0.5 h-5 w-5 text-teal-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
                                    />
                                </svg>
                                <div>
                                    <p :class="isDark ? 'text-gray-300' : 'text-gray-700'" class="text-sm font-medium">Duration</p>
                                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-gray-600'" class="text-sm">
                                        {{ appointment?.duration || '30 minutes' }}
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div v-if="appointment?.notes" :class="isDark ? 'bg-blue-900/20' : 'bg-blue-50'" class="rounded-xl p-4 transition-colors">
                            <p :class="isDark ? 'text-blue-300' : 'text-gray-700'" class="mb-2 text-sm font-medium">Notes</p>
                            <p :class="isDark ? 'text-blue-100/70' : 'text-gray-600'" class="text-sm">{{ appointment.notes }}</p>
                        </div>

                        <div class="flex gap-3 pt-4">
                            <button
                                type="button"
                                @click="handleReschedule"
                                class="flex-1 rounded-lg bg-teal-500 px-4 py-3 font-medium text-white shadow-md transition-all hover:bg-teal-600 active:scale-[0.98]"
                            >
                                Reschedule
                            </button>
                            <button
                                type="button"
                                @click="handleCancel"
                                :class="isDark ? 'border-red-500/50 text-red-400 hover:bg-red-500/10' : 'border-red-300 text-red-600 hover:bg-red-50'"
                                class="flex-1 rounded-lg border px-4 py-3 font-medium transition-all active:scale-[0.98]"
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

<style scoped>
/* Same styles as before */
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
    transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}
.modal-enter-from .relative,
.modal-leave-to .relative {
    transform: scale(0.95) translateY(10px);
}
</style>
