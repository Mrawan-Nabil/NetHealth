<script setup>
import { Link } from '@inertiajs/vue3';
import { computed } from 'vue';

const props = defineProps({
    appointment: {
        type: Object,
        default: null,
    },
    isDark: Boolean,
});

const statusClass = computed(() => {
    const status = props.appointment?.appointment_status?.toLowerCase() || '';
    const classes = {
        scheduled: 'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400',
        pending: 'bg-yellow-100 text-yellow-700 dark:bg-yellow-900/30 dark:text-yellow-400',
        cancelled: 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400',
    };
    return classes[status] || 'bg-gray-100 text-gray-700';
});
</script>

<template>
    <div
        :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'"
        class="container-hover-subtle rounded-xl border p-6 shadow-sm"
    >
        <div class="mb-6 flex items-start justify-between">
            <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold">Next Appointment</h3>
            <span v-if="appointment" :class="statusClass" class="rounded-full px-3 py-1 text-xs font-semibold">
                {{ appointment.appointment_status }}
            </span>
        </div>

        <div v-if="appointment" class="space-y-6">
            <div class="flex items-start gap-4">
                <img
                    :src="appointment?.doctor?.user?.avatar || '/images/default-avatar.png'"
                    :alt="appointment?.doctor?.user?.full_name || 'Doctor'"
                    class="smooth-transition h-14 w-14 shrink-0 rounded-full object-cover ring-2"
                    :class="isDark ? 'ring-[#334155]' : 'ring-gray-100'"
                />
                <div class="min-w-0 flex-1">
                    <h4 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-1 text-base font-semibold">
                        {{ appointment?.doctor?.user?.full_name }}
                    </h4>
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="mb-3 text-sm">{{ appointment?.doctor?.specialty }}</p>
                    <div class="space-y-1">
                        <div class="flex items-center gap-2">
                            <svg
                                :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'"
                                class="h-4 w-4"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                    stroke-width="2"
                                    d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
                                />
                            </svg>
                            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">{{ appointment?.appointment_time }}</p>
                        </div>
                        <div class="flex items-center gap-2">
                            <svg
                                :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'"
                                class="h-4 w-4"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                    stroke-width="2"
                                    d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"
                                />
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                            </svg>
                            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">{{ appointment?.clinic?.clinic_address }}</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="flex gap-3">
                <Link
                    href="/appointments/create"
                    class="btn-primary flex-1 rounded-lg bg-primary px-4 py-3 text-sm font-medium text-white hover:bg-[#0F9B8E]"
                >
                    View Details
                </Link>
                <Link
                    href="/appointments/create"
                    :class="[
                        'btn-secondary flex-1 rounded-lg border px-4 py-3 text-sm font-medium',
                        isDark
                            ? 'border-[#334155] bg-[#334155] text-[#94A3B8] hover:bg-[#475569] hover:text-[#F8FAFC]'
                            : 'border-[#E5E7EB] bg-[#F8FAFC] text-[#6B7280] hover:bg-[#E5E7EB] hover:text-[#111827]',
                    ]"
                >
                    Reschedule
                </Link>
            </div>
        </div>

        <div v-else class="py-12 text-center">
            <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="mx-auto mb-4 flex h-16 w-16 items-center justify-center rounded-full">
                <svg :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
                    />
                </svg>
            </div>
            <h4 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-1 font-semibold">No upcoming appointments</h4>
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">Schedule your next appointment to get started</p>
        </div>
    </div>
</template>
