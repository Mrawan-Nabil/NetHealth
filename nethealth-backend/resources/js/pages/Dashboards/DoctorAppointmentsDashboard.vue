<script setup lang="ts">
import { Head, router } from '@inertiajs/vue3';
import { computed, ref } from 'vue';
import AppSidebar from '@/components/doctor-ui/AppSidebar.vue';
import AppointmentCardCancelled from '@/components/doctor-appointments/AppointmentCardCancelled.vue';
import AppointmentCardCompleted from '@/components/doctor-appointments/AppointmentCardCompleted.vue';
import AppointmentCardUpcoming from '@/components/doctor-appointments/AppointmentCardUpcoming.vue';
import AppointmentsTabs from '@/components/doctor-appointments/AppointmentsTabs.vue';
import TopHeader from '@/components/doctor-ui/TopHeader.vue';
import { useDashboard } from '@/composables/useDashboard';

type Tab = 'completed' | 'upcoming' | 'cancelled';
type NavIcon = 'home' | 'profile' | 'appointments' | 'reviews' | 'notification' | 'logout';

const { state, setTheme } = useDashboard();
const sidebarOpen = ref(false);
const activeTab = ref<Tab>('completed');

const doctor = {
    fullName: 'Ahmed Yahia',
    handle: '@y7ia007',
    avatar: 'https://i.pravatar.cc/200?img=12',
};

const navItems = ref<Array<{ key: string; label: string; icon: NavIcon; active?: boolean }>>([
    { key: 'home', label: 'Home', icon: 'home' },
    { key: 'profile', label: 'Profile', icon: 'profile' },
    { key: 'appointments', label: 'Appointments', icon: 'appointments', active: true },
    { key: 'reviews', label: 'Reviews', icon: 'reviews' },
    { key: 'notification', label: 'Notification', icon: 'notification' },
    { key: 'logout', label: 'Logout', icon: 'logout' },
]);

const completedAppointments = ref([
    { id: 1, patientName: 'Sarah Johnson', initials: 'SJ', date: 'Mar 22, 2026', time: '09:00 AM', visitType: 'In-Clinic Visit', canEdit: false },
    { id: 2, patientName: 'Emma Williams', initials: 'EW', date: 'Mar 22, 2026', time: '09:00 AM', visitType: 'Follow-up Visit', canEdit: true },
    { id: 3, patientName: 'David Martinez', initials: 'DM', date: 'Mar 22, 2026', time: '09:00 AM', visitType: 'In-Clinic Visit', canEdit: true },
    { id: 4, patientName: 'Emma Williams', initials: 'EW', date: 'Mar 22, 2026', time: '09:00 AM', visitType: 'Follow-up Visit', canEdit: true },
]);

const upcomingAppointments = ref([
    { id: 1, patientName: 'Emily Rodriguez', initials: 'ER', visitType: 'In-Clinic Visit', date: 'Tue, Mar 24, 2026', time: '4:00 PM', status: 'Pending', action: 'start' },
    { id: 2, patientName: 'David Thompson', initials: 'DT', visitType: 'Lab & Imaging Review', date: 'Wed, Mar 25, 2026', time: '9:00 AM', status: 'Confirmed', action: 'review' },
    { id: 3, patientName: 'David Thompson', initials: 'DT', visitType: 'Lab & Imaging Review', date: 'Wed, Mar 25, 2026', time: '9:00 AM', status: 'Confirmed', action: 'review' },
]);

const cancelledAppointments = ref([
    { id: 1, patientName: 'Sarah Johnson', initials: 'SJ', date: 'Sun, Mar 22, 2026', time: '2:30 PM', cancelledNote: 'Cancelled on Mar 21 by Patient', reason: 'Personal emergency' },
    { id: 2, patientName: 'Sarah Johnson', initials: 'SJ', date: 'Sun, Mar 22, 2026', time: '2:30 PM', cancelledNote: 'Cancelled on Mar 18 by Doctor', reason: 'Doctor unavailable' },
    { id: 3, patientName: 'Sarah Johnson', initials: 'SJ', date: 'Sun, Mar 22, 2026', time: '2:30 PM', cancelledNote: 'Cancelled on Mar 21 by Patient', reason: 'Personal emergency' },
]);

const isDark = computed(() => state.isDark);

const tabLabel = computed(() => activeTab.value.charAt(0).toUpperCase() + activeTab.value.slice(1));
const sectionTitle = computed(() => `${tabLabel.value} Appointments`);
const sectionSubtitle = computed(() => {
    if (activeTab.value === 'completed') return 'Review history and manage patient prescriptions.';
    if (activeTab.value === 'upcoming') return `You have ${upcomingAppointments.value.length} appointments scheduled for today.`;
    return 'Review and manage patient appointments that were recently cancelled.';
});
const tabCounts = computed(() => ({
    completed: completedAppointments.value.length,
    upcoming: upcomingAppointments.value.length,
    cancelled: cancelledAppointments.value.length,
}));

const toggleTheme = (value: 'light' | 'dark') => setTheme(value);

const openPatientRecord = () => router.get('/doctor/reviews/medical-record');
const openReviewFiles = () => router.get('/doctor/reviews/files');
const openPrescription = () => router.get('/doctor/reviews/medical-record');
const cancelUpcoming = (id: number) => {
    upcomingAppointments.value = upcomingAppointments.value.filter((appointment) => appointment.id !== id);
};
const restoreCancelled = () => {
    activeTab.value = 'upcoming';
};

const handleNav = (key: string) => {
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
    <Head title="Doctor Appointments Dashboard" />
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <AppSidebar :nav-items="navItems" :is-open="sidebarOpen" :is-dark="isDark" @close="sidebarOpen = false" @navigate="handleNav" @toggle-theme="toggleTheme" />
        <div class="lg:ml-64">
            <TopHeader
                title="Appointments"
                :doctor-name="doctor.fullName"
                :handle="doctor.handle"
                :avatar="doctor.avatar"
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
                            v-for="item in completedAppointments"
                            :key="item.id"
                            :item="item"
                            @edit="openPrescription"
                            @prescription="openPrescription"
                        />
                        <AppointmentCardUpcoming
                            v-else-if="activeTab === 'upcoming'"
                            v-for="item in upcomingAppointments"
                            :key="item.id"
                            :item="item"
                            @view-patient="openPatientRecord"
                            @review-files="openReviewFiles"
                            @cancel="cancelUpcoming(item.id)"
                        />
                        <AppointmentCardCancelled
                            v-else
                            v-for="item in cancelledAppointments"
                            :key="item.id"
                            :item="item"
                            @reschedule="restoreCancelled"
                        />
                    </section>
                </transition>
            </main>
        </div>
    </div>
</template>
