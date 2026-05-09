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

defineEmits(['reschedule']);
</script>

<template>
    <div
        :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'"
        class="overflow-hidden rounded-xl border transition-all duration-300"
    >
        <!-- Red top notice strip -->
        <div class="flex flex-wrap items-center gap-2 border-b border-red-100 bg-red-50 px-5 py-2.5 dark:border-red-500/10 dark:bg-red-500/8">
            <span class="flex items-center gap-1.5 rounded px-2 py-0.5 text-xs font-semibold" style="background:#FEE2E2;color:#991B1B;">
                <span class="h-1.5 w-1.5 rounded-full bg-[#EF4444]"></span>
                CANCELLED
            </span>
            <span
                v-if="appointment.reason"
                :class="isDark ? 'bg-[#334155] text-[#94A3B8]' : 'bg-[#F3F4F6] text-[#6B7280]'"
                class="rounded px-2 py-0.5 text-xs font-semibold uppercase"
            >
                {{ appointment.reason }}
            </span>
        </div>

        <!-- Horizontal body -->
        <div class="flex items-start justify-between gap-4 p-5">
            <!-- Left: doctor info -->
            <div class="flex items-start gap-3 flex-1">
                <img
                    :src="appointment.doctorAvatar"
                    alt="Doctor"
                    class="h-12 w-12 flex-shrink-0 rounded-full object-cover opacity-60"
                />
                <div class="flex-1">
                    <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold">
                        {{ appointment.doctorName }}
                    </h3>
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">{{ appointment.specialty }}</p>

                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="mt-2 text-sm">{{ appointment.dateTime }}</p>
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">{{ appointment.clinicAddress }}</p>

                    <div v-if="appointment.cancelledBy" class="mt-2">
                        <span :class="isDark ? 'text-[#64748B]' : 'text-[#9CA3AF]'" class="text-xs font-medium">
                            Cancelled by {{ appointment.cancelledBy }}
                        </span>
                    </div>
                </div>
            </div>

            <!-- Right: reschedule button -->
            <button
                @click="$emit('reschedule', appointment)"
                class="flex shrink-0 items-center gap-2 rounded-lg bg-[#14B8A6] px-4 py-2.5 text-sm font-semibold text-white transition-colors hover:bg-[#0F9B8E]"
            >
                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
                Reschedule
            </button>
        </div>
    </div>
</template>
