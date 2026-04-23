<script setup>
import { router } from '@inertiajs/vue3';
import { computed, ref, watch } from 'vue';
import CancelledAppointmentCard from '@/components/appointments/CancelledAppointmentCard.vue';
import CompletedAppointmentCard from '@/components/appointments/CompletedAppointmentCard.vue';
import ScheduledAppointmentCard from '@/components/appointments/ScheduledAppointmentCard.vue';
import RescheduleModal from '@/components/dashboard/RescheduleModal.vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import { useDashboard } from '@/composables/useDashboard.js';

const { state, setTheme } = useDashboard();

const props = defineProps({
    appointments: { type: Array, required: true, default: () => [] },
    auth: { type: Object, default: () => ({ user: null }) },
});

const localAppointments = ref([...props.appointments]);
const cancellingAppointmentId = ref(null);
const cancelError = ref('');
const cancelSuccess = ref('');

watch(
    () => props.appointments,
    (appointments) => {
        localAppointments.value = [...appointments];
    },
    { deep: true },
);

const isDark = computed(() => state.isDark);
const activeTab = computed({
    get: () => state.activeAppointmentTab || 'completed',
    set: (v) => {
        state.activeAppointmentTab = v;
    },
});

const normalizeStatus = (status) =>
    String(status ?? '')
        .trim()
        .toLowerCase();

const filteredAppointments = computed(() => {
    return localAppointments.value.filter((apt) => normalizeStatus(apt.status) === activeTab.value);
});

const tabCounts = computed(() => ({
    completed: localAppointments.value.filter((a) => normalizeStatus(a.status) === 'completed').length,
    scheduled: localAppointments.value.filter((a) => normalizeStatus(a.status) === 'scheduled').length,
    cancelled: localAppointments.value.filter((a) => normalizeStatus(a.status) === 'cancelled').length,
}));

const toggleTheme = (theme) => setTheme(theme);
const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('authToken');
        router.get('/logout');
    }
};

// 1. Add state for the modal and the selected appointment
const showRescheduleModal = ref(false);
const selectedAppointment = ref(null);

// 2. Add the function to open the modal
const openRescheduleModal = (apt) => {
    selectedAppointment.value = apt;
    showRescheduleModal.value = true;
};

// 3. Add the function to handle the actual database update
const handleRescheduleConfirm = (payload) => {
    if (!selectedAppointment.value) return;

    router.put(
        `/appointments/${selectedAppointment.value.id}`,
        {
            date: payload.date,
            time: payload.time,
            reason: payload.reason,
        },
        {
            preserveScroll: true,
            onSuccess: () => {
                selectedAppointment.value = null;
                showRescheduleModal.value = false;
            },
            onError: (errors) => {
                console.error('Reschedule failed:', errors);
            },
        },
    );
};
const handleNewAppointment = () => router.get('/appointments/create');
const handleViewPrescription = (apt) => router.get(`/prescription/${apt.id}`);
const handleReBook = (apt) => router.get(`/doctor/${apt.doctorId}`);
const handleCancelAppointment = (apt) => {
    cancelError.value = '';
    cancelSuccess.value = '';

    if (normalizeStatus(apt.status) === 'cancelled') {
        cancelError.value = 'This appointment is already cancelled.';
        return;
    }
    if (!confirm('Are you sure you want to cancel this appointment?')) return;
    if (cancellingAppointmentId.value === apt.id) return;

    cancellingAppointmentId.value = apt.id;

    router.delete(`/appointments/${apt.id}`, {
        preserveScroll: true,
        onSuccess: () => {
            localAppointments.value = localAppointments.value.map((item) => {
                if (item.id !== apt.id) return item;
                return {
                    ...item,
                    status: 'Cancelled',
                    cancelledBy: item.cancelledBy || 'Patient',
                    reason: item.reason || 'Patient Request',
                };
            });
            cancelSuccess.value = 'Appointment cancelled successfully.';
        },
        onError: (errors) => {
            const firstError = Object.values(errors || {})[0];
            cancelError.value = firstError
                ? Array.isArray(firstError)
                    ? firstError[0]
                    : firstError
                : 'Failed to cancel appointment. Please try again.';
        },
        onFinish: () => {
            cancellingAppointmentId.value = null;
        },
    });
};

const tabs = [
    { id: 'completed', label: 'Completed' },
    { id: 'scheduled', label: 'Upcoming' },
    { id: 'cancelled', label: 'Cancelled' },
];
</script>

