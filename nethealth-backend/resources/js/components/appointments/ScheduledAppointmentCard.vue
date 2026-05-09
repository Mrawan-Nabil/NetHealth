<script setup>
defineProps({
    appointment: {
        type: Object,
        required: true,
    },
    isDark: {
        type: Boolean,
        default: false,
    },
    isCancelling: {
        type: Boolean,
        default: false,
    },
});

defineEmits(['upload-test-results', 'upload-imaging', 'reschedule', 'cancel']);
</script>

<template>
    <div
        :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'"
        class="overflow-hidden rounded-xl border transition-all duration-300"
    >
        <!-- Teal top strip — mirrors Cancelled's red strip structure exactly -->
        <div class="flex flex-wrap items-center gap-2 border-b border-teal-100 bg-teal-50 px-5 py-2.5 dark:border-teal-500/10 dark:bg-teal-500/8">
            <span class="flex items-center gap-1.5 rounded px-2 py-0.5 text-xs font-semibold" style="background:#CCFBF1;color:#0F766E;">
                <span class="h-1.5 w-1.5 rounded-full bg-[#14B8A6]"></span>
                SCHEDULED
            </span>
            <span
                v-if="appointment.visitType"
                :class="isDark ? 'bg-[#334155] text-[#94A3B8]' : 'bg-[#F3F4F6] text-[#6B7280]'"
                class="rounded px-2 py-0.5 text-xs font-semibold uppercase"
            >
                {{ appointment.visitType }}
            </span>
        </div>

        <!-- Horizontal body — same structure as CancelledAppointmentCard -->
        <div class="flex items-start justify-between gap-4 p-5">

            <!-- Left: doctor info -->
            <div class="flex flex-1 items-start gap-3">
                <img
                    :src="appointment.doctorAvatar"
                    alt="Doctor"
                    class="h-12 w-12 flex-shrink-0 rounded-full object-cover"
                />
                <div class="flex-1">
                    <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold">
                        {{ appointment.doctorName }}
                    </h3>
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">{{ appointment.specialty }}</p>
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="mt-2 text-sm">{{ appointment.dateTime }}</p>
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">{{ appointment.clinicAddress }}</p>
                </div>
            </div>

            <!-- Right: upload buttons + secondary actions -->
            <div class="flex shrink-0 flex-col gap-2">
                <button
                    @click="$emit('upload-test-results', appointment)"
                    class="flex items-center gap-2 rounded-lg bg-[#14B8A6] px-4 py-2.5 text-sm font-semibold text-white transition-colors hover:bg-[#0F9B8E]"
                >
                    <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                    </svg>
                    Upload Test Results
                </button>
                <button
                    @click="$emit('upload-imaging', appointment)"
                    class="flex items-center gap-2 rounded-lg bg-[#14B8A6] px-4 py-2.5 text-sm font-semibold text-white transition-colors hover:bg-[#0F9B8E]"
                >
                    <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                    Upload Imaging
                </button>
                <div class="flex items-center justify-between gap-3 pt-0.5">
                    <button
                        @click="$emit('reschedule', appointment)"
                        :class="isDark ? 'text-[#94A3B8] hover:text-[#F1F5F9]' : 'text-[#6B7280] hover:text-[#111827]'"
                        class="text-xs font-medium transition-colors"
                    >
                        Reschedule
                    </button>
                    <button
                        @click="$emit('cancel', appointment)"
                        :disabled="isCancelling"
                        :class="isDark ? 'text-[#94A3B8] hover:text-red-400' : 'text-[#9CA3AF] hover:text-red-600'"
                        class="text-xs font-medium transition-colors disabled:cursor-not-allowed disabled:opacity-50"
                    >
                        {{ isCancelling ? 'Cancelling...' : 'Cancel' }}
                    </button>
                </div>
            </div>

        </div>
    </div>
</template>
