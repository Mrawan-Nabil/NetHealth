<script setup>
import { Link } from '@inertiajs/vue3';
import { computed } from 'vue';

const props = defineProps({
    appointment: { type: Object, default: null },
    isDark:      Boolean,
});

const emit = defineEmits(['view-details', 'reschedule']);

const statusMeta = computed(() => {
    const s = props.appointment?.appointment_status?.toLowerCase() || '';
    const map = {
        scheduled: { label: 'Scheduled', cls: 'bg-emerald-50 text-emerald-700',     dotCls: 'bg-emerald-400' },
        pending:   { label: 'Pending',   cls: 'bg-amber-50  text-amber-700',         dotCls: 'bg-amber-400'  },
        cancelled: { label: 'Cancelled', cls: 'bg-red-50    text-red-700',            dotCls: 'bg-red-400'    },
    };
    return map[s] || { label: props.appointment?.appointment_status, cls: 'bg-slate-50 text-slate-600', dotCls: 'bg-slate-400' };
});
</script>

<template>
    <div
        :class="isDark ? 'border-[#1E293B] bg-[#1E293B]' : 'border-[#F1F5F9] bg-white'"
        class="dash-card border p-6"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <!-- Header -->
        <div class="mb-5 flex items-center justify-between">
            <h3
                :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'"
                class="text-sm font-semibold uppercase tracking-wide"
            >
                Next Appointment
            </h3>
            <span v-if="appointment" :class="statusMeta.cls" class="flex items-center gap-1.5 rounded-full px-2.5 py-1 text-xs font-semibold">
                <span :class="statusMeta.dotCls" class="h-1.5 w-1.5 rounded-full" />
                {{ statusMeta.label }}
            </span>
        </div>

        <!-- Has appointment -->
        <div v-if="appointment" class="space-y-5">
            <!-- Doctor info -->
            <div class="flex items-start gap-4">
                <div class="relative shrink-0">
                    <img
                        :src="appointment?.doctor?.user?.avatar || '/images/default-avatar.png'"
                        :alt="appointment?.doctor?.user?.full_name || 'Doctor'"
                        class="h-12 w-12 rounded-full object-cover ring-2"
                        :class="isDark ? 'ring-[#334155]' : 'ring-[#F1F5F9]'"
                    />
                    <span class="absolute -right-0.5 -bottom-0.5 h-3.5 w-3.5 rounded-full border-2 border-white bg-emerald-400" />
                </div>
                <div class="min-w-0 flex-1">
                    <h4 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-0.5 font-semibold">
                        {{ appointment?.doctor?.user?.full_name }}
                    </h4>
                    <p :class="isDark ? 'text-[#14B8A6]' : 'text-[#0D9488]'" class="mb-3 text-xs font-medium">
                        {{ appointment?.doctor?.specialty }}
                    </p>

                    <!-- Meta rows -->
                    <div class="space-y-1.5">
                        <div class="flex items-center gap-2">
                            <svg :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="h-3.5 w-3.5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                            <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'" class="text-xs">{{ appointment?.appointment_time }}</span>
                        </div>
                        <div class="flex items-start gap-2">
                            <svg :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="mt-px h-3.5 w-3.5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                            </svg>
                            <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'" class="text-xs leading-snug">{{ appointment?.clinic?.clinic_address }}</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Divider -->
            <div :class="isDark ? 'bg-[#334155]' : 'bg-[#F1F5F9]'" class="h-px" />

            <!-- Actions -->
            <div class="flex gap-2.5">
                <button
                    @click="$emit('view-details', appointment)"
                    class="btn-primary flex-1 justify-center text-center"
                >
                    View Details
                </button>
                <button
                    @click="$emit('reschedule', appointment)"
                    :class="isDark
                        ? 'border-[#334155] bg-[#334155]/60 text-[#94A3B8] hover:bg-[#334155] hover:text-[#F1F5F9]'
                        : 'border-[#E5E7EB] bg-[#F8FAFC] text-[#64748B] hover:bg-[#F1F5F9] hover:text-[#0F172A]'"
                    class="flex-1 rounded-xl border py-2 text-sm font-semibold transition-all duration-200"
                >
                    Reschedule
                </button>
            </div>
        </div>

        <!-- Empty state -->
        <div v-else class="py-10 text-center">
            <div
                :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'"
                class="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-full"
            >
                <svg :class="isDark ? 'text-[#334155]' : 'text-[#CBD5E1]'" class="h-7 w-7" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
            </div>
            <h4 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-sm font-semibold">No upcoming appointments</h4>
            <p :class="isDark ? 'text-[#475569]' : 'text-[#94A3B8]'" class="mb-4 text-xs">Schedule your next visit to get started</p>
            <Link
                href="/appointments/create"
                class="btn-primary mx-auto inline-flex"
            >
                Book Now
            </Link>
        </div>
    </div>
</template>