<template>
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <Sidebar :is-dark="isDark" @toggle-theme="toggleTheme" @logout="handleLogout" />

        <div class="ml-64">
            <TopNavbar
                title="Appointments"
                :is-dark="isDark"
                :notifications="[]"
                :show-last-viewed="false"
                :show-share="false"
                @logout="handleLogout"
            />

            <main class="animate-fadeInUp p-7">
                <!-- Page header -->
                <div class="mb-7 flex items-start justify-between gap-4">
                    <div>
                        <!-- Breadcrumb -->
                        <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="mb-2 text-xs font-medium">
                            Dashboard
                            <span class="mx-1.5 text-[#D1D5DB]">/</span>
                            <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'">Appointments</span>
                        </p>

                        <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-2xl font-bold tracking-tight">
                            {{
                                activeTab === 'completed'
                                    ? 'Completed Appointments'
                                    : activeTab === 'scheduled'
                                      ? 'Upcoming Appointments'
                                      : 'Cancelled Appointments'
                            }}
                        </h1>
                        <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-sm">
                            {{
                                activeTab === 'completed'
                                    ? 'Review details from your past visits and download medical documentation.'
                                    : activeTab === 'scheduled'
                                      ? 'View and manage your upcoming scheduled appointments.'
                                      : 'Review your cancelled appointments and rebook if needed.'
                            }}
                        </p>
                    </div>

                    <button @click="handleNewAppointment" class="btn-primary shrink-0">
                        <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 4v16m8-8H4" />
                        </svg>
                        New Appointment
                    </button>
                </div>

                <!-- Tabs bar -->
                <div
                    :class="isDark ? 'border-[#1E293B] bg-[#1E293B]' : 'border-[#F1F5F9] bg-white'"
                    class="mb-7 flex items-center gap-1 rounded-2xl border p-1.5"
                    style="box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04)"
                >
                    <button
                        v-for="tab in tabs"
                        :key="tab.id"
                        @click="activeTab = tab.id"
                        :class="[
                            'flex flex-1 items-center justify-center gap-2 rounded-xl px-4 py-2.5 text-sm font-semibold transition-all duration-200',
                            activeTab === tab.id
                                ? isDark
                                    ? 'bg-[#14B8A6] text-white shadow-sm shadow-teal-500/30'
                                    : 'bg-[#14B8A6] text-white shadow-sm shadow-teal-500/20'
                                : isDark
                                  ? 'text-[#64748B] hover:bg-[#334155]/50 hover:text-[#94A3B8]'
                                  : 'text-[#94A3B8] hover:bg-[#F8FAFC] hover:text-[#64748B]',
                        ]"
                    >
                        {{ tab.label }}
                        <span
                            :class="[
                                'rounded-full px-2 py-0.5 text-[10px] font-bold tabular-nums',
                                activeTab === tab.id
                                    ? 'bg-white/20 text-white'
                                    : isDark
                                      ? 'bg-[#334155] text-[#64748B]'
                                      : 'bg-[#F1F5F9] text-[#9CA3AF]',
                            ]"
                        >
                            {{ tabCounts[tab.id] }}
                        </span>
                    </button>
                </div>

                <!-- Appointment grid -->
                <div
                    v-if="cancelSuccess"
                    class="mb-4 rounded-xl border border-emerald-200 bg-emerald-50 px-4 py-2 text-sm font-medium text-emerald-700"
                >
                    {{ cancelSuccess }}
                </div>

+                <div v-if="cancelError" class="mb-4 rounded-xl border border-red-200 bg-red-50 px-4 py-2 text-sm font-medium text-red-700">
                    {{ cancelError }}
                </div>

                <div v-if="filteredAppointments.length > 0">
                    <div v-if="activeTab !== 'cancelled'" class="grid grid-cols-1 gap-5 lg:grid-cols-2">
                        <CompletedAppointmentCard
                            v-if="activeTab === 'completed'"
                            v-for="apt in filteredAppointments"
                            :key="apt.id"
                            :appointment="apt"
                            :is-dark="isDark"
                            @view-prescription="handleViewPrescription"
                        />
                        <ScheduledAppointmentCard
                            v-if="activeTab === 'scheduled'"
                            v-for="apt in filteredAppointments"
                            :key="apt.id"
                            :appointment="apt"
                            :is-dark="isDark"
                            :is-cancelling="cancellingAppointmentId === apt.id"
                            @reschedule="openRescheduleModal"
                            @cancel="handleCancelAppointment"
                        />
                    </div>

                    <div v-else class="space-y-4">
                        <CancelledAppointmentCard
                            v-for="apt in filteredAppointments"
                            :key="apt.id"
                            :appointment="apt"
                            :is-dark="isDark"
                            @reschedule="handleReBook"
                        />
                    </div>

                    <RescheduleModal
                        :is-open="showRescheduleModal"
                        :is-dark="isDark"
                        :appointment="selectedAppointment"
                        @close="showRescheduleModal = false"
                        @confirm="handleRescheduleConfirm"
                    />

                </div>

                <!-- Empty state -->
                <div
                    v-else
                    :class="isDark ? 'border-[#1E293B] bg-[#1E293B]' : 'border-[#F1F5F9] bg-white'"
                    class="rounded-2xl border p-16 text-center"
                    style="box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04)"
                >
                    <div
                        :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'"
                        class="mx-auto mb-5 flex h-16 w-16 items-center justify-center rounded-2xl"
                    >
                        <svg
                            :class="isDark ? 'text-[#334155]' : 'text-[#CBD5E1]'"
                            class="h-8 w-8"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                        >
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="1.5"
                                d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
                            />
                        </svg>
                    </div>
                    <h3 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-2 text-base font-semibold">
                        No {{ activeTab }} appointments
                    </h3>
                    <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="mb-6 text-sm">
                        {{ activeTab === 'scheduled' ? 'Book your first appointment to get started.' : 'Nothing to show here.' }}
                    </p>
                    <button v-if="activeTab === 'scheduled'" @click="handleNewAppointment" class="btn-primary mx-auto inline-flex">
                        Book Appointment
                    </button>
                </div>
            </main>
        </div>
    </div>
</template>

<style scoped>
.animate-fadeInUp {
    animation: fadeInUp 0.4s ease-out both;
}
@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(14px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}
</style>
