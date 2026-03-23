<script setup>
import { router, Link } from '@inertiajs/vue3';
import { ref, onMounted, watch } from 'vue';
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

// LARAVEL DATA BINDING: Real data coming straight from Patient/DashboardController
const props = defineProps({
    healthOverview: {
        type: Object,
        default: () => ({})
    },
    upcomingAppointments: {
        type: Number,
        default: 0
    },
    latestPrescriptionCount: {
        type: Number,
        default: 0
    },
    pendingTests: {
        type: Number,
        default: 0
    },
    nextAppointment: {
        type: Object,
        default: null
    },
    recentRecords: {
        type: Array,
        default: () => []
    },
    activities: {
        type: Array,
        default: () => []
    },
    notifications: {
        type: Array,
        default: () => [],
    },
});

// State
const isDark = ref(false);
const showAppointmentDetails = ref(false);
const showRescheduleModal = ref(false);
const showChatWidget = ref(false);
const selectedAppointment = ref(null);

// Methods
const toggleTheme = (theme) => {
    isDark.value = theme === 'dark';
    localStorage.setItem('theme', theme);
};

const handleBookAppointment = () => {
    router.get('/appointments/create');
};

const handleStatsClick = (data) => {
    console.log('Stats clicked:', data);
    if (data.label.includes('Appointments')) {
        router.get('/appointments');
    } else if (data.label.includes('Prescription')) {
        router.get('/medical-records');
    } else if (data.label.includes('Test')) {
        router.get('/test-results');
    }
};

const openAppointmentDetails = (appointment) => {
    selectedAppointment.value = appointment;
    showAppointmentDetails.value = true;
};

const openRescheduleModal = (appointment) => {
    selectedAppointment.value = appointment || props.nextAppointment;
    showAppointmentDetails.value = false;
    showRescheduleModal.value = true;
};

const handleRescheduleConfirm = (rescheduleData) => {
    console.log('Rescheduling appointment:', rescheduleData);
    alert(`Appointment rescheduled to ${rescheduleData.date} at ${rescheduleData.time}`);
};

const handleCancelAppointment = () => {
    if (confirm('Are you sure you want to cancel this appointment?')) {
        router.delete(`/appointments/${selectedAppointment.value.id}`, {
            preserveScroll: true,
            onSuccess: () => {
                showAppointmentDetails.value = false;
            },
        });
    }
};

const openChatWidget = () => {
    showChatWidget.value = true;
};

const markNotificationAsRead = (id) => {
    // Note: If you want to persist this, you'll need a router.post('/notifications/mark-read') later!
    const notification = props.notifications.find((n) => n.id === id);
    if (notification) {
        notification.read = true;
    }
};

const markAllNotificationsAsRead = () => {
    props.notifications.forEach((n) => (n.read = true));
};

const handleNotificationClick = (notification) => {
    console.log('Notification clicked:', notification);
    if (notification.type === 'appointment') {
        router.get('/appointments');
    } else if (notification.type === 'test') {
        router.get('/test-results');
    } else if (notification.type === 'prescription') {
        router.get('/medical-records');
    }
};

const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('authToken');
        router.get('/logout');
    }
};

// Lifecycle
onMounted(() => {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme) {
        isDark.value = savedTheme === 'dark';
    }
});

// Watch for theme changes
watch(isDark, (newVal) => {
    if (newVal) {
        document.documentElement.classList.add('dark');
    } else {
        document.documentElement.classList.remove('dark');
    }
});
</script>

