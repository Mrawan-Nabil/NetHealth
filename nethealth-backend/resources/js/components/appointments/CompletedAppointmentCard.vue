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
});

defineEmits(['view-prescription', 'view-report']);
</script>

<template>
    <div
        :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'"
        class="flex gap-0 overflow-hidden rounded-xl border transition-all duration-300 lg:flex-row"
    >
        <!-- Left column: doctor info + status -->
        <div class="flex flex-1 flex-col justify-between p-5">
            <div>
                <!-- Doctor info -->
                <div class="mb-4 flex items-center gap-3">
                    <img :src="appointment.doctorAvatar" alt="Doctor" class="h-11 w-11 rounded-full object-cover" />
                    <div>
                        <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">
                            {{ appointment.doctorName }}
                        </h3>
                        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs">{{ appointment.specialty }}</p>
                    </div>
                </div>

                <!-- Date, time, clinic -->
                <div :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="space-y-1 text-xs">
                    <p class="flex items-center gap-1.5">
                        <svg class="h-3.5 w-3.5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                        </svg>
                        {{ appointment.dateTime }}
                    </p>
                    <p class="flex items-center gap-1.5">
                        <svg class="h-3.5 w-3.5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                        </svg>
                        {{ appointment.clinicAddress }}
                    </p>
                </div>
            </div>

            <!-- Status badge at bottom of left col -->
            <div class="mt-4">
                <span class="inline-flex items-center gap-1.5 rounded-full bg-[#D1FAE5] px-3 py-1 text-xs font-semibold text-[#065F46]">
                    <svg class="h-3 w-3" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                    </svg>
                    Completed
                </span>
            </div>
        </div>

        <!-- Divider -->
        <div :class="isDark ? 'bg-[#334155]' : 'bg-[#F1F5F9]'" class="hidden w-px lg:block"></div>

        <!-- Right column: reports + actions -->
        <div class="flex w-full flex-col p-5 lg:w-56">
            <!-- Reports section -->
            <div
                :class="isDark ? 'bg-[#0F766E]/10 border-[#14B8A6]/20' : 'bg-[#CCFBF1] border-[#14B8A6]/30'"
                class="mb-4 flex-1 rounded-lg border p-3"
            >
                <div class="mb-2 flex items-center gap-1.5">
                    <svg class="h-3.5 w-3.5 text-[#F97316]" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M2 6a2 2 0 012-2h5l2 2h5a2 2 0 012 2v6a2 2 0 01-2 2H4a2 2 0 01-2-2V6z" />
                    </svg>
                    <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-xs font-semibold">Reports & X-rays</span>
                </div>

                <div v-if="appointment.reports && appointment.reports.length > 0" class="space-y-1.5">
                    <div
                        v-for="report in appointment.reports"
                        :key="report.name"
                        :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'"
                        class="flex items-center gap-2 rounded-lg border px-2.5 py-1.5"
                    >
                        <svg class="h-3.5 w-3.5 text-[#EF4444]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                        </svg>
                        <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="flex-1 truncate text-xs font-medium">{{ report.name }}</span>
                    </div>
                </div>
                <div v-else class="flex items-center gap-1.5">
                    <svg class="h-3.5 w-3.5" :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                    </svg>
                    <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs">No reports uploaded</span>
                </div>
            </div>

            <!-- Action buttons -->
            <div class="space-y-2">
                <button
                    @click="$emit('view-prescription', appointment)"
                    class="flex w-full items-center justify-center gap-2 rounded-lg bg-[#14B8A6] px-4 py-2 text-xs font-semibold text-white transition-colors hover:bg-[#0F9B8E]"
                >
                    <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                    </svg>
                    Prescription
                </button>
                <button
                    @click="$emit('view-report', appointment)"
                    :disabled="!appointment.reports || appointment.reports.length === 0"
                    :class="[
                        'flex w-full items-center justify-center gap-2 rounded-lg px-4 py-2 text-xs font-semibold transition-colors',
                        appointment.reports && appointment.reports.length > 0
                            ? 'bg-[#14B8A6] text-white hover:bg-[#0F9B8E]'
                            : isDark
                              ? 'cursor-not-allowed bg-[#334155] text-[#94A3B8]'
                              : 'cursor-not-allowed bg-[#F3F4F6] text-[#9CA3AF]',
                    ]"
                >
                    <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                    </svg>
                    View Report
                </button>
            </div>
        </div>
    </div>
</template>
