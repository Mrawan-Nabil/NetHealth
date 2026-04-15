<script setup>
import { router, Link } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
import ActivityTimeline from '@/components/dashboard/ActivityTimeline.vue';
import AppointmentCard from '@/components/dashboard/AppointmentCard.vue';
import AppointmentDetailsModal from '@/components/dashboard/AppointmentDetailsModal.vue';
import ChatWidget from '@/components/dashboard/ChatWidget.vue';
import HealthOverview from '@/components/dashboard/HealthOverview.vue';
import MedicalRecordItem from '@/components/dashboard/MedicalRecordItem.vue';
import RescheduleModal from '@/components/dashboard/RescheduleModal.vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import StatsCard from '@/components/dashboard/StatsCard.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import { useDashboard } from '@/composables/useDashboard';

const props = defineProps({
    healthOverview:          { type: Object,  default: () => ({}) },
    upcomingAppointments:    { type: Number,  default: 0 },
    latestPrescriptionCount: { type: Number,  default: 0 },
    pendingTests:            { type: Number,  default: 0 },
    nextAppointment:         { type: Object,  default: null },
    recentRecords:           { type: Array,   default: () => [] },
    activities:              { type: Array,   default: () => [] },
    notifications:           { type: Array,   default: () => [] },
});

/* ── state ── */
const { state, setTheme }   = useDashboard();
const isDark                = computed(() => state.isDark);
const showAppointmentDetails = ref(false);
const showRescheduleModal   = ref(false);
const showChatWidget        = ref(false);
const selectedAppointment   = ref(null);

/* ── theme ── */
const toggleTheme = (theme) => {
    setTheme(theme);
};

/* ── navigation ── */
const handleBookAppointment = ()       => router.get('/appointments/create');
const handleStatsClick      = (data)  => {
    if (data.label.includes('Appointment')) router.get('/appointments');
    else if (data.label.includes('Prescription')) router.get('/prescription');
    else if (data.label.includes('Test')) router.get('/test-results');
};

/* ── appointment actions ── */
const openAppointmentDetails = (apt) => { selectedAppointment.value = apt; showAppointmentDetails.value = true; };
const openRescheduleModal    = (apt) => { selectedAppointment.value = apt || props.nextAppointment; showAppointmentDetails.value = false; showRescheduleModal.value = true; };
const handleRescheduleConfirm = (d)  => alert(`Appointment rescheduled to ${d.date} at ${d.time}`);
const handleCancelAppointment = ()   => {
    if (confirm('Are you sure you want to cancel this appointment?')) {
        router.delete(`/appointments/${selectedAppointment.value.id}`, {
            preserveScroll: true,
            onSuccess: () => { showAppointmentDetails.value = false; },
        });
    }
};

/* ── notifications ── */
const markNotificationAsRead  = (id) => { const n = props.notifications.find(n => n.id === id); if (n) n.read = true; };
const markAllNotificationsAsRead = () => props.notifications.forEach(n => (n.read = true));
const handleNotificationClick = (n)  => {
    if (n.type === 'appointment') router.get('/appointments');
    else if (n.type === 'test') router.get('/test-results');
    else if (n.type === 'prescription') router.get('/medical-records');
};

/* ── logout ── */
const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('authToken');
        router.get('/logout');
    }
};

</script>