<template>
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="dashboard-layout min-h-screen transition-colors duration-300">
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

            <main class="space-y-4 p-6">
                <div
                    :class="isDark ? 'border-[#334155] bg-[#1E293B] shadow-lg shadow-black/20' : 'border-[#E5E7EB] bg-white shadow-sm'"
                    class="rounded-lg border p-5 transition-all duration-300"
                >
                    <h2 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-1 text-xl font-bold">
                        Welcome back, {{ $page.props.auth.user.full_name }} 👋
                    </h2>
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">Here's your health overview for today</p>
                </div>

                <div
                    class="relative overflow-hidden rounded-lg bg-gradient-to-r from-[#14B8A6] to-[#0D9488] p-6 text-white shadow-lg transition-all duration-300 hover:shadow-xl"
                >
                    <div class="relative z-10 flex items-center justify-between">
                        <div class="flex-1">
                            <h3 class="mb-2 text-xl font-bold">Book a New Appointment</h3>
                            <p class="mb-3 max-w-md text-sm text-white/90">
                                Schedule a consultation with your preferred doctor in just a few steps. Get instant confirmation and digital
                                prescriptions.
                            </p>
                            <div class="flex items-center gap-4 text-xs">
                                <div class="flex items-center gap-1.5">
                                    <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path
                                            stroke-linecap="round"
                                            stroke-linejoin="round"
                                            stroke-width="2"
                                            d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
                                        />
                                    </svg>
                                    <span>Available 24/7</span>
                                </div>
                                <div class="flex items-center gap-1.5">
                                    <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path
                                            stroke-linecap="round"
                                            stroke-linejoin="round"
                                            stroke-width="2"
                                            d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                                        />
                                    </svg>
                                    <span>Verified Doctors</span>
                                </div>
                            </div>
                        </div>
                        <div class="flex flex-col items-end">
                            <button
                                @click="handleBookAppointment"
                                class="flex items-center gap-2 rounded-lg bg-white px-5 py-2 text-sm font-semibold text-[#14B8A6] shadow-md transition-all duration-300 hover:bg-gray-50"
                            >
                                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
                                    />
                                </svg>
                                Book Now
                            </button>
                            <p class="mt-1.5 text-xs tracking-wide text-white/80 uppercase">Takes less than 2 minutes</p>
                        </div>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                    <div>
                        <StatsCard
                            :value="upcomingAppointments"
                            label="Upcoming Appointments"
                            icon="calendar"
                            :is-dark="isDark"
                            @click="handleStatsClick"
                        />
                    </div>
                    <div>
                        <StatsCard
                            :value="latestPrescriptionCount"
                            label="Latest Prescription"
                            icon="prescription"
                            :is-dark="isDark"
                            @click="handleStatsClick"
                        />
                    </div>
                    <div>
                        <StatsCard
                            :value="pendingTests"
                            label="Pending Test Results"
                            icon="test"
                            :is-dark="isDark"
                            @click="handleStatsClick" />
                    </div>

                    <div>
                        <div
                            @click="openChatWidget"
                            class="cursor-pointer rounded-lg bg-gradient-to-br from-[#14B8A6] to-[#0D9488] p-4 text-white shadow-md transition-all duration-300 hover:shadow-lg"
                        >
                            <div class="mb-2 flex items-center gap-2">
                                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M18.364 5.636l-3.536 3.536m0 5.656l3.536 3.536M9.172 9.172L5.636 5.636m3.536 9.192l-3.536 3.536M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-5 0a4 4 0 11-8 0 4 4 0 018 0z"
                                    />
                                </svg>
                                <h3 class="text-sm font-semibold">Need Help?</h3>
                            </div>
                            <p class="mb-3 text-xs leading-relaxed text-white/90">
                                Ask our AI Medical Assistant for quick answers about your health.
                            </p>
                            <button
                                class="w-full rounded-lg bg-white px-3 py-1.5 text-xs font-medium text-[#14B8A6] transition-colors duration-300 hover:bg-gray-50"
                            >
                                Ask Now
                            </button>
                        </div>
                    </div>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-3 gap-4">
                    <div class="col-span-2 space-y-4">
                        <AppointmentCard
                            :appointment="nextAppointment"
                            :is-dark="isDark"
                            @view-details="openAppointmentDetails"
                            @reschedule="openRescheduleModal"
                        />

                        <div
                            :class="isDark ? 'border-[#334155] bg-[#1E293B] shadow-lg shadow-black/20' : 'border-[#E5E7EB] bg-white shadow-sm'"
                            class="rounded-lg border p-5 transition-all duration-300"
                        >
                            <div class="mb-4 flex items-center justify-between">
                                <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">Recent Medical Records</h3>
                                <Link
                                    href="/medical-records"
                                    :class="isDark ? 'text-[#2DD4BF] hover:text-[#14B8A6]' : 'text-[#14B8A6] hover:text-[#0D9488]'"
                                    class="text-xs font-medium transition-colors"
                                >
                                    View Full Records
                                </Link>
                            </div>
                            <div class="space-y-2">
                                <MedicalRecordItem v-for="(record, index) in props.recentRecords" :key="index" :record="record" :is-dark="isDark" />
                            </div>
                        </div>
                    </div>

                    <div class="space-y-4">
                        <HealthOverview :patient="healthOverview" :is-dark="isDark" />

                        <ActivityTimeline :activities="activities" :is-dark="isDark" />
                    </div>
                </div>
            </main>
        </div>

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
@import '@/assets/dashboard-animations.css';

/* Dashboard-specific animations */
.dashboard-layout {
    animation: dashboardFadeIn 0.4s ease-out;
}

@keyframes dashboardFadeIn {
    from {
        opacity: 0;
    }
    to {
        opacity: 1;
    }
}

/* Apply dashboard animations to child elements */
.dashboard-layout :deep(.animate-fade-in-up) {
    animation: dashboardCardSlideUp 0.5s ease-out backwards;
}

.dashboard-layout :deep(.stagger-1) {
    animation-delay: 0.1s;
}

.dashboard-layout :deep(.stagger-2) {
    animation-delay: 0.2s;
}

.dashboard-layout :deep(.stagger-3) {
    animation-delay: 0.3s;
}

.dashboard-layout :deep(.stagger-4) {
    animation-delay: 0.4s;
}

/* Dashboard card hover effects */
.dashboard-layout :deep(.hover\:-translate-y-1:hover) {
    transform: translateY(-4px);
}

.dashboard-layout :deep(.hover\:scale-105:hover) {
    transform: scale(1.05);
}

.dashboard-layout :deep(.active\:scale-95:active) {
    transform: scale(0.95);
}

/* Enhanced dashboard card styling */
.dashboard-layout :deep(.bg-white),
.dashboard-layout :deep(.bg-\[#1E293B\]) {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.dashboard-layout :deep(.bg-white:hover),
.dashboard-layout :deep(.bg-\[#1E293B\]:hover) {
    transform: translateY(-2px);
}

/* Dashboard button enhancements */
.dashboard-layout :deep(button) {
    transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}

.dashboard-layout :deep(button:hover) {
    transform: translateY(-1px);
}

.dashboard-layout :deep(button:active) {
    transform: translateY(0);
}
</style>
