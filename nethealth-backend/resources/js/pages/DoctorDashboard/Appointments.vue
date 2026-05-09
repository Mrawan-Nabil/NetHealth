<script setup>
import { Head, router } from '@inertiajs/vue3';
import { computed, ref } from 'vue';
import AppointmentCardCancelled from '@/components/doctor-appointments/AppointmentCardCancelled.vue';
import AppointmentCardCompleted from '@/components/doctor-appointments/AppointmentCardCompleted.vue';
import AppointmentCardUpcoming from '@/components/doctor-appointments/AppointmentCardUpcoming.vue';
import AppointmentsTabs from '@/components/doctor-appointments/AppointmentsTabs.vue';
import AppSidebar from '@/components/doctor-ui/AppSidebar.vue';
import TopHeader from '@/components/doctor-ui/TopHeader.vue';
import RescheduleModal from '@/components/dashboard/RescheduleModal.vue';
import { useDashboard } from '@/composables/useDashboard';

// ─── Props (Inertia Data Contract) ───────────────────────────────────────────
const props = defineProps({
    doctor: { type: Object, required: true },
    completedAppointments: { type: Array, default: () => [] },
    upcomingAppointments: { type: Array, default: () => [] },
    cancelledAppointments: { type: Array, default: () => [] },
});

// ─── State ───────────────────────────────────────────────────────────────────
const { state, setTheme } = useDashboard();
const sidebarOpen = ref(false);
const activeTab = ref('completed');

const localUpcoming = ref([...props.upcomingAppointments]);

const navItems = ref([
    { key: 'home', label: 'Home', icon: 'home' },
    { key: 'profile', label: 'Profile', icon: 'profile' },
    { key: 'appointments', label: 'Appointments', icon: 'appointments', active: true },
    { key: 'reviews', label: 'Reviews', icon: 'reviews' },
    { key: 'notification', label: 'Notification', icon: 'notification' },
    { key: 'logout', label: 'Logout', icon: 'logout' },
]);

// ─── Computed ─────────────────────────────────────────────────────────────────
const isDark = computed(() => state.isDark);

const tabLabel = computed(() => activeTab.value.charAt(0).toUpperCase() + activeTab.value.slice(1));
const sectionTitle = computed(() => `${tabLabel.value} Appointments`);
const sectionSubtitle = computed(() => {
    if (activeTab.value === 'completed') return 'Review history and manage patient prescriptions.';
    if (activeTab.value === 'upcoming') return `You have ${localUpcoming.value.length} appointments scheduled.`;
    return 'Review and manage patient appointments that were recently cancelled.';
});
const tabCounts = computed(() => ({
    completed: props.completedAppointments.length,
    upcoming: localUpcoming.value.length,
    cancelled: props.cancelledAppointments.length,
}));

// ─── Handlers ────────────────────────────────────────────────────────────────
const toggleTheme = (value) => setTheme(value);
const openPatientRecord = () => router.get('/doctor/reviews/medical-record');
const openReviewFiles = () => router.get('/doctor/reviews/files');
const openPrescription = () => router.get('/doctor/reviews/medical-record');

const cancelUpcoming = (id) => {
    localUpcoming.value = localUpcoming.value.filter((a) => a.id !== id);
};

const showRescheduleModal = ref(false);
const selectedAppointment = ref(null);

const openRescheduleModal = (item) => {
    selectedAppointment.value = item;
    showRescheduleModal.value = true;
};

const handleRescheduleConfirm = (payload) => {
    if (!selectedAppointment.value) return;
    router.put(
        `/appointments/${selectedAppointment.value.id}`,
        { date: payload.date, time: payload.time, reason: payload.reason },
        {
            preserveScroll: true,
            onSuccess: () => {
                selectedAppointment.value = null;
                showRescheduleModal.value = false;
            },
            onError: (errors) => console.error('Reschedule failed:', errors),
        },
    );
};

const handleNav = (key) => {
    navItems.value = navItems.value.map((item) => ({ ...item, active: item.key === key }));
    sidebarOpen.value = false;
    if (key === 'home') return router.get('/doctor/dashboard');
    if (key === 'profile') return router.get('/doctor/profile');
    if (key === 'appointments') return router.get('/doctor/appointments');
    if (key === 'reviews') return router.get('/doctor/reviews');
    if (key === 'notification') return router.get('/doctor/notifications');
    if (key === 'logout') return router.get('/logout');
};
</script>

<template>
    <Head title="Doctor Appointments" />
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <AppSidebar :nav-items="navItems" :is-open="sidebarOpen" :is-dark="isDark" @close="sidebarOpen = false" @navigate="handleNav" @toggle-theme="toggleTheme" />
        <div class="lg:ml-64">
            <TopHeader
                title="Appointments"
                :doctor-name="props.doctor?.fullName"
                :handle="props.doctor?.handle"
                :avatar="props.doctor?.avatar ?? ''"
                :is-dark="isDark"
                @toggle-sidebar="sidebarOpen = true"
            />
            <main class="space-y-6 p-4 sm:p-6 lg:p-7 animate-fadeInUp">
                <div class="mb-1">
                    <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="mb-2 text-xs font-medium">
                        Dashboard <span class="mx-1.5 text-[#D1D5DB]">/</span>
                        <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'">Appointments</span>
                    </p>
                    <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-2xl font-bold tracking-tight">{{ sectionTitle }}</h1>
                    <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-sm">{{ sectionSubtitle }}</p>
                </div>

                <AppointmentsTabs :active-tab="activeTab" :counts="tabCounts" @change="activeTab = $event" />

                <transition name="fade" mode="out-in">
                    <section :key="activeTab" class="space-y-4">
                        <AppointmentCardCompleted
                            v-if="activeTab === 'completed'"
                            v-for="item in props.completedAppointments"
                            :key="item.id"
                            :item="item"
                            @edit="openPrescription"
                            @prescription="openPrescription"
                        />
                        <AppointmentCardUpcoming
                            v-else-if="activeTab === 'upcoming'"
                            v-for="item in localUpcoming"
                            :key="item.id"
                            :item="item"
                            @view-patient="openPatientRecord"
                            @review-files="openReviewFiles"
                            @cancel="cancelUpcoming(item.id)"
                            @reschedule="openRescheduleModal"
                        />
                        <AppointmentCardCancelled
                            v-else
                            v-for="item in props.cancelledAppointments"
                            :key="item.id"
                            :item="item"
                            @reschedule="activeTab = 'upcoming'"
                        />
                    </section>
                </transition>
            </main>
        </div>
    </div>

    <RescheduleModal
        :is-open="showRescheduleModal"
        :is-dark="isDark"
        :appointment="selectedAppointment"
        @close="showRescheduleModal = false"
        @confirm="handleRescheduleConfirm"
    />
</template>