<template>
    <div
        :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'"
        class="min-h-screen transition-colors duration-300"
    >
        <Sidebar :is-dark="isDark" @toggle-theme="toggleTheme" @logout="handleLogout" />

        <div class="ml-64">
            <TopNavbar
                title="Dashboard"
                :notifications="props.notifications"
                :is-dark="isDark"
                @mark-read="markNotificationAsRead"
                @mark-all-read="markAllNotificationsAsRead"
                @notification-click="handleNotificationClick"
                @logout="handleLogout"
            />

            <main class="p-7 space-y-6 animate-fadeInUp">

                <!-- ── Welcome banner ── -->
                <div
                    :class="isDark ? 'border-[#1E293B] bg-[#1E293B]' : 'border-[#F1F5F9] bg-white'"
                    class="flex items-center justify-between rounded-2xl border px-6 py-5"
                    style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
                >
                    <div>
                        <h2 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-0.5 text-xl font-bold">
                            Welcome back, {{ $page.props.auth.user.full_name }} 👋
                        </h2>
                        <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-sm">
                            Here's your health overview for today.
                        </p>
                    </div>
                    <!-- Today's date pill -->
                    <div
                        :class="isDark ? 'bg-[#0F172A] text-[#64748B]' : 'bg-[#F8FAFC] text-[#94A3B8]'"
                        class="hidden items-center gap-2 rounded-xl px-4 py-2 text-xs font-medium sm:flex"
                    >
                        <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                        </svg>
                        {{ new Date().toLocaleDateString('en-GB', { weekday:'long', day:'numeric', month:'long' }) }}
                    </div>
                </div>

                <!-- ── Book appointment CTA ── -->
                <div class="relative overflow-hidden rounded-2xl bg-gradient-to-r from-[#0D9488] via-[#14B8A6] to-[#0891B2] p-6 text-white shadow-lg shadow-teal-500/15">
                    <!-- Background decoration -->
                    <div class="pointer-events-none absolute -right-8 -top-8 h-40 w-40 rounded-full bg-white/5" />
                    <div class="pointer-events-none absolute right-20 bottom-0 h-24 w-24 rounded-full bg-white/5" />

                    <div class="relative z-10 flex items-center justify-between gap-6">
                        <div class="flex-1">
                            <p class="mb-1 text-xs font-semibold uppercase tracking-wider text-white/70">Quick Action</p>
                            <h3 class="mb-2 text-xl font-bold">Book a New Appointment</h3>
                            <p class="mb-4 max-w-sm text-sm leading-relaxed text-white/85">
                                Schedule a consultation with your preferred doctor. Get instant confirmation and digital prescriptions.
                            </p>
                            <div class="flex flex-wrap items-center gap-4 text-xs text-white/80">
                                <span class="flex items-center gap-1.5">
                                    <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                    </svg>
                                    Available 24/7
                                </span>
                                <span class="flex items-center gap-1.5">
                                    <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                    </svg>
                                    Verified Doctors
                                </span>
                                <span class="flex items-center gap-1.5">
                                    <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                                    </svg>
                                    Secure &amp; Private
                                </span>
                            </div>
                        </div>

                        <div class="flex shrink-0 flex-col items-end gap-2">
                            <button
                                @click="handleBookAppointment"
                                class="flex items-center gap-2 rounded-xl bg-white px-5 py-2.5 text-sm font-bold text-[#0D9488] shadow-lg shadow-black/10 transition-all duration-200 hover:bg-gray-50 hover:shadow-xl hover:-translate-y-0.5 active:translate-y-0"
                            >
                                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 4v16m8-8H4"/>
                                </svg>
                                Book Now
                            </button>
                            <p class="text-[10px] uppercase tracking-widest text-white/60">Takes less than 2 minutes</p>
                        </div>
                    </div>
                </div>

                <!-- ── Stats row ── -->
                <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
                    <StatsCard
                        :value="upcomingAppointments"
                        label="Upcoming Appointments"
                        icon="calendar"
                        :is-dark="isDark"
                        class="animate-fadeInUp stagger-1"
                        @click="handleStatsClick"
                    />
                    <StatsCard
                        :value="latestPrescriptionCount"
                        label="Active Prescriptions"
                        icon="prescription"
                        :is-dark="isDark"
                        class="animate-fadeInUp stagger-2"
                        @click="handleStatsClick"
                    />
                    <StatsCard
                        :value="pendingTests"
                        label="Pending Test Results"
                        icon="test"
                        :is-dark="isDark"
                        class="animate-fadeInUp stagger-3"
                        @click="handleStatsClick"
                    />

                    <!-- AI Assistant card -->
                    <div
                        @click="showChatWidget = true"
                        class="animate-fadeInUp stagger-4 group cursor-pointer rounded-2xl bg-gradient-to-br from-violet-500 to-purple-600 p-5 shadow-lg shadow-violet-500/20 transition-all duration-200 hover:shadow-xl hover:shadow-violet-500/30 hover:-translate-y-0.5"
                    >
                        <div class="mb-3 flex items-center gap-2">
                            <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-white/20">
                                <svg class="h-4 w-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m1.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z"/>
                                </svg>
                            </div>
                            <p class="text-xs font-semibold text-white/90">AI Assistant</p>
                        </div>
                        <h3 class="mb-1 text-sm font-bold text-white">Need Help?</h3>
                        <p class="mb-3 text-xs leading-relaxed text-white/75">
                            Ask our AI Medical Assistant for quick answers.
                        </p>
                        <div class="flex items-center gap-1.5 text-xs font-semibold text-white/90">
                            <span>Ask Now</span>
                            <svg class="h-3 w-3 transition-transform duration-200 group-hover:translate-x-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"/>
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- ── Main grid ── -->
                <div class="grid grid-cols-1 gap-6 lg:grid-cols-3">

                    <!-- Left 2/3 -->
                    <div class="space-y-6 lg:col-span-2">

                        <!-- Next appointment -->
                        <AppointmentCard
                            :appointment="nextAppointment"
                            :is-dark="isDark"
                            @view-details="openAppointmentDetails"
                            @reschedule="openRescheduleModal"
                        />

                        <!-- Recent medical records -->
                        <div
                            :class="isDark ? 'border-[#1E293B] bg-[#1E293B]' : 'border-[#F1F5F9] bg-white'"
                            class="rounded-2xl border p-6"
                            style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
                        >
                            <div class="mb-5 flex items-center justify-between">
                                <h3
                                    :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'"
                                    class="text-sm font-semibold"
                                >
                                    Recent Medical Records
                                </h3>
                                <Link
                                    href="/medical-records"
                                    :class="isDark ? 'text-[#2DD4BF] hover:text-[#14B8A6]' : 'text-[#14B8A6] hover:text-[#0D9488]'"
                                    class="flex items-center gap-1 text-xs font-semibold transition-colors"
                                >
                                    View All
                                    <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                                    </svg>
                                </Link>
                            </div>

                            <div v-if="props.recentRecords.length > 0" class="space-y-2">
                                <MedicalRecordItem
                                    v-for="(record, index) in props.recentRecords"
                                    :key="index"
                                    :record="record"
                                    :is-dark="isDark"
                                />
                            </div>

                            <div v-else class="py-8 text-center">
                                <p :class="isDark ? 'text-[#475569]' : 'text-[#94A3B8]'" class="text-sm">
                                    No recent records to display.
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Right 1/3 -->
                    <div class="space-y-6">
                        <HealthOverview :patient="healthOverview" :is-dark="isDark" />
                        <ActivityTimeline :activities="activities" :is-dark="isDark" />
                    </div>
                </div>
            </main>
        </div>

        <!-- Modals -->
        <AppointmentDetailsModal
            :is-open="showAppointmentDetails"
            :appointment="selectedAppointment"
            :is-dark="isDark"
            @close="showAppointmentDetails = false"
            @reschedule="openRescheduleModal"
            @cancel="handleCancelAppointment"
        />
        <RescheduleModal
            :is-open="showRescheduleModal"
            :appointment="selectedAppointment"
            @close="showRescheduleModal = false"
            @confirm="handleRescheduleConfirm"
        />
        <ChatWidget :is-open="showChatWidget" @close="showChatWidget = false" />
    </div>
</template>

<style scoped>
main {
    animation: fadeInUp 0.4s ease-out both;
}
@keyframes fadeInUp {
    from { opacity: 0; transform: translateY(16px); }
    to   { opacity: 1; transform: translateY(0); }
}
</style>
